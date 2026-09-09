# directory location
set this_project_dir [get_property DIRECTORY [current_project]]
set this_project_name [current_project]

open_bd_design ${this_project_dir}/${this_project_name}.srcs/sources_1/bd/design_1/design_1.bd

# create pins
# create_bd_pin -dir O hdmi_de
# create_bd_pin -dir O -from 15 -to 0 hdmi_data
# create_bd_pin -dir O hdmi_hs
# create_bd_pin -dir O hdmi_vs
# create_bd_pin -dir O -type clk hdmi_clk
# ?? create_bd_pin -dir I -type clk vid_clk
# create_bd_pin -dir I -from 0 -to 0 hdmi_intn


# create ports
set hdmi_de [ create_bd_port -dir O hdmi_de ]
set hdmi_data [ create_bd_port -dir O -from 15 -to 0 -type data hdmi_data ]
set hdmi_hs [ create_bd_port -dir O hdmi_hs ]
set hdmi_vs [ create_bd_port -dir O hdmi_vs ]
set hdmi_clk [ create_bd_port -dir O -type clk hdmi_clk ]
set_property -dict [ list \
CONFIG.FREQ_HZ {148500000} \
] $hdmi_clk
set hdmi_intn [ create_bd_port -dir I -from 0 -to 0 hdmi_intn ]

# add clock wizard and configure
set clk_wiz_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:clk_wiz:6.0 clk_wiz_0 ]
set_property -dict [list \
  CONFIG.CLKOUT1_JITTER {125.247} \
  CONFIG.CLKOUT1_REQUESTED_OUT_FREQ {125.000} \
  CONFIG.MMCM_CLKOUT0_DIVIDE_F {8.000} \
  CONFIG.PRIM_SOURCE {No_buffer} \
  CONFIG.RESET_PORT {resetn} \
  CONFIG.RESET_TYPE {ACTIVE_LOW} \
] $clk_wiz_0

# add top_HDMI_.v
create_bd_cell -type module -reference top_HDMI_ top_HDMI_0

# wire up clock wizard - reset and clk from processing_system7_0, and 125MHz clock to top_HDMI_.v
connect_bd_net [get_bd_pins processing_system7_0/FCLK_RESET0_N] [get_bd_pins clk_wiz_0/resetn]
connect_bd_net [get_bd_pins processing_system7_0/FCLK_CLK0] [get_bd_pins clk_wiz_0/clk_in1]
connect_bd_net [get_bd_pins clk_wiz_0/clk_out1] [get_bd_pins top_HDMI_0/sysclk]

# wire up top_HDMI_.v
connect_bd_net -net top_HDMI_0_hdmi_de [get_bd_pins top_HDMI_0/hdmi_de] [get_bd_ports hdmi_de]
connect_bd_net -net top_HDMI_0_hdmi_data [get_bd_pins top_HDMI_0/hdmi_data] [get_bd_ports hdmi_data]
connect_bd_net -net top_HDMI_0_hdmi_hs [get_bd_pins top_HDMI_0/hdmi_hs] [get_bd_ports hdmi_hs]
connect_bd_net -net top_HDMI_0_hdmi_vs [get_bd_pins top_HDMI_0/hdmi_vs] [get_bd_ports hdmi_vs]
connect_bd_net -net top_HDMI_0_hdmi_clk [get_bd_pins top_HDMI_0/hdmi_clk] [get_bd_ports hdmi_clk]
connect_bd_net -net top_HDMI_0_hdmi_intn [get_bd_pins top_HDMI_0/hdmi_intn] [get_bd_ports hdmi_intn]

save_bd_design
