/**
 * agent-bridge.mjs — 에이전트 간 자동 통신 브릿지
 * 
 * inbox 폴더를 감시 → 새 파일 감지 → CDP로 해당 에이전트에 인젝션
 * 
 * 이것만 백그라운드로 돌리면 파일 쓰기 = 대화 인젝션이 된다.
 * 
 * Usage: node agent-bridge.mjs
 */
import http from 'http';
import WebSocket from 'ws';
import { watch, readFileSync, readdirSync, renameSync, existsSync, mkdirSync } from 'fs';
import { join, basename } from 'path';

const CDP_PORT = 9000;
const BRAIN = 'C:\\Users\\BASEMENT_ADMIN\\NeuronFS\\brain_v4';
const AGENTS_DIR = join(BRAIN, '_agents');
const POLL_MS = 3000;

// 에이전트 → CDP 타겟 매핑
const AGENT_TARGETS = {
  agent_a: 'BASEMENT_ADMIN',   // Agent A 창 title에 포함된 키워드
  agent_b: 'bot1'              // Agent B 창 title
};

function log(msg) {
  const ts = new Date().toISOString().slice(11, 19);
  console.log(`[${ts}] ${msg}`);
}

function getJson(url) {
  return new Promise((resolve, reject) => {
    http.get(url, res => {
      let d = ''; res.on('data', c => d += c);
      res.on('end', () => resolve(JSON.parse(d)));
    }).on('error', reject);
  });
}

async function injectToAgent(agentId, message) {
  const keyword = AGENT_TARGETS[agentId];
  if (!keyword) { log(`❌ Unknown agent: ${agentId}`); return false; }

  let list;
  try { list = await getJson(`http://127.0.0.1:${CDP_PORT}/json/list`); }
  catch { log('❌ CDP 미연결'); return false; }

  const target = list.find(t => t.title?.includes(keyword) && t.type === 'page');
  if (!target) { log(`❌ ${keyword} 창 없음`); return false; }

  const ws = new WebSocket(target.webSocketDebuggerUrl);
  await new Promise((r, j) => { ws.on('open', r); ws.on('error', j); });

  let id = 1;
  const pending = new Map();
  ws.on('message', msg => {
    const data = JSON.parse(msg);
    if (data.id && pending.has(data.id)) { pending.get(data.id)(data); pending.delete(data.id); }
  });
  const call = (method, params) => new Promise((resolve, reject) => {
    const myId = id++;
    const t = setTimeout(() => { pending.delete(myId); reject(new Error('timeout')); }, 10000);
    pending.set(myId, r => { clearTimeout(t); resolve(r); });
    ws.send(JSON.stringify({ id: myId, method, params }));
  });

  await call('Runtime.enable', {});
  await new Promise(r => setTimeout(r, 300));

  // 포커스
  const focusExpr = `(() => {
    function collectAll(root) {
      const found = [];
      const walk = node => {
        if (!node) return;
        if (node.shadowRoot) walk(node.shadowRoot);
        if (node.matches && node.matches('[aria-label="Message input"][role="textbox"]')) found.push(node);
        const children = node.children || [];
        for (let i = 0; i < children.length; i++) walk(children[i]);
      };
      walk(root);
      return found;
    }
    const inputs = collectAll(document);
    if (inputs.length > 0) { inputs[0].focus(); return 'ok'; }
    return 'not_found';
  })()`;

  const focusRes = await call('Runtime.evaluate', { expression: focusExpr });
  if (focusRes?.result?.result?.value !== 'ok') {
    log(`⚠️ ${agentId} 채팅창 미발견 — 패널이 열려있는지 확인`);
    ws.close();
    return false;
  }

  await new Promise(r => setTimeout(r, 200));
  await call('Input.insertText', { text: message });
  await new Promise(r => setTimeout(r, 200));
  await call('Input.dispatchKeyEvent', { type: 'keyDown', key: 'Enter', code: 'Enter', windowsVirtualKeyCode: 13 });
  await call('Input.dispatchKeyEvent', { type: 'keyUp', key: 'Enter', code: 'Enter', windowsVirtualKeyCode: 13 });

  ws.close();
  return true;
}

// inbox 폴링
const processed = new Set();

async function checkInboxes() {
  for (const [agentId, _keyword] of Object.entries(AGENT_TARGETS)) {
    const inbox = join(AGENTS_DIR, agentId, 'inbox');
    if (!existsSync(inbox)) continue;

    const files = readdirSync(inbox).filter(f => f.endsWith('.md') && !processed.has(f));
    for (const file of files) {
      const filePath = join(inbox, file);
      const content = readFileSync(filePath, 'utf8');
      
      log(`📨 ${agentId}/inbox/${file} → 인젝션`);

      // 메시지 앞에 출처 표시
      const fromMatch = content.match(/^# from: (.+)$/m);
      const from = fromMatch ? fromMatch[1] : 'unknown';
      const body = content.replace(/^#.*$/gm, '').trim();
      const injection = `🤖 [${from}→${agentId}] ${body}`;

      const ok = await injectToAgent(agentId, injection);
      if (ok) {
        processed.add(file);
        // 처리 완료 표시 — _done 서브디렉토리로 이동
        const doneDir = join(AGENTS_DIR, agentId, 'inbox', '_done');
        if (!existsSync(doneDir)) mkdirSync(doneDir, { recursive: true });
        try { renameSync(filePath, join(doneDir, file)); } catch {}
        log(`✅ ${file} 인젝션 완료 → _done/`);
      }
    }
  }
}

// 메인
async function main() {
  log('🌉 Agent Bridge 시작');
  log(`📂 감시: ${AGENTS_DIR}`);
  log(`🔗 CDP: ${CDP_PORT}`);
  log(`👤 Agent A: ${AGENT_TARGETS.agent_a}`);
  log(`👤 Agent B: ${AGENT_TARGETS.agent_b}`);
  log('');

  // 최초 체크
  await checkInboxes();

  // 폴링
  setInterval(checkInboxes, POLL_MS);

  log(`⏱️ ${POLL_MS}ms 간격 폴링 중... Ctrl+C로 중지`);
}

main().catch(e => { log(`💥 ${e.message}`); process.exit(1); });
