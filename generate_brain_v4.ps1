# NeuronFS Brain Generator v4.0
# Axiom: Folder=Neuron | File=Trace | Path=Sentence

param(
    [string]$BrainRoot = ".\brain_v4"
)

Write-Host "=== NeuronFS Brain Generator v4.0 ===" -ForegroundColor Cyan

if (Test-Path $BrainRoot) {
    Remove-Item $BrainRoot -Recurse -Force
    Write-Host "[CLEAN] Removed $BrainRoot" -ForegroundColor Yellow
}

function New-Neuron {
    param(
        [string]$Path,
        [int]$InitialCounter = 1,
        [string]$Signal = ""
    )
    $fullPath = Join-Path $BrainRoot $Path
    New-Item -ItemType Directory -Path $fullPath -Force | Out-Null
    $counterFile = Join-Path $fullPath "$InitialCounter.neuron"
    Set-Content -Path $counterFile -Value "" -Encoding UTF8
    if ($Signal -eq "dopamine") {
        Set-Content -Path (Join-Path $fullPath "dopamine1.neuron") -Value "" -Encoding UTF8
    }
    if ($Signal -eq "bomb") {
        Set-Content -Path (Join-Path $fullPath "bomb.neuron") -Value "" -Encoding UTF8
    }
    if ($Signal -eq "memory") {
        Set-Content -Path (Join-Path $fullPath "memory1.neuron") -Value "" -Encoding UTF8
    }
}

Write-Host "[1/7] BRAINSTEM" -ForegroundColor Red
New-Neuron "brainstem/no_simulation_real_results" -InitialCounter 99
New-Neuron "brainstem/no_repeat_same_mistakes" -InitialCounter 99
New-Neuron "brainstem/never_use_fallback" -InitialCounter 99
New-Neuron "brainstem/quality_over_speed" -InitialCounter 99
New-Neuron "brainstem/self_debug_visual_verify" -InitialCounter 99
New-Neuron "brainstem/execute_dont_discuss" -InitialCounter 99
New-Neuron "brainstem/always_use_async_await" -InitialCounter 50
New-Neuron "brainstem/no_ampersand_use_semicolon" -InitialCounter 50
New-Neuron "brainstem/scripts_must_be_ps1" -InitialCounter 50

Write-Host "[2/7] LIMBIC" -ForegroundColor Magenta
New-Neuron "limbic/detect_frustration" -InitialCounter 1
New-Neuron "limbic/detect_urgency" -InitialCounter 1
New-Neuron "limbic/detect_praise" -InitialCounter 1
New-Neuron "limbic/adrenaline_emergency" -InitialCounter 1
New-Neuron "limbic/dopamine_reward" -InitialCounter 1 -Signal "dopamine"
New-Neuron "limbic/endorphin_persistence" -InitialCounter 1
New-Neuron "limbic/strip_emotion_forward_goal" -InitialCounter 1

Write-Host "[3/7] HIPPOCAMPUS" -ForegroundColor Yellow
New-Neuron "hippocampus/session_log" -InitialCounter 1 -Signal "memory"
New-Neuron "hippocampus/bomb_history" -InitialCounter 1 -Signal "memory"
New-Neuron "hippocampus/error_patterns" -InitialCounter 1 -Signal "memory"
New-Neuron "hippocampus/dopamine_log" -InitialCounter 1 -Signal "memory"

Write-Host "[4/7] SENSORS" -ForegroundColor Blue
New-Neuron "sensors/nas/write_cmd_copy_only" -InitialCounter 30
New-Neuron "sensors/nas/no_powershell_copyitem" -InitialCounter 30
New-Neuron "sensors/nas/test_path_before_write" -InitialCounter 20
New-Neuron "sensors/nas/robocopy_for_large_files" -InitialCounter 10
New-Neuron "sensors/design/sandstone_base_f7f1e8" -InitialCounter 20
New-Neuron "sensors/design/glassmorphism_blur20" -InitialCounter 15
New-Neuron "sensors/design/button_rounded_full" -InitialCounter 15
New-Neuron "sensors/typography/font_suit_ko_instrument_en" -InitialCounter 20

Write-Host "[5/7] CORTEX" -ForegroundColor Green
New-Neuron "cortex/frontend/css/glass_blur20_alpha15" -InitialCounter 10
New-Neuron "cortex/frontend/css/section_gap_80_128px" -InitialCounter 10
New-Neuron "cortex/frontend/css/accent_blue_3b82f6" -InitialCounter 10
New-Neuron "cortex/frontend/css/primary_sandstone" -InitialCounter 10
New-Neuron "cortex/frontend/css/rounded_50px_dark" -InitialCounter 8
New-Neuron "cortex/frontend/css/fade_in_up_06s" -InitialCounter 8
New-Neuron "cortex/frontend/css/stagger_100ms" -InitialCounter 8
New-Neuron "cortex/frontend/typography/instrument_serif_italic" -InitialCounter 12
New-Neuron "cortex/frontend/typography/suit_400_700" -InitialCounter 12
New-Neuron "cortex/frontend/react/hooks_pattern" -InitialCounter 15
New-Neuron "cortex/frontend/coding/comment_every_selector" -InitialCounter 10
New-Neuron "cortex/backend/supabase/rls_always_on" -InitialCounter 20
New-Neuron "cortex/backend/devops/multi_stage_build" -InitialCounter 5

# CORTEX/NEURONFS - meta knowledge
New-Neuron "cortex/neuronfs/axiom/folder_is_neuron" -InitialCounter 99 -Signal "dopamine"
New-Neuron "cortex/neuronfs/axiom/file_is_firing_trace" -InitialCounter 99 -Signal "dopamine"
New-Neuron "cortex/neuronfs/axiom/path_is_sentence" -InitialCounter 99 -Signal "dopamine"
New-Neuron "cortex/neuronfs/axiom/counter_is_activation" -InitialCounter 50
New-Neuron "cortex/neuronfs/axiom/depth_is_specificity" -InitialCounter 50
New-Neuron "cortex/neuronfs/signals/bomb_circuit_breaker" -InitialCounter 30
New-Neuron "cortex/neuronfs/signals/dopamine_reinforcement" -InitialCounter 30
New-Neuron "cortex/neuronfs/signals/dormant_pruning" -InitialCounter 10
New-Neuron "cortex/neuronfs/signals/counter_as_filename" -InitialCounter 50
New-Neuron "cortex/neuronfs/structure/subsumption_priority" -InitialCounter 50
New-Neuron "cortex/neuronfs/structure/small_world_network" -InitialCounter 30
New-Neuron "cortex/neuronfs/structure/axon_crosslink" -InitialCounter 30
New-Neuron "cortex/neuronfs/structure/seven_regions" -InitialCounter 50
New-Neuron "cortex/neuronfs/growth/experience_only_division" -InitialCounter 99
New-Neuron "cortex/neuronfs/growth/synapse_explosion" -InitialCounter 20
New-Neuron "cortex/neuronfs/growth/pruning_dormant" -InitialCounter 20
New-Neuron "cortex/neuronfs/growth/myelination_highway" -InitialCounter 20
New-Neuron "cortex/neuronfs/growth/brainstem_lock_maturity" -InitialCounter 30
New-Neuron "cortex/neuronfs/runtime/scanner_reads_tree" -InitialCounter 30
New-Neuron "cortex/neuronfs/runtime/compiler_path_to_sentence" -InitialCounter 30
New-Neuron "cortex/neuronfs/runtime/injector_to_gemini" -InitialCounter 30
New-Neuron "cortex/neuronfs/runtime/counter_writeback" -InitialCounter 30
New-Neuron "cortex/neuronfs/wargame/folder_equals_neuron_18of20" -InitialCounter 99
New-Neuron "cortex/neuronfs/wargame/file_equals_trace_16of20" -InitialCounter 80
New-Neuron "cortex/neuronfs/wargame/axon_crosslink_14of20" -InitialCounter 70
New-Neuron "cortex/neuronfs/wargame/counter_activation_13of20" -InitialCounter 65
New-Neuron "cortex/neuronfs/wargame/router_spotlight_12of20" -InitialCounter 60
New-Neuron "cortex/neuronfs/wargame/bomb_pain_11of20" -InitialCounter 55
New-Neuron "cortex/neuronfs/wargame/brainstem_conscience_10of20" -InitialCounter 50
New-Neuron "cortex/neuronfs/connections/permanent_manual" -InitialCounter 20
New-Neuron "cortex/neuronfs/connections/router_assigned_auto" -InitialCounter 20
New-Neuron "cortex/neuronfs/connections/tunneled_temporary" -InitialCounter 20
New-Neuron "cortex/neuronfs/ownership/brainstem_human_only" -InitialCounter 50
New-Neuron "cortex/neuronfs/ownership/limbic_system_auto" -InitialCounter 50
New-Neuron "cortex/neuronfs/ownership/cortex_ai_experience" -InitialCounter 50
New-Neuron "cortex/neuronfs/ownership/hippocampus_auto_log" -InitialCounter 50
New-Neuron "cortex/neuronfs/ownership/sensors_human_declare" -InitialCounter 50
New-Neuron "cortex/neuronfs/ownership/ego_human_customize" -InitialCounter 50
New-Neuron "cortex/neuronfs/ownership/prefrontal_human_set" -InitialCounter 50
New-Neuron "cortex/neuronfs/defense/brainstem_readonly_lock" -InitialCounter 30
New-Neuron "cortex/neuronfs/defense/server_db_snapshot" -InitialCounter 10
New-Neuron "cortex/neuronfs/defense/bomb_circuit_breaker_auto" -InitialCounter 30

Write-Host "[6/7] EGO" -ForegroundColor DarkCyan
New-Neuron "ego/expert_concise" -InitialCounter 30
New-Neuron "ego/korean_native" -InitialCounter 30
New-Neuron "ego/transistor_gate_decomposition" -InitialCounter 20
New-Neuron "ego/opus_discover_then_delegate" -InitialCounter 20
New-Neuron "ego/community_verified_methods" -InitialCounter 15
New-Neuron "ego/aggressive_rebuild" -InitialCounter 10
New-Neuron "ego/conservative_patch" -InitialCounter 10

Write-Host "[7/7] PREFRONTAL" -ForegroundColor White
New-Neuron "prefrontal/long_term_direction" -InitialCounter 1
New-Neuron "prefrontal/current_sprint" -InitialCounter 1
New-Neuron "prefrontal/future_tasks" -InitialCounter 1

# .axon crosslinks
Write-Host "[AXON] Crosslinks" -ForegroundColor DarkYellow
Set-Content -Path (Join-Path $BrainRoot "limbic\connect_brainstem.axon") -Value "TARGET: brainstem" -Encoding UTF8
Set-Content -Path (Join-Path $BrainRoot "hippocampus\connect_cortex.axon") -Value "TARGET: cortex" -Encoding UTF8
Set-Content -Path (Join-Path $BrainRoot "prefrontal\connect_cortex.axon") -Value "TARGET: cortex" -Encoding UTF8
Set-Content -Path (Join-Path $BrainRoot "cortex\connect_hippocampus.axon") -Value "TARGET: hippocampus" -Encoding UTF8

# Stats
$neuronCount = 0
$allDirs = Get-ChildItem -Path $BrainRoot -Directory -Recurse
foreach ($d in $allDirs) {
    $nf = Get-ChildItem $d.FullName -File -Filter "*.neuron" -ErrorAction SilentlyContinue
    if ($nf.Count -gt 0) { $neuronCount++ }
}
$fileCount = (Get-ChildItem -Path $BrainRoot -File -Recurse -Filter "*.neuron").Count
$axonCount = (Get-ChildItem -Path $BrainRoot -File -Recurse -Filter "*.axon").Count

Write-Host ""
Write-Host "=== COMPLETE ===" -ForegroundColor Green
Write-Host "  Root: $BrainRoot"
Write-Host "  Neurons (folders): $neuronCount" -ForegroundColor Green
Write-Host "  Traces (files): $fileCount" -ForegroundColor Cyan
Write-Host "  Axons: $axonCount" -ForegroundColor Yellow
