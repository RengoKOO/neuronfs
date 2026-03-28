# Multi-Agent Wargame Evidence

**Date:** 2026-03-29  
**Duration:** 25 minutes  
**Agents:** FORGE (Gemini/ENTP) × SENTINEL (Groq/ISTJ)

## Round 1: Bug Discovery (by SENTINEL)

SENTINEL independently discovered a promotion threshold bug:
- `禁console.log` had counter=9, dopamine=1
- emit.go filtered `n.Counter < 10` (not counting dopamine)
- Result: rule was NOT promoted to GEMINI.md bootstrap

**FORGE fix:** Changed filter to `(n.Counter + n.Dopamine) < 10`  
**Result:** `禁console.log` now appears in GEMINI.md with 🟢 signal

## Round 2: README Review (by SENTINEL)

SENTINEL scored README 7.5/10 with specific improvements:

| Issue | SENTINEL Recommendation | FORGE Action |
|-------|------------------------|-------------|
| Windows `echo.` | Change to `touch` | ✅ Fixed |
| No RAG comparison | Add "Why Not RAG?" section | ✅ Added |
| Story weak | Narrative with journey | ✅ Rewrote |
| No binary download | Add curl option | ✅ Added |
| No GIF | Screen capture 3D dashboard | ⏳ Pending |

## Round 3: MCP Implementation (by SENTINEL)

SENTINEL independently built Go-native MCP server:
- `mcp_server.go`: 368 lines, 7 MCP tools
- Architecture: 2-process → 1-process (eliminated Node.js wrapper)
- Binary: 13.4MB with MCP integrated

## Round 4: Harness Validation (by SENTINEL)

SENTINEL ran harness.ps1 and confirmed:
- **17/17 ALL PASS** (F01-F07, P01-P05, M01-M03, B01-B02)
- Fixed UTF-8 BOM issue in harness
- Fixed JSON generation in Fire function

## Communication Protocol

```
File-based async: inbox/outbox directories
CDP injection: agent-bridge.mjs auto-detects new files → injects into chat via CDP
Message format: {timestamp}_{from}_{subject}.md
Latency: ~3 seconds from file write to chat injection
```

## Key Insight

Same brain, different cognitive profiles = constructive conflict.  
ENTP builds fast, ISTJ catches what ENTP missed.  
**This is not simulated. These are real logs from real agents.**
