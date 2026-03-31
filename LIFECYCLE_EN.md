# 🧬 NeuronFS Neuron Lifecycle

> **Neurons are born, reinforced, audited, put to sleep, and killed.**

---

## Overview

Every neuron follows a defined lifecycle from Birth to Apoptosis.
This cycle is driven by user corrections and system observation.

```
Birth → Reinforcement → Maturation → Dormancy/Bomb → (Apoptosis or Revival)
```

---

## 1. Birth

| Trigger | Result |
|---------|--------|
| User corrects AI mistake | `corrections.jsonl` → `mkdir` (auto neuron creation) |
| Memory Observer detects pattern | Auto-neuronize when 3KB chunk watermark exceeded |
| Manual creation | `mkdir brain/cortex/.../new_rule` + `touch 1.neuron` |

**Rules:**
- Minimum 2-level hierarchy required (`region/category/neuron_name`)
- Korean + Hanja micro-opcodes (`禁`, `必`, `推`)
- No spaces, underscore-separated

---

## 2. Reinforcement

| Signal | File | Effect |
|--------|------|--------|
| Repeated correction | `N.neuron` counter increment | Placed higher in system prompt |
| Praise | `dopamineN.neuron` created | Positive weight increase |
| Disagreement | `N.contra` created | Polarity decrease |

**Frequency tiers:**

| Counter | Tier | Behavior |
|---------|------|----------|
| 1–4 | Normal | Recorded in `_rules.md` only |
| 5–9 | Repeated | Strong marker |
| 10+ | **Confirmed** | Found in bootstrap. Injected every session |
| 30+ | **Law** | brainstem promotion candidate |

---

## 3. Hygiene Audit

> **Neurons that only accumulate become contaminated. Periodic audits are mandatory.**

### Automated Audits (Runtime — Implemented)

| Item | Frequency | Status | Code |
|------|-----------|--------|------|
| Duplicate detection (Jaccard) | On idle / API manual | ✅ Implemented | `deduplicateNeurons()`, `/api/dedup` |
| Dormant marking | `--decay` or on idle | ✅ Implemented | `runDecay()`, 30-day default |
| Bomb detection + physical alarm | Every scan | ✅ Implemented | `triggerPhysicalHook()` |

### Automated Audits (Planned)

| Item | Frequency | Status |
|------|-----------|--------|
| EN/KR duplicate auto-merge | Weekly | 🔧 Planned |
| PII path scan | Per commit | 🔧 Planned (git hook) |
| Empty folder quarantine | Daily | 🔧 Planned (move to `_quarantine/`, not delete) |

### Manual Audit (Quarterly recommended)

| Item | Check |
|------|-------|
| **Region integrity** | Are runtime bugfixes sitting in brainstem? |
| **Ambiguous names** | Would an outsider understand the meaning? |
| **Counter truthfulness** | Any artificially inflated counters? |
| **Hierarchy depth** | Are flat neurons floating without categories? |
| **Duplicates/merges** | Same meaning under different names? |

---

## 4. Maturation

| Condition | Result |
|-----------|--------|
| Counter 10+ & dopamine 3+ | **Core neuron** promotion. Included in Tier 1 |
| No counter change for 30 days | **Stable neuron**. No further correction needed |
| brainstem candidate | Counter 30+, polarity +0.8+ → P0 promotion review |

---

## 5. Dormancy

| Trigger | Result |
|---------|--------|
| 30 days untouched | `*.dormant` marking |
| `--decay` command | Batch dormancy sweep |

**Dormancy is NOT deletion.** Excluded from compilation but folder is preserved. If corrected again, revives immediately.

---

## 6. Circuit Breaker (Bomb)

| Trigger | Result |
|---------|--------|
| Same mistake repeated 3x | `bomb.neuron` created |
| Physical alarm triggered | USB siren + fullscreen red flash |
| Entire region output halted | cortex bomb → coding disabled |
| Release | `rm bomb.neuron` — delete one file |

---

## 7. Apoptosis

| Condition | Result |
|-----------|--------|
| dormant 90+ days + counter 1 | Added to deletion candidate list |
| Manual `prune` command | Deleted after user approval |

**Apoptosis always requires user approval.** No automatic deletion.

---

## Lifecycle Diagram

```
  User correction
      │
      ▼
  ┌─ Birth ─┐
  │ mkdir   │
  │ 1.neuron│
  └────┬────┘
       │
       ▼
  ┌─ Reinforcement ─────────────┐
  │ counter++  dopamine++       │
  │ contra → polarity shift     │
  └────┬────────────────────────┘
       │
       ├── counter 10+ → Tier 1 promotion
       │
       ├── 30 days untouched → Dormancy
       │                         │
       │                         ├── Re-correction → Revival
       │                         └── 90 days → Apoptosis candidate
       │
       └── 3x repeated mistake → Bomb (circuit breaker)
                                    │
                                    └── rm bomb → Normal operation
```

---

## Heartbeat Autonomous Loop

> **When the heart stops, the brain dies.** Heartbeat auto-evolves the brain when AI is idle.

### Polling Cycle

```
[10-second polling]
    │
    ├── Check _transcripts/ latest file mtime
    │     └── No update for 60s → AI idle detected
    │
    ├── On idle detection:
    │     ├── Extract next task from prefrontal/todo
    │     ├── CDP injection → force-feed task to AI
    │     └── 3-minute cooldown before recheck
    │
    └── AI active: pass
```

### Heartbeat Agenda (Idle Engine)

Sequential execution when AI is judged idle:

| Order | Task | Code | Status |
|-------|------|------|--------|
| 1 | **Auto-evolve** (correction→neuron) | `processInbox()` → `corrections.jsonl` → `mkdir` | ✅ |
| 2 | **Auto-decay** (30-day dormancy) | `runDecay(brainRoot, 30)` | ✅ |
| 3 | **Dedup** (Jaccard duplicate merge) | `deduplicateNeurons(brainRoot)` | ✅ |
| 4 | **Git snapshot** | `git add -A; git commit` | ✅ |
| 5 | **NAS sync** | `robocopy /MIR` (excludes dormant) | ✅ |
| 6 | **Transcript chunk neuronize** | Auto-classify when 3KB watermark exceeded | 🔧 Planned |

### Transcript Chunking → Neuronize

> **When conversations get long, they must become neurons.**

```
_transcripts/session_2026-03-31.jsonl
    │
    ├── 3KB chunk watermark exceeded
    │
    ├── Groq/local LLM extracts correction patterns
    │     └── "3 repeated corrections found in this session"
    │
    ├── Auto neuron creation
    │     └── mkdir brain/cortex/.../extracted_pattern
    │
    └── Write to corrections.jsonl → reflected in next evolve
```

| Item | Status | Note |
|------|--------|------|
| Transcript log collection (`_transcripts/`) | ✅ Implemented | auto-accept transcript logs |
| Idle detection (mtime-based) | ✅ Implemented | 60-second threshold |
| CDP forced task injection | ✅ Implemented | `insertText` pattern |
| Chunk splitting (3KB watermark) | 🔧 Planned | Groq batch analysis |
| Auto neuron classification | 🔧 Planned | 7-region auto-placement |

### Heartbeat API

```bash
GET  /api/heartbeat                          # Status query
POST /api/heartbeat {"enabled":true}         # ON/OFF toggle
POST /api/heartbeat {"interval":10}          # Polling interval (seconds)
POST /api/heartbeat {"cooldown":3}           # Post-injection cooldown (minutes)
```

---

## Migration History

| Date | Action | Result |
|------|--------|--------|
| 2026-03-31 | v1 Full Audit | 307→293 neurons. 2 test deleted, 12 duplicates merged, 9 PD renamed, 5 relocated, 4 renamed |
