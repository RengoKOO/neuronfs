package main

// Dashboard HTML for NeuronFS v4.0 — Folder-as-Neuron Cognitive Engine

const dashboardHTML = `<!DOCTYPE html>
<html lang="ko">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>NeuronFS v4 — 인지 엔진</title>
<style>
  /* ── Reset & Base ── */
  *, *::before, *::after { box-sizing: border-box; margin: 0; padding: 0; }
  body {
    font-family: 'SUIT', -apple-system, sans-serif;
    background: #0f0f0f; color: #e0e0e0;
    min-height: 100vh; padding: 24px;
  }
  a { color: #3B82F6; text-decoration: none; }

  /* ── Header ── */
  .header {
    display: flex; align-items: center; gap: 16px;
    margin-bottom: 32px; padding-bottom: 16px;
    border-bottom: 1px solid #2a2a2a;
  }
  .header h1 { font-size: 20px; font-weight: 700; color: #fff; }
  .header .axiom {
    font-size: 11px; color: #888; letter-spacing: 0.05em;
    background: #1a1a1a; padding: 4px 12px; border-radius: 50px;
  }
  .status {
    margin-left: auto; padding: 6px 16px; border-radius: 50px;
    font-size: 12px; font-weight: 700;
  }
  .status.ok { background: #064e3b; color: #34d399; }
  .status.bomb { background: #7f1d1d; color: #fca5a5; animation: pulse 1s infinite; }

  /* ── Grid ── */
  .grid {
    display: grid;
    grid-template-columns: repeat(auto-fill, minmax(400px, 1fr));
    gap: 16px;
  }

  /* ── Region Card ── */
  .region {
    background: #1a1a1a; border-radius: 12px;
    border: 1px solid #2a2a2a; overflow: hidden;
    transition: border-color 0.2s;
  }
  .region:hover { border-color: #3a3a3a; }
  .region-header {
    display: flex; align-items: center; gap: 10px;
    padding: 16px; cursor: pointer; user-select: none;
  }
  .region-icon { font-size: 20px; }
  .region-name { font-weight: 700; font-size: 14px; color: #fff; text-transform: uppercase; letter-spacing: 0.1em; }
  .region-ko { font-size: 11px; color: #888; }
  .region-stats {
    margin-left: auto; display: flex; gap: 12px;
    font-size: 11px; color: #666;
  }
  .region-stats span { background: #222; padding: 2px 8px; border-radius: 4px; }

  /* ── Neurons List ── */
  .neurons {
    max-height: 0; overflow: hidden;
    transition: max-height 0.3s ease;
    border-top: 1px solid #222;
  }
  .region.open .neurons { max-height: 2000px; }
  .neuron {
    display: flex; align-items: center; gap: 8px;
    padding: 8px 16px; border-bottom: 1px solid #1f1f1f;
    font-size: 12px; transition: background 0.15s;
  }
  .neuron:hover { background: #222; }
  .neuron:last-child { border-bottom: none; }

  /* ── Path as Sentence ── */
  .neuron-path {
    flex: 1; font-family: monospace; font-size: 11px; color: #ccc;
    word-break: break-all;
  }
  .neuron-path .segment { color: #888; }
  .neuron-path .leaf { color: #fff; font-weight: 600; }

  /* ── Activation Bar ── */
  .activation {
    width: 60px; height: 6px; background: #333; border-radius: 3px;
    overflow: hidden; flex-shrink: 0;
  }
  .activation-fill {
    height: 100%; border-radius: 3px;
    transition: width 0.3s;
  }
  .act-low { background: #475569; }
  .act-med { background: #3b82f6; }
  .act-high { background: #22c55e; }
  .act-max { background: #f59e0b; }

  .neuron-counter {
    font-size: 10px; color: #666; width: 40px; text-align: right;
    font-family: monospace;
  }
  .neuron-signals { font-size: 12px; width: 40px; text-align: center; }

  /* ── Add Neuron Form ── */
  .add-form {
    display: flex; gap: 8px; padding: 12px 16px;
    background: #151515; border-top: 1px solid #222;
  }
  .add-form input {
    flex: 1; background: #222; border: 1px solid #333;
    border-radius: 6px; padding: 6px 10px; color: #fff;
    font-size: 11px; font-family: monospace;
  }
  .add-form input::placeholder { color: #555; }
  .add-form button {
    background: #1d4ed8; color: #fff; border: none;
    border-radius: 6px; padding: 6px 14px; font-size: 11px;
    cursor: pointer; font-weight: 600;
  }
  .add-form button:hover { background: #2563eb; }

  /* ── Growth Protocol Card ── */
  .protocol {
    grid-column: 1 / -1;
    background: #0d1117; border: 1px solid #1f3a5f;
    border-radius: 12px; padding: 24px;
  }
  .protocol h3 { color: #58a6ff; font-size: 14px; margin-bottom: 12px; }
  .protocol pre {
    background: #161b22; padding: 16px; border-radius: 8px;
    font-size: 11px; color: #8b949e; line-height: 1.6;
    overflow-x: auto; white-space: pre-wrap;
  }
  .protocol .highlight { color: #79c0ff; }

  /* ── Tree Visualization ── */
  .tree-section {
    grid-column: 1 / -1;
    background: #1a1a1a; border: 1px solid #2a2a2a;
    border-radius: 12px; padding: 24px;
  }
  .tree-section h3 { color: #fff; font-size: 14px; margin-bottom: 16px; }
  .tree {
    font-family: monospace; font-size: 11px; color: #888;
    line-height: 1.8; max-height: 500px; overflow-y: auto;
  }
  .tree .folder { color: #f59e0b; }
  .tree .counter { color: #22c55e; }
  .tree .signal { color: #ef4444; }

  /* ── Inject Button ── */
  .inject-bar {
    grid-column: 1 / -1;
    display: flex; gap: 12px; align-items: center;
  }
  .btn-inject {
    background: #059669; color: #fff; border: none;
    border-radius: 50px; padding: 10px 28px; font-size: 13px;
    cursor: pointer; font-weight: 700; letter-spacing: 0.05em;
  }
  .btn-inject:hover { background: #047857; }
  .btn-bomb {
    background: #dc2626; color: #fff; border: none;
    border-radius: 50px; padding: 10px 28px; font-size: 13px;
    cursor: pointer; font-weight: 700;
  }
  .inject-result {
    font-size: 12px; color: #888; flex: 1;
  }

  @keyframes pulse {
    0%, 100% { opacity: 1; }
    50% { opacity: 0.5; }
  }
</style>
</head>
<body>

<div class="header">
  <h1>🧠 NeuronFS v4.0</h1>
  <span class="axiom">폴더=뉴런 | 파일=발화흔적 | 경로=문장</span>
  <div id="status" class="status ok">NOMINAL</div>
</div>

<div class="grid" id="grid">
  <div style="color:#666; padding:40px; text-align:center;">로딩 중...</div>
</div>

<script>
// ── State ──
let brainData = null;

// ── Load ──
async function loadBrain() {
  const res = await fetch('/api/brain');
  brainData = await res.json();
  render();
}

// ── Render ──
function render() {
  if (!brainData) return;
  const d = brainData;
  const grid = document.getElementById('grid');
  const status = document.getElementById('status');

  // Status
  if (d.bombSource) {
    status.className = 'status bomb';
    status.textContent = 'BOMB: ' + d.bombSource;
  } else {
    status.className = 'status ok';
    status.textContent = 'NOMINAL — ' + d.firedNeurons + '/' + d.totalNeurons + ' neurons';
  }

  let html = '';

  // ── Inject Bar ──
  html += '<div class="inject-bar">';
  html += '<button class="btn-inject" onclick="doInject()">⚡ INJECT → GEMINI.md</button>';
  html += '<button class="btn-bomb" onclick="doBomb()">💀 BOMB</button>';
  html += '<span class="inject-result" id="inject-result">총 활성도: ' + d.totalCounter + '</span>';
  html += '</div>';

  // ── Region Cards ──
  for (const region of d.regions) {
    const icon = region.icon || '📁';
    const ko = region.ko || '';
    const nc = region.neurons ? region.neurons.length : 0;
    const totalAct = region.neurons ? region.neurons.reduce((s,n) => s + n.counter, 0) : 0;
    const hasBomb = region.hasBomb;

    html += '<div class="region open" onclick="this.classList.toggle(\'open\')">';
    html += '<div class="region-header">';
    html += '<span class="region-icon">' + icon + '</span>';
    html += '<span class="region-name">' + region.name + '</span>';
    html += '<span class="region-ko">' + ko + '</span>';
    html += '<div class="region-stats">';
    html += '<span>뉴런 ' + nc + '</span>';
    html += '<span>활성도 ' + totalAct + '</span>';
    if (hasBomb) html += '<span style="color:#ef4444">💀 BOMB</span>';
    if (region.axons && region.axons.length > 0) html += '<span>.axon ' + region.axons.length + '</span>';
    html += '</div></div>';

    html += '<div class="neurons">';
    if (region.neurons) {
      // Sort by counter desc
      const sorted = [...region.neurons].sort((a,b) => b.counter - a.counter);
      for (const n of sorted) {
        const segments = n.path.split(/[\/\\]/);
        const leaf = segments.pop();
        const prefix = segments.length > 0 ? '<span class="segment">' + segments.join(' > ') + ' > </span>' : '';

        let actPct = Math.min(100, n.counter);
        let actClass = 'act-low';
        if (n.counter >= 90) actClass = 'act-max';
        else if (n.counter >= 50) actClass = 'act-high';
        else if (n.counter >= 10) actClass = 'act-med';

        let signals = '';
        if (n.dopamine > 0) signals += '🟢';
        if (n.hasBomb) signals += '💀';
        if (n.hasMemory) signals += '📝';
        if (n.isDormant) signals += '💤';

        html += '<div class="neuron">';
        html += '<div class="neuron-path">' + prefix + '<span class="leaf">' + leaf.replace(/_/g, ' ') + '</span></div>';
        html += '<div class="activation"><div class="activation-fill ' + actClass + '" style="width:' + actPct + '%"></div></div>';
        html += '<div class="neuron-counter">' + n.counter + '</div>';
        html += '<div class="neuron-signals">' + signals + '</div>';
        html += '</div>';
      }
    }

    // Add neuron form
    html += '<div class="add-form" onclick="event.stopPropagation()">';
    html += '<input type="text" placeholder="새 뉴런 경로 (예: react/server_components)" id="add-' + region.name + '">';
    html += '<button onclick="addNeuron(\'' + region.name + '\')">+ 뉴런</button>';
    html += '</div>';

    html += '</div></div>';
  }

  // ── Growth Protocol ──
  html += '<div class="protocol">';
  html += '<h3>🌱 자동 성장 프로토콜 — GEMINI.md에 주입되는 메타 지침</h3>';
  html += '<pre>';
  html += '폴더 계층이 <span class="highlight">무한히 확장</span>됩니다:\n\n';
  html += '  cortex/frontend/react/hooks_pattern/          ← 8단계에서 멈출 필요 없음\n';
  html += '  cortex/frontend/react/hooks_pattern/useCallback/  ← 더 깊어질 수 있음\n';
  html += '  cortex/frontend/react/hooks_pattern/useCallback/memoize_deps/\n\n';
  html += '성장 트리거:\n';
  html += '  1. 사용자가 교정 → AI가 cortex/ 에 새 폴더 생성 + 1.neuron\n';
  html += '  2. 같은 규칙 재사용 → 카운터 파일명 증가 (1.neuron → 2.neuron)\n';
  html += '  3. 사용자 칭찬 → dopamine1.neuron 생성 (보상 신호)\n';
  html += '  4. 3회 반복 실수 → bomb.neuron 생성 (서킷 브레이커)\n';
  html += '  5. 오래 미사용 → .dormant 처리 (가지치기)\n\n';
  html += '카운터 = 파일명 숫자:\n';
  html += '  1.neuron   → 1회 발화 (신생 뉴런)\n';
  html += '  42.neuron  → 42회 발화 (학습된 경로)\n';
  html += '  99.neuron  → 99회 발화 (수초화 완료 = 반사적 실행)\n';
  html += '</pre>';
  html += '</div>';

  grid.innerHTML = html;
}

// ── API Calls ──
async function doInject() {
  const res = await fetch('/api/inject', { method: 'POST' });
  const text = await res.text();
  document.getElementById('inject-result').textContent = text;
  loadBrain();
}

async function doBomb() {
  const region = prompt('Bomb을 놓을 영역 (brainstem, cortex, ...):');
  if (!region) return;
  const neuron = prompt('Bomb 뉴런 이름 (예: halt_all):');
  if (!neuron) return;
  await fetch('/api/bomb', {
    method: 'POST',
    headers: {'Content-Type':'application/json'},
    body: JSON.stringify({region: region, name: neuron})
  });
  loadBrain();
}

async function addNeuron(region) {
  const input = document.getElementById('add-' + region);
  const path = input.value.trim();
  if (!path) return;
  await fetch('/api/neuron', {
    method: 'POST',
    headers: {'Content-Type':'application/json'},
    body: JSON.stringify({region: region, path: path})
  });
  input.value = '';
  loadBrain();
}

// ── Auto-refresh ──
loadBrain();
setInterval(loadBrain, 5000);
</script>
</body>
</html>`
