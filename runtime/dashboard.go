package main

import (
	"encoding/json"
	"fmt"
	"net/http"
	"os"
	"path/filepath"
	"strings"
)

// ─── JSON models for API ───

type NeuronJSON struct {
	Name      string `json:"name"`
	Path      string `json:"path"`
	Counter   int    `json:"counter"`
	Dopamine  int    `json:"dopamine"`
	HasBomb   bool   `json:"hasBomb"`
	HasMemory bool   `json:"hasMemory"`
	IsDormant bool   `json:"isDormant"`
	Depth     int    `json:"depth"`
}

type RegionJSON struct {
	Name     string       `json:"name"`
	Icon     string       `json:"icon"`
	Ko       string       `json:"ko"`
	Priority int          `json:"priority"`
	HasBomb  bool         `json:"hasBomb"`
	Neurons  []NeuronJSON `json:"neurons"`
	Axons    []string     `json:"axons"`
}

type BrainJSON struct {
	Root         string       `json:"root"`
	Regions      []RegionJSON `json:"regions"`
	BombSource   string       `json:"bombSource"`
	FiredNeurons int          `json:"firedNeurons"`
	TotalNeurons int          `json:"totalNeurons"`
	TotalCounter int          `json:"totalCounter"`
}

type AddNeuronReq struct {
	Region string `json:"region"`
	Path   string `json:"path"`
}

type AddBombReq struct {
	Region string `json:"region"`
	Name   string `json:"name"`
}

// ─── CORS middleware ───
func withCORSDashboard(h http.HandlerFunc) http.HandlerFunc {
	return func(w http.ResponseWriter, r *http.Request) {
		w.Header().Set("Access-Control-Allow-Origin", "*")
		w.Header().Set("Access-Control-Allow-Methods", "GET, POST, OPTIONS")
		w.Header().Set("Access-Control-Allow-Headers", "Content-Type")
		if r.Method == "OPTIONS" {
			w.WriteHeader(200)
			return
		}
		h(w, r)
	}
}

// ─── Build brain JSON from scan ───
func buildBrainJSONResponse(brainRoot string) BrainJSON {
	brain := scanBrain(brainRoot)
	result := runSubsumption(brain)

	data := BrainJSON{
		Root:         brain.Root,
		BombSource:   result.BombSource,
		FiredNeurons: result.FiredNeurons,
		TotalNeurons: result.TotalNeurons,
		TotalCounter: result.TotalCounter,
	}

	for _, region := range brain.Regions {
		rj := RegionJSON{
			Name:     region.Name,
			Icon:     regionIcons[region.Name],
			Ko:       regionKo[region.Name],
			Priority: region.Priority,
			HasBomb:  region.HasBomb,
			Axons:    region.Axons,
		}
		for _, n := range region.Neurons {
			rj.Neurons = append(rj.Neurons, NeuronJSON{
				Name:      n.Name,
				Path:      strings.ReplaceAll(n.Path, string(filepath.Separator), "/"),
				Counter:   n.Counter,
				Dopamine:  n.Dopamine,
				HasBomb:   n.HasBomb,
				HasMemory: n.HasMemory,
				IsDormant: n.IsDormant,
				Depth:     n.Depth,
			})
		}
		data.Regions = append(data.Regions, rj)
	}
	return data
}

// ─── Dashboard Server (--dashboard mode) ───

func startDashboard(brainRoot string, port int) {
	fmt.Printf("[NeuronFS] Dashboard: http://localhost:%d\n", port)
	fmt.Printf("[NeuronFS] Brain: %s\n", brainRoot)
	fmt.Printf("[NeuronFS] Axiom: Folder=Neuron | File=Trace | Path=Sentence\n")

	mux := http.NewServeMux()

	// GET / — Dashboard HTML (exact match "/" or fallback for non-API paths)
	mux.HandleFunc("/", withCORSDashboard(func(w http.ResponseWriter, r *http.Request) {
		// Serve dashboard HTML for root, ignore favicon etc silently
		if r.URL.Path != "/" && !strings.HasPrefix(r.URL.Path, "/api/") {
			// Return empty 204 for favicon, manifest etc to suppress 404 in console
			if r.URL.Path == "/favicon.ico" || r.URL.Path == "/manifest.json" {
				w.WriteHeader(204)
				return
			}
			http.NotFound(w, r)
			return
		}
		w.Header().Set("Content-Type", "text/html; charset=utf-8")
		fmt.Fprint(w, dashboardHTML)
	}))

	// GET /api/brain — scan and return full state
	mux.HandleFunc("/api/brain", withCORSDashboard(func(w http.ResponseWriter, r *http.Request) {
		data := buildBrainJSONResponse(brainRoot)
		w.Header().Set("Content-Type", "application/json")
		json.NewEncoder(w).Encode(data)
	}))

	// POST /api/inject — inject rules to GEMINI.md
	mux.HandleFunc("/api/inject", withCORSDashboard(func(w http.ResponseWriter, r *http.Request) {
		if r.Method != "POST" {
			http.Error(w, "POST only", 405)
			return
		}
		brain := scanBrain(brainRoot)
		result := runSubsumption(brain)
		rules := emitRules(result)
		injectToGemini(brainRoot, rules)
		w.Write([]byte(fmt.Sprintf("OK — %d neurons injected, activation: %d",
			result.FiredNeurons, result.TotalCounter)))
	}))

	// POST /api/neuron — add a new neuron (create folder + 1.neuron)
	mux.HandleFunc("/api/neuron", withCORSDashboard(func(w http.ResponseWriter, r *http.Request) {
		if r.Method != "POST" {
			http.Error(w, "POST only", 405)
			return
		}
		var req AddNeuronReq
		if err := json.NewDecoder(r.Body).Decode(&req); err != nil {
			http.Error(w, "bad json", 400)
			return
		}

		path := strings.ReplaceAll(req.Path, "\\", "/")
		path = strings.Trim(path, "/")

		neuronDir := filepath.Join(brainRoot, req.Region, path)
		if err := os.MkdirAll(neuronDir, 0755); err != nil {
			http.Error(w, "mkdir failed: "+err.Error(), 500)
			return
		}

		counterFile := filepath.Join(neuronDir, "1.neuron")
		if err := os.WriteFile(counterFile, []byte(""), 0644); err != nil {
			http.Error(w, "write failed: "+err.Error(), 500)
			return
		}

		fmt.Printf("[GROWTH] New neuron: %s/%s\n", req.Region, path)
		w.Write([]byte("OK — " + req.Region + "/" + path))
	}))

	// POST /api/bomb — create bomb.neuron in a region
	mux.HandleFunc("/api/bomb", withCORSDashboard(func(w http.ResponseWriter, r *http.Request) {
		if r.Method != "POST" {
			http.Error(w, "POST only", 405)
			return
		}
		var req AddBombReq
		if err := json.NewDecoder(r.Body).Decode(&req); err != nil {
			http.Error(w, "bad json", 400)
			return
		}

		bombDir := filepath.Join(brainRoot, req.Region, req.Name)
		os.MkdirAll(bombDir, 0755)
		bombFile := filepath.Join(bombDir, "bomb.neuron")
		os.WriteFile(bombFile, []byte(""), 0644)

		fmt.Printf("[BOMB] 💀 %s/%s\n", req.Region, req.Name)
		w.Write([]byte("BOMB placed: " + req.Region + "/" + req.Name))
	}))

	// POST /api/increment — increment a neuron's counter
	mux.HandleFunc("/api/increment", withCORSDashboard(func(w http.ResponseWriter, r *http.Request) {
		if r.Method != "POST" {
			http.Error(w, "POST only", 405)
			return
		}
		var req AddNeuronReq
		if err := json.NewDecoder(r.Body).Decode(&req); err != nil {
			http.Error(w, "bad json", 400)
			return
		}

		neuronDir := filepath.Join(brainRoot, req.Region, req.Path)
		if _, err := os.Stat(neuronDir); os.IsNotExist(err) {
			http.Error(w, "neuron not found", 404)
			return
		}

		files, _ := filepath.Glob(filepath.Join(neuronDir, "*.neuron"))
		currentCounter := 0
		var counterFilePath string
		for _, f := range files {
			fname := filepath.Base(f)
			if m := counterRegex.FindStringSubmatch(fname); m != nil {
				n := 0
				fmt.Sscanf(m[1], "%d", &n)
				if n > currentCounter {
					currentCounter = n
					counterFilePath = f
				}
			}
		}

		if counterFilePath != "" {
			os.Remove(counterFilePath)
		}
		newCounter := currentCounter + 1
		newFile := filepath.Join(neuronDir, fmt.Sprintf("%d.neuron", newCounter))
		os.WriteFile(newFile, []byte(""), 0644)

		fmt.Printf("[FIRE] %s/%s: %d → %d\n", req.Region, req.Path, currentCounter, newCounter)
		w.Write([]byte(fmt.Sprintf("%d", newCounter)))
	}))

	http.ListenAndServe(fmt.Sprintf(":%d", port), mux)
}
