# 🧠 NeuronFS 3.0 : Multi-Layer Cognitive Architecture

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
brain/
├── P0_brainstem/          ← 헌법 (절대 원칙)
│   ├── canon/             ← 경전 (삭제/수정 불가)
│   ├── reflexes/          ← 무조건 반사
│   └── _PRIORITY.md
│
├── P1_limbic/             ← 반사 신경 (감정 필터)
│   ├── emotion_parser/    ← 감정 분리기
│   ├── command_extractor/ ← 명령 추출기
│   ├── neurotransmitters/ ← 신경전달물질 엔진
│   └── _PRIORITY.md
│
├── P2_hippocampus/        ← 일기장 (경험 기록)
│   ├── rewards/           ← dopamine 이력
│   ├── failures/          ← bomb 이력
│   ├── episodes/          ← 세션 로그
│   └── _PRIORITY.md
│
├── P3_sensors/            ← 눈과 귀 (환경 입력)
│   ├── workspace/         ← 워크스페이스 제약
│   ├── design/            ← 디자인 시스템 상수
│   └── _PRIORITY.md
│
├── P4_cortex/             ← 교과서 (지식)
│   ├── left/              ← 좌뇌: 지침/규칙 (.neuron)
│   ├── right/             ← 우뇌: 실행 코드 (.tsx/.css)
│   └── _PRIORITY.md
│
├── P5_ego/                ← 말투와 스타일 (성향)
│   ├── tone/              ← 톤 앤 매너
│   ├── refactoring/       ← 리팩토링 강도
│   ├── philosophy/        ← 철학적 성향
│   └── _PRIORITY.md
│
└── P6_prefrontal/         ← 작전 보드 (목표)
    ├── active/            ← 현재 스프린트 (.goal)
    ├── backlog/           ← 대기 과제 (.goal)
    ├── vision/            ← 장기 방향 (.goal)
    └── _PRIORITY.md
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
# 정상 상태 — 모든 영역 활성
./neuronfs.exe ../brain
# → STATUS: 🟢 ALL SYSTEMS NOMINAL
# → Fired: 51/51 neurons

# bomb 발생 시 — 전체 차단
echo "CRITICAL FAILURE" > ../brain/P0_brainstem/bomb.neuron
./neuronfs.exe ../brain
# → STATUS: 🔴 CIRCUIT BREAKER ACTIVE — REPAIR REQUIRED
# → Fired: 0/52 neurons
```

## 왜 7개 영역인가? (분리의 3대 이유)

### 1. 시간 스케일이 다르다
brainstem(불변) ≠ limbic(초) ≠ cortex(일) ≠ prefrontal(월)

### 2. 권한이 다르다
brainstem(인간만) ≠ limbic(자동) ≠ cortex(학습) ≠ ego(사용자)

### 3. Subsumption — 하위가 상위를 삼킨다
bomb(P0) → 지식(P4) 무시. 감정(P1) → 목표(P6) 편향.
