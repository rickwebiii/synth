module Synth where

import Clash.Prelude
import Clash.Explicit.Testbench
import Clash.Explicit.Signal

--import WaveGen
import Counter
import Clash.Prelude
import Clash.Xilinx.ClockGen

createDomain vSystem{vName="Clk12288k", vPeriod=81380}
createDomain vSystem{vName="Clk100M", vPeriod=10000}

topEntity
  :: Clock Clk100M
  -> Clock Clk12288k
  -> Reset Clk100M
  -> Enable Clk100M
  -> Enable Clk12288k
  -> (Signal Clk100M (BitVector 2), Signal Clk12288k (BitVector 2))
topEntity clk100M clk12288k rst100M en100M en12288k = (slice d24 d23 <$> out100M, slice d24 d23 <$> out12288k)
  where
    cntr      = exposeClockResetEnable $ upCounter (pure False) (pure True)
    out100M   = (cntr clk100M rst100M en100M) :: Signal Clk100M (Unsigned 32)
    out12288k = cntr clk12288k rst12288k en12288k :: Signal Clk12288k (Unsigned 32)
    rst12288k = convertReset clk100M clk12288k rst100M

--channel
--  :: HiddenClockResetEnable dom
--  => BitVector 16 -- Seed for random channel
--  -> Signal dom (Unsigned 27)  -- # of ticks to enable l
--  -> Signal dom (BitVector 2)  -- Function
--  -> Signal dom (Unsigned 16)
--channel seed ticks function = wave
--  where
--    nextVal = ticks .<=. upCounter nextVal (pure True)
--    wave = waveGen16 seed nextVal function

--topEntity
--  :: Clock System
--  -> Reset System
--  -> Enable System
--  -> Signal System (Signed 9, Signed 9)
--  -> Signal System (Signed 9)
--topEntity = exposeClockResetEnable pure 0
