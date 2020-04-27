load("@bazel_tools//tools/build_defs/repo:git.bzl", "git_repository")

git_repository(
  name = "fpga_rules",
  remote = "https://github.com/rickwebiii/bazel_fpga_rules",
  branch = "master"
)

load("@fpga_rules//clash:rules.bzl", "load_clash_deps")

load_clash_deps()

