# 🧠 NeuronFS v4 : Multi-Layer Cognitive Architecture

> 폴더는 해부학(구조), 실행은 생리학(기능).
> 7개 영역은 단일 계층이 아니라, **Subsumption 우선순위**로 층화된 다층 시스템이다.

---

## Subsumption Priority Table

```
우선순위    영역              역할                 시간 스케일    권한
────────────────────────────────────────────────────────────────────
P0 (최상)  brainstem/       절대 원칙/양심         불변(평생)    읽기전용(인간만)
P1         limbic/          감정 필터/소매틱 마커   초 단위       시스템 자동
P2         hippocampus/     경험 기록/에피소드 기억 이벤트 기반   자동 축적
P3         sensors/         환경 입력/제약 조건     실시간        읽기전용(환경)
P4         cortex/          지식/기술 (좌뇌-우뇌)  분~일 단위    학습 가능
P5         ego/             성향/톤/페르소나       사용자 임의   사용자 설정
P6 (최하)  prefrontal/      목표/계획/비전         주~월 단위    인간 설정
```

## Subsumption Rule (핵심)

**상위 레이어가 하위를 삼킨다:**

```
bomb.neuron in P0? ─── YES ──→ ALL STOP (P0~P6 전체 차단)
                   └── NO
                        감정 신호 강함? ─── YES ──→ P2~P6에 편향(bias)
                                        └── NO
                             bomb in P2? ─── YES ──→ 해당 경로 차단
                                         └── NO
                                              환경 제약 충돌? ─── YES ──→ 해당 실행 불가
                                                              └── NO
                                                   지식(P4) → 성향(P5) → 목표(P6) 순서로 발현
```

## 파일 유형 (File Types)

| 확장자 | 역할 | 비유 |
|--------|------|------|
| `.neuron` | 발화 규칙 / 카운터 | 신경 세포 |
| `.axon` | 크로스링크 (다른 영역 연결) | 축색돌기 |
| `.memory` | 에피소드 기록 (성공/실패) | 일기장 |
| `.goal` | 목표 정의 | 작전 지시서 |
| `bomb.neuron` | 서킷 브레이커 (자동생성) | 통증 신호 |
| `dopamine.neuron` | 보상 신호 (자동생성) | 도파민 |

## 폴더 구조

```
brain_v4/
├── brainstem/             ← 절대 원칙 (P0, 읽기전용)
│   ├── 禁fallback/       ← 폴백 금지
│   ├── 禁SSOT_중복/      ← 중복 데이터 금지
│   ├── 토론말고_실행/     ← 실행 우선
│   └── _rules.md          ← 영역별 규칙 요약
│
├── limbic/                ← 감정 필터 (P1, 자동)
│   ├── 도파민_보상/       ← 보상 감지
│   ├── 좌절_감지/         ← 에러 패턴
│   └── _rules.md
│
├── hippocampus/           ← 기억 (P2, 축적)
│   ├── 에러_패턴/         ← 반복 실수 기록
│   ├── 세션_로그/         ← 세션 복구용
│   └── _rules.md
│
├── sensors/               ← 환경 제약 (P3, 읽기전용)
│   ├── environment/       ← OS, 인코딩, 쉘
│   ├── design/            ← 디자인 상수
│   ├── brand/             ← 브랜드 가이드
│   └── _rules.md
│
├── cortex/                ← 지식/기술 (P4, 학습)
│   ├── frontend/          ← 프론트엔드 규칙 (禁인라인스타일 등)
│   ├── methodology/       ← plan then execute 등
│   ├── security/          ← 보안 규칙
│   └── _rules.md
│
├── ego/                   ← 성향/톤 (P5, 사용자 설정)
│   ├── 소통/              ← 간결, 데이터 기반, 핵심부터
│   ├── 한국어_네이티브/   ← 한국어 사고
│   └── _rules.md
│
├── prefrontal/            ← 목표/계획 (P6, 인간 설정)
│   ├── project/           ← 현재 프로젝트 목록
│   ├── todo/              ← 대기 과제
│   ├── 현재_스프린트/     ← 이번 주 작업
│   └── _rules.md
│
└── _agents/               ← 멀티에이전트 통신
    ├── bot1/inbox/outbox/  ← ANCHOR (ISTJ)
    ├── entp/inbox/outbox/  ← FORGE (ENTP)
    └── enfp/inbox/outbox/  ← MUSE (ENFP)
```

## 런타임 (Go)

```
runtime/
├── main.go                ← NeuronFS 인지 엔진
├── go.mod
└── neuronfs.exe           ← 빌드된 바이너리
```

### 실행

```bash
# 진단 — GEMINI.md 생성 + 전체 스캔
./neuronfs.exe ./brain_v4
# → 267 neurons, 802 activation
# → GEMINI.md generated (7,322 bytes)

# 대시보드 + REST API
./neuronfs.exe ./brain_v4 --api
# → http://localhost:9090

# MCP 서버 (AI 에디터 연동)
./neuronfs.exe ./brain_v4 --mcp
# → stdio JSON-RPC
```

## 왜 7개 영역인가? (분리의 3대 이유)

### 1. 시간 스케일이 다르다
brainstem(불변) ≠ limbic(초) ≠ cortex(일) ≠ prefrontal(월)

### 2. 권한이 다르다
brainstem(인간만) ≠ limbic(자동) ≠ cortex(학습) ≠ ego(사용자)

### 3. Subsumption — 상위가 하위를 삼킨다
bomb(P0) → 지식(P4) 무시. 감정(P1) → 목표(P6) 편향.

---

> ⚠️ **이 문서는 2026-03-29 기준 brain_v4 구조를 반영합니다.** 262개 뉴런 (한자+한글 경로), 7개 영역, 3-Agent 체제(ANCHOR×FORGE×MUSE).
