load(
  "@fpga_rules//vivado:rules.bzl",
  "fpga_bitstream"
)
load(
  "@fpga_rules//clash:rules.bzl",
  "clash_to_verilog"
)


fpga_bitstream(
  name = "synth",
  srcs = [
    ":synth_clash"
  ],
  part = "xc7z020clg400-1",
  constraints = [
    "const.xdc"
  ],
  topEntity = "topEntity",
  optimize = True
)

clash_to_verilog(
  name = "synth_clash",
  srcs = [
    "Synth.hs"
  ],
  outputs = [
    "verilog/BlinkenLights/topEntity.v"
  ],
  top_entity = "Synth.hs"
)
