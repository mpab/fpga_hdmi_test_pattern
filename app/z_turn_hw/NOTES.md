# Design/Implementation Notes: Z-Turn

# ZYNQ7 Processing System Configuration

- Enable UART 1, MIO 48..49
- Enable I2C 0, connect to IIC_0

# Clock Wizard Configuration

- <https://adaptivesupport.amd.com/s/question/0D52E00006hpjYhSAI/timing4-invalid-clock-redefinition-on-a-clock-tree?language=en_US>
- "invalid primary clock redefinition on a clock tree"
- on clk_wiz_0, change clock input (from ZYNQ7) Source
- "Single ended clock capable pin" -> "No buffer"

# z3660 configuration

- set part part: xc7z020clg400-3

- HDMI clock/timing

```verilog

# ./src/top_HDMI_.v
(* X_INTERFACE_PARAMETER = "FREQ_HZ 148500000" *)
output wire hdmi_clk,

# ./scripts/extend-design.tcl
# create ports
set_property -dict [ list \
CONFIG.FREQ_HZ {148500000} \
] $hdmi_clk
```
