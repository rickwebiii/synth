load(
  "@fpga_rules//vivado:rules.bzl",
  "fpga_bitstream"
)
load(
  "@fpga_rules//clash:rules.bzl",
  "clash_to_vhdl"
)


fpga_bitstream(
  name = "synth",
  srcs = [
    ":synth_clash",
    "Dom12288.xci",
    "Dom12288.v",
    "Dom12288_clk_wiz.v",
    "DOM100M.xci",
    "DOM100M.v",
    "DOM100M_clk_wiz.v"
  ],
  part = "xc7z020clg400-1",
  constraints = [
    "const.xdc",
    "DOM100M.xdc",
    "Dom12288.xdc"
  ],
  topEntity = "topEntity",
  optimize = False
)

clash_to_vhdl(
  name = "synth_clash",
  srcs = [
    "Synth.hs",
    "Counter.hs"
  ],
  outputs = [
    "vhdl/Synth/topentity.vhdl",
    "vhdl/Synth/synth_types.vhdl"
  ],
  top_entity = "Synth.hs"
)
