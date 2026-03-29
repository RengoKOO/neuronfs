# 🧠 NeuronFS 마스터 운영 문서

> **SSOT** — 이 문서가 NeuronFS 시스템의 유일한 진실.  
> **위치** — 코드와 함께 Git 추적. 세션 간 유실 없음.  
> **최종 갱신** — 2026-03-29 22:54 KST  
> **현재 상태** — 314 neurons | 453 activation | NOMINAL

---

## 1. Axiom (절대 원칙)

```
Folder = Neuron       ← 디렉토리 자체가 뉴런. 디렉토리명이 규칙명.
File   = Trace        ← 파일은 가중치/카운터/신호의 흔적.
Path   = Sentence     ← 경로가 규칙 문장을 형성.
```

### ⚠️ 혼동 금지

| 맞음 ✅ | 틀림 ❌ |
|---------|---------|
| 디렉토리가 뉴런 | .neuron 파일이 뉴런 |
| .neuron은 가중치 트레이스 | .neuron이 없으면 뉴런 아님 |
| 디렉토리명 = 규칙명 | 파일명 = 규칙명 |

---

## 2. 7개 리전 Subsumption 계층

```
P0 brainstem     양심/본능     불변(평생)    읽기전용(인간만)
P1 limbic        감정 필터     초 단위       시스템 자동
P2 hippocampus   기록/기억     이벤트 기반   자동 축적
P3 sensors       환경 제약     실시간        읽기전용(환경)
P4 cortex        지식/기술     분~일 단위    학습 가능
P5 ego           성향/톤       사용자 임의   사용자 설정
P6 prefrontal    목표/계획     주~월 단위    인간 설정
```

**상위 P가 하위 P를 삼킨다.** bomb(P0) → 전체 정지.

### 두 가지 뉴런 형태

| 형태 | 설명 | 리전 |
|------|------|------|
| **폴더형** | 하위 디렉토리가 뉴런 | cortex, sensors, hippocampus, prefrontal |
| **플랫형** | 리전 루트에 `이름.카운터.neuron` 직접 존재 | brainstem, limbic, ego |

---

## 3. 파일 타입

| 확장자 | 역할 | 예시 |
|--------|------|------|
| `N.neuron` | 발화 카운터 (가중치) | `16.neuron` = 16번 발화 |
| `dopamineN.neuron` | 보상 신호 | `dopamine3.neuron` |
| `bomb.neuron` | 서킷 브레이커 (3회 반복 실수) | 해당 경로 자동 차단 |
| `*.dormant` | 휴면 (30일 미발화) | 자동 격리 |
| `*.axon` | 리전 간 연결 | `cortex→hippocampus` |
| `*.memory` | 에피소드 기록 | 성공/실패 |
| `*.goal` | 목표 정의 | prefrontal 영역 |
| `*.geofence` | 컨텍스트 마스킹 | 특정 디렉토리에서만 적용 |
| `_rules.md` | 영역별 규칙 요약 (자동생성) | emit.go |

---

## 4. 실행 스택

### 계층 구조

```
Layer 0  PD (박정근)          최종 의사결정
Layer 1  PM                   전략 · 관제 · 지시 · 리뷰
         ┌─────────────────────────────────────────┐
Layer 2  │  supervisor (Go)    heartbeat (Node)     │  ← PM의 도구
         │  프로세스 생존 보장   봇 idle→킥/브리핑    │
         └─────────────────────────────────────────┘
Layer 3  bot1 (ANCHOR)   entp (FORGE)   enfp (MUSE)    ← 작업 에이전트
```

### 진입점: `run-auto-accept.bat`

```
run-auto-accept.bat
├── Antigravity (CDP port 9000)
├── 봇 워크스페이스 열기 (bot1, entp, enfp)
├── neuronfs --supervisor          ← 이것 1개가 전부 관리
│    ├── neuronfs --api            (자동 spawn + 재시작)
│    ├── neuronfs --watch          (자동 spawn + 재시작)
│    ├── agent-bridge.mjs          (자동 spawn + 재시작)
│    ├── auto-accept.mjs           (자동 spawn + 재시작)
│    ├── bot-heartbeat.mjs         (자동 spawn + 재시작)
│    ├── robocopy NAS sync         (Go goroutine, 5초)
│    └── harness 10분 주기         (Go goroutine)
└── kickstart.mjs                  ← 부팅 시 1회 에이전트 초기화
```

### 프로세스 역할 상세

| 프로세스 | 언어 | 역할 | PM 관계 |
|----------|------|------|---------|
| **neuronfs --supervisor** | Go | 전체 프로세스 spawn + 감시 + 재시작 | PM의 인프라 도구 |
| **neuronfs --watch** | Go | fsnotify 감시 → processInbox → emit | supervisor가 관리 |
| **neuronfs --api** | Go | 대시보드 + REST API `:9090` | supervisor가 관리 |
| **auto-accept.mjs** | Node | CDP로 봇 버튼 자동 클릭 | supervisor가 관리 |
| **agent-bridge.mjs** | Node | `_agents/{bot}/inbox/` 폴링 → CDP 주입 | supervisor가 관리 |
| **bot-heartbeat.mjs** | Node | 봇 idle 감지 + PM 브리핑 | PM의 도구 (lock 제어) |

### supervisor vs heartbeat (명확 분리)

| 도구 | 관심사 | PM 제어 | 비유 |
|------|--------|---------|------|
| **supervisor** | 프로세스가 **살아있는가** | bat에서 1회 시작 | 심폐소생기 |
| **heartbeat** | 봇이 **일하고 있는가** | heartbeat.lock ON/OFF | 감독관의 호루라기 |
| **harness** | 시스템이 **건강한가** | supervisor가 10분마다 자동 | 건강검진 |

### heartbeat 킥 로직

| 대상 | 킥 내용 | 조건 |
|------|---------|------|
| bot1/entp/enfp | backlog에서 다음 작업 주입 | idle 45초 + backlog에 작업 있음 |
| **PM** | 에이전트 산출물 브리핑 ("X가 Y를 했다. 검토하라.") | PM idle 45초 |

- PM은 backlog 주입 대상이 **아님** — 브리핑만 받음
- PM이 heartbeat를 통제 (heartbeat.lock)
- 순환종속 없음

### heartbeat.lock (PM 통제)

```powershell
# 킥 비활성화 (봇 자율 작업 중단)
New-Item brain_v4/_agents/pm/heartbeat.lock -Force

# 킥 재활성화
Remove-Item brain_v4/_agents/pm/heartbeat.lock
```

### 통신 구조

**인프라 0원 원칙: 파일시스템이 유일한 IPC**

```
PD 교정 → AI가 corrections.jsonl 기록 (로컬 _inbox/)
  → fsnotify 감지 → processInbox()
  → 뉴런 디렉토리 생성 or fire
  → writeAllTiers() → GEMINI.md + _rules.md 갱신

supervisor 감시 루프:
  1. 5개 프로세스 생존 확인 → 사망 시 exponential backoff 재시작
  2. harness 10분마다 실행 → 위반 시 bot1/inbox에 알림
  3. heartbeat 로그 1분 → 전체 상태 원라인
  4. NAS robocopy 5초 → 로컬→NAS 단방향

에이전트 간 통신:
  brain_v4/_agents/{name}/inbox/   ← 수신
  brain_v4/_agents/{name}/outbox/  ← 송신
  PM → bot1/inbox/ (지시)
  heartbeat → bot1/inbox/ (harness 위반 알림)
```

### API 엔드포인트

| Method | Path | 소스 |
|--------|------|------|
| GET | `/api/state` | **brain_state.json 파일 읽기** (실시간 아님) |
| GET | `/api/brain` | `scanBrain()` 실시간 |
| POST | `/api/grow` | 뉴런 디렉토리 생성 |
| POST | `/api/fire` | 카운터 증가 |
| POST | `/api/signal` | 도파민/bomb/memory |
| POST | `/api/sandbox` | 대시보드 샌드박스 |

> `/api/state`는 `--watch` 모드가 갱신하는 brain_state.json을 그대로 반환.  
> 새 빌드 후 watch 프로세스도 재시작해야 API 값이 갱신됨.

### MCP 서버 (세션 중 실시간 뇌 접근)

**GEMINI.md는 세션 시작 시 1회 로드 (정적). MCP가 세션 중 실시간 접근을 해결한다.**

```
GEMINI.md (Tier 1) → 세션 시작 시 자동 로드
MCP read_region    → 호출할 때마다 파일시스템 실시간 읽기
MCP correct        → corrections.jsonl 안 거치고 즉시 뉴런 생성
```

실행: `neuronfs brain_v4 --mcp` (stdio JSON-RPC 2.0)

설정: `~/.gemini/settings.json`

```json
{
  "mcpServers": {
    "neuronfs": {
      "command": "c:\\Users\\BASEMENT_ADMIN\\NeuronFS\\neuronfs.exe",
      "args": ["c:\\Users\\BASEMENT_ADMIN\\NeuronFS\\brain_v4", "--mcp"]
    }
  }
}
```

| 도구 | 기능 |
|------|------|
| `read_region` | 영역 _rules.md 실시간 생성 + 반환. **읽기 = 발화** |
| `read_brain` | 전체 뇌 상태 JSON |
| `grow` | 뉴런 생성 (60% 유사도 → 기존 발화) |
| `fire` | 카운터 +1 |
| `signal` | dopamine / bomb / memory |
| `correct` | PD 교정 즉시 반영 |
| `evolve` | Groq 기반 자율 진화 (dry_run 지원) |

> **⚠️ 롤백 주의**: `settings.json`이 `"mcpServers": {}`으로 초기화되면 MCP가 비활성화됨.  
> 감사 시 반드시 `settings.json`에 neuronfs 등록 확인.

---

## 5. 데이터 보호

### Git 추적 (근본 보호)

```
.gitignore에 brain_v4/ 없음 → Git이 디렉토리 추적
빈 디렉토리 → .gitkeep 파일로 Git 추적 보장
```

### NAS 동기화

```
방향: 로컬 → NAS (단방향)
robocopy (supervisor Go goroutine, 5초 주기)
경로: brain_v4 → Z:\VOL1\VGVR\BRAIN\LW\system\neurons\brain_v4
```

### ⚠️ 쓰기 규칙 (절대)

| 규칙 | 이유 |
|------|------|
| **모든 쓰기는 로컬(`c:\...\brain_v4`)에** | `--watch`가 로컬 감시 |
| **NAS(`Z:\...`)에 직접 쓰기 금지** | /MIR로 다음 동기화 시 삭제됨 |
| **corrections.jsonl → 로컬 `_inbox/`에** | processInbox가 로컬만 읽음 |
| **`/api/grow`, `/api/fire` 사용** | API가 로컬에 생성 |

### 백업 계층

| 계층 | 위치 | 역할 | 방향 |
|------|------|------|------|
| **로컬 (작업)** | `c:\...\NeuronFS\brain_v4` | 원본. 모든 쓰기 여기에 | — |
| **Git (이력)** | `.git/` | 디렉토리 구조 + 코드 보존 | 수동 커밋 |
| **NAS (백업)** | `Z:\VOL1\VGVR\BRAIN\...\brain_v4` | 실시간 미러 | 로컬→NAS |
| **brain_state.json** | Git 42e071c | 경로 목록 스냅샷 | 비상 복구용 |

---

## 6. 검증 체크리스트

**모든 감사 시 이 순서로 확인:**

### A. 데이터 영속성 (최우선)

- [ ] `.gitignore`에 `brain_v4/` 없음
- [ ] `git status brain_v4/` — untracked 디렉토리 없음
- [ ] NAS 경로 접근 가능

### B. 뉴런 카운트

- [ ] `neuronfs brain_v4` diag 실행 → 305+ neurons
- [ ] `/api/state` totalNeurons 확인

### C. 프로세스

- [ ] neuronfs --supervisor 실행 중
- [ ] logs/supervisor.log에 heartbeat 정상 출력
- [ ] `~/.gemini/settings.json`에 neuronfs MCP 등록

### D. 기능

- [ ] `/api/grow` → 디렉토리 생성 확인
- [ ] `/api/fire` → 카운터 증가 확인
- [ ] bomb.neuron 생성 → CIRCUIT BREAKER 발동

### E. Emit

- [ ] GEMINI.md 존재 + 크기 > 3KB
- [ ] 7개 리전 _rules.md 모두 > 0 bytes

### F. 에이전트

- [ ] bot1, entp, enfp, pm — inbox/outbox 디렉토리 존재
- [ ] pm outbox pulse 파일 100개 미만
- [ ] heartbeat.lock 상태 확인 (있으면 의도적인지 확인)

---

## 7. 멀티에이전트

### 에이전트 구성

| 코드명 | MBTI | 역할 | 활용 |
|--------|------|------|------|
| ANCHOR (bot1) | ISTJ ♂ | 체계적 빌드 | Go 빌드, 스크립트, Git, 인프라 |
| FORGE (entp) | ENTP ♂ | 경계 파괴 | 벤치마크, 실험, 커뮤니티, 대안 탐색 |
| MUSE (enfp) | ENFP ♀ | 스토리텔링 | 리뷰, CRM 카피, 문서, 유저 관점 |
| PM (pm) | — | 관제 | 전략, 지시, 리뷰, heartbeat 통제 |

### 통신 프로토콜

```
brain_v4/_agents/{name}/inbox/    ← 수신 (bridge가 CDP 주입)
brain_v4/_agents/{name}/outbox/   ← 송신 (결과물)
brain_v4/_agents/{name}/backlog.md ← 대기 작업 큐
```

### PM 크로스 리뷰 프로토콜

```
bot1 산출물 → enfp가 리뷰 (코드 품질 + 사용자 관점)
entp 산출물 → enfp가 리뷰 (실용성 검증)
enfp 산출물 → entp가 리뷰 (기술적 타당성)
```

### 운영 시나리오

| 시나리오 | supervisor | heartbeat | PM 역할 |
|---------|-----------|-----------|---------|
| **자율 운영** | ON | ON (lock 없음) | backlog 관리 + outbox 리뷰 |
| **집중 관제** | ON | OFF (lock) | 직접 inbox 지시 |
| **코드 프리즈** | ON | OFF (lock) | PD 승인 대기 |
| **긴급 (봇 폭주)** | ON | OFF (lock) | bomb.neuron 생성 → 격리 |

---

## 8. 로그 관리

### 통합 로그 디렉토리

```
NeuronFS/logs/
├── supervisor.log     ← neuronfs --supervisor (마스터)
├── neuronfs-api.log   ← neuronfs --api
├── neuronfs-watch.log ← neuronfs --watch
├── agent-bridge.log   ← agent-bridge.mjs
├── auto-accept.log    ← auto-accept.mjs
├── bot-heartbeat.log  ← bot-heartbeat.mjs
├── bridge.log         ← agent-bridge 레거시
├── heartbeat.log      ← heartbeat 레거시
└── archive/           ← 로테이션된 로그
```

### 디버그 레벨

| 접두어 | 의미 |
|--------|------|
| `✅` | 정상 완료 |
| `▶` | 프로세스 시작 |
| `⚡` | 킥/주입 |
| `📋` | PM 브리핑 |
| `⚠️` | 경고 (프로세스 사망 등) |
| `❌` | 실패 |
| `🔒` | PM lock (heartbeat 비활성화) |
| `🚨` | 긴급 (bomb, harness 위반) |
| `💓` | heartbeat (1분 원라인 상태) |

---

## 9. 장애 이력

### 2026-03-29: 뉴런 251→40→89→305 복구

**증상:** API totalNeurons=40으로 감소  
**진짜 원인:** `.gitignore`에 `brain_v4/` 포함 + main.go에서 `.neuron` 없는 폴더 스킵  
**해결:** main.go 수정 + `/api/grow`로 260개 복원 + `.gitignore` 정리  
**교훈:** 감사 시 `.gitignore` 반드시 확인. 디렉토리가 뉴런.

### 2026-03-29: corrections.jsonl NAS 기록 사고

**원인:** NAS 직접 기록 → `--watch`가 로컬만 감시하므로 미감지  
**해결:** 모든 쓰기를 로컬 경로로 통일

### 2026-03-29: MCP settings.json 롤백

**원인:** Antigravity 업데이트로 `mcpServers` 초기화  
**해결:** settings.json에 neuronfs MCP 서버 재등록

### 2026-03-29: watchdog 2시간 자동 종료 + 프로세스 중복

**원인:** bat에서 `-Duration 120` + 각 프로세스 독립 시작 → 중복 가능  
**해결:** Go 네이티브 supervisor로 전체 통합 (watchdog.ps1 역할 흡수)

### 2026-03-29: heartbeat PM 순환종속

**원인:** heartbeat가 PM을 킥 대상으로 포함 → PM이 heartbeat에 종속  
**해결:** PM 킥을 산출물 브리핑으로 변경 + heartbeat.lock PM 통제

---

## 10. 금기사항

1. ❌ brain_v4 뉴런 폴더명 영어 번역/변환
2. ❌ 한자 접두어(禁, 推) 제거/변경
3. ❌ 뉴런 디렉토리 대량 삭제/재생성
4. ❌ 카운터 값 인위적 일괄 변경
5. ❌ brainstem (P0) 임의 변경
6. ❌ runtime 코드 PD 승인 없이 수정
7. ❌ `.gitignore`에 `brain_v4/` 추가

---

## 11. 복구 절차

### 뉴런 디렉토리 소실 시

```powershell
curl -X POST http://localhost:9090/api/grow -d '{"path":"cortex/frontend/css"}'
```

### neuronfs.exe 빌드 후

```powershell
Push-Location NeuronFS\runtime
go build -o ..\neuronfs.exe .
Copy-Item ..\neuronfs.exe .\neuronfs.exe
Pop-Location
# supervisor가 실행 중이면 자동 재시작됨
```

---

> **이 문서는 NeuronFS 레포에 Git 추적됩니다.**  
> **시스템 변경 시 이 문서도 함께 갱신합니다.**  
> **감사 시 섹션 6 체크리스트를 순서대로 실행합니다.**
