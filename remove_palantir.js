const fs = require('fs');

function patchKo() {
    let text = fs.readFileSync('README.ko.md', 'utf8');
    const targetRegex = /팔란티어\(Palantir\)의 도박은 '더 똑똑한 AI'가 아니었습니다\. '더 엄격한 파이프라인'이었습니다\. NeuronFS는 똑같은 철학을 파일시스템 위에서, 0달러로, 누구나 쓸 수 있게 구현한 결과물입니다\.\r?\n\r?\n?/;
    if (targetRegex.test(text)) {
        text = text.replace(targetRegex, '');
        fs.writeFileSync('README.ko.md', text, 'utf8');
        console.log('KO patched successfully');
    } else {
        console.log('KO target not found');
    }
}

function patchEn() {
    let text = fs.readFileSync('README.md', 'utf8');
    const targetRegex = /Palantir's bet wasn't a smarter AI — it was a stricter pipeline\. This is the same bet, on a filesystem, for anyone\.\r?\n\r?\n?/;
    if (targetRegex.test(text)) {
        text = text.replace(targetRegex, '');
        fs.writeFileSync('README.md', text, 'utf8');
        console.log('EN patched successfully');
    } else {
        console.log('EN target not found');
    }
}

patchKo();
patchEn();
