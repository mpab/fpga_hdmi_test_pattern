set this_project_dir [get_property DIRECTORY [current_project]]
set this_project_name [current_project]

make_wrapper -files [get_files ${this_project_dir}/${this_project_name}.srcs/sources_1/bd/design_1/design_1.bd] -top
add_files -norecurse ${this_project_dir}/${this_project_name}.gen/sources_1/bd/design_1/hdl/design_1_wrapper.v
