# Program and Refresh the XC7K325T Device
current_hw_device [lindex [get_hw_devices] 1]
refresh_hw_device -update_hw_probes false [lindex [get_hw_devices] 1]
set_property PROGRAM.FILE {bazel-bin/blinkenlights_bitstream.bit} [lindex [get_hw_devices] 1]
#set_property PROBES.FILE {C:/design.ltx} [lindex [get_hw_devices] 0]

program_hw_devices [lindex [get_hw_devices] 1]
refresh_hw_device [lindex [get_hw_devices] 1]
