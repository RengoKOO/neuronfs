/**
 * NeuronFS MCP Server
 * 
 * AI가 실시간으로 뇌 상태를 조회/조작할 수 있는 MCP 도구 서버.
 * NeuronFS REST API (localhost:9090) 위에 얇은 래퍼.
 * 
 * 도구:
 *   read_region  — 영역의 최신 _rules.md 반환 (라우터 대체)
 *   read_brain   — 전체 뇌 상태 요약
 *   grow         — 뉴런 생성
 *   fire         — 뉴런 발화 (카운터 증가)
 *   signal       — 도파민/bomb/memory 신호
 *   correct      — 교정 기록 (corrections.jsonl 대체)
 */

import { McpServer } from "@modelcontextprotocol/sdk/server/mcp.js";
import { StdioServerTransport } from "@modelcontextprotocol/sdk/server/stdio.js";
import { z } from "zod";

const API_BASE = "http://localhost:9090";

/* ── REST 헬퍼 ── */
async function apiGet(path) {
  const res = await fetch(`${API_BASE}${path}`);
  if (!res.ok) throw new Error(`API ${res.status}: ${await res.text()}`);
  const ct = res.headers.get("content-type") || "";
  return ct.includes("json") ? res.json() : res.text();
}

async function apiPost(path, body) {
  const res = await fetch(`${API_BASE}${path}`, {
    method: "POST",
    headers: { "Content-Type": "application/json" },
    body: JSON.stringify(body),
  });
  if (!res.ok) throw new Error(`API ${res.status}: ${await res.text()}`);
  return res.json();
}

/* ── MCP 서버 ── */
const server = new McpServer({
  name: "neuronfs",
  version: "1.0.0",
});

/* ─── 도구 1: read_region ─── */
server.tool(
  "read_region",
  "영역의 최신 _rules.md를 실시간 생성하여 반환. 작업 전환 시 해당 영역을 읽으면 최신 뉴런 상태를 얻는다. 읽기 = 발화: 상위 3개 뉴런이 자동으로 활성화된다.",
  {
    region: z.enum([
      "brainstem", "limbic", "hippocampus", "sensors", "cortex", "ego", "prefrontal"
    ]).describe("읽을 영역. CSS/디자인→cortex, NAS→sensors, 브랜드→sensors, 프로젝트→prefrontal"),
  },
  async ({ region }) => {
    try {
      const content = await apiGet(`/api/read?region=${region}`);
      return { content: [{ type: "text", text: typeof content === "string" ? content : JSON.stringify(content, null, 2) }] };
    } catch (e) {
      return { content: [{ type: "text", text: `❌ ${e.message}` }], isError: true };
    }
  }
);

/* ─── 도구 2: read_brain ─── */
server.tool(
  "read_brain",
  "전체 뇌 상태를 JSON으로 반환. 영역별 뉴런 수, 활성도, axon 연결, bomb 상태 등을 포함한다.",
  {},
  async () => {
    try {
      const state = await apiGet("/api/brain");
      return { content: [{ type: "text", text: JSON.stringify(state, null, 2) }] };
    } catch (e) {
      return { content: [{ type: "text", text: `❌ ${e.message}` }], isError: true };
    }
  }
);

/* ─── 도구 3: grow ─── */
server.tool(
  "grow",
  "새 뉴런을 생성한다. 경로는 region/카테고리/이름 형식. 이미 존재하면 스킵, 60% 이상 유사한 뉴런이 있으면 기존 뉴런을 발화한다.",
  {
    path: z.string().describe("뉴런 경로. 예: cortex/frontend/css/새_규칙, brainstem/禁새_금지사항"),
  },
  async ({ path }) => {
    try {
      const result = await apiPost("/api/grow", { path });
      return { content: [{ type: "text", text: `🌱 ${result.status}: ${result.path}` }] };
    } catch (e) {
      return { content: [{ type: "text", text: `❌ ${e.message}` }], isError: true };
    }
  }
);

/* ─── 도구 4: fire ─── */
server.tool(
  "fire",
  "기존 뉴런의 카운터를 1 증가시킨다. 뉴런이 없으면 자동으로 생성 후 발화한다.",
  {
    path: z.string().describe("뉴런 경로. 예: cortex/testing/검증_E2E"),
  },
  async ({ path }) => {
    try {
      const result = await apiPost("/api/fire", { path });
      return { content: [{ type: "text", text: `🔥 ${result.status}: ${result.path}` }] };
    } catch (e) {
      return { content: [{ type: "text", text: `❌ ${e.message}` }], isError: true };
    }
  }
);

/* ─── 도구 5: signal ─── */
server.tool(
  "signal",
  "뉴런에 신호를 보낸다. dopamine=PD 칭찬/강화, bomb=3회 반복실수 차단, memory=기억 기록.",
  {
    path: z.string().describe("뉴런 경로"),
    type: z.enum(["dopamine", "bomb", "memory"]).describe("신호 유형"),
  },
  async ({ path, type }) => {
    try {
      const result = await apiPost("/api/signal", { path, type });
      const icon = type === "dopamine" ? "🟢" : type === "bomb" ? "💣" : "📝";
      return { content: [{ type: "text", text: `${icon} ${result.status}: ${type} → ${result.path}` }] };
    } catch (e) {
      return { content: [{ type: "text", text: `❌ ${e.message}` }], isError: true };
    }
  }
);

/* ─── 도구 6: correct ─── */
server.tool(
  "correct",
  "PD 교정을 기록한다. corrections.jsonl에 쓰는 대신 직접 뉴런을 생성/발화한다. 교정은 즉시 뉴런으로 변환된다.",
  {
    path: z.string().describe("뉴런 경로. 예: cortex/methodology/새_방법론"),
    text: z.string().describe("교정 사유"),
  },
  async ({ path, text }) => {
    try {
      // 1. fire 시도 (기존 뉴런이면 카운터 +1)
      const fireResult = await apiPost("/api/fire", { path });
      return { content: [{ type: "text", text: `📝 교정 반영: ${path}\n사유: ${text}\n결과: ${fireResult.status} (카운터 +1)` }] };
    } catch (e) {
      try {
        // 2. fire 실패 → grow 후 자동 fire
        const growResult = await apiPost("/api/grow", { path });
        return { content: [{ type: "text", text: `📝 교정 반영 (신규): ${path}\n사유: ${text}\n결과: ${growResult.status}` }] };
      } catch (e2) {
        return { content: [{ type: "text", text: `❌ ${e2.message}` }], isError: true };
      }
    }
  }
);

/* ─── 도구 7: evolve ─── */
server.tool(
  "evolve",
  "Groq 기반 자율 뇌 진화를 실행한다. dry_run=true면 제안만, false면 실행.",
  {
    dry_run: z.boolean().default(true).describe("true=제안만, false=실제 실행"),
  },
  async ({ dry_run }) => {
    try {
      const result = await apiPost("/api/evolve", { dry_run });
      let text = `🧬 Evolve ${dry_run ? "(DRY RUN)" : "(EXECUTED)"}\n`;
      text += `Summary: ${result.summary}\n`;
      if (result.insights) {
        text += `\nInsights:\n${result.insights.map(i => `  • ${i}`).join("\n")}\n`;
      }
      if (result.actions) {
        text += `\nActions (${result.executed || 0} executed, ${result.skipped || 0} skipped):\n`;
        result.actions.forEach((a, i) => {
          text += `  ${i + 1}. [${a.type}] ${a.path} — ${a.reason}\n`;
        });
      }
      return { content: [{ type: "text", text }] };
    } catch (e) {
      return { content: [{ type: "text", text: `❌ ${e.message}` }], isError: true };
    }
  }
);

/* ─── 시작 ─── */
const transport = new StdioServerTransport();
await server.connect(transport);
