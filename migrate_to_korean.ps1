# NeuronFS 뉴런 폴더 마이그레이션: 영어 → 한글/한자
# 카운터(.neuron), dopamine, bomb, goal, memory 파일 모두 보존
# 규칙: 금지류=禁, 권장류=推, 나머지=한글

$bp = 'C:\Users\BASEMENT_ADMIN\NeuronFS\brain_v4'

# 매핑 테이블: old_path → new_path (리프 폴더만 rename, 중간 폴더도 필요시 rename)
$map = @{
    # === brainstem (양심/핵심) ===
    'brainstem\ask_only_when_necessary'       = 'brainstem\필요할때만_질문'
    'brainstem\execute_dont_discuss'           = 'brainstem\토론말고_실행'
    'brainstem\no_hardcoding'                  = 'brainstem\禁하드코딩'
    'brainstem\no_process_bypass'              = 'brainstem\禁프로세스_우회'
    'brainstem\quality_over_speed'             = 'brainstem\품질우선_속도후순'
    'brainstem\self_debug_visual_verify'       = 'brainstem\셀프디버그_시각검증'
    'brainstem\community_academic_search'      = 'brainstem\커뮤니티_학술검색'
    'brainstem\dictionary_based_matching'      = 'brainstem\사전기반_매칭'
    'brainstem\positive_negative_both'         = 'brainstem\긍정부정_양면검토'
    'brainstem\third_party_audit'              = 'brainstem\제3자_검증'
    'brainstem\two_persona_debate'             = 'brainstem\두_페르소나_토론'
    'brainstem\real_ontology_not_text'         = 'brainstem\실재_온톨로지'
    'brainstem\bomb_circuit_breaker_auto'      = 'brainstem\bomb_자동_차단'
    'brainstem\brainstem_readonly_lock'        = 'brainstem\brainstem_읽기전용'
    'brainstem\brainstem_lock_maturity'        = 'brainstem\brainstem_성숙잠금'
    'brainstem\tunneled_temporary'             = 'brainstem\터널_임시'

    # === limbic (감정) ===
    'limbic\adrenaline_emergency'              = 'limbic\아드레날린_비상'
    'limbic\detect_frustration'                = 'limbic\좌절_감지'
    'limbic\detect_praise'                     = 'limbic\칭찬_감지'
    'limbic\detect_urgency'                    = 'limbic\긴급_감지'
    'limbic\dopamine_reward'                   = 'limbic\도파민_보상'
    'limbic\endorphin_persistence'             = 'limbic\엔도르핀_지속'
    'limbic\strip_emotion_forward_goal'        = 'limbic\감정제거_목표전진'

    # === hippocampus (기억) ===
    'hippocampus\bomb_history'                 = 'hippocampus\bomb_이력'
    'hippocampus\context_restore_from_previous'= 'hippocampus\이전_컨텍스트_복원'
    'hippocampus\context_restore_trigger_keywords' = 'hippocampus\복원_트리거_키워드'
    'hippocampus\dopamine_log'                 = 'hippocampus\도파민_로그'
    'hippocampus\error_patterns'               = 'hippocampus\에러_패턴'
    'hippocampus\ki_auto_reference_on_start'   = 'hippocampus\KI_자동참조_시작시'
    'hippocampus\session_log'                  = 'hippocampus\세션_로그'
    'hippocampus\user_correction_ground_truth' = 'hippocampus\PD교정_절대진실'

    # === sensors\brand ===
    'sensors\brand\design_ref_oura_aesop_apple'   = 'sensors\brand\디자인참조_oura_aesop_apple'
    'sensors\brand\slogan_for_your_wellness'       = 'sensors\brand\슬로건_for_your_wellness'
    'sensors\brand\target_30_50_health_runners'    = 'sensors\brand\타겟_30_50_건강러너'
    'sensors\brand\tone_premium_natural_luxury'    = 'sensors\brand\톤_프리미엄_자연_럭셔리'
    'sensors\brand\vegavery_run_premium_wellness'  = 'sensors\brand\베가베리런_프리미엄_웰니스'

    # === sensors\design ===
    'sensors\design\animation_float_infinite_3s'   = 'sensors\design\애니메이션_부유_무한_3s'
    'sensors\design\animation_glass_pop_08s'       = 'sensors\design\애니메이션_글래스팝_08s'
    'sensors\design\animation_slow_zoom_4s'        = 'sensors\design\애니메이션_슬로우줌_4s'
    'sensors\design\button_rounded_full'           = 'sensors\design\버튼_라운드_풀'
    'sensors\design\color_cool_blue_b6cfdd'        = 'sensors\design\색상_쿨블루_b6cfdd'
    'sensors\design\color_dark_button_1c1c1c'      = 'sensors\design\색상_다크버튼_1c1c1c'
    'sensors\design\color_milk_fefaef'             = 'sensors\design\색상_밀크_fefaef'
    'sensors\design\color_stone_text_4a4741'       = 'sensors\design\색상_스톤텍스트_4a4741'
    'sensors\design\color_warm_beige_eadccf'       = 'sensors\design\색상_웜베이지_eadccf'
    'sensors\design\glassmorphism_blur20'          = 'sensors\design\글래스모피즘_blur20'
    'sensors\design\sandstone_base_f7f1e8'         = 'sensors\design\샌드스톤_베이스_f7f1e8'
    'sensors\design\shadow_subtle_0_2_8_006'       = 'sensors\design\그림자_미세_0_2_8_006'
    'sensors\design\spacing_card_24_32px'          = 'sensors\design\여백_카드_24_32px'

    # === sensors\nas ===
    'sensors\nas\no_powershell_copyitem'            = 'sensors\nas\禁powershell_copyitem'
    'sensors\nas\robocopy_for_large_files'          = 'sensors\nas\推robocopy_대용량'
    'sensors\nas\test_path_before_write'            = 'sensors\nas\쓰기전_경로확인'
    'sensors\nas\write_cmd_copy_only'               = 'sensors\nas\禁PS복사_cmd만'

    # === sensors\nas_brain ===
    'sensors\nas_brain\data_collection_path_z'      = 'sensors\nas_brain\데이터수집_경로Z'
    'sensors\nas_brain\io_nas_reconnect_net_use'    = 'sensors\nas_brain\NAS재연결_net_use'
    'sensors\nas_brain\knowledge_market_path_z'     = 'sensors\nas_brain\지식마켓_경로Z'
    'sensors\nas_brain\path_z_vol1_vgvr_brain_lw'   = 'sensors\nas_brain\경로_Z_VOL1_VGVR_BRAIN'
    'sensors\nas_brain\projects_path_z_omniverse'   = 'sensors\nas_brain\프로젝트_경로Z_옴니버스'
    'sensors\nas_brain\system_docs_path_z'          = 'sensors\nas_brain\시스템문서_경로Z'

    # === sensors\tools ===
    'sensors\tools\local_scraper_clawl_dir'         = 'sensors\tools\로컬스크래퍼_clawl'
    'sensors\tools\n8n_automation_localhost_5678'    = 'sensors\tools\n8n_자동화_5678'
    'sensors\tools\scraper_node_cdp_js'             = 'sensors\tools\스크래퍼_node_CDP'

    # === sensors\typography ===
    'sensors\typography\font_suit_ko_instrument_en' = 'sensors\typography\폰트_Suit한글_Instrument영문'

    # === cortex\backend ===
    'cortex\backend\multi_stage_build'              = 'cortex\backend\멀티스테이지_빌드'
    'cortex\backend\rls_always_on'                  = 'cortex\backend\RLS_항상_활성'

    # === cortex\frontend ===
    'cortex\frontend\accent_blue_3b82f6'            = 'cortex\frontend\강조색_블루_3b82f6'
    'cortex\frontend\comment_every_selector'        = 'cortex\frontend\모든_셀렉터_주석'
    'cortex\frontend\fade_in_up_06s'                = 'cortex\frontend\페이드인업_06s'
    'cortex\frontend\glass_blur20_alpha15'          = 'cortex\frontend\글래스_blur20_alpha15'
    'cortex\frontend\hooks_pattern'                 = 'cortex\frontend\hooks_패턴'
    'cortex\frontend\instrument_serif_italic'       = 'cortex\frontend\Instrument_세리프_이탤릭'
    'cortex\frontend\no_console_log'                = 'cortex\frontend\禁console_log'
    'cortex\frontend\no_emoji_use_svg'              = 'cortex\frontend\禁이모지_SVG사용'
    'cortex\frontend\no_inline_styles'              = 'cortex\frontend\禁인라인스타일'
    'cortex\frontend\output_structured_json'        = 'cortex\frontend\출력_구조화JSON'
    'cortex\frontend\primary_sandstone'             = 'cortex\frontend\기본색_샌드스톤'
    'cortex\frontend\responsive_design'             = 'cortex\frontend\반응형_디자인'
    'cortex\frontend\rounded_50px_dark'             = 'cortex\frontend\라운드_50px_다크'
    'cortex\frontend\section_gap_80_128px'          = 'cortex\frontend\섹션간격_80_128px'
    'cortex\frontend\stagger_100ms'                 = 'cortex\frontend\스태거_100ms'
    'cortex\frontend\suit_400_700'                  = 'cortex\frontend\Suit_400_700'
    'cortex\frontend\禁inline_style'                = 'cortex\frontend\禁인라인스타일_v2'

    # === cortex\methodology ===
    'cortex\methodology\ask_only_when_necessary'    = 'cortex\methodology\필요할때만_질문'
    'cortex\methodology\community_academic_search'  = 'cortex\methodology\커뮤니티_학술검색'
    'cortex\methodology\dictionary_based_matching'  = 'cortex\methodology\사전기반_매칭'
    'cortex\methodology\positive_negative_both'     = 'cortex\methodology\긍정부정_양면검토'
    'cortex\methodology\third_party_audit'          = 'cortex\methodology\제3자_검증'
    'cortex\methodology\two_persona_debate'         = 'cortex\methodology\두_페르소나_토론'

    # === cortex\neuronfs (NeuronFS 자체 메타 — 영어 유지가 혼동 방지!) ===
    # NeuronFS 구조 설명은 영어 원본이 정확도 높음, 한글로 전환
    'cortex\neuronfs\core\counter_is_activation'    = 'cortex\neuronfs\core\카운터가_활성도'
    'cortex\neuronfs\core\depth_is_specificity'     = 'cortex\neuronfs\core\깊이가_구체성'
    'cortex\neuronfs\core\file_is_firing_trace'     = 'cortex\neuronfs\core\파일이_발화기록'
    'cortex\neuronfs\core\folder_is_neuron'         = 'cortex\neuronfs\core\폴더가_뉴런'
    'cortex\neuronfs\core\path_is_sentence'         = 'cortex\neuronfs\core\경로가_문장'
    'cortex\neuronfs\core\permanent_manual'         = 'cortex\neuronfs\core\영구_수동'
    'cortex\neuronfs\core\router_assigned_auto'     = 'cortex\neuronfs\core\라우터_자동배정'
    'cortex\neuronfs\core\server_db_snapshot'       = 'cortex\neuronfs\core\서버DB_스냅샷'

    'cortex\neuronfs\growth\experience_only_division'  = 'cortex\neuronfs\growth\경험만이_분류'
    'cortex\neuronfs\growth\folder_hierarchy_unlimited_depth' = 'cortex\neuronfs\growth\폴더계층_무제한깊이'
    'cortex\neuronfs\growth\myelination_highway'    = 'cortex\neuronfs\growth\수초화_고속경로'
    'cortex\neuronfs\growth\novelty_curiosity_signal'= 'cortex\neuronfs\growth\신기함_호기심_신호'
    'cortex\neuronfs\growth\pruning_dormant'        = 'cortex\neuronfs\growth\가지치기_휴면'
    'cortex\neuronfs\growth\synapse_explosion'      = 'cortex\neuronfs\growth\시냅스_폭증'
    'cortex\neuronfs\growth\time_decay_forgetting'  = 'cortex\neuronfs\growth\시간감쇠_망각'

    'cortex\neuronfs\ownership\brainstem_human_only'   = 'cortex\neuronfs\ownership\brainstem_PD전용'
    'cortex\neuronfs\ownership\cortex_ai_experience'   = 'cortex\neuronfs\ownership\cortex_AI경험'
    'cortex\neuronfs\ownership\ego_human_customize'    = 'cortex\neuronfs\ownership\ego_PD커스텀'
    'cortex\neuronfs\ownership\hippocampus_auto_log'   = 'cortex\neuronfs\ownership\hippocampus_자동로그'
    'cortex\neuronfs\ownership\limbic_system_auto'     = 'cortex\neuronfs\ownership\limbic_자동'
    'cortex\neuronfs\ownership\prefrontal_human_set'   = 'cortex\neuronfs\ownership\prefrontal_PD설정'
    'cortex\neuronfs\ownership\sensors_human_declare'  = 'cortex\neuronfs\ownership\sensors_PD선언'

    'cortex\neuronfs\runtime\compiler_path_to_sentence'= 'cortex\neuronfs\runtime\컴파일러_경로를_문장으로'
    'cortex\neuronfs\runtime\counter_writeback'        = 'cortex\neuronfs\runtime\카운터_쓰기반영'
    'cortex\neuronfs\runtime\injector_to_gemini'       = 'cortex\neuronfs\runtime\인젝터_GEMINI전송'
    'cortex\neuronfs\runtime\scanner_reads_tree'       = 'cortex\neuronfs\runtime\스캐너_트리읽기'

    'cortex\neuronfs\signals\bomb_circuit_breaker'     = 'cortex\neuronfs\signals\bomb_회로차단'
    'cortex\neuronfs\signals\counter_as_filename'      = 'cortex\neuronfs\signals\카운터가_파일명'
    'cortex\neuronfs\signals\dopamine_reinforcement'   = 'cortex\neuronfs\signals\도파민_강화'
    'cortex\neuronfs\signals\dormant_pruning'          = 'cortex\neuronfs\signals\휴면_가지치기'

    'cortex\neuronfs\structure\axon_crosslink'         = 'cortex\neuronfs\structure\축삭_교차연결'
    'cortex\neuronfs\structure\seven_regions'          = 'cortex\neuronfs\structure\7개_영역'
    'cortex\neuronfs\structure\small_world_network'    = 'cortex\neuronfs\structure\소세계_네트워크'
    'cortex\neuronfs\structure\subsumption_priority'   = 'cortex\neuronfs\structure\포섭_우선순위'

    'cortex\neuronfs\wargame\axon_crosslink_14of20'        = 'cortex\neuronfs\wargame\축삭교차_14of20'
    'cortex\neuronfs\wargame\bomb_pain_11of20'             = 'cortex\neuronfs\wargame\bomb_고통_11of20'
    'cortex\neuronfs\wargame\brainstem_conscience_10of20'  = 'cortex\neuronfs\wargame\brainstem_양심_10of20'
    'cortex\neuronfs\wargame\counter_activation_13of20'    = 'cortex\neuronfs\wargame\카운터활성_13of20'
    'cortex\neuronfs\wargame\file_equals_trace_16of20'     = 'cortex\neuronfs\wargame\파일은_trace_16of20'
    'cortex\neuronfs\wargame\folder_equals_neuron_18of20'  = 'cortex\neuronfs\wargame\폴더는_뉴런_18of20'
    'cortex\neuronfs\wargame\router_spotlight_12of20'      = 'cortex\neuronfs\wargame\라우터_스포트라이트_12of20'

    # === cortex\project_management ===
    'cortex\project_management\goal_setting'        = 'cortex\프로젝트관리\목표_설정'
    'cortex\project_management\task_prioritization' = 'cortex\프로젝트관리\작업_우선순위'

    # === cortex\security ===
    'cortex\security\no_plain_text_tokens'          = 'cortex\security\禁평문_토큰'

    # === cortex\skills\supanova ===
    'cortex\skills\supanova\output_skill'           = 'cortex\skills\supanova\출력_스킬'
    'cortex\skills\supanova\redesign_skill'         = 'cortex\skills\supanova\리디자인_스킬'
    'cortex\skills\supanova\soft_skill'             = 'cortex\skills\supanova\소프트_스킬'
    'cortex\skills\supanova\taste_skill'            = 'cortex\skills\supanova\취향_스킬'

    # === cortex\testing ===
    'cortex\testing\always_verify_output'           = 'cortex\testing\항상_출력검증'

    # === ego ===
    'ego\aggressive_rebuild'                        = 'ego\공격적_재구축'
    'ego\community_verified_methods'                = 'ego\커뮤니티_검증방법'
    'ego\conservative_patch'                        = 'ego\보수적_패치'
    'ego\expert_concise'                            = 'ego\전문가_간결'
    'ego\korean_native'                             = 'ego\한국어_네이티브'
    'ego\opus_discover_then_delegate'               = 'ego\발견후_위임'
    'ego\think_in_korean_respond_in_korean'          = 'ego\한국어로_사고하고_응답'
    'ego\transistor_gate_decomposition'             = 'ego\트랜지스터_게이트분해'

    # === prefrontal ===
    'prefrontal\current_sprint'                     = 'prefrontal\현재_스프린트'
    'prefrontal\future_tasks'                       = 'prefrontal\미래_작업'
    'prefrontal\long_term_direction'                = 'prefrontal\장기_방향'
    'prefrontal\project\neuronfs_brain_evolution'   = 'prefrontal\project\NeuronFS_뇌_진화'
    'prefrontal\project\neuronfs_dashboard_integration' = 'prefrontal\project\NeuronFS_대시보드_통합'
    'prefrontal\project\neuronfs_idle_engine'       = 'prefrontal\project\NeuronFS_유휴엔진'
    'prefrontal\project\omniverse_jollyhour_brand'  = 'prefrontal\project\옴니버스_졸리아워_브랜드'
    'prefrontal\project\omniverse_market_research'  = 'prefrontal\project\옴니버스_시장조사'
    'prefrontal\project\omniverse_nugray_brand'     = 'prefrontal\project\옴니버스_누그레이_브랜드'
    'prefrontal\project\omniverse_whitetowel_brand' = 'prefrontal\project\옴니버스_화이트타올_브랜드'
    'prefrontal\project\vegavery_crm_operations'    = 'prefrontal\project\베가베리_CRM_운영'
    'prefrontal\project\video_pipeline_v17'         = 'prefrontal\project\영상파이프라인_v17'
}

$success = 0; $fail = 0; $skip = 0
foreach ($kv in $map.GetEnumerator()) {
    $oldFull = Join-Path $bp $kv.Key
    $newFull = Join-Path $bp $kv.Value

    if (!(Test-Path $oldFull)) { $skip++; continue }
    if (Test-Path $newFull) { echo "SKIP (이미 존재): $($kv.Value)"; $skip++; continue }

    # 대상 부모 디렉토리 생성
    $newParent = Split-Path $newFull -Parent
    if (!(Test-Path $newParent)) { New-Item -ItemType Directory -Path $newParent -Force | Out-Null }

    try {
        Move-Item -Path $oldFull -Destination $newFull -Force
        $success++
    } catch {
        echo "FAIL: $($kv.Key) → $($kv.Value): $($_.Exception.Message)"
        $fail++
    }
}

# 빈 상위 폴더 정리
Get-ChildItem $bp -Directory -Recurse | Where-Object { 
    $_.Name -notmatch '^_' -and (Get-ChildItem $_.FullName -Recurse).Count -eq 0 
} | Remove-Item -Recurse -Force -ErrorAction SilentlyContinue

echo "=== 결과: 성공=$success 실패=$fail 스킵=$skip ==="
