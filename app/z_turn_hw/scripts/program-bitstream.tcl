# TODO: check if this still works when multipl targets are connected

open_project "${VIVADO_PROJECT_FOLDER}/${VIVADO_PROJECT_SLUG}.xpr"
set_param general.maxThreads 8

# directory location
set this_project_dir [get_property DIRECTORY [current_project]]
set this_project_name [current_project]
set bitstream_filepath "${this_project_dir}/${this_project_name}.runs/${VIVADO_IMPL}/${VIVADO_DESIGN_WRAPPER_SLUG}.bit"

open_hw_manager
connect_hw_server
current_hw_target
open_hw_target
set_property PROGRAM.FILE "$bitstream_filepath" [current_hw_device]
program_hw_devices [current_hw_device]
