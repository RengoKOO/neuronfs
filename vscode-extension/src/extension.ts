/**
 * NeuronFS VSCode Extension — Main Entry Point
 * 
 * Core loop:
 *   1. On activation: scan all .neuron files
 *   2. Auto-inject parsed rules into GEMINI.md / .cursorrules
 *   3. Watch for changes → re-scan → re-inject (no delay)
 *   4. Track access frequency → auto-accumulate weights
 *   5. Sidebar TreeView for visual management
 * 
 * Weight accumulation strategy:
 *   - Every time a neuron is READ by the extension (scan), its atime updates
 *   - The extension tracks "violation reinforcements" — user marks a rule as violated
 *   - Each reinforcement adds 1 byte to the neuron file → weight increases
 *   - Neurons that are never reinforced stay at 0 bytes
 *   - This creates an organic, usage-driven weight system
 */

import * as vscode from 'vscode';
import * as fs from 'fs';
import * as path from 'path';
import { NeuronScanner, ScanResult } from './scanner';
import { NeuronTreeProvider } from './treeview';
import { AutoInjector } from './injector';

let injector: AutoInjector;
let treeProvider: NeuronTreeProvider;
let scanner: NeuronScanner;

export function activate(context: vscode.ExtensionContext) {
  console.log('🧠 NeuronFS activated');

  // ─── Status Bar ───────────────────────────────────────────────
  const statusBar = vscode.window.createStatusBarItem(vscode.StatusBarAlignment.Left, 100);
  statusBar.command = 'neuronfs.scan';
  statusBar.text = '$(brain) NeuronFS';
  statusBar.show();
  context.subscriptions.push(statusBar);

  // ─── Core Components ──────────────────────────────────────────
  scanner = new NeuronScanner();
  treeProvider = new NeuronTreeProvider();
  injector = new AutoInjector(statusBar);

  // ─── TreeView Registration ────────────────────────────────────
  const treeView = vscode.window.createTreeView('neuronfs.neuronTree', {
    treeDataProvider: treeProvider,
    showCollapseAll: true,
  });
  context.subscriptions.push(treeView);

  // ─── Commands ─────────────────────────────────────────────────

  // Scan & inject
  context.subscriptions.push(
    vscode.commands.registerCommand('neuronfs.scan', async () => {
      const result = await injector.inject();
      treeProvider.refresh(result);
      vscode.window.showInformationMessage(
        `🧠 NeuronFS: ${result.neurons.length} neurons scanned, rules injected`
      );
    })
  );

  // Create neuron
  context.subscriptions.push(
    vscode.commands.registerCommand('neuronfs.createNeuron', async () => {
      const ruleName = await vscode.window.showInputBox({
        prompt: 'Neuron rule (use UPPER_SNAKE_CASE)',
        placeHolder: 'NEVER_USE_FALLBACK',
        validateInput: (value) => {
          if (!value) return 'Rule name is required';
          if (!/^[A-Z0-9_]+$/.test(value)) return 'Use UPPER_SNAKE_CASE (A-Z, 0-9, _)';
          return null;
        }
      });
      if (!ruleName) return;

      // Choose location
      const locations: vscode.QuickPickItem[] = [
        { label: '🌐 Global (neurons/)', description: 'Applies to all projects' },
      ];

      if (vscode.workspace.workspaceFolders) {
        for (const folder of vscode.workspace.workspaceFolders) {
          locations.push({
            label: `📁 ${folder.name}`,
            description: folder.uri.fsPath,
          });
        }
      }

      const location = await vscode.window.showQuickPick(locations, {
        placeHolder: 'Where should this neuron live?'
      });
      if (!location) return;

      // Choose domain
      const domain = await vscode.window.showInputBox({
        prompt: 'Domain folder (e.g., core, quality, design)',
        placeHolder: 'core',
        value: 'core'
      });
      if (!domain) return;

      // Determine path
      let targetDir: string;
      if (location.label.startsWith('🌐')) {
        const home = process.env.USERPROFILE || process.env.HOME || '';
        targetDir = path.join(home, 'neurons', domain);
      } else {
        targetDir = path.join(location.description!, domain);
      }

      if (!fs.existsSync(targetDir)) {
        fs.mkdirSync(targetDir, { recursive: true });
      }

      // Find next index
      const existing = fs.readdirSync(targetDir)
        .filter(f => f.endsWith('.neuron'))
        .map(f => {
          const match = f.match(/^(\d+)_/);
          return match ? parseInt(match[1], 10) : 0;
        });
      const nextIndex = existing.length > 0 ? Math.max(...existing) + 1 : 1;
      const paddedIndex = String(nextIndex).padStart(2, '0');

      // Create 0-byte neuron file
      const neuronPath = path.join(targetDir, `${paddedIndex}_${ruleName}.neuron`);
      fs.writeFileSync(neuronPath, '', 'utf-8');

      vscode.window.showInformationMessage(`🧠 Created: ${paddedIndex}_${ruleName}.neuron`);

      // Re-scan and inject
      const result = await injector.inject();
      treeProvider.refresh(result);
    })
  );

  // Delete neuron
  context.subscriptions.push(
    vscode.commands.registerCommand('neuronfs.deleteNeuron', async (item: any) => {
      if (!item?.neuron) {
        vscode.window.showWarningMessage('Select a neuron to delete');
        return;
      }
      const confirm = await vscode.window.showWarningMessage(
        `Delete neuron "${item.neuron.rule}"?`,
        { modal: true },
        'Delete'
      );
      if (confirm === 'Delete') {
        fs.unlinkSync(item.neuron.filePath);
        const result = await injector.inject();
        treeProvider.refresh(result);
      }
    })
  );

  // Increase weight (+1 byte = add a dot)
  context.subscriptions.push(
    vscode.commands.registerCommand('neuronfs.increaseWeight', async (item: any) => {
      if (!item?.neuron) return;
      const currentContent = fs.readFileSync(item.neuron.filePath, 'utf-8');
      fs.writeFileSync(item.neuron.filePath, currentContent + '.', 'utf-8');
      const result = await injector.inject();
      treeProvider.refresh(result);
      vscode.window.showInformationMessage(
        `🧠 Weight increased: ${item.neuron.rule} → ${item.neuron.weight + 1}B`
      );
    })
  );

  // Decrease weight (-1 byte = remove a dot)
  context.subscriptions.push(
    vscode.commands.registerCommand('neuronfs.decreaseWeight', async (item: any) => {
      if (!item?.neuron) return;
      const currentContent = fs.readFileSync(item.neuron.filePath, 'utf-8');
      if (currentContent.length > 0) {
        fs.writeFileSync(item.neuron.filePath, currentContent.slice(0, -1), 'utf-8');
        const result = await injector.inject();
        treeProvider.refresh(result);
      }
    })
  );

  // Manual inject
  context.subscriptions.push(
    vscode.commands.registerCommand('neuronfs.injectToSystemPrompt', async () => {
      const result = await injector.inject();
      treeProvider.refresh(result);
      vscode.window.showInformationMessage('🧠 NeuronFS rules injected to system prompt file');
    })
  );

  // Toggle dormant
  context.subscriptions.push(
    vscode.commands.registerCommand('neuronfs.toggleDormant', async (item: any) => {
      if (!item?.neuron) return;
      const neuron = item.neuron;
      const dir = path.dirname(neuron.filePath);
      const dormantDir = path.join(dir, 'dormant');
      const fileName = path.basename(neuron.filePath);

      if (neuron.isDormant) {
        // Reactivate: move out of dormant/
        const newPath = path.join(path.dirname(dir), fileName);
        fs.renameSync(neuron.filePath, newPath);
      } else {
        // Deactivate: move to dormant/
        if (!fs.existsSync(dormantDir)) fs.mkdirSync(dormantDir);
        fs.renameSync(neuron.filePath, path.join(dormantDir, fileName));
      }

      const result = await injector.inject();
      treeProvider.refresh(result);
    })
  );

  // ─── Auto-Inject on Startup + File Watch ─────────────────────
  const config = vscode.workspace.getConfiguration('neuronfs');
  const autoInject = config.get<boolean>('autoInject') !== false;

  if (autoInject) {
    injector.startWatching();

    // Initial scan + inject on activation
    injector.inject().then(result => {
      treeProvider.refresh(result);
      console.log(`🧠 NeuronFS: ${result.neurons.length} neurons loaded, rules injected`);
    });
  }

  context.subscriptions.push(injector);
}

export function deactivate() {
  console.log('🧠 NeuronFS deactivated');
}
