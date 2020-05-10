load(
  "@fpga_rules//vivado:rules.bzl",
  "fpga_bitstream",
  "run_tcl_template"
)
load(
  "@fpga_rules//clash:rules.bzl",
  "clash_to_vhdl"
)

run_tcl_template(
  name = "clockgen",
  build_template = "clockGen.tcl",
  outs = [
    "ip/clocks/clocks.v",
    "ip/clocks/clocks_clk_wiz.v",
    "ip/clocks/clocks.xci"
  ]
)

fpga_bitstream(
  name = "synth",
  srcs = [
    ":synth_clash",
    ":clockgen",
    "synthWrapper.vhd"
  ],
  part = "xc7z020clg400-1",
  constraints = [
    "const.xdc",
  ],
  topEntity = "synthWrapper",
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
