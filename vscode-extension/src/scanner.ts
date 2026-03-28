/**
 * NeuronFS Core — Neuron Scanner & Rule Parser
 * 
 * Scans the workspace for .neuron files, parses filenames into behavioral rules,
 * and provides sorted, scoped rule sets for injection into AI system prompts.
 */

import * as vscode from 'vscode';
import * as path from 'path';
import * as fs from 'fs';

// ─── Types ──────────────────────────────────────────────────────────

export interface Neuron {
  /** Absolute path to the .neuron file */
  filePath: string;
  /** Filename without extension */
  fileName: string;
  /** Parsed rule (underscores → spaces, prefix stripped) */
  rule: string;
  /** File size in bytes = dynamic weight */
  weight: number;
  /** Numeric prefix for static ordering (e.g., 01, 02) */
  index: number | null;
  /** Scope: 'global' (neurons/ dir) or 'project' (in project folder) */
  scope: 'global' | 'project';
  /** Domain derived from parent folder name */
  domain: string;
  /** Last access time */
  lastAccessed: Date;
  /** Last modified time */
  lastModified: Date;
  /** Whether dormant (not accessed for N days) */
  isDormant: boolean;
}

export interface ScanResult {
  neurons: Neuron[];
  globalCount: number;
  projectCount: number;
  totalWeight: number;
  scannedAt: Date;
}

// ─── Scanner ────────────────────────────────────────────────────────

export class NeuronScanner {
  private globalNeuronsPath: string | undefined;
  private dormantDays: number;

  constructor() {
    const config = vscode.workspace.getConfiguration('neuronfs');
    this.globalNeuronsPath = config.get<string>('globalNeuronsPath') || undefined;
    this.dormantDays = config.get<number>('dormantDays') || 30;
  }

  /**
   * Scan all .neuron files in workspace + global neurons directory
   */
  async scan(): Promise<ScanResult> {
    const neurons: Neuron[] = [];
    const now = new Date();

    // 1. Scan workspace folders
    if (vscode.workspace.workspaceFolders) {
      for (const folder of vscode.workspace.workspaceFolders) {
        const found = await this.scanDirectory(folder.uri.fsPath, 'project');
        neurons.push(...found);
      }
    }

    // 2. Scan global neurons directory
    if (this.globalNeuronsPath && fs.existsSync(this.globalNeuronsPath)) {
      const found = await this.scanDirectory(this.globalNeuronsPath, 'global');
      neurons.push(...found);
    }

    // 3. Check for ~/neurons/ as default global path
    const homeNeurons = path.join(process.env.USERPROFILE || process.env.HOME || '', 'neurons');
    if (!this.globalNeuronsPath && fs.existsSync(homeNeurons)) {
      const found = await this.scanDirectory(homeNeurons, 'global');
      neurons.push(...found);
    }

    // 4. Mark dormant neurons
    for (const n of neurons) {
      const daysSinceAccess = (now.getTime() - n.lastAccessed.getTime()) / (1000 * 60 * 60 * 24);
      n.isDormant = daysSinceAccess > this.dormantDays;
    }

    // 5. Sort: weight DESC (Dimension 2), then index ASC (Dimension 1)
    neurons.sort((a, b) => {
      if (b.weight !== a.weight) return b.weight - a.weight;
      const ai = a.index ?? 999;
      const bi = b.index ?? 999;
      return ai - bi;
    });

    return {
      neurons,
      globalCount: neurons.filter(n => n.scope === 'global').length,
      projectCount: neurons.filter(n => n.scope === 'project').length,
      totalWeight: neurons.reduce((sum, n) => sum + n.weight, 0),
      scannedAt: now,
    };
  }

  /**
   * Recursively find all .neuron files in a directory
   */
  private async scanDirectory(dirPath: string, scope: 'global' | 'project'): Promise<Neuron[]> {
    const neurons: Neuron[] = [];

    const walkDir = (dir: string) => {
      if (!fs.existsSync(dir)) return;

      // Skip dormant/, .git/, node_modules/
      const basename = path.basename(dir);
      if (['dormant', '.git', 'node_modules', '.next', 'out', 'dist'].includes(basename)) return;

      const entries = fs.readdirSync(dir, { withFileTypes: true });

      for (const entry of entries) {
        const fullPath = path.join(dir, entry.name);

        if (entry.isDirectory()) {
          walkDir(fullPath);
        } else if (entry.name.endsWith('.neuron')) {
          const stat = fs.statSync(fullPath);
          const neuron = this.parseNeuron(fullPath, stat, scope);
          neurons.push(neuron);
        } else if (entry.name.endsWith('.axon')) {
          try {
            const targetPath = fs.readFileSync(fullPath, 'utf-8').split('\n')[0].trim();
            if (fs.existsSync(targetPath) && fs.statSync(targetPath).isDirectory()) {
              walkDir(targetPath); // Neural Projection (Brain Copy)
            }
          } catch (e) {
            console.error(`Failed to read axon: ${fullPath}`, e);
          }
        }
      }
    };

    walkDir(dirPath);
    return neurons;
  }

  /**
   * Parse a .neuron filename into a behavioral rule
   * 
   * Filename convention:
   *   [NN_]RULE_NAME.neuron
   *   e.g., 01_NEVER_USE_FALLBACK.neuron → "NEVER USE FALLBACK"
   */
  private parseNeuron(filePath: string, stat: fs.Stats, scope: 'global' | 'project'): Neuron {
    const fileName = path.basename(filePath, '.neuron');
    const parentDir = path.basename(path.dirname(filePath));

    // Extract numeric prefix
    const prefixMatch = fileName.match(/^(\d+)_(.+)$/);
    const index = prefixMatch ? parseInt(prefixMatch[1], 10) : null;
    const rulePart = prefixMatch ? prefixMatch[2] : fileName;

    // Convert underscores to spaces = English imperative sentence
    const rule = rulePart.replace(/_/g, ' ');

    return {
      filePath,
      fileName,
      rule,
      weight: stat.size,
      index,
      scope,
      domain: parentDir,
      lastAccessed: stat.atime,
      lastModified: stat.mtime,
      isDormant: false,
    };
  }
}

// ─── Rule Formatter — generates text for system prompt injection ────

export class RuleFormatter {

  /**
   * Format scan results for injection into GEMINI.md / .cursorrules
   */
  static formatForInjection(result: ScanResult): string {
    const lines: string[] = [];
    const active = result.neurons.filter(n => !n.isDormant);

    lines.push(`<!-- NeuronFS Auto-Injected Rules (${result.scannedAt.toISOString()}) -->`);
    lines.push(`<!-- ${active.length} active neurons | Total weight: ${result.totalWeight} bytes -->`);
    lines.push('');
    lines.push('## 🧠 NeuronFS Active Rules');
    lines.push('');
    lines.push('The following rules are derived from .neuron files in the workspace.');
    lines.push('**These are hard constraints. Follow every single one.**');
    lines.push('');

    // Group by domain
    const domains = new Map<string, Neuron[]>();
    for (const n of active) {
      const key = `${n.scope}/${n.domain}`;
      if (!domains.has(key)) domains.set(key, []);
      domains.get(key)!.push(n);
    }

    for (const [domainKey, neurons] of domains) {
      const [scope, domain] = domainKey.split('/');
      const scopeLabel = scope === 'global' ? '🌐' : '📁';
      lines.push(`### ${scopeLabel} ${domain}`);

      for (const n of neurons) {
        const weightIndicator = n.weight === 0 ? '○' :
          n.weight <= 10 ? '●' :
          n.weight <= 50 ? '●●' : '●●●';
        lines.push(`- **${n.rule}** ${weightIndicator}`);
      }
      lines.push('');
    }

    lines.push('<!-- END NeuronFS Rules -->');
    return lines.join('\n');
  }

  /**
   * Format as compact single-line rules (minimal token usage)
   */
  static formatCompact(result: ScanResult): string {
    const active = result.neurons.filter(n => !n.isDormant);
    const rules = active.map(n => `[${n.domain}] ${n.rule}`);
    return `NEURONFS RULES (${active.length}): ${rules.join(' | ')}`;
  }
}
