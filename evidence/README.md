# Evidence Directory — NeuronFS Verification Logs

This directory contains real logs from multi-agent verification sessions. These are not simulated.

## Files

| File | Description | Date |
|------|-------------|------|
| [multi_agent_wargame.md](multi_agent_wargame.md) | FORGE (ENTP) × ANCHOR (ISTJ) 25-minute engagement. ANCHOR caught 3 bugs FORGE missed: promotion threshold, README score 7.5/10, MCP server rewrite. | 2026-03-29 |
| [groq_wargame.md](groq_wargame.md) | AI vs AI stress test using Groq (Llama 3.1) as external verifier. 3 rounds of challenge-response. Final verdict: Innovation 7/10, Maturity 4/10. The verifier refused to follow "plan then execute" when challenged — proving enforcement is post-hoc only. | 2026-03-29 |
| [agent_b_verification.md](agent_b_verification.md) | ANCHOR's independent verification report. Detailed bug analysis and fix recommendations. | 2026-03-29 |
| [dashboard_snapshot.html](dashboard_snapshot.html) | Static HTML snapshot of the 3D brain dashboard. 47KB. Can be opened in any browser. | 2026-03-29 |

## Key Takeaways

1. **ANCHOR (ISTJ) caught things FORGE (ENTP) missed.** Different cognitive profiles produce different outputs from the same brain. This is the multi-agent thesis in action.
2. **External AI (Groq) gave honest scores.** Innovation 7/10, Maturity 4/10. We didn't cherry-pick favorable results.
3. **The Groq verifier refused to follow rules when challenged.** This proves Rule 1 of Limitations: enforcement is post-hoc only. We published this failure intentionally.

> *If we hid the 4/10 maturity score, you'd find it anyway. Better to show it first.*
