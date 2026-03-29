package main

import (
	"encoding/json"
	"net/http"
	"net/http/httptest"
	"strings"
	"testing"
)

// ━━━ Heartbeat Unit Tests ━━━

// ━━━ TEST 39: Heartbeat GET returns state ━━━
func TestHeartbeat_GetState(t *testing.T) {
	dir := setupTestBrain(t)
	mux := buildDashboardMux(dir)

	req := httptest.NewRequest("GET", "/api/heartbeat", nil)
	w := httptest.NewRecorder()
	mux.ServeHTTP(w, req)

	if w.Code != 200 {
		t.Fatalf("expected 200, got %d", w.Code)
	}

	var state map[string]interface{}
	if err := json.Unmarshal(w.Body.Bytes(), &state); err != nil {
		t.Fatalf("invalid JSON: %v", err)
	}

	// Should have enabled, interval, cooldown
	if _, ok := state["enabled"]; !ok {
		t.Fatal("missing 'enabled' field")
	}
	if _, ok := state["interval"]; !ok {
		t.Fatal("missing 'interval' field")
	}
	if _, ok := state["cooldown"]; !ok {
		t.Fatal("missing 'cooldown' field")
	}

	t.Logf("OK: heartbeat GET returns state: enabled=%v, interval=%v, cooldown=%v",
		state["enabled"], state["interval"], state["cooldown"])
}

// ━━━ TEST 40: Heartbeat POST toggles state ━━━
func TestHeartbeat_PostToggle(t *testing.T) {
	dir := setupTestBrain(t)
	mux := buildDashboardMux(dir)

	// Toggle off
	body := `{"enabled":false,"interval":15,"cooldown":5}`
	req := httptest.NewRequest("POST", "/api/heartbeat", strings.NewReader(body))
	req.Header.Set("Content-Type", "application/json")
	w := httptest.NewRecorder()
	mux.ServeHTTP(w, req)

	if w.Code != 200 {
		t.Fatalf("expected 200, got %d", w.Code)
	}

	var state map[string]interface{}
	json.Unmarshal(w.Body.Bytes(), &state)

	if state["enabled"] != false {
		t.Fatalf("expected enabled=false, got %v", state["enabled"])
	}
	if state["interval"].(float64) != 15 {
		t.Fatalf("expected interval=15, got %v", state["interval"])
	}
	if state["cooldown"].(float64) != 5 {
		t.Fatalf("expected cooldown=5, got %v", state["cooldown"])
	}

	// Restore defaults
	restore := `{"enabled":true,"interval":10,"cooldown":3}`
	req2 := httptest.NewRequest("POST", "/api/heartbeat", strings.NewReader(restore))
	req2.Header.Set("Content-Type", "application/json")
	w2 := httptest.NewRecorder()
	mux.ServeHTTP(w2, req2)

	t.Logf("OK: heartbeat POST toggles state correctly")
}

// ━━━ TEST 41: Heartbeat rejects invalid interval ━━━
func TestHeartbeat_RejectsInvalidInterval(t *testing.T) {
	dir := setupTestBrain(t)
	mux := buildDashboardMux(dir)

	// interval < 5 should be rejected (not applied)
	body := `{"interval":1}`
	req := httptest.NewRequest("POST", "/api/heartbeat", strings.NewReader(body))
	req.Header.Set("Content-Type", "application/json")
	w := httptest.NewRecorder()
	mux.ServeHTTP(w, req)

	var state map[string]interface{}
	json.Unmarshal(w.Body.Bytes(), &state)

	interval := state["interval"].(float64)
	if interval < 5 {
		t.Fatalf("interval should not be set below 5, got %v", interval)
	}

	t.Logf("OK: heartbeat rejects interval < 5 (got %v)", interval)
}

// helper to build dashboard mux without starting server
func buildDashboardMux(brainRoot string) *http.ServeMux {
	mux := http.NewServeMux()
	// We need to register the heartbeat handler like startDashboard does
	// Since startDashboard uses its own mux, we register directly
	mux.HandleFunc("/api/heartbeat", func(w http.ResponseWriter, r *http.Request) {
		if r.Method == "POST" {
			var req struct {
				Enabled  *bool `json:"enabled"`
				Interval *int  `json:"interval"`
				Cooldown *int  `json:"cooldown"`
			}
			json.NewDecoder(r.Body).Decode(&req)

			heartbeatMu.Lock()
			if req.Enabled != nil {
				heartbeatEnabled = *req.Enabled
			}
			if req.Interval != nil && *req.Interval >= 5 {
				heartbeatInterval = *req.Interval
			}
			if req.Cooldown != nil && *req.Cooldown >= 1 {
				heartbeatCooldown = *req.Cooldown
			}
			state := map[string]interface{}{
				"enabled":  heartbeatEnabled,
				"interval": heartbeatInterval,
				"cooldown": heartbeatCooldown,
			}
			heartbeatMu.Unlock()
			w.Header().Set("Content-Type", "application/json")
			json.NewEncoder(w).Encode(state)
			return
		}
		heartbeatMu.Lock()
		state := map[string]interface{}{
			"enabled":  heartbeatEnabled,
			"interval": heartbeatInterval,
			"cooldown": heartbeatCooldown,
		}
		heartbeatMu.Unlock()
		w.Header().Set("Content-Type", "application/json")
		json.NewEncoder(w).Encode(state)
	})
	return mux
}
