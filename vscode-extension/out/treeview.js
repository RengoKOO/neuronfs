"use strict";
/**
 * NeuronFS TreeView Provider
 *
 * Displays neurons in the VSCode sidebar as a hierarchical tree,
 * grouped by domain (parent folder).
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
exports.NeuronTreeItem = exports.NeuronTreeProvider = void 0;
const vscode = __importStar(require("vscode"));
class NeuronTreeProvider {
    _onDidChangeTreeData = new vscode.EventEmitter();
    onDidChangeTreeData = this._onDidChangeTreeData.event;
    scanResult = null;
    refresh(result) {
        this.scanResult = result;
        this._onDidChangeTreeData.fire(undefined);
    }
    getTreeItem(element) {
        return element;
    }
    getChildren(element) {
        if (!this.scanResult)
            return [];
        // Root level: show domains
        if (!element) {
            const domains = new Map();
            for (const n of this.scanResult.neurons) {
                const key = `${n.scope}:${n.domain}`;
                if (!domains.has(key))
                    domains.set(key, []);
                domains.get(key).push(n);
            }
            return Array.from(domains.entries()).map(([key, neurons]) => {
                const [scope, domain] = key.split(':');
                const icon = scope === 'global' ? '🌐' : '📁';
                return new NeuronTreeItem(`${icon} ${domain}`, `${neurons.length} neurons`, vscode.TreeItemCollapsibleState.Expanded, 'domain', undefined, neurons);
            });
        }
        // Domain level: show individual neurons
        if (element.neurons) {
            return element.neurons.map(n => {
                const weightBar = this.getWeightBar(n.weight);
                const dormantTag = n.isDormant ? ' 💤' : '';
                return new NeuronTreeItem(`${n.rule}`, `${weightBar} ${n.weight}B${dormantTag}`, vscode.TreeItemCollapsibleState.None, 'neuron', n);
            });
        }
        return [];
    }
    getWeightBar(weight) {
        if (weight === 0)
            return '○○○';
        if (weight <= 3)
            return '●○○';
        if (weight <= 10)
            return '●●○';
        return '●●●';
    }
}
exports.NeuronTreeProvider = NeuronTreeProvider;
class NeuronTreeItem extends vscode.TreeItem {
    label;
    description;
    collapsibleState;
    contextValue;
    neuron;
    neurons;
    constructor(label, description, collapsibleState, contextValue, neuron, neurons) {
        super(label, collapsibleState);
        this.label = label;
        this.description = description;
        this.collapsibleState = collapsibleState;
        this.contextValue = contextValue;
        this.neuron = neuron;
        this.neurons = neurons;
        this.tooltip = neuron
            ? `${neuron.rule}\nWeight: ${neuron.weight}B | Scope: ${neuron.scope}\nPath: ${neuron.filePath}`
            : `${label}`;
        if (neuron) {
            this.resourceUri = vscode.Uri.file(neuron.filePath);
            this.command = {
                command: 'vscode.open',
                title: 'Open Neuron',
                arguments: [vscode.Uri.file(neuron.filePath)]
            };
        }
    }
}
exports.NeuronTreeItem = NeuronTreeItem;
//# sourceMappingURL=treeview.js.map