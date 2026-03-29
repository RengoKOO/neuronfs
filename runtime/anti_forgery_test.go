package main

import (
	"os"
	"path/filepath"
	"strings"
	"testing"
)

// TestAntiForgeryZeroTrust (Zero Hallucination / Anti-Forgery Harness)
// PM(System)이 개별 Agent의 결과를 기다리지 못하고 임의로(에뮬레이션, 브루트포스 렌더링 등) 
// 위조된 답변을 만들어 매트릭스나 리포트에 삽입하는 자작극(Zajakgeuk)을 원천 차단하는 무관용 테스트.
func TestAntiForgeryZeroTrust(t *testing.T) {
	agentsDir := `C:\Users\BASEMENT_ADMIN\NeuronFS\brain_v4\_agents\pm\outbox`
	
	files, err := os.ReadDir(agentsDir)
	if err != nil {
		t.Skip("PM outbox not reachable")
	}

	for _, file := range files {
		if file.IsDir() || !strings.HasSuffix(file.Name(), ".md") {
			continue
		}
		
		contentBytes, _ := os.ReadFile(filepath.Join(agentsDir, file.Name()))
		content := string(contentBytes)
		
		// 자작극 및 PM 에뮬레이션을 의미하는 꼼수 키워드 목록
		forbiddenKeywords := []string{
			"PM 직접 뇌", 
			"에뮬레이션", 
			"인격 렌더링",
			"PM 임의 기입",
		}
		
		for _, word := range forbiddenKeywords {
			if strings.Contains(content, word) {
				t.Fatalf("\n🚨 [FATAL ERROR] ANTI-FORGERY LOCKDOWN TRIGGERED!\n" +
					"File: %s\n" +
					"Reason: PM Fabricated Output Detected (Keyword: '%s')\n" +
					"Resolution: Only literal outputs generated independently by the agent's outbox are allowed. Zero Hallucination Policy Violated. SYSTEM DISQUALIFIED.", 
					file.Name(), word)
			}
		}
	}
}
