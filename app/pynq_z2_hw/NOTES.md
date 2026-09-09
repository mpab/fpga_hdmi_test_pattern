# Design/Implementation Notes: Pynq-Z2

# ZYNQ7 Processing System Configuration

# Clock Wizard Configuration

- <https://adaptivesupport.amd.com/s/question/0D52E00006hpjYhSAI/timing4-invalid-clock-redefinition-on-a-clock-tree?language=en_US>
- "invalid primary clock redefinition on a clock tree"
- on clk_wiz_0, change clock input (from ZYNQ7) Source
- "Single ended clock capable pin" -> "No buffer"