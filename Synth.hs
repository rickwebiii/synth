module BlinkenLights where

import Clash.Prelude
import Clash.Explicit.Testbench

upCounter32
  :: HiddenClockResetEnable dom
  => Signal dom (BitVector 4)
upCounter32 = (pack . slice d29 d26) <$> s
  where
    s = register (0 :: Unsigned 32) (s + 1)

topEntity
  :: Clock System
  -> Reset System
  -> Enable System
  -> Signal System (BitVector 4)
topEntity = exposeClockResetEnable upCounter32
