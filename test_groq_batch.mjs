// Groq 배치 분석 실전 테스트
import https from 'https';
import { readFileSync, writeFileSync } from 'fs';

const GROQ_API_KEY = process.env.GROQ_API_KEY;
const tf = 'C:\\Users\\BASEMENT_ADMIN\\NeuronFS\\brain_v4\\_transcripts\\2026-03-28.txt';
const lines = readFileSync(tf, 'utf8').split('\n').filter(l => l.trim());
const transcript = lines.slice(-60).join('\n');

console.log(`전사 ${lines.length}줄 중 마지막 60줄 사용`);

const systemPrompt = `당신은 NeuronFS 교정 감지기입니다. PD(사용자)가 AI를 교정한 부분을 찾아 뉴런 경로로 변환합니다.

뉴런 경로 규칙:
- 7개 영역: brainstem, limbic, hippocampus, sensors, cortex, ego, prefrontal
- 반드시 영역/카테고리/규칙명 3단계 경로 사용 (예: cortex/frontend/禁console_log)
- 영역명만 단독 사용 금지
- 한글/한자 사용 (금지: 禁 접두어)
- snake_case 또는 한글 조합

JSON으로만 응답 (마크다운 코드블록 없이):
{"corrections":[{"path":"cortex/coding/禁하드코딩","reason":"교정 사유","counter_add":1}],"insights":[{"path":"cortex/methodology/발견명","reason":"사유"}]}`;

const body = JSON.stringify({
    model: 'llama-3.3-70b-versatile',
    messages: [
        { role: 'system', content: systemPrompt },
        { role: 'user', content: `대화 전사:\n${transcript}` }
    ],
    temperature: 0.3,
    max_tokens: 1500
});

const req = https.request({
    hostname: 'api.groq.com',
    path: '/openai/v1/chat/completions',
    method: 'POST',
    headers: {
        'Authorization': `Bearer ${GROQ_API_KEY}`,
        'Content-Type': 'application/json'
    }
}, res => {
    let data = '';
    res.on('data', c => data += c);
    res.on('end', () => {
        try {
            const resp = JSON.parse(data);
            const content = resp.choices[0].message.content;
            console.log('=== Groq 원본 응답 ===');
            console.log(content);
            
            // JSON 파싱
            const jsonMatch = content.match(/\{[\s\S]*\}/);
            if (jsonMatch) {
                const analysis = JSON.parse(jsonMatch[0]);
                console.log('\n=== 파싱 결과 ===');
                console.log('교정:', JSON.stringify(analysis.corrections, null, 2));
                console.log('인사이트:', JSON.stringify(analysis.insights, null, 2));
                writeFileSync('C:\\Users\\BASEMENT_ADMIN\\NeuronFS\\groq_test_result.json', JSON.stringify(analysis, null, 2), 'utf8');
            }
        } catch (e) {
            console.log('파싱 실패:', e.message);
            console.log('원본:', data.slice(0, 500));
        }
    });
});
req.write(body);
req.end();
