module Synth where

import Clash.Prelude
import Clash.Explicit.Testbench
import Clash.Explicit.Signal

--import WaveGen
import Counter
import Clash.Xilinx.ClockGen

createDomain vSystem{vName="Clk12288k", vPeriod=81380}
createDomain vSystem{vName="Clk100M", vPeriod=10000}

topEntity
  :: Clock System
  -> Reset System
  -> Enable System
--  -> (Signal Clk100M (BitVector 2), Signal Clk12288k (BitVector 2))
  -> (Signal Clk12288k (BitVector 2), Signal Clk12288k (BitVector 2))
topEntity clk rst en = (out12288k, out12288k)
  where
    (clk12288k, en12288k) = clockWizard @System @Clk12288k (SSymbol @"Dom12288") clk rst
    --(clk100M, en100M)     = clockWizard @System @Clk100M (SSymbol @"DOM100M") clk rst
    cntr                  = exposeClockResetEnable $ upCounter (pure False) (pure True)
    --out100M               = cntr clk100M rst100M en100M
    out12288k             = cntr clk12288k rst12288k en12288k
    rst12288k             = convertReset clk clk12288k rst
    --rst100M               = convertReset clk clk100M rst

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
