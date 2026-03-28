# ═══════════════════════════════════════════════════════
# NeuronFS Harness — 같은 실수 반복 방지 자동 검증
# ═══════════════════════════════════════════════════════
# 
# 모든 禁 뉴런 + PD 교정 이력을 코드에서 자동 검증.
# 위반 시 경고 + bomb 경고. 통과 시 관련 뉴런 자연 fire.
#
# 사용: .\harness.ps1 [-Fix]
# ═══════════════════════════════════════════════════════

param([switch]$Fix)

$ErrorActionPreference = "SilentlyContinue"
$brain = "C:\Users\BASEMENT_ADMIN\NeuronFS\brain_v4"
$runtime = "C:\Users\BASEMENT_ADMIN\NeuronFS\runtime"
$pass = 0; $fail = 0; $warn = 0
$violations = @()

function Check($id, $name, $test) {
    $result = & $test
    if ($result) {
        Write-Host "  ✅ [$id] $name" -ForegroundColor Green
        $script:pass++
        return $true
    } else {
        Write-Host "  ❌ [$id] $name" -ForegroundColor Red
        $script:fail++
        $script:violations += $name
        return $false
    }
}

function Warn($id, $name, $msg) {
    Write-Host "  ⚠️  [$id] $name — $msg" -ForegroundColor Yellow
    $script:warn++
}

function Fire($neuronPath) {
    $safePath = $neuronPath.Replace('\', '/')
    $obj = @{ path = $safePath }
    $jsonStr = ($obj | ConvertTo-Json -Compress)
    $body = [System.Text.Encoding]::UTF8.GetBytes($jsonStr)
    try {
        Invoke-RestMethod "http://localhost:9090/api/fire" -Method POST -ContentType "application/json; charset=utf-8" -Body $body -TimeoutSec 3 | Out-Null
    } catch {
        Write-Host "    fire skip: $neuronPath" -ForegroundColor DarkYellow
    }
}

Write-Host ""
Write-Host "╔═══════════════════════════════════════╗" -ForegroundColor Cyan
Write-Host "║   NeuronFS Harness — 실수 반복 방지   ║" -ForegroundColor Cyan
Write-Host "╚═══════════════════════════════════════╝" -ForegroundColor Cyan
Write-Host ""

# ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
# 禁 뉴런 — 코드 위반 감지
# ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
Write-Host "── 禁 규칙 검증 ──" -ForegroundColor Yellow

# 1. 禁console.log (Go 코드에 console.log 없어야)
$r = Check "F01" "禁console.log" {
    $hits = Select-String -Path "$runtime\*.go" -Pattern "console\.log" 
    $hits.Count -eq 0
}
if ($r) { Fire "cortex/frontend\coding\禁console_log" }

# 2. 禁인라인스타일 (dashboard에 style= 최소화)
$r = Check "F02" "禁inline style (Go 템플릿)" {
    $html = Get-Content "$runtime\dashboard_html.go" -Raw
    $inlines = [regex]::Matches($html, 'style="[^"]{30,}"')
    $inlines.Count -lt 5
}
if ($r) { Fire "cortex/frontend\coding\禁인라인스타일" }

# 3. 禁평문 토큰
$r = Check "F03" "禁평문 API 키" {
    $hits = Select-String -Path "$runtime\*.go" -Pattern "(sk-|gsk_|AKIA)[a-zA-Z0-9]{20,}" 
    ($hits -eq $null) -or ($hits.Count -eq 0)
}
if ($r) { Fire "cortex/security\禁평문_토큰" }

# 4. 禁context stuffing (GEMINI.md < 15KB — 한글 UTF-8 3bytes/char 감안)
$r = Check "F04" "禁context stuffing (GEMINI.md < 15KB)" {
    $size = (Get-Item "C:\Users\BASEMENT_ADMIN\.gemini\GEMINI.md" -ErrorAction SilentlyContinue).Length
    $size -lt 15000
}
if ($r) { Fire "cortex/neuronfs\design\실재_온톨로지" }

# 5. 禁인위적 카운터 조작 (카운터 20 이상 경고)
Check "F05" "禁인위적 카운터 (max < 30)" {
    $high = Get-ChildItem $brain -Recurse -Filter "*.neuron" | Where-Object { $_.BaseName -match '^\d+$' -and [int]$_.BaseName -ge 30 }
    $high.Count -eq 0
} | Out-Null

# 6. 禁cognitive drift (brainstem 뉴런 변경 없음 — _rules.md는 자동생성이므로 제외)
$r = Check "F06" "禁brainstem 무단 변경" {
    $bs = "$brain\brainstem"
    $recent = Get-ChildItem $bs -Recurse -File | Where-Object { $_.LastWriteTime -gt (Get-Date).AddHours(-1) -and $_.Name -ne "_rules.md" }
    $recent.Count -eq 0
}
if ($r) { Fire "cortex/neuronfs/defense/brainstem_readonly" }

# 7. API fire UTF-8 encoding
$r = Check "F07" "API fire UTF-8 encoding" {
    $testPath = "cortex/methodology/plan_then_execute"
    $obj = @{ path = $testPath }
    $jsonStr = ($obj | ConvertTo-Json -Compress)
    $body = [System.Text.Encoding]::UTF8.GetBytes($jsonStr)
    try {
        $res = Invoke-RestMethod "http://localhost:9090/api/fire" -Method POST -ContentType "application/json; charset=utf-8" -Body $body -TimeoutSec 3
        $res.status -eq "fired"
    } catch { $false }
}

# ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
# PD 교정 이력 기반 검증
# ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
Write-Host ""
Write-Host "── PD 교정 패턴 검증 ──" -ForegroundColor Yellow

# 7. 중복 뉴런 (같은 의미의 폴더 2개)
$r = Check "P01" "禁SSOT 중복 (동일 뉴런)" {
    $inlineA = Test-Path "$brain\cortex\frontend\coding\禁inline_style"
    $inlineB = Test-Path "$brain\cortex\frontend\coding\禁인라인스타일"
    -not ($inlineA -and $inlineB)
}
if (-not $r -and $Fix) {
    Remove-Item "$brain\cortex\frontend\coding\禁inline_style" -Recurse -Force
    Write-Host "    → 자동 수정: 禁inline_style 제거 (禁인라인스타일로 통합)" -ForegroundColor DarkGreen
}

# 8. _rules.md에 강도 접두어 존재
$r = Check "P02" "강도 치환 작동 (절대/반드시 in _rules.md)" {
    $cortex = Get-Content "$brain\cortex\_rules.md" -Raw -Encoding UTF8
    $cortex -match "절대|반드시"
}

# 9. 3-tier 분리 (7개 _rules.md 존재)
$r = Check "P03" "3-tier 분리 (7x _rules.md)" {
    $rules = Get-ChildItem $brain -Filter "_rules.md" -Recurse
    $rules.Count -ge 7
}

# 10. bomb 해제 상태
$r = Check "P04" "bomb 없음 (정상 운영)" {
    $bombs = Get-ChildItem $brain -Recurse -Filter "bomb.neuron"
    $bombs.Count -eq 0
}

# 11. dormant 기능 정상
Check "P05" "dormant 파일 존재 (가지치기 작동)" {
    $d = Get-ChildItem $brain -Recurse -Filter "*.dormant"
    $d.Count -gt 0
} | Out-Null

# ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
# 멀티에이전트 검증
# ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
Write-Host ""
Write-Host "── 멀티에이전트 검증 ──" -ForegroundColor Yellow

$r = Check "M01" "에이전트 디렉토리 구조" {
    (Test-Path "$brain\_agents\agent_a\inbox") -and (Test-Path "$brain\_agents\agent_b\inbox")
}

$r = Check "M02" "통신 프로토콜 문서" {
    Test-Path "$brain\_agents\protocol.md"
}

Check "M03" "agent-bridge 프로세스" {
    $alive = $false
    Get-Process node -ErrorAction SilentlyContinue | ForEach-Object {
        try {
            $cmd = (Get-CimInstance Win32_Process -Filter "ProcessId=$($_.Id)").CommandLine
            if ($cmd -match "agent-bridge") { $alive = $true }
        } catch {}
    }
    $alive
} | Out-Null

# ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
# 빌드 검증
# ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
Write-Host ""
Write-Host "── 빌드 검증 ──" -ForegroundColor Yellow

$r = Check "B01" "Go build" {
    $tmpExe = Join-Path $env:TEMP "neuronfs_harness_test.exe"
    Remove-Item $tmpExe -Force -ErrorAction SilentlyContinue
    $saved = Get-Location
    Set-Location $script:runtime
    go build -o $tmpExe . 2>$null | Out-Null
    Set-Location $saved
    $exists = Test-Path $tmpExe
    Remove-Item $tmpExe -Force -ErrorAction SilentlyContinue
    $exists
}

$r = Check "B02" "API 응답 정상" {
    try {
        $state = Invoke-RestMethod "http://localhost:9090/api/state" -TimeoutSec 3
        $state.totalNeurons -gt 0
    } catch { $false }
}

# ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
# 결과
# ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
Write-Host ""
Write-Host "╔═══════════════════════════════════════╗" -ForegroundColor $(if ($fail -eq 0) { "Green" } else { "Red" })
Write-Host "║  PASS: $pass  |  FAIL: $fail  |  WARN: $warn" -ForegroundColor $(if ($fail -eq 0) { "Green" } else { "Red" })
Write-Host "╚═══════════════════════════════════════╝" -ForegroundColor $(if ($fail -eq 0) { "Green" } else { "Red" })

if ($violations.Count -gt 0) {
    Write-Host ""
    Write-Host "위반 사항:" -ForegroundColor Red
    $violations | ForEach-Object { Write-Host "  • $_" -ForegroundColor Red }
}

# 세션 로그
$timestamp = Get-Date -Format "yyyy-MM-dd HH:mm"
$logEntry = "$timestamp | PASS=$pass FAIL=$fail | violations: $($violations -join ', ')"
$logDir = "$brain\hippocampus\session_log"
if (-not (Test-Path $logDir)) { New-Item $logDir -ItemType Directory -Force | Out-Null }
Add-Content "$logDir\harness_log.txt" $logEntry

if ($fail -eq 0) {
    Write-Host ""
    Write-Host "🧠 All clear. 같은 실수 없음." -ForegroundColor Green
} else {
    Write-Host ""
    Write-Host "⚠️  $fail개 위반 — 즉시 수정 필요. (harness.ps1 -Fix로 자동수정)" -ForegroundColor Red
}
