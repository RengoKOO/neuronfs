/**
 * NeuronFS TreeView Provider
 * 
 * Displays neurons in the VSCode sidebar as a hierarchical tree,
 * grouped by domain (parent folder).
 */

import * as vscode from 'vscode';
import * as path from 'path';
import { Neuron, ScanResult } from './scanner';

export class NeuronTreeProvider implements vscode.TreeDataProvider<NeuronTreeItem> {
  private _onDidChangeTreeData = new vscode.EventEmitter<NeuronTreeItem | undefined>();
  readonly onDidChangeTreeData = this._onDidChangeTreeData.event;

  private scanResult: ScanResult | null = null;

  refresh(result: ScanResult): void {
    this.scanResult = result;
    this._onDidChangeTreeData.fire(undefined);
  }

  getTreeItem(element: NeuronTreeItem): vscode.TreeItem {
    return element;
  }

  getChildren(element?: NeuronTreeItem): NeuronTreeItem[] {
    if (!this.scanResult) return [];

    // Root level: show domains
    if (!element) {
      const domains = new Map<string, Neuron[]>();
      for (const n of this.scanResult.neurons) {
        const key = `${n.scope}:${n.domain}`;
        if (!domains.has(key)) domains.set(key, []);
        domains.get(key)!.push(n);
      }

      return Array.from(domains.entries()).map(([key, neurons]) => {
        const [scope, domain] = key.split(':');
        const icon = scope === 'global' ? '🌐' : '📁';
        return new NeuronTreeItem(
          `${icon} ${domain}`,
          `${neurons.length} neurons`,
          vscode.TreeItemCollapsibleState.Expanded,
          'domain',
          undefined,
          neurons
        );
      });
    }

    // Domain level: show individual neurons
    if (element.neurons) {
      return element.neurons.map(n => {
        const weightBar = this.getWeightBar(n.weight);
        const dormantTag = n.isDormant ? ' 💤' : '';
        return new NeuronTreeItem(
          `${n.rule}`,
          `${weightBar} ${n.weight}B${dormantTag}`,
          vscode.TreeItemCollapsibleState.None,
          'neuron',
          n
        );
      });
    }

    return [];
  }

  private getWeightBar(weight: number): string {
    if (weight === 0) return '○○○';
    if (weight <= 3) return '●○○';
    if (weight <= 10) return '●●○';
    return '●●●';
  }
}

export class NeuronTreeItem extends vscode.TreeItem {
  constructor(
    public readonly label: string,
    public readonly description: string,
    public readonly collapsibleState: vscode.TreeItemCollapsibleState,
    public readonly contextValue: string,
    public readonly neuron?: Neuron,
    public readonly neurons?: Neuron[]
  ) {
    super(label, collapsibleState);
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
