"use strict";
/**
 * NeuronFS Auto-Injector
 *
 * THE CORE FEATURE: Watches .neuron files and automatically updates
 * GEMINI.md / .cursorrules / CLAUDE.md with pre-scanned, pre-parsed rules.
 *
 * This means the AI never needs to scan — rules are already in the system prompt.
 * The extension does the scanning, not the AI.
 *
 * This is Lv.2 enforcement: the IDE handles the deterministic part (scanning + parsing),
 * and injects the results into the AI's input context.
 */
var __createBinding = (this && this.__createBinding) || (Object.create ? (function(o, m, k, k2) {
    if (k2 === undefined) k2 = k;
    var desc = Object.getOwnPropertyDescriptor(m, k);
    if (!desc || ("get" in desc ? !m.__esModule : desc.writable || desc.configurable)) {
      desc = { enumerable: true, get: function() { return m[k]; } };
    }
    Object.defineProperty(o, k2, desc);
}) : (function(o, m, k, k2) {
    if (k2 === undefined) k2 = k;
    o[k2] = m[k];
}));
var __setModuleDefault = (this && this.__setModuleDefault) || (Object.create ? (function(o, v) {
    Object.defineProperty(o, "default", { enumerable: true, value: v });
}) : function(o, v) {
    o["default"] = v;
});
var __importStar = (this && this.__importStar) || (function () {
    var ownKeys = function(o) {
        ownKeys = Object.getOwnPropertyNames || function (o) {
            var ar = [];
            for (var k in o) if (Object.prototype.hasOwnProperty.call(o, k)) ar[ar.length] = k;
            return ar;
        };
        return ownKeys(o);
    };
    return function (mod) {
        if (mod && mod.__esModule) return mod;
        var result = {};
        if (mod != null) for (var k = ownKeys(mod), i = 0; i < k.length; i++) if (k[i] !== "default") __createBinding(result, mod, k[i]);
        __setModuleDefault(result, mod);
        return result;
    };
})();
Object.defineProperty(exports, "__esModule", { value: true });
exports.AutoInjector = void 0;
const vscode = __importStar(require("vscode"));
const fs = __importStar(require("fs"));
const path = __importStar(require("path"));
const scanner_1 = require("./scanner");
// Markers for the injected section
const INJECT_START = '<!-- NEURONFS:START -->';
const INJECT_END = '<!-- NEURONFS:END -->';
class AutoInjector {
    scanner;
    watcher;
    debounceTimer;
    statusBar;
    constructor(statusBar) {
        this.scanner = new scanner_1.NeuronScanner();
        this.statusBar = statusBar;
    }
    /**
     * Start watching .neuron files and auto-inject on changes
     */
    startWatching() {
        // Watch for .neuron file changes across the workspace
        this.watcher = vscode.workspace.createFileSystemWatcher('**/*.neuron');
        this.watcher.onDidCreate(() => this.debouncedInject('created'));
        this.watcher.onDidDelete(() => this.debouncedInject('deleted'));
        this.watcher.onDidChange(() => this.debouncedInject('changed'));
        // Also watch global neurons path
        const config = vscode.workspace.getConfiguration('neuronfs');
        const globalPath = config.get('globalNeuronsPath');
        if (globalPath) {
            const globalPattern = new vscode.RelativePattern(globalPath, '**/*.neuron');
            const globalWatcher = vscode.workspace.createFileSystemWatcher(globalPattern);
            globalWatcher.onDidCreate(() => this.debouncedInject('created'));
            globalWatcher.onDidDelete(() => this.debouncedInject('deleted'));
            globalWatcher.onDidChange(() => this.debouncedInject('changed'));
        }
    }
    /**
     * Debounce rapid changes (e.g., multiple neurons created at once)
     */
    debouncedInject(reason) {
        if (this.debounceTimer)
            clearTimeout(this.debounceTimer);
        this.debounceTimer = setTimeout(async () => {
            await this.inject();
            vscode.window.showInformationMessage(`🧠 NeuronFS: Rules auto-updated (${reason})`);
        }, 500);
    }
    /**
     * Scan neurons and inject into the target system prompt file
     */
    async inject() {
        const result = await this.scanner.scan();
        const config = vscode.workspace.getConfiguration('neuronfs');
        const target = config.get('injectTarget') || 'gemini.md';
        // Find all target files to inject into
        const targetPaths = await this.findTargetFiles(target);
        for (const targetPath of targetPaths) {
            await this.injectIntoFile(targetPath, result);
        }
        // Update status bar
        const activeCount = result.neurons.filter(n => !n.isDormant).length;
        this.statusBar.text = `$(brain) ${activeCount} neurons`;
        this.statusBar.tooltip = `NeuronFS: ${activeCount} active, ${result.totalWeight}B total weight`;
        return result;
    }
    /**
     * Find target files for injection
     */
    async findTargetFiles(target) {
        const paths = [];
        if (!vscode.workspace.workspaceFolders)
            return paths;
        for (const folder of vscode.workspace.workspaceFolders) {
            const root = folder.uri.fsPath;
            switch (target) {
                case 'gemini.md': {
                    // Check .gemini/GEMINI.md (Antigravity)
                    const geminiPath = path.join(root, '.gemini', 'GEMINI.md');
                    if (fs.existsSync(geminiPath))
                        paths.push(geminiPath);
                    // Also check home directory
                    const homeGemini = path.join(process.env.USERPROFILE || process.env.HOME || '', '.gemini', 'GEMINI.md');
                    if (fs.existsSync(homeGemini) && !paths.includes(homeGemini)) {
                        paths.push(homeGemini);
                    }
                    break;
                }
                case '.cursorrules': {
                    const cursorPath = path.join(root, '.cursorrules');
                    paths.push(cursorPath); // Create if doesn't exist
                    break;
                }
                case 'claude.md': {
                    const claudePath = path.join(root, 'CLAUDE.md');
                    paths.push(claudePath);
                    break;
                }
            }
        }
        return paths;
    }
    /**
     * Inject formatted rules into a specific file
     *
     * Strategy:
     * - If file has NEURONFS:START / NEURONFS:END markers → replace between them
     * - If file exists but no markers → append markers + rules at the end
     * - If file doesn't exist → create with rules
     */
    async injectIntoFile(filePath, result) {
        const formatted = scanner_1.RuleFormatter.formatForInjection(result);
        const injectionBlock = `${INJECT_START}\n${formatted}\n${INJECT_END}`;
        try {
            if (fs.existsSync(filePath)) {
                let content = fs.readFileSync(filePath, 'utf-8');
                const startIdx = content.indexOf(INJECT_START);
                const endIdx = content.indexOf(INJECT_END);
                if (startIdx !== -1 && endIdx !== -1) {
                    // Replace existing injection block (wherever it is)
                    content = content.substring(0, startIdx) +
                        injectionBlock +
                        content.substring(endIdx + INJECT_END.length);
                }
                else {
                    // PREPEND at TOP — rules must be the first thing the AI reads
                    content = injectionBlock + '\n\n' + content;
                }
                fs.writeFileSync(filePath, content, 'utf-8');
            }
            else {
                // Create file with injection block
                const dir = path.dirname(filePath);
                if (!fs.existsSync(dir))
                    fs.mkdirSync(dir, { recursive: true });
                fs.writeFileSync(filePath, injectionBlock + '\n', 'utf-8');
            }
        }
        catch (err) {
            vscode.window.showErrorMessage(`NeuronFS: Failed to inject into ${filePath}: ${err}`);
        }
    }
    dispose() {
        if (this.watcher)
            this.watcher.dispose();
        if (this.debounceTimer)
            clearTimeout(this.debounceTimer);
    }
}
exports.AutoInjector = AutoInjector;
//# sourceMappingURL=injector.js.map