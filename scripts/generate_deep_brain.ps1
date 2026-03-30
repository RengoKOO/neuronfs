$ErrorActionPreference = "Stop"

$workspace = "C:\Users\BASEMENT_ADMIN\NeuronFS_Brain\design_system"

# Clear existing if any
if (Test-Path $workspace) {
    Remove-Item -Recurse -Force $workspace
}

# Define the ultra-deep pathways
$pathways = @(
    "foundations/color/primary/sandstone_f7f1e8.neuron",
    "foundations/color/semantic/interactive_states/hover_darken_10.neuron",
    "foundations/color/semantic/interactive_states/active_scale_95.neuron",
    "foundations/color/semantic/status_states/error_vibrant_red.neuron",
    "foundations/color/accessibility/contrast_ratio/wcag_aa_4_5_1.neuron",
    "foundations/color/accessibility/color_blindness/avoid_red_green_only.neuron",
    
    "foundations/typography/families/korean/suit_sans.neuron",
    "foundations/typography/families/english/instrument_serif_italic.neuron",
    "foundations/typography/scale/fluid_scaling/clamp_h1.neuron",
    "foundations/typography/scale/fluid_scaling/clamp_body.neuron",
    "foundations/typography/scale/mobile_optimizations/line_height_1_6.neuron",
    
    "foundations/spatial/grid/8pt_soft_grid.neuron",
    "foundations/spatial/spacing_tokens/section_gap/minimum_120px.neuron",
    "foundations/spatial/spacing_tokens/component_padding/glass_card_24px.neuron",
    
    "components/atoms/buttons/shape/fully_rounded_50px.neuron",
    "components/atoms/buttons/behavior/floating_action_shadow.neuron",
    "components/atoms/buttons/variations/primary_dark_1c1c1c.neuron",
    
    "components/molecules/cards/material/glassmorphism/blur_20px.neuron",
    "components/molecules/cards/material/glassmorphism/bg_white_alpha_15.neuron",
    "components/molecules/cards/material/shadowing/subtle_drop_0_2_8_006.neuron",
    
    "interaction/motion/physics/cubic_bezier_snappy.neuron",
    "interaction/motion/triggers/on_scroll/fade_in_up_06s.neuron",
    "interaction/motion/triggers/on_scroll/staggering_100ms.neuron",
    "interaction/motion/triggers/on_hover/glass_pop_08s.neuron"
)

Write-Host "Synaptogenesis initializing: Creating ultra-deep neural pathways..."

foreach ($path in $pathways) {
    $fullPath = Join-Path $workspace $path
    $dir = Split-Path $fullPath
    if (-not (Test-Path $dir)) {
        New-Item -ItemType Directory -Path $dir | Out-Null
    }
    
    # Fill the neuron with a tiny snippet of rule
    $ruleName = (Split-Path $fullPath -Leaf) -replace "\.neuron","" -replace "_"," "
    $ruleName = $ruleName.ToUpper()
    
    Set-Content -Path $fullPath -Value "RULE: $ruleName"
}

Write-Host "Neural paths generated successfully."
tree $workspace /F
