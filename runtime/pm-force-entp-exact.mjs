import http from 'http';
import WebSocket from 'ws';

const CDP_PORT = 9000;
const agentId = 'entp';
const prompt = `현재 모든 시스템 락을 해제하고 다음 3가지 퍼즐에 대한 너만의 답변을 즉각 렌더링하라.
[문제 1] 시공간 제약 추론: 사우디(UTC+3, 야외운영 16~24시, 화상 18~24시) vs 한국(UTC+9, KST 22시 행사시작, 2시간진행, 화상은 시작 30분후~종료 10분전). 30분 실시간 조인 가능한가? 시간 얼마나 밀방해야 하는가?
[문제 2] 릴레이 순서 논리: A, B, C, D, E. B는 C 먼저지만 바로 다음 아님. D는 E 바로 다음. A!=1. (C=3이면 A=5). E!=2. A와 E 연달아 안 뜀. D의 순서는?
[문제 3] 5x5 그리드 토러스: (0,0), (2,2), (4,4) 십자 5칸씩 3번 반전 후 흑색(1)의 합?`;

function getJson(url) {
    return new Promise((resolve, reject) => {
        http.get(url, res => {
            let d = ''; res.on('data', c => d += c);
            res.on('end', () => resolve(JSON.parse(d)));
        }).on('error', reject);
    });
}

function debugLog(msg) {
    console.log(`[PM-FORCE] ${msg}`);
}

async function run() {
    debugLog(`Scanning for ${agentId} CDP instance...`);
    const list = await getJson(`http://127.0.0.1:${CDP_PORT}/json/list`);
    const target = list.find(t => t.title?.toLowerCase().startsWith(agentId.toLowerCase()) && t.type === 'page');
    if (!target) { console.error('Browser session not found'); process.exit(1); }

    const ws = new WebSocket(target.webSocketDebuggerUrl);
    await new Promise(r => ws.on('open', r));
    
    let id = 1; const pending = new Map();
    ws.on('message', msg => {
        const d = JSON.parse(msg);
        if (d.id && pending.has(d.id)) { pending.get(d.id)(d); pending.delete(d.id); }
    });
    
    const call = (method, params) => new Promise(r => {
        const myId = id++; pending.set(myId, r);
        ws.send(JSON.stringify({ id: myId, method, params }));
    });

    await call('Runtime.enable', {});
    
    debugLog(`Reloading ${agentId} to clear locks...`);
    await call('Page.reload', {});
    await new Promise(r => setTimeout(r, 4000)); // wait for page load

    debugLog(`Injecting prompt...`);
    const focusExpr = `(() => {
        const walk = n => { if(!n)return null; if(n.shadowRoot){ let r=walk(n.shadowRoot); if(r)return r; } if(n.matches&&n.matches('[aria-label="Message input"][role="textbox"]'))return n; for(const c of(n.children||[])){ let r=walk(c); if(r)return r; } return null; };
        const input = walk(document) || document.querySelector('[contenteditable="true"]');
        if(input){ input.textContent=''; input.focus(); return 'ok'; }
        return 'fail';
    })()`;
    await call('Runtime.evaluate', { expression: focusExpr });
    await new Promise(r => setTimeout(r, 500));
    await call('Input.insertText', { text: prompt });
    await new Promise(r => setTimeout(r, 200));
    await call('Input.dispatchKeyEvent', { type: 'keyDown', key: 'Enter', code: 'Enter', windowsVirtualKeyCode: 13, nativeVirtualKeyCode: 13});
    await call('Input.dispatchKeyEvent', { type: 'keyUp', key: 'Enter', code: 'Enter', windowsVirtualKeyCode: 13, nativeVirtualKeyCode: 13});

    debugLog(`Waiting 15 seconds for actual LLM to generate reply natively...`);
    await new Promise(r => setTimeout(r, 15000));

    debugLog(`Scraping DOM for the exact response...`);
    const scrapeExpr = `(() => {
        const msgs = Array.from(document.querySelectorAll('article, .message, div')).filter(el => el.innerText && el.innerText.length > 50);
        return msgs.length > 0 ? msgs[msgs.length - 1].innerText : 'NO_RESPONSE_RENDERED_PROBABLY_STILL_TYPING';
    })()`;
    
    const scrapeRes = await call('Runtime.evaluate', { expression: scrapeExpr, returnByValue: true });
    
    console.log('\n================ ACTUAL ENTP BOT RESPONSE ================');
    console.log(scrapeRes?.result?.result?.value || 'Extraction failed');
    console.log('==========================================================\n');
    
    ws.close();
    process.exit(0);
}
run();
