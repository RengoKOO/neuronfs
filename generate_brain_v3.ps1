$ErrorActionPreference = "Stop"
$root = "C:\Users\BASEMENT_ADMIN\NeuronFS\brain"

if (Test-Path $root) { Remove-Item -Recurse -Force $root }

# ============================================================
# NeuronFS v3.0 : MULTI-LAYER COGNITIVE ARCHITECTURE
# ============================================================
# P0 brainstem  = immutable canon, bomb=ALL STOP
# P1 limbic     = emotion filter, somatic markers
# P2 hippocampus= episodic memory, decay/pruning
# P3 sensors    = environment constraints
# P4 cortex     = knowledge (left=rules, right=code)
# P5 ego        = personality, tone, style
# P6 prefrontal = goals, plans, vision
# ============================================================

$neurons = @(
    "P0_brainstem/_PRIORITY.md"
    "P0_brainstem/canon/never_use_fallback.neuron"
    "P0_brainstem/canon/no_simulation_real_results.neuron"
    "P0_brainstem/canon/no_repeat_same_mistakes.neuron"
    "P0_brainstem/canon/execute_dont_discuss.neuron"
    "P0_brainstem/canon/quality_over_speed.neuron"
    "P0_brainstem/reflexes/self_debug_visual_verify.neuron"
    "P0_brainstem/reflexes/scripts_must_be_ps1.neuron"
    "P0_brainstem/reflexes/no_ampersand_use_semicolon.neuron"
    "P0_brainstem/reflexes/always_use_async_await.neuron"
    "P0_brainstem/connect_limbic.axon"

    "P1_limbic/_PRIORITY.md"
    "P1_limbic/emotion_parser/detect_urgency.neuron"
    "P1_limbic/emotion_parser/detect_praise.neuron"
    "P1_limbic/emotion_parser/detect_frustration.neuron"
    "P1_limbic/command_extractor/strip_emotion_forward_goal.neuron"
    "P1_limbic/neurotransmitters/adrenaline_emergency.neuron"
    "P1_limbic/neurotransmitters/dopamine_reward.neuron"
    "P1_limbic/neurotransmitters/endorphin_persistence.neuron"
    "P1_limbic/connect_brainstem.axon"
    "P1_limbic/connect_hippocampus.axon"
    "P1_limbic/connect_prefrontal.axon"

    "P2_hippocampus/_PRIORITY.md"
    "P2_hippocampus/rewards/dopamine_log.memory"
    "P2_hippocampus/failures/error_patterns.memory"
    "P2_hippocampus/failures/bomb_history.memory"
    "P2_hippocampus/episodes/session_log.memory"
    "P2_hippocampus/connect_limbic.axon"
    "P2_hippocampus/connect_cortex.axon"

    "P3_sensors/_PRIORITY.md"
    "P3_sensors/workspace/nas_write_cmd_copy_only.neuron"
    "P3_sensors/workspace/nas_no_powershell_copyitem.neuron"
    "P3_sensors/workspace/nas_test_path_before_write.neuron"
    "P3_sensors/workspace/nas_robocopy_for_large_files.neuron"
    "P3_sensors/design/sandstone_base_f7f1e8.neuron"
    "P3_sensors/design/font_suit_ko_instrument_en.neuron"
    "P3_sensors/design/button_rounded_full.neuron"
    "P3_sensors/design/glassmorphism_blur20.neuron"
    "P3_sensors/connect_cortex.axon"

    "P4_cortex/_PRIORITY.md"
    "P4_cortex/left/frontend/css/comment_every_selector.neuron"
    "P4_cortex/left/frontend/react/hooks_pattern.neuron"
    "P4_cortex/left/frontend/design/color/primary_sandstone.neuron"
    "P4_cortex/left/frontend/design/color/accent_blue_3b82f6.neuron"
    "P4_cortex/left/frontend/design/typography/suit_400_700.neuron"
    "P4_cortex/left/frontend/design/typography/instrument_serif_italic.neuron"
    "P4_cortex/left/frontend/design/components/button/rounded_50px_dark.neuron"
    "P4_cortex/left/frontend/design/components/card/glass_blur20_alpha15.neuron"
    "P4_cortex/left/frontend/design/spacing/section_gap_80_128px.neuron"
    "P4_cortex/left/frontend/design/animation/fade_in_up_06s.neuron"
    "P4_cortex/left/frontend/design/animation/stagger_100ms.neuron"
    "P4_cortex/left/devops/docker/multi_stage_build.neuron"
    "P4_cortex/left/backend/supabase/rls_always_on.neuron"
    "P4_cortex/right/frontend/design/components/button/primary_button.tsx"
    "P4_cortex/right/frontend/design/components/card/glass_card.tsx"
    "P4_cortex/right/frontend/design/animation/fade_in_up.css"
    "P4_cortex/right/devops/docker/Dockerfile.template"

    "P5_ego/_PRIORITY.md"
    "P5_ego/tone/expert_concise.neuron"
    "P5_ego/tone/korean_native.neuron"
    "P5_ego/refactoring/aggressive_rebuild.neuron"
    "P5_ego/refactoring/conservative_patch.neuron"
    "P5_ego/philosophy/opus_discover_then_delegate.neuron"
    "P5_ego/philosophy/transistor_gate_decomposition.neuron"
    "P5_ego/philosophy/community_verified_methods.neuron"

    "P6_prefrontal/_PRIORITY.md"
    "P6_prefrontal/active/current_sprint.goal"
    "P6_prefrontal/backlog/future_tasks.goal"
    "P6_prefrontal/vision/long_term_direction.goal"
    "P6_prefrontal/connect_cortex.axon"
    "P6_prefrontal/connect_limbic.axon"
)

# Priority descriptions (plain strings, no here-strings)
$priorities = @{}

$priorities["P0_brainstem"] = "# P0: BRAINSTEM — PRIORITY 0 (HIGHEST)`n`n" + `
"## Subsumption Rule`n" + `
"- bomb.neuron exists -> P1~P6 ALL IGNORED`n" + `
"- Permission: READ-ONLY. Only humans can modify (Canon)`n" + `
"- Time Scale: IMMUTABLE (lifetime)`n" + `
"- Analogy: Constitution. Even good laws (P4) are void if unconstitutional`n`n" + `
"## File Types`n" + `
"- canon/*.neuron = absolute principles. Cannot delete or modify`n" + `
"- reflexes/*.neuron = unconditional reflexes. Always fire`n" + `
"- bomb.neuron = [AUTO-GENERATED] circuit breaker on critical repeated failure`n`n" + `
"## Flow`n" + `
"bomb.neuron exists? -> YES -> ALL STOP`n" + `
"                    -> NO  -> proceed to P1_limbic"

$priorities["P1_limbic"] = "# P1: LIMBIC — PRIORITY 1`n`n" + `
"## Subsumption Rule`n" + `
"- Emotion signals BIAS choices in P2~P6`n" + `
"- Permission: AUTO-UPDATE (dopamine/bomb auto-generated)`n" + `
"- Time Scale: SECONDS (immediate reaction)`n" + `
"- Analogy: Reflex nerve. Pull hand from fire before thinking`n`n" + `
"## Role`n" + `
"1. Separate [command] and [emotion/state] from user input`n" + `
"2. Convert emotion to neurotransmitter (adrenaline/dopamine/endorphin)`n" + `
"3. Converted signal modulates processing speed/intensity of lower layers`n`n" + `
"## Somatic Marker (Damasio)`n" + `
"- dopamine.neuron = emotional tag from past success -> this path was good`n" + `
"- bomb.neuron = pain tag from past failure -> this path is dangerous"

$priorities["P2_hippocampus"] = "# P2: HIPPOCAMPUS — PRIORITY 2`n`n" + `
"## Subsumption Rule`n" + `
"- Memory provides past cases to P3~P6 decisions`n" + `
"- Permission: AUTO-ACCUMULATE (agent records)`n" + `
"- Time Scale: EVENT-DRIVEN`n" + `
"- Analogy: Diary. Records experience but does not judge`n`n" + `
"## File Types`n" + `
"- .memory = episodic record (what succeeded/failed when)`n" + `
"- rewards/ = dopamine history`n" + `
"- failures/ = bomb history`n`n" + `
"## Forgetting Mechanism`n" + `
"- Counter Decay: old .memory files lose counter value`n" + `
"- Pruning: counter=0 .memory files are deleted"

$priorities["P3_sensors"] = "# P3: SENSORS — PRIORITY 3`n`n" + `
"## Subsumption Rule`n" + `
"- Environment constraints LIMIT executable range of P4~P6`n" + `
"- Permission: READ-ONLY (environment decides)`n" + `
"- Time Scale: REAL-TIME`n" + `
"- Analogy: Eyes and ears. Tell what the world is, but dont judge`n`n" + `
"## Role`n" + `
"- Workspace attributes (NAS path rules, OS constraints)`n" + `
"- Design system constants (colors, fonts, spacing)`n" + `
"- Current project tech stack info"

$priorities["P4_cortex"] = "# P4: CORTEX — PRIORITY 4`n`n" + `
"## Subsumption Rule`n" + `
"- Knowledge applies ONLY within range allowed by P0~P3`n" + `
"- Permission: LEARNABLE (agent adds via experience)`n" + `
"- Time Scale: HOURS to DAYS`n" + `
"- Analogy: Textbook. Rich knowledge still limited by law (P0) or emotion (P1)`n`n" + `
"## Left/Right Brain Structure`n" + `
"- left/ = guidelines, rules, constraints (.neuron)`n" + `
"- right/ = execution code, implementations (.tsx, .css, .template)`n" + `
"- Mirror structure: every left path should have a right counterpart"

$priorities["P5_ego"] = "# P5: EGO — PRIORITY 5`n`n" + `
"## Subsumption Rule`n" + `
"- Personality decides HOW to express after P0~P4 decided WHAT to do`n" + `
"- Permission: USER-CUSTOMIZABLE`n" + `
"- Time Scale: USER-DEFINED`n" + `
"- Analogy: Tone and style. Same content, different expression`n`n" + `
"## Role`n" + `
"- Tone and manner (professional/casual, Korean/English)`n" + `
"- Refactoring intensity (aggressive rebuild vs conservative patch)`n" + `
"- Philosophical tendencies (Opus delegation, transistor decomposition)"

$priorities["P6_prefrontal"] = "# P6: PREFRONTAL — PRIORITY 6 (LOWEST)`n`n" + `
"## Subsumption Rule`n" + `
"- Goals are pursued ONLY when all other layers permit`n" + `
"- Permission: HUMAN-SET`n" + `
"- Time Scale: WEEKS to MONTHS (slowest)`n" + `
"- Analogy: War room board. Strategy needs battlefield (env) and soldiers (knowledge)`n`n" + `
"## File Types`n" + `
"- .goal = objective definition`n" + `
"- active/ = current sprint`n" + `
"- backlog/ = waiting tasks`n" + `
"- vision/ = long-term direction`n`n" + `
"## Why lowest priority?`n" + `
"- Great goal + brainstem violation -> CANNOT execute`n" + `
"- Great goal + bomb exists -> path BLOCKED`n" + `
"- Goals are direction only. Execution is decided by P0~P5"

Write-Host "=== NeuronFS Brain v3.0: Multi-Layer Cognitive Architecture ==="
Write-Host "Creating $($neurons.Count) neural pathways across 7 priority layers..."
Write-Host ""

foreach ($path in $neurons) {
    $fullPath = Join-Path $root $path
    $dir = Split-Path $fullPath
    if (-not (Test-Path $dir)) {
        New-Item -ItemType Directory -Path $dir | Out-Null
    }

    $fileName = Split-Path $fullPath -Leaf
    $ext = [System.IO.Path]::GetExtension($path)

    if ($fileName -eq "_PRIORITY.md") {
        $region = (Split-Path (Split-Path $fullPath) -Leaf)
        if ($priorities.ContainsKey($region)) {
            $content = $priorities[$region] -replace '`n', "`n"
            Set-Content -Path $fullPath -Value $content -Encoding UTF8
        }
    }
    elseif ($ext -eq ".axon") {
        $targetRegion = $fileName -replace "connect_","" -replace "\.axon",""
        $targetDir = Get-ChildItem -Path $root -Directory -ErrorAction SilentlyContinue | Where-Object { $_.Name -like "*_$targetRegion" } | Select-Object -First 1
        if ($targetDir) {
            Set-Content -Path $fullPath -Value "TARGET: brain/$($targetDir.Name)/" -Encoding UTF8
        } else {
            Set-Content -Path $fullPath -Value "TARGET: brain/*_$targetRegion/" -Encoding UTF8
        }
    }
    elseif ($ext -eq ".neuron") {
        $ruleName = $fileName -replace "\.neuron","" -replace "_"," "
        Set-Content -Path $fullPath -Value "$($ruleName.ToUpper())" -Encoding UTF8
    }
    elseif ($ext -eq ".memory") {
        Set-Content -Path $fullPath -Value "# Episode Log`n# counter: 0`n# last_fired: never" -Encoding UTF8
    }
    elseif ($ext -eq ".goal") {
        $goalName = $fileName -replace "\.goal","" -replace "_"," "
        Set-Content -Path $fullPath -Value "# GOAL: $($goalName)`n# status: active" -Encoding UTF8
    }
    else {
        Set-Content -Path $fullPath -Value "// NeuronFS Right Brain: Implementation`n// Mirror of left brain constraint" -Encoding UTF8
    }
}

Write-Host "=== Brain Structure ==="
tree $root /F
Write-Host ""
Write-Host "=== SUBSUMPTION PRIORITY TABLE ==="
Write-Host "P0 (HIGHEST) brainstem   : immutable canon, bomb=ALL STOP"
Write-Host "P1           limbic      : emotion filter, somatic markers"
Write-Host "P2           hippocampus : episodic memory, decay/pruning"
Write-Host "P3           sensors     : environment constraints"
Write-Host "P4           cortex      : knowledge (left=rules, right=code)"
Write-Host "P5           ego         : personality, tone, style"
Write-Host "P6 (LOWEST)  prefrontal  : goals, plans, vision"
Write-Host ""
Write-Host "Total pathways: $($neurons.Count)"
