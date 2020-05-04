module ClockDivider where

import Clash.Prelude

import Counter

-- Emits a full output clock period every 2 * ticks base clock cycles
clockDivider
  :: (HiddenClockResetEnable dom, KnownNat n)
  => Unsigned n
  -> Signal dom Bit
clockDivider ticks = outClk
  where
    counter = upCounter reset (pure False)
    reset = (== ticks) <$> counter
    outClk = register 0 $ mux reset (complement <$> outClk) outClk
