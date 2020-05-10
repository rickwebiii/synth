library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use work.all;
use work.synth_types.all;

entity synthWrapper is
  port(
    clk_system: in std_logic;
    result_0: out std_logic_vector(1 downto 0);
    result_1: out std_logic_vector(1 downto 0)
  );
end;

architecture structural of synthWrapper is
  signal clk_100M    : std_logic;
  signal clk_12288k  : std_logic;
  signal pll_locked  : std_logic_vector(0 downto 0);
  signal reset       : std_logic;

  component clocks
    port(
      clk_out1: out std_logic;
      clk_out2: out std_logic;
      reset   : in std_logic;
      locked  : out std_logic;
      clk_in1 : in std_logic
    );
  end component;

  component topEntity
    port(
      \clk100M\  : in synth_types.clk_clk100M;
      clk12288k  : in synth_types.clk_clk12288k;
      \rst100M\  : in synth_types.rst_clk100m;
      \en100M\   : in boolean;
      en12288k   : in boolean;
      result_0   : out std_logic_vector(1 downto 0);
      result_1   : out std_logic_vector(1 downto 0)
    );
  end component;

begin

  clock_pll: clocks port map(
    clk_out1   => clk_100M,
    clk_out2   => clk_12288k,
    reset      => reset,
    locked     => pll_locked(0),
    clk_in1    => clk_system
  );

  top: topEntity port map(
    \clk100M\ => clk_100M,
    clk12288k => clk_12288k,
    \rst100M\ => reset,
    \en100M\  => synth_types.fromSLV(pll_locked),
    en12288k  => synth_types.fromSLV(pll_locked),
    result_0  => result_0,
    result_1  => result_1
  );

  reset <= '0';
end;
