# Connect to the Digilent Cable on localhost:3121
open_hw_manager
connect_hw_server -url localhost:3121
current_hw_target [get_hw_targets]
open_hw_target

