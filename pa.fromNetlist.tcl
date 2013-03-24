
# PlanAhead Launch Script for Post-Synthesis pin planning, created by Project Navigator

create_project -name ponggame -dir "C:/project/ponggame/planAhead_run_1" -part xc3s500efg320-5
set_property design_mode GateLvl [get_property srcset [current_run -impl]]
set_property edif_top_file "C:/project/ponggame/ponggame.ngc" [ get_property srcset [ current_run ] ]
add_files -norecurse { {C:/project/ponggame} }
set_param project.pinAheadLayout  yes
set_property target_constrs_file "ponggame.ucf" [current_fileset -constrset]
add_files [list {ponggame.ucf}] -fileset [get_property constrset [current_run]]
link_design
