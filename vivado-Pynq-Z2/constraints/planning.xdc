## Clock and buffer component layout

## Worst-Case Generated Clock Constraints (75 MHz Pixel / 375 MHz TMDS)
## Note: Vivado auto-derives generated clocks from MMCME2_ADV parameters (40 MHz / 200 MHz).
##       To ensure timing closes across ALL programmable DRP modes up to 720p60 (75 MHz / 375 MHz),
##       constrain the MMCM output pins to the fastest programmable frequency:
create_generated_clock -name tmds_clk_max -source [get_pins u_clk_gen/u_mmcm_adv/CLKIN1] \
    -multiply_by 3 [get_pins u_clk_gen/u_mmcm_adv/CLKOUT0]
create_generated_clock -name pixel_clk_max  -source [get_pins u_clk_gen/u_mmcm_adv/CLKIN1] \
    -divide_by 5 -multiply_by 3 [get_pins u_clk_gen/u_mmcm_adv/CLKOUT1]

## Asynchronous CDC & Floorplanning Hints (Bank 34 is in Clock Region X1Y1)
set_false_path -from [get_ports { sw[*] btn[*] }]
set_false_path -to   [get_ports { led[*] }]

## Lock MMCM and BUFGs to the X1Y1 / Top Clock Spine adjacent to Bank 34
set_property LOC MMCME2_ADV_X1Y1 [get_cells u_clk_gen/u_mmcm_adv]
set_property LOC BUFGCTRL_X0Y16  [get_cells u_clk_gen/u_bufg_pixel]
set_property LOC BUFGCTRL_X0Y17  [get_cells u_clk_gen/u_bufg_tmds]

## Keep TMDS encoders in X1Y1 near Bank 34 IOBs so setup/hold into OSERDESE2 is minimal
create_pblock pblock_hdmi_encoders
add_cells_to_pblock [get_pblocks pblock_hdmi_encoders] [get_cells {u_enc_blue u_enc_green u_enc_red}]
resize_pblock [get_pblocks pblock_hdmi_encoders] -add {CLOCKREGION_X1Y1:CLOCKREGION_X1Y1}
