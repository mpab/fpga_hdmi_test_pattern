variable THIS_DIR [file normalize [info script]]
set ENV_FP "[file dirname [file dirname [file dirname $THIS_DIR]]]/xilinx_env.tcl"
source "${ENV_FP}"
set_param general.maxThreads 8

open_project "${VIVADO_PROJECT_FOLDER}/${VIVADO_PROJECT_SLUG}.xpr"

# Ensure source/module changes are integrated
set ip_list [get_ips]
puts $ip_list
update_module_reference $ip_list

# Run Synthesis
reset_run synth_1
launch_runs synth_1 -jobs 4
wait_on_run synth_1

# Run Implementation and generate the bitstream
launch_runs ${VIVADO_IMPL} -jobs 4
wait_on_run ${VIVADO_IMPL}
launch_runs ${VIVADO_IMPL} -to_step write_bitstream -jobs 4
wait_on_run ${VIVADO_IMPL}

# Export xsa
write_hw_platform -fixed -include_bit -force -file "${XSA_FILEPATH}"
