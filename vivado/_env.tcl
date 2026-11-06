source "[file dirname [file dirname [info script]]]/env.tcl"

set NUM_JOBS 32
set_param general.maxThreads ${NUM_JOBS}
