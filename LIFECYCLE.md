# 🧬 NeuronFS 뉴런 생애주기 (Neuron Lifecycle)

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
| Memory Observer가 대화 패턴 감지 | 3KB 청크 워터마크 초과 시 자동 뉴런화 |
| 사용자가 직접 생성 | `mkdir brain/cortex/.../새규칙` + `touch 1.neuron` |

**규칙:**
- 최소 2단계 계층 필수 (`region/category/neuron_name`)
- 한글 + 한자 마이크로옵코드 사용 (`禁`, `必`, `推`)
- 공백 금지, 언더스코어 구분

---

## 2. 강화 (Reinforcement)

| 신호 | 파일 | 효과 |
|------|------|------|
| 반복 교정 | `N.neuron` 카운터 증가 | 시스템 프롬프트에서 더 상위에 배치 |
| 칭찬 | `dopamineN.neuron` 생성 | 긍정 가중치 상승 |
| 반대 의견 | `N.contra` 생성 | 극성(polarity) 하락 |

**빈도별 등급:**

| 카운터 | 등급 | 동작 |
|--------|------|------|
| 1~4 | 일반 | `_rules.md`에만 기록 |
| 5~9 | 반복됨 | 강력 마크 |
| 10+ | **확신** | bootstrap에 발견. 매 세션 주입 |
| 30+ | **법** | brainstem 승격 검토 대상 |

---

## 3. 교정 감사 (Hygiene Audit)

> **뉴런이 쌓이기만 하면 오염된다. 정기적 감사가 필수다.**

### 자동 감사 (런타임 구현 완료)

| 항목 | 주기 | 구현 | 코드 |
|------|------|------|------|
| 중복 탐지 (Jaccard) | 유휴 시 자동 / API 수동 | ✅ 구현됨 | `deduplicateNeurons()`, `/api/dedup` |
| dormant 마킹 | `--decay` 또는 유휴 시 자동 | ✅ 구현됨 | `runDecay()`, 30일 기본 |
| bomb 감지 + 물리 경보 | 매 스캔 시 | ✅ 구현됨 | `triggerPhysicalHook()` |

### 자동 감사 (향후 구현 예정)

| 항목 | 주기 | 상태 |
|------|------|------|
| 영/한 중복 자동 병합 | 주 1회 | 🔧 계획 |
| 개인정보 경로 스캔 | 매 commit | 🔧 계획 (git hook) |
| 빈 폴더 격리 | 매일 | 🔧 계획 (삭제 아닌 `_quarantine/`로 이동) |

### 수동 감사 (분기 1회 권장)

| 항목 | 체크 내용 |
|------|----------|
| **리전 정합성** | brainstem에 런타임 버그픽스가 있진 않은가? |
| **중의적 이름** | 외부인이 읽어도 뜻이 명확한가? |
| **카운터 진실성** | 인위적으로 올린 카운터가 없는가? |
| **계층 깊이** | flat 뉴런이 카테고리 없이 떠돌고 있진 않은가? |
| **중복/병합** | 같은 의미의 뉴런이 다른 이름으로 존재하지 않는가? |

---

## 4. 성숙 (Maturation)

| 조건 | 결과 |
|------|------|
| 카운터 10+ & 도파민 3+ | **핵심 뉴런** 승격. Tier 1에 포함 |
| 30일간 카운터 변동 없음 | **안정 뉴런**. 더 이상 교정이 필요 없는 상태 |
| brainstem 후보 | 카운터 30+, 폴래리티 +0.8 이상 → P0 승격 검토 |

---

## 5. 수면 (Dormancy)

| 트리거 | 결과 |
|--------|------|
| 30일 미접촉 | `*.dormant` 마킹 |
| `--decay` 명령 | 수면 뉴런 일괄 처리 |

**수면은 삭제가 아니다.** 컴파일에서 제외되지만 폴더는 유지된다. 다시 교정되면 즉시 부활한다.

---

## 6. 폭탄 (Circuit Breaker)

| 트리거 | 결과 |
|--------|------|
| 동일 실수 3회 반복 | `bomb.neuron` 생성 |
| 물리 알람 발동 | USB 사이렌 + 전체화면 빨간 플래시 |
| 해당 영역 전체 출력 중단 | cortex bomb → 코딩 자체 불가 |
| 해제 | `rm bomb.neuron` — 파일 삭제 1개 |

---

## 7. 소멸 (Apoptosis)

| 조건 | 결과 |
|------|------|
| dormant 90일 초과 + 카운터 1 | 삭제 후보 목록에 추가 |
| 수동 `prune` 명령 | 사용자 승인 후 삭제 |

**소멸은 항상 사용자 승인이 필요하다.** 자동 삭제는 없다.

---

## 생애주기 다이어그램

```
  사용자 교정
      │
      ▼
  ┌─ 탄생 ──┐
  │ mkdir   │
  │ 1.neuron│
  └────┬────┘
       │
       ▼
  ┌─ 강화 ──────────────────┐
  │ counter++  dopamine++   │
  │ contra → polarity shift │
  └────┬────────────────────┘
       │
       ├── counter 10+ → Tier 1 승격
       │
       ├── 30일 미접촉 → 수면 (dormant)
       │                    │
       │                    ├── 재교정 → 부활
       │                    └── 90일 → 소멸 후보
       │
       └── 3회 반복 실수 → 폭탄 (bomb)
                              │
                              └── rm bomb → 정상 복귀
```

---

## 와치독 생애주기 (Watchdog Lifecycle)

> **와치독이 죽으면 뇌가 죽는다.** 그리고 아무도 모른다.

### 아키텍처: 3계층 감시

```
[OS 자동시작]              ← 예약 작업 / 서비스 (와치독의 와치독)
    │
    └── [Supervisor]       ← neuronfs --supervisor (프로세스 매니저)
           │
           ├── neuronfs-api     ← --api (대시보드 + heartbeat + idle engine)
           ├── neuronfs-watch   ← --watch (fsnotify 폴더 감시)
           └── auto-accept      ← node (CDP 전사)
```

### 각 계층의 역할

| 계층 | 이름 | 죽으면? | 자동복구? |
|------|------|---------|----------|
| **L0** | OS 예약 작업 | 재부팅 시 아무것도 안 뜸 | ✅ OS가 보장 |
| **L1** | Supervisor | heartbeat/idle/watch 전멸 | ❌ L0 필요 |
| **L2** | neuronfs-api | heartbeat+idle 정지 | ✅ L1이 재시작 |
| **L2** | neuronfs-watch | 폴더 변경 감지 불가 | ✅ L1이 재시작 |
| **L2** | auto-accept | CDP 전사 중단 | ✅ L1이 재시작 |

### 자기 감시 메커니즘

| 항목 | 방법 | 구현 |
|------|------|------|
| Supervisor 상태 로그 | `logs/supervisor.log` 60초 주기 | ✅ `svStatus()` |
| 자식 프로세스 crash 감지 | exit code 감시 → 지수 백오프 재시작 | ✅ `svSupervise()` |
| Harness 위반 탐지 | 10분 주기 harness.ps1 실행 | ✅ `svHarness()` |
| **Supervisor 자체 생존** | **OS 예약 작업이 감시** | 🔧 등록 필요 |
| **Heartbeat 로그 mtime** | `_transcripts/` 갱신 여부로 전체 시스템 판단 | ✅ 구현 |

### 현재 문제 (2026-03-31 감사 결과)

```
❌ OS 자동시작 (L0) — 예약 작업 미등록. 재부팅 시 전 시스템 사망
❌ Supervisor (L1) — 프로세스 미실행. 모든 자식 죽음
❌ bot-heartbeat.mjs — 삭제됨 (Go로 대체했으나 Go도 미실행)
❌ agent-bridge.mjs — 삭제됨 (supervisor가 없는 파일 실행 시도 → crash loop)
```

### 해결: L0 등록

```powershell
# Windows 예약 작업으로 supervisor를 OS 부팅 시 자동시작
$action = New-ScheduledTaskAction `
  -Execute "C:\Users\BASEMENT_ADMIN\NeuronFS\runtime\neuronfs.exe" `
  -Argument "C:\Users\BASEMENT_ADMIN\NeuronFS\brain_v4 --supervisor"
$trigger = New-ScheduledTaskTrigger -AtLogOn
$settings = New-ScheduledTaskSettingsSet -RestartCount 3 -RestartInterval (New-TimeSpan -Minutes 1)
Register-ScheduledTask -TaskName "NeuronFS-Supervisor" -Action $action -Trigger $trigger -Settings $settings
```

---

## Heartbeat 자율 루프 (Autonomous Loop)

> **심장이 멈추면 뇌도 죽는다.** Heartbeat는 AI가 유휴 상태일 때 자동으로 뇌를 진화시킨다.

### 실행 주기

```
[10초 간격 폴링]
    │
    ├── _transcripts/ 최신 파일 mtime 확인
    │     └── 60초 이상 갱신 없음 → AI 정지 판정
    │
    ├── AI 정지 감지 시:
    │     ├── prefrontal/todo 에서 다음 작업 추출
    │     ├── CDP 인젝션으로 AI에게 작업 강제 주입
    │     └── 3분 쿨다운 후 재확인
    │
    └── AI 활동 중: 패스
```

### Heartbeat 아젠다 (Idle Engine)

AI가 유휴 판정되면 순차 실행:

| 순서 | 작업 | 코드 | 구현 |
|------|------|------|------|
| 1 | **Auto-evolve** (교정→뉴런) | `processInbox()` → `corrections.jsonl` 파싱 → `mkdir` | ✅ |
| 2 | **Auto-decay** (30일 수면) | `runDecay(brainRoot, 30)` | ✅ |
| 3 | **Dedup** (Jaccard 중복 병합) | `deduplicateNeurons(brainRoot)` | ✅ |
| 4 | **Git snapshot** | `git add -A; git commit` | ✅ |
| 5 | **NAS sync** | `robocopy /MIR` (dormant 제외) | ✅ |
| 6 | **전사 청크 뉴런화** | 3KB 워터마크 초과 시 자동 분류 | 🔧 계획 |

### 전사 청크 뉴런화 (Transcript Chunking → Neuronize)

> **대화가 길어지면 뉴런이 되어야 한다.**

```
_transcripts/session_2026-03-31.jsonl
    │
    ├── 3KB 청크 워터마크 초과 감지
    │
    ├── Groq/로컬 LLM으로 교정 패턴 추출
    │     └── "이 세션에서 반복된 교정 3건 발견"
    │
    ├── 자동 뉴런 생성
    │     └── mkdir brain/cortex/.../추출된_패턴
    │
    └── corrections.jsonl에 기록 → 다음 evolve에서 반영
```

| 항목 | 상태 | 비고 |
|------|------|------|
| 전사 로그 수집 (`_transcripts/`) | ✅ 구현 | auto-accept 전사 로그 |
| 유휴 판정 (mtime 기반) | ✅ 구현 | 60초 임계값 |
| CDP 강제 작업 주입 | ✅ 구현 | `insertText` 패턴 |
| 청크 분할 (3KB 워터마크) | 🔧 계획 | Groq 배치 분석 |
| 자동 뉴런 분류 | 🔧 계획 | 7개 리전 자동 배치 |

### Heartbeat API

```bash
GET  /api/heartbeat                          # 상태 조회
POST /api/heartbeat {"enabled":true}         # ON/OFF 토글
POST /api/heartbeat {"interval":10}          # 폴링 간격 (초)
POST /api/heartbeat {"cooldown":3}           # 주입 후 쿨다운 (분)
```

---

## 마이그레이션 이력 (Migration History)

| 날짜 | 작업 | 결과 |
|------|------|------|
| 2026-03-31 | v1 전수 감사 | 307→293 뉴런. 테스트 2개 삭제, 중복 12개 병합, PD 9개 개명, 5개 리전 이동, 4개 이름 변경 |
