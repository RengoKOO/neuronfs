<p align="center">
  <img src="https://img.shields.io/badge/Go-1.22+-00ADD8?style=flat-square&logo=go" />
  <img src="https://img.shields.io/badge/Architecture-Cognitive_Engine-blueviolet?style=flat-square" />
  <img src="https://img.shields.io/badge/License-MIT-green?style=flat-square" />
  <img src="https://img.shields.io/badge/Status-Production-brightgreen?style=flat-square" />
</p>

# 🧠 NeuronFS

**Folder-as-Neuron Cognitive Engine** — AI가 스스로 학습하고, 기억하고, 진화하는 파일시스템 기반 인지 아키텍처.

> *"폴더가 뉴런이고, 경로가 문장이며, 카운터가 활성도이다."*

NeuronFS는 기존 AI 메모리 프레임워크(Mem0, Letta, Zep)가 해결하지 못하는 문제를 풀기 위해 탄생했습니다:
**외부 DB 없이, 파일시스템만으로 AI의 인지 상태를 완전히 관리하는 것.**

---

## 왜 NeuronFS인가?

### 기존 솔루션의 한계

| 프레임워크 | 접근 방식 | 한계 |
|-----------|----------|------|
| **Mem0** | Vector + Graph 메모리 레이어 | 기존 에이전트에 "볼트온" — 자율 진화 불가 |
| **Letta** (MemGPT) | OS 영감 에이전트 런타임 | LLM이 자기 메모리를 관리 — 환각·오류에 취약 |
| **Zep** | Temporal Knowledge Graph | 시간축 관계 추적 특화 — 범용 거버넌스 불가 |
| **LangGraph** | 상태 머신 기반 워크플로우 | 선언적 규칙 관리 없음 — 코드 변경 필요 |

### NeuronFS의 차별점

| 특성 | NeuronFS | Mem0 | Letta | Zep |
|------|----------|------|-------|-----|
| **저장소** | 파일시스템 (Zero-dependency) | Vector DB + Graph | SQLite/Postgres | Neo4j/Postgres |
| **투명성** | `ls`로 전체 인지 상태 확인 | API 호출 필요 | ADE 필요 | Dashboard 필요 |
| **자율 진화** | Groq + Git diff 판정 | ❌ | LLM 자기관리 | ❌ |
| **거버넌스** | Subsumption 억제 체계 | ❌ | ❌ | ❌ |
| **안전장치** | bomb.neuron (회로차단) | ❌ | ❌ | ❌ |
| **외부 의존성** | Go 바이너리 하나 | Python + Vector DB | Python + DB | Python + Graph DB |
| **Git 버전관리** | 내장 (자동 스냅샷 + rollback) | ❌ | ❌ | ❌ |

---

## 핵심 공리 (Axioms)

```
1. Folder = Neuron     — 폴더 이름이 곧 의미, 깊이가 구체성
2. File = Firing Trace — N.neuron = 활성 카운터, dopamine = 보상, bomb = 고통
3. Path = Sentence     — brain/cortex/css/글래스_blur20 → "cortex > css > 글래스 blur20"
4. Counter = Activation — 높을수록 강한 경로 (수초화)
5. AI writes back      — 카운터 증가 = 경험 축적
```

## 뇌 구조 (7개 영역)

```
brain_v4/
├── brainstem/    [P0] 핵심 정체성 — 읽기 전용, 불변
├── limbic/       [P1] 감정 필터 — 긴급/도파민/아드레날린
├── hippocampus/  [P2] 기억/기록 — 교정 로그, 세션 기록
├── sensors/      [P3] 환경 제약 — 브랜드, 디자인, NAS, 도구
├── cortex/       [P4] 지식/기술 — 코딩, 방법론, 뉴런 운영
├── ego/          [P5] 성향/톤 — 한국어 네이티브, 전문가 간결
└── prefrontal/   [P6] 목표/계획 — 프로젝트, TODO, 장기 방향
```

**Subsumption Cascade**: 낮은 P가 높은 P를 항상 억제. `brainstem`에 `bomb.neuron`이 생기면 **전체 정지**.

---

## 아키텍처

```
┌─────────────────────────────────────────────────────────┐
│                    NeuronFS Runtime                      │
│                                                         │
│  ┌──────────┐  ┌──────────┐  ┌──────────┐              │
│  │ Scanner  │→ │Subsumption│→ │ Emitter  │→ GEMINI.md   │
│  │(Tree→    │  │(Priority  │  │(Rules→   │  (AI 주입)    │
│  │ Neurons) │  │ Cascade)  │  │ Prose)   │              │
│  └──────────┘  └──────────┘  └──────────┘              │
│                                                         │
│  ┌──────────┐  ┌──────────┐  ┌──────────┐              │
│  │ fsnotify │  │ Heartbeat│  │ Git Diff │              │
│  │(Event    │  │(CDP Pulse│  │(Evolution│              │
│  │ Driven)  │  │ Injector)│  │ Judge)   │              │
│  └──────────┘  └──────────┘  └──────────┘              │
│                                                         │
│  REST API (:9090) | Dashboard | Groq Evolve | NAS Sync  │
└─────────────────────────────────────────────────────────┘
```

---

## 빠른 시작

### 설치

```bash
git clone https://github.com/your-username/NeuronFS.git
cd NeuronFS/runtime
go build -o ../neuronfs .
```

### 실행

```bash
# 진단 모드 (뇌 상태 출력)
./neuronfs ./brain_v4

# API 서버 + 대시보드 + 하트비트 시작
./neuronfs ./brain_v4 --api

# 규칙을 GEMINI.md에 주입
./neuronfs ./brain_v4 --inject

# Groq 기반 자율 진화
GROQ_API_KEY=gsk_xxx ./neuronfs ./brain_v4 --evolve
```

### REST API

```bash
# 뉴런 생성
curl -X POST http://localhost:9090/api/grow \
  -d '{"path":"cortex/testing/새로운_규칙"}'

# 뉴런 발화 (카운터 +1)
curl -X POST http://localhost:9090/api/fire \
  -d '{"path":"cortex/methodology/로컬깃_생활화"}'

# 도파민 신호
curl -X POST http://localhost:9090/api/signal \
  -d '{"path":"cortex/frontend/css/글래스_blur20", "type":"dopamine"}'

# 뇌 상태 조회
curl http://localhost:9090/api/brain
```

---

## 자율 운영 루프

NeuronFS는 인간 개입 없이 자율적으로 운영됩니다:

1. **fsnotify 이벤트 루프** — `_inbox/corrections.jsonl` 변화 감지 → 즉시 뉴런 생성/강화
2. **하트비트 (Heartbeat)** — 3분 유휴 시 `prefrontal/todo`에서 다음 작업 추출 → CDP로 IDE 챗창에 강제 주입
3. **유휴 엔진 (Idle Engine)** — 5분 유휴 시 Groq 자율 진화 → Git 스냅샷 → NAS 동기화
4. **Git 진화 판정** — commit 후 `diff` 분석, 뉴런 순감소면 자동 `revert`
5. **auto-accept** — AI 출력을 CDP로 스크래핑 → Groq 배치 분석 → 뉴런 교정

```
AI 출력 → [auto-accept] → _inbox → [fsnotify] → 뉴런 성장
         ↓                                        ↓
    Groq 분석                              GEMINI.md 재주입
         ↓                                        ↓
   뉴런 교정 ──────────────────────────→ AI 행동 변화
```

---

## 신호 시스템

| 파일 | 의미 | 효과 |
|------|------|------|
| `N.neuron` | 발화 카운터 | N이 높을수록 강한 경로 |
| `dopamineN.neuron` | 보상 신호 | PD 칭찬 시 생성, 경로 강화 |
| `bomb.neuron` | 고통/차단 | 3회 반복 실패 시, 해당 회로 전체 정지 |
| `memory.neuron` | 에피소드 기억 | 특정 맥락 보존 |
| `decay.dormant` | 휴면 | 30일 미사용 시 자동 격리 (삭제 아님) |

---

## 개발

```bash
# 테스트 실행
cd runtime && go test -v

# 빌드
go build -o ../neuronfs .

# CDP 인젝션 테스트 (Node.js 필요)
cd runtime && npm install
node pulse.mjs "테스트 메시지"
```

### 프로젝트 구조

```
NeuronFS/
├── brain_v4/           # 뇌 데이터 (7개 영역 + 뉴런)
│   ├── brainstem/      # P0 — 핵심 정체성
│   ├── limbic/         # P1 — 감정 필터
│   ├── hippocampus/    # P2 — 기억/기록
│   ├── sensors/        # P3 — 환경 제약
│   ├── cortex/         # P4 — 지식/기술
│   ├── ego/            # P5 — 성향/톤
│   ├── prefrontal/     # P6 — 목표/계획
│   └── _inbox/         # 외부 입력 큐
├── runtime/            # Go 소스 코드
│   ├── main.go         # 메인 엔진 (스캐너, 서브섬션, API, 이벤트 루프)
│   ├── emit.go         # 규칙 생성기 (뉴런 → 산문 텍스트)
│   ├── evolve.go       # Groq 기반 자율 진화 엔진
│   ├── init.go         # 초기 뇌 부트스트랩
│   ├── dashboard.go    # 웹 대시보드 서버
│   ├── dashboard_html.go # 내장 대시보드 HTML
│   ├── main_test.go    # 테스트 스위트
│   └── pulse.mjs       # CDP 기반 IDE 챗 주입기
├── .gitignore
├── LICENSE
└── README.md
```

---

## 철학

NeuronFS는 단순한 메모리 프레임워크가 아닙니다. **AI의 인지 거버넌스 엔진**입니다.

- **투명성**: `ls brain_v4/cortex/`로 AI가 무엇을 아는지 즉시 확인
- **감사 가능성**: 모든 학습이 Git 히스토리로 추적 가능
- **안전성**: `bomb.neuron`으로 위험한 패턴을 물리적으로 차단
- **자율성**: 인간 개입 없이 스스로 학습하고, 판단하고, 실행
- **이식성**: 파일과 폴더만 있으면 어떤 AI 시스템에든 이식 가능

> *"기억은 인프라이지, 에이전트 로직이 아니다."*

---

## 라이선스

MIT License — 자유롭게 사용, 수정, 배포하세요.

Copyright (c) 2026 박정근 (PD) — VEGAVERY RUN®
