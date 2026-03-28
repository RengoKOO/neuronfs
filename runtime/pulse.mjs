import http from 'http';
import WebSocket from 'ws';

function getJson(url) {
    return new Promise((resolve, reject) => {
        http.get(url, res => { let d = ''; res.on('data', c => d+=c); res.on('end', ()=>resolve(JSON.parse(d))); }).on('error', reject);
    });
}

const PROMPT = process.argv[2] || "기본 하트비트 주입(Todo 확인 바랍니다)";
const CDP_PORT = 9000;

async function injectPulse() {
    console.log(`[PULSE] 💉 주입 시작: ${PROMPT}`);
    try {
        const list = await getJson(`http://127.0.0.1:${CDP_PORT}/json/list`);
        const target = list.find(t => t.url?.includes('workbench.html'));
        if (!target) {
            console.error('[PULSE] workbench.html 타겟을 찾을 수 없습니다.');
            return;
        }

        const ws = new WebSocket(target.webSocketDebuggerUrl);
        await new Promise((resolve, reject) => { ws.on('open', resolve); ws.on('error', reject); });

        let idCounter = 1;
        const pending = new Map();
        ws.on('message', msg => {
            const data = JSON.parse(msg);
            if (data.id && pending.has(data.id)) {
                pending.get(data.id)(data);
                pending.delete(data.id);
            }
        });

        const call = (method, params) => new Promise(resolve => {
            const id = idCounter++;
            pending.set(id, resolve);
            ws.send(JSON.stringify({ id, method, params }));
        });

        await call('Runtime.enable', {});
        // 잠시 대기
        await new Promise(r => setTimeout(r, 500));

        // 프롬프트 내 특수문자 이스케이프 (백틱 백슬래시 등)
        const safePrompt = PROMPT.replace(/\\/g, '\\\\').replace(/`/g, '\\`').replace(/\$/g, '\\$');

        const SCRIPT = `(() => {
            function collectInputs(root) {
                let found = [];
                const walk = node => {
                    if (!node) return;
                    if (node.shadowRoot) walk(node.shadowRoot);
                    if (node.tagName === 'TEXTAREA') found.push(node);
                    if (node.getAttribute && node.getAttribute('contenteditable') === 'true') found.push(node);
                    const children = node.children || [];
                    for (let i = 0; i < children.length; i++) walk(children[i]);
                };
                walk(root);
                return found;
            }
            const tas = collectInputs(document.body);
            // 디버깅용으로 수집된 요소 정보 반환 (최대 10개)
            const debugInfo = tas.map(t => ({
                tag: t.tagName, cls: t.className, 
                ph: t.placeholder || t.getAttribute('placeholder') || t.getAttribute('aria-placeholder'),
                aria: t.getAttribute('aria-label')
            }));
            // xterm-helper 등 터미널 시스템 입력창은 제외
            const valid = tas.filter(t => !t.className.includes('xterm') && t.offsetParent !== null && !t.disabled && !t.readOnly);
            
            // Antigravity 챗 인풋은 placeholder, class, aria-label에 단서가 있음
            let chatInput = valid.find(t => (t.placeholder||t.getAttribute('placeholder')||'').toLowerCase().includes('ask')) 
                         || valid.find(t => (t.className||'').includes('input') || (t.className||'').includes('chat'))
                         || valid.find(t => (t.placeholder||t.getAttribute('placeholder')||'').toLowerCase().includes('message'))
                         || valid.find(t => (t.getAttribute('aria-label')||'').toLowerCase().includes('chat'))
                         || valid.find(t => (t.getAttribute('aria-label')||'').toLowerCase().includes('message'));
            
            if (!chatInput) return { success: false, error: 'textarea not found amongst ' + tas.length + ' tas', debug: debugInfo };

            chatInput.focus();

            if (chatInput.tagName === 'TEXTAREA') {
                const nativeSetter = Object.getOwnPropertyDescriptor(window.HTMLTextAreaElement.prototype, "value")?.set;
                if (nativeSetter) {
                    nativeSetter.call(chatInput, \`${safePrompt}\`);
                } else {
                    chatInput.value = \`${safePrompt}\`;
                }
            } else if (chatInput.tagName === 'VSCODE-TEXT-AREA' || 'value' in chatInput) {
                chatInput.value = \`${safePrompt}\`;
            } else {
                chatInput.textContent = \`${safePrompt}\`;
            }

            chatInput.dispatchEvent(new Event('input', { bubbles: true }));
            chatInput.dispatchEvent(new Event('change', { bubbles: true }));

            // 엔터키 발생 (명령 전송)
            const enterDown = new KeyboardEvent('keydown', { key: 'Enter', code: 'Enter', keyCode: 13, which: 13, bubbles: true, cancelable: true });
            chatInput.dispatchEvent(enterDown);
            chatInput.dispatchEvent(new KeyboardEvent('keypress', { key: 'Enter', code: 'Enter', keyCode: 13, which: 13, bubbles: true, cancelable: true }));
            chatInput.dispatchEvent(new KeyboardEvent('keyup',   { key: 'Enter', code: 'Enter', keyCode: 13, which: 13, bubbles: true, cancelable: true }));
            
            // 전송 버튼 명시적 탐색 및 클릭 시도
            const btns = Array.from(document.querySelectorAll('button, [role="button"], a'));
            const sendBtn = btns.find(b => {
                const lower = (b.ariaLabel || b.title || b.className || '').toLowerCase();
                return lower.includes('send') || lower.includes('submit') || b.querySelector('.codicon-send');
            }) || Array.from(document.querySelectorAll('.codicon-send')).map(i => i.closest('button'))[0];
            
            if (sendBtn) {
                sendBtn.click();
            }

            return { success: true, target: chatInput.className, clicked: !!sendBtn };
        })()`;

        const res = await call('Runtime.evaluate', { expression: SCRIPT, returnByValue: true });
        console.log(`[PULSE] 전송 응답: ${JSON.stringify(res)}`);
        
        ws.close();
    } catch (e) {
        console.error(`[PULSE] 에러 발생: ${e.message}`);
    }
}
injectPulse();
