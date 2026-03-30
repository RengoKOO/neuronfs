$ErrorActionPreference = "Stop"
$root = "C:\Users\BASEMENT_ADMIN\NeuronFS\brain"

if (Test-Path $root) { Remove-Item -Recurse -Force $root }

# ============================================================
# SPATIAL BRAIN REGIONS (no numbering = no false linearity)
# ============================================================

$neurons = @(
    # ── LIMBIC (변연계: 감정/의도 필터) ──
    "limbic/emotion_parser/detect_urgency.neuron"
    "limbic/emotion_parser/detect_praise.neuron"
    "limbic/emotion_parser/detect_frustration.neuron"
    "limbic/command_extractor/strip_emotion_forward_goal.neuron"
    "limbic/connect_brainstem.axon"
    "limbic/connect_prefrontal.axon"

    # ── BRAINSTEM (뇌간: 본능/생존 반사) ──
    "brainstem/survival/never_use_fallback.neuron"
    "brainstem/survival/no_simulation_real_results.neuron"
    "brainstem/survival/no_repeat_same_mistakes.neuron"
    "brainstem/reflexes/execute_dont_discuss.neuron"
    "brainstem/reflexes/quality_over_speed.neuron"
    "brainstem/reflexes/self_debug_visual_verify.neuron"
    "brainstem/code_instincts/always_use_async_await.neuron"
    "brainstem/code_instincts/scripts_must_be_ps1.neuron"
    "brainstem/code_instincts/no_ampersand_use_semicolon.neuron"

    # ── EGO (자아: 성향/페르소나) ──
    "ego/tone/expert_concise.neuron"
    "ego/tone/korean_native.neuron"
    "ego/refactoring/aggressive_rebuild.neuron"
    "ego/refactoring/conservative_patch.neuron"
    "ego/philosophy/opus_discover_then_delegate.neuron"
    "ego/philosophy/transistor_gate_decomposition.neuron"
    "ego/philosophy/community_verified_methods.neuron"

    # ── SENSORS (센서: 대상의 환경/속성) ──
    "sensors/workspace/nas_write_cmd_copy_only.neuron"
    "sensors/workspace/nas_no_powershell_copyitem.neuron"
    "sensors/workspace/nas_test_path_before_write.neuron"
    "sensors/workspace/nas_robocopy_for_large_files.neuron"
    "sensors/design/sandstone_base_f7f1e8.neuron"
    "sensors/design/font_suit_ko_instrument_en.neuron"
    "sensors/design/button_rounded_full.neuron"
    "sensors/design/glassmorphism_blur20.neuron"
    "sensors/connect_cortex.axon"

    # ── CORTEX (대뇌피질: 지식 / 좌뇌-우뇌) ──
    # 좌뇌 (지침)
    "cortex/left/frontend/css/comment_every_selector.neuron"
    "cortex/left/frontend/react/hooks_pattern.neuron"
    "cortex/left/frontend/design/color/primary_sandstone.neuron"
    "cortex/left/frontend/design/color/accent_blue_3b82f6.neuron"
    "cortex/left/frontend/design/typography/suit_400_700.neuron"
    "cortex/left/frontend/design/typography/instrument_serif_italic.neuron"
    "cortex/left/frontend/design/components/button/rounded_50px_dark.neuron"
    "cortex/left/frontend/design/components/card/glass_blur20_alpha15.neuron"
    "cortex/left/frontend/design/spacing/section_gap_80_128px.neuron"
    "cortex/left/frontend/design/animation/fade_in_up_06s.neuron"
    "cortex/left/frontend/design/animation/stagger_100ms.neuron"
    "cortex/left/devops/docker/multi_stage_build.neuron"
    "cortex/left/backend/supabase/rls_always_on.neuron"

    # 우뇌 (실행 코드) - 동일한 거울 구조
    "cortex/right/frontend/design/components/button/primary_button.tsx"
    "cortex/right/frontend/design/components/card/glass_card.tsx"
    "cortex/right/frontend/design/animation/fade_in_up.css"
    "cortex/right/devops/docker/Dockerfile.template"

    # ── PREFRONTAL (전두엽: 목표/작전실) ──
    "prefrontal/active/current_sprint.neuron"
    "prefrontal/backlog/future_tasks.neuron"
    "prefrontal/connect_cortex.axon"
    "prefrontal/connect_limbic.axon"

    # ── HIPPOCAMPUS (해마: 기억/학습 로그) ──
    "hippocampus/rewards/dopamine_log.neuron"
    "hippocampus/failures/error_patterns.neuron"
    "hippocampus/connect_limbic.axon"
    "hippocampus/connect_cortex.axon"
)

Write-Host "=== NeuronFS Brain v2.0: Spatial Architecture ==="
Write-Host "Creating $($neurons.Count) neural pathways..."

foreach ($path in $neurons) {
    $fullPath = Join-Path $root $path
    $dir = Split-Path $fullPath
    if (-not (Test-Path $dir)) {
        New-Item -ItemType Directory -Path $dir | Out-Null
    }

    $ext = [System.IO.Path]::GetExtension($path)

    if ($ext -eq ".axon") {
        # .axon = 축색돌기 (다른 영역으로의 크로스링크)
        $targetRegion = (Split-Path $fullPath -Leaf) -replace "connect_","" -replace "\.axon",""
        Set-Content -Path $fullPath -Value "TARGET: brain/$targetRegion/"
    }
    elseif ($ext -eq ".neuron") {
        $ruleName = (Split-Path $fullPath -Leaf) -replace "\.neuron","" -replace "_"," "
        Set-Content -Path $fullPath -Value "$($ruleName.ToUpper())"
    }
    else {
        # 우뇌 실행 파일 (tsx, css, template 등)
        Set-Content -Path $fullPath -Value "// NeuronFS Right Brain: Implementation file`n// Mirror of left brain constraint"
    }
}

Write-Host ""
Write-Host "=== Brain Structure ==="
tree $root /F
Write-Host ""
Write-Host "Total neurons: $($neurons.Count)"
Write-Host "Brain regions: limbic, brainstem, ego, sensors, cortex (left/right), prefrontal, hippocampus"
