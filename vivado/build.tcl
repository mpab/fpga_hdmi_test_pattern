# set standard vars
source [file dirname [info script]]/_env.tcl

open_project "${MB_VIVADO_XPR_FP}"

# Run Synthesis
reset_run synth_1
launch_runs synth_1 -jobs ${NUM_JOBS}
wait_on_run synth_1

# Generate bitstream
reset_run impl_1
launch_runs impl_1 -to_step write_bitstream -jobs ${NUM_JOBS}
wait_on_run impl_1

# Export xsa
write_hw_platform -fixed -include_bit -force -file "${MB_VIVADO_XSA_FP}"
