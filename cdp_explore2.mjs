import WebSocket from 'ws';
const ws = new WebSocket(process.argv[2]);
let id = 1;
ws.on('open', () => {
    ws.send(JSON.stringify({ id: id++, method: 'Runtime.evaluate', params: {
        expression: `(() => {
            const results = [];
            function walk(root) {
                if(!root) return;
                if(root.shadowRoot) walk(root.shadowRoot);
                for(const c of (root.children||[])) {
                    if(c.nodeType !== 1) continue;
                    const text = (c.innerText||'').trim();
                    if (text.length > 10 && text.length < 500) {
                        const style = getComputedStyle(c);
                        const op = style.opacity;
                        const bg = style.backgroundColor;
                        if (op !== '1' || bg !== 'rgba(0, 0, 0, 0)') {
                            results.push(c.tagName + '|op=' + op + '|bg=' + bg + '|' + text.slice(0,40));
                        }
                    }
                    if (results.length < 30) walk(c);
                }
            }
            walk(document.body);
            return results.slice(0, 20);
        })()`,
        returnByValue: true
    }}));
});
ws.on('message', d => {
    const msg = JSON.parse(d);
    const v = msg.result?.result?.value;
    if (v) v.forEach(x => console.log(x));
    else console.log('no data:', JSON.stringify(msg).slice(0,200));
    process.exit(0);
});
setTimeout(() => { console.log('timeout'); process.exit(1); }, 5000);