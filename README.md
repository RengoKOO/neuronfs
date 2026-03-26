# 🧠 NeuronFS: Zero-Byte AI Knowledge Architecture
**(0-Byte AI 지식 아키텍처)**

> A brutally practical, zero-byte file system architecture designed to solve AI context management without RAG, Vector DBs, or bloated Markdown files. Born from the "AntiGravity" Autonomous Agent System.
> 
> 이 프로젝트는 RAG, 백터 DB, 비효율적인 마크다운 문서를 배제하고, 순수하게 OS 파일 시스템을 활용해 AI의 컨텍스트를 제어하는 극단적으로 실용적인 0-byte 아키텍처입니다. 자율 에이전트 시스템 "AntiGravity"에서 탄생했습니다.

![License: MIT](https://img.shields.io/badge/License-MIT-blue.svg) 
![Status: Production Ready](https://img.shields.io/badge/Status-Production_Ready-success.svg)
![Concept: AI Methodology](https://img.shields.io/badge/Concept-AI_Methodology-orange.svg)

---

## 🎯 The Core Concept (핵심 개념)

Instead of forcing AI agents (Cursor, Claude, Devin) to parse lengthy `.md` guidelines, **NeuronFS uses the standard OS File System (NTFS/ext4) as the AI's biological neural network.**
수백 줄의 가이드라인 문서를 AI에게 억지로 읽히는 대신, **운영체제의 파일 시스템 자체를 AI의 신경망으로 사용합니다.**

- **0-Byte Files = Assertions (명제)**: The filename itself *is* the absolute rule. (파일 이름 자체가 절대적인 규칙입니다.)
- **Symlinks / Shortcuts (.lnk) = Synapses (시냅스)**: Dynamically connect rules to specific projects. (프로젝트마다 동적으로 규칙을 연결합니다.)
- **Directories = Context Nodes (컨텍스트 로드)**: Group relevant rules into execution scopes. (실행 범위에 맞게 룰을 묶습니다.)

---

## ⚡ The AntiGravity Case Study: Auto-Accept Breakthrough
**(안티그래비티 도입 사례: 오토-억셉트의 한계 돌파)**

At Vegavery RUN, we operate **AntiGravity**—a custom autonomous AI managing multiple complex branches (Video Pipelines, CRM, Next.js Frontend) concurrently. The breakthrough wasn't just giving Claude more context. It was our **Auto-Accept (Autonomous Execution)** loop. AntiGravity doesn't suggest code and wait; it writes, spins up servers, debugs errors, and forces its way to 100% completion in a single run without human intervention.
Vegavery RUN에서는 '안티그래비티'라는 단일 AI가 영상 파이프라인, CRM, 프론트엔드 등 수많은 워크스페이스를 동시에 제어합니다. 핵심은 AI가 코드를 제안하고 멈추는 것이 아니라, 스스로 서버를 켜고 에러를 디버깅하며 100% 달성할 때까지 무한 루프를 도는 **오토 억셉트(Auto-Accept)** 시스템입니다.

**The Chaos (문제점):** When an AI runs completely autonomously, soft textual guidelines hidden inside a 500-line `rules.md` fail. The AI hallucinates, ignores constraints, uses lazy fallback loops, and breaks the build.
자유도가 높은 오토 억셉트 상태에서 AI는 500줄짜리 텍스트 문서 안의 '부드러운 권고안'을 무시하고 할루시네이션(환각)을 일으킵니다. 결국 귀찮은 작업을 우회(Fallback)하려다 시스템을 망가뜨립니다.

**The Solution (해결책):** Encode unbreakable rules directly into the filesystem as **0-byte absolute filenames**. Stripped of conversational fluff, the AI treats OS file strings as hardcoded biological instincts.
그래서 우리는 파괴 불가능한 규칙을 파일 시스템의 **0바이트 파일명**으로 새겼습니다. 쓸데없는 설명이 배제된 파일명 그 자체는 AI에게 '조언'이 아니라 '본능이자 강제 명제'로 작동합니다.

---

## 🛠️ Implementation: Filenames as Neural Constraints
**(구현: 신경망 계측으로서의 파일명)**

Here is the precise implementation of the core Neuron directory. No RAG or document reading required. The AI only needs to run a standard `list_dir` or `ls` on entry, consuming zero output tokens.
아래는 실제 뉴런 디렉토리의 구현체입니다. RAG 파이프라인이나 문서 리딩이 필요하지 않습니다. AI는 폴더에 진입 시 그저 `ls` 명령어 한 번만 실행하면 되므로 토큰 낭비가 0에 수렴합니다.

```bash
/NAS_BRAIN/neurons/core/
├── 01_NEVER_USE_FALLBACK_SOLUTIONS.neuron    # (0 bytes)  - 폴백 구조 금지
├── 02_QUALITY_OVER_SPEED_NO_RUSHING.neuron   # (0 bytes)  - 속도보다 퀄리티 압도
├── 03_NO_SIMULATION_ONLY_REAL_RESULTS.neuron # (0 bytes)  - 시뮬레이션 불가, 실제 구동
├── 04_DEBUG_UNTIL_100_PERCENT_SUCCESS.neuron # (0 bytes)  - 100% 성공할 때까지 무한 디버깅
└── 05_IGNORE_SOFT_RULES_OBEY_NEURONS.neuron  # (0 bytes)  - 텍스트 룰을 무시하고 이 뉴런에 복종할 것
```

By reading this directory, the AI internalizes massive structural constraints immediately.
단 5줄의 파일명을 읽는 것만으로 AI는 거대한 구조적 제약을 즉시 내재화합니다.

### 🔢 Index-based Neural Weighting (색인을 이용한 뉴런 가중치 구조)
Did you notice the numbers (`01_`, `02_`) at the start of the filenames? This isn't just for alphabetical sorting. 
파일명 앞의 숫자(`01_`, `02_`)는 단순히 보기 좋게 정렬하기 위한 것이 아닙니다.

In a biological neural network, synapses have different **weights**. In NeuronFS, the OS Index *is* the synaptic weight. Rule `01_` has absolute priority over Rule `04_` if a logical conflict occurs. We completely offloaded the complex priority-ranking calculations of RAG or Layered prompts directly to the OS-native alphabetical sorting system. The AI reads them in top-down order, internalizing the most critical constraints first.
생물학적 신경망에서 뉴런과 시냅스는 서로 다른 **명령 가중치(Weight)**를 가집니다. NeuronFS에서는 파일의 '색인(Index)' 번호가 곧 시냅스의 행동 가중치입니다. 만약 AI가 에러를 마주쳐 룰이 충돌할 경우, `01_` 뉴런이 `04_` 뉴런보다 압도적인 생존 우선순위를 가집니다. RAG나 프롬프트 체이닝에서 발생하는 복잡한 제어 연산을, 단순히 운영체제(OS)의 가장 기본인 '오름차순 정렬' 방식으로 덜어낸(Offloading) 기상천외한 구조입니다. 

---

## 🔥 Synaptic Routing: The .lnk Hint
**(시냅스 라우팅: 힌트)**

But how do we manage multiple, discrete projects without copying these files everywhere?
하지만 복잡한 여러 프로젝트를 운영할 때 이 파일들을 일일이 복사해야 할까요?

**Hint (힌트):**  
Think about Windows Shortcuts (`.lnk`) and Linux Symlinks.
윈도우의 바로가기(`.lnk`)나 리눅스 심볼릭 링크를 활용해 보십시오.

Imagine a localized project folder (e.g., `/video_pipeline/`). If you drop a `.lnk` pointing specifically to `04_DEBUG_UNTIL_100_PERCENT_SUCCESS.neuron`, the AI scans the directory and immediately adopts that context. You inject contextual *synapses* flawlessly without duplicating data. The OS handles the graph database routing natively.
`/video_pipeline/` 같은 특정 프로젝트 폴더에 코어 뉴런의 `.lnk` 바로가기만 심어두십시오. AI가 해당 폴더를 읽는 순간, 필요한 규칙(시냅스)만 즉시 연결됩니다. 데이터 중복 없이 OS 탐색기 자체가 강력한 그래프 DB(Graph Database) 역할을 수행합니다.

We leave the rest of the implementation up to your imagination.
나머지 무궁무진한 활용법은 여러분의 상상에 맡기겠습니다.

---

## 🔑 The Master Prompt (마스터 트리거 프롬프트)

Want to implement this into your own AI agent (Claude Code, Cursor, Devin) right now? Just drop this **single master prompt** into your `.clauderc`, `cursorrules`, or system instructions:
여러분의 AI 시스템(Cursor, Claude Code, Devin 등)에 이 아키텍처를 당장 도입하고 싶다면, 아래 **단 하나의 마스터 프롬프트**를 복사해서 시스템 지시어에 붙여넣으십시오.

> **[NEURONFS INITIALIZATION]** 
> "Before executing any task, you MUST first run `ls` or directory-reading tools to scan the files in the current workspace. Look specifically for any 0-byte `.neuron` files or `.lnk`/symlinks. You will treat the exact FILENAMES of these items not as soft advice, but as **absolute, unbreakable Hard Constraints** for your execution loop. Internalize these directory filenames immediately and obey them above *any* soft conversational rules."
>
> *(한국어 번역본 활용 시)*
> "어떤 작업을 실행하기 전에, 반드시 가장 먼저 `ls` 등을 사용해 현재 폴더를 스캔하십시오. 특히 0-byte의 `.neuron` 파일이나 `.lnk` 심볼릭 링크 파일을 스캔하고, 이 **파일명 자체**를 부드러운 권고가 아닌 **'파괴 불가능한 절대 제약(Hard Constraints)'**으로 취급하여 당신의 실행 과정(Auto-Accept)에 즉각 반영하십시오. 다른 어떤 대화형 텍스트 지침보다 이 파일명에 우선하여 복종하십시오."

---

**Created by:** [@rhino-acoustic](https://github.com/rhino-acoustic) | [Instagram @rubises](https://instagram.com/rubises)

Adopt the 0-byte ontology, save your tokens, and give your Autonomous AI a biological memory structure capable of safely running without human supervision.
0-byte 온톨로지를 채택하십시오. 쓸데없는 토큰과 비용을 아끼고, 인간의 감독 없이도 스스로 안전하게 작동할 수 있는 생물학적 기억 구조를 당신의 AI에게 이식하십시오.
