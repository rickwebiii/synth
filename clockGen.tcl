create_project -in_memory

file mkdir {BASE_DIR}/ip

set_part xc7z020clg400-1

create_ip -force -name clk_wiz -vendor xilinx.com -library ip -version 6.0 -module_name clocks -dir {BASE_DIR}/ip
set_property -dict [list\
  CONFIG.CLK_IN1_BOARD_INTERFACE {sys_clock}\
  CONFIG.CLKOUT2_USED {true}\
  CONFIG.CLKOUT2_REQUESTED_OUT_FREQ {12.288}\
  CONFIG.PRIM_IN_FREQ {125.000}\
  CONFIG.CLKIN1_JITTER_PS {80.0}\
  CONFIG.MMCM_DIVCLK_DIVIDE {5}\
  CONFIG.MMCM_CLKFBOUT_MULT_F {29.000}\
  CONFIG.MMCM_CLKIN1_PERIOD {8.000}\
  CONFIG.MMCM_CLKIN2_PERIOD {10.0}\
  CONFIG.MMCM_CLKOUT0_DIVIDE_F {7.250}\
  CONFIG.MMCM_CLKOUT1_DIVIDE {59}\
  CONFIG.NUM_OUT_CLKS {2}\
  CONFIG.CLKOUT1_JITTER {283.516}\
  CONFIG.CLKOUT1_PHASE_ERROR {293.530}\
  CONFIG.CLKOUT2_JITTER {425.475}\
  CONFIG.CLKOUT2_PHASE_ERROR {293.530}\
] [get_ips clocks]

#generate_target {instantiation_template} [get_ips clocks]

generate_target -force all [get_ips clocks]

synth_ip -force [get_ips clocks]

export_ip_user_files -of_objects [get_ips clocks] -no_script -sync -force -quiet
