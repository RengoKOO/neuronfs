import WebSocket from 'ws';
const ws = new WebSocket(process.argv[2]);
let id = 1;
ws.on('open', () => {
    ws.send(JSON.stringify({ id: id++, method: 'Runtime.evaluate', params: {
        expression: `(() => {
            function walk(root, results) {
                if(!root) return;
                if(root.shadowRoot) walk(root.shadowRoot, results);
                for(const c of (root.children||[])) {
                    if(c.nodeType !== 1) continue;
                    const cls = (c.className||'').toString().toLowerCase();
                    const style = getComputedStyle(c);
                    const opacity = parseFloat(style.opacity);
                    const bg = style.backgroundColor;
                    const color = style.color;
                    if ((cls.includes('message') || cls.includes('chat') || cls.includes('user') || cls.includes('human')) && (c.innerText||'').trim().length > 5) {
                        results.push({
                            tag: c.tagName,
                            cls: cls.slice(0, 80),
                            opacity: opacity,
                            bg: bg,
                            color: color,
                            text: (c.innerText||'').trim().slice(0, 60)
                        });
                    }
                    if (results.length < 20) walk(c, results);
                }
            }
            const r = [];
            walk(document.body, r);
            return r;
        })()`,
        returnByValue: true
    }}));
});
ws.on('message', d => {
    const msg = JSON.parse(d);
    if (msg.result?.result?.value) {
        const items = msg.result.result.value;
        for (const item of items) {
            console.log(`[${item.opacity}] ${item.tag} cls="${item.cls.slice(0,40)}" bg=${item.bg} color=${item.color} → "${item.text.slice(0,50)}"`);
        }
    }
    process.exit(0);
});
setTimeout(() => process.exit(1), 5000);