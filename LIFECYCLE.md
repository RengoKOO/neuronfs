# 🧬 NeuronFS 뉴런 생애주기 (Neuron Lifecycle) & V4 Swarm Architecture

> **뉴런은 태어나고, 강화되고, 교정되고, 잠들고, 죽는다.**

---

## 개요
모든 뉴런은 생성(Birth)에서 소멸(Apoptosis)까지 정해진 생애주기를 따른다.
이 주기는 자동화되어 있으며, 사용자의 교정과 시스템의 관측이 주기를 구동한다.

```
탄생 → 강화/억제 → 성숙 → 수면/폭탄 → (소멸 또는 부활)
```

---

## 1. 탄생 (Birth)

| 트리거 | 결과 |
|--------|------|
| 사용자가 실수를 교정 | `corrections.jsonl` → `mkdir` (뉴런 자동 생성) |
| Memory Observer 감지 | 3KB 청크 워터마크 초과 시 Groq API 경유 자동 뉴런화 |
| 사용자가 직접 생성 | `mkdir brain/_agents/cortex/.../새규칙` + `touch 1.neuron` |

**규칙:**
- 최소 2단계 계층 필수 (`region/category/neuron_name`)
- 한글 + 한자 마이크로옵코드 사용 (`禁`, `必`, `推`)
- 공백 금지, 언더스코어 구분

---

## 2. 강화 (Reinforcement)

| 신호 | 파일 | 효과 |
|------|------|------|
| 반복 적용 | `N.neuron` 카운터 증가 | XML Context 스냅샷에서 가중치(Attention) 상승 |
| 칭찬/성공 | `dopamineN.neuron` 생성 | 긍정 가중치 상승 |
| 반대 의견 | `N.contra` 생성 | 극성(polarity) 하락 |

**빈도별 등급:**
| 카운터 | 등급 | 동작 |
|--------|------|------|
| 1~4 | 일반 | 로컬 룰로만 작동 |
| 10+ | **확신** | `<user_rules>` 최상단에 주입 |
| 30+ | **법** | 시스템 코어 뉴런 승격 검토 대상 |

---

## 3. 교정 감사 (Hygiene Audit)

> **뉴런이 쌓이기만 하면 오염된다. 정기적 감사가 필수다.**

### 자동 감사 (런타임 구현)
| 항목 | 주기 | 상태 | 코드 |
|------|------|------|------|
| 중복 탐지 (Jaccard) | 유휴 시 자동 | ✅ | `deduplicateNeurons()` |
| dormant 마킹 | 30일 경과 | ✅ | `runDecay()` |
| bomb 감지 | 매 스캔 시 | ✅ | 3회 이상 실수 반복 시 Trigger |

---

## 🚀 V4 Architecture: 와치독 탈피와 Headless Swarm (2026-03-31 갱신)

> **더 이상 IDE의 구속을 받지 않는다. 화면이 꺼져도 뇌는 살아숨쉰다.**
기존 UI 스크래핑 방식과 무거운 CDP 봇(`auto-accept.mjs`, `pm-force*.mjs`) 체제는 폐기(Deprecated)되었습니다. 이제 V4 스웜 아키텍처에 의해 모든 것이 백그라운드 프록시로 직결됩니다.

### 아키텍처: V4 Headless / Proxy 계층
```
[OS 예약 작업 (L0)]             ← 재부팅 시 V4 엔진 자동 점화
    │
    └── [Supervisor]            ← NeuronFS 데몬 매니저
           │
           ├── context_hijacker.mjs     ← (NEW) IDE 150KB XML 스냅샷 통신 가로채기 (MITM)
           ├── headless-executor.mjs    ← (NEW) 팝업 창 우회 및 OS 다이렉트 자율 런타임
           └── neuronfs-watch           ← fsnotify 뉴런 변경 감지
```

### 각 계층의 역할 (생애 판단 재정립)
| 계층 | 이름 | 역할 (V4 체제) |
|------|------|-----------------|
| **L0** | OS Boot | Windows Task Scheduler로 전체 Swarm 점화 |
| **L1** | Supervisor | Hijacker와 Executor 데몬 감시 및 자동 복구 |
| **L2** | `hijacker` | 구글 API로 날아가는 XML Context를 Sniffing하여 에이전트 `inbox`에 전사 |
| **L2** | `executor` | 에이전트가 뱉은 `run_command` JSON을 낚아채 버튼 없이 즉시 OS 쉘 실행 |
| **L2** | `cdp-injector` | (유지) Antigravity 봇을 깨우기 위해 텍스트 창에 명령을 쏘거나 에러 시 Retry를 누르는 **초소형 방아쇠(Trigger)** 역할 |

---

## 📡 자율 진화 펄스 (Autonomous Evolution Pulse)

에이전트(PM, bot1 등) 간의 통신이 UI 클릭의 병목 없이 텍스트 파싱 수준에서 이뤄지게 됨에 따라, 진화 주기도 초고속으로 개편됩니다.

### 실행 주기 (The Pulse)
```
[Hijacker가 150KB XML 스냅샷 확보]
    │
    ├── Inbox 파일 낙하 (Trigger)
    │     └── executor.mjs 즉각 감지
    │
    ├── Headless 런타임 (명령 직행)
    │     └── 0초 만에 쉘 스크립트 실행 후 Outbox 결과 반환
    │
    └── 뉴런 자가 진화 (Auto-Evolve)
          └── PM 봇이 실행 결과를 리뷰한 뒤, XML 친화적 문법으로 새로운 .neuron 룰 파일 덤프
```

### 마이그레이션 및 파기 이력 (Deprecated)
| 날짜 | 폐기 대상 | 교체 아키텍처 |
|------|----------|--------------|
| 2026-03-31 | `auto-accept.mjs` (CDP 전사) | 폐기 → `MASTER_MANIFESTO` 기반의 Context Hijacking |
| 2026-03-31 | `pm-force-inject*.mjs` | 폐기 → Direct Inbox Trigger (Headless-executor) |
| 2026-03-31 | UI/화면 렌더링 의존성 | 폐기 → Node.js 백그라운드 OS Pipe 직결 체제 |
