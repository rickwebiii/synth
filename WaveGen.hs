module WaveGen where

import Clash.Prelude
import Clash.Explicit.Testbench

import Counter

-- A 2:1 mux for combinational logic
muxComb s a b
  | s == low = a
  | s == high = b

squareWave val = unpack $ signExtend $ pack $ msb val

triangleWave val = out
  where
    out = muxComb (msb val) valTimes2 (complement valTimes2)
    valTimes2 = shiftL val 1

sawWave val = val

lfsrF' :: BitVector 16 -> BitVector 16
lfsrF' s = pack feedback ++# slice d15 d1 s
  where
      feedback = s!5 `xor` s!3 `xor` s!2 `xor` s!0

lfsrF
  :: HiddenClockResetEnable dom
  => BitVector 16
  -> Signal dom (BitVector 16)
lfsrF seed = r
  where r = register seed (lfsrF' <$> r)

waveGen16
  :: HiddenClockResetEnable dom
  => BitVector 16
  -> Signal dom (Bool)
  -> Signal dom (BitVector 2)
  -> Signal dom (Unsigned 16)
waveGen16 seed nextSample function = fOut
  where
    fOut = mux ((== 1) . (!1) <$> function) squareTri sawNoise
    squareTri = mux ((== 1) . (!0) <$> function) (squareWave <$> counter) (triangleWave <$> counter)
    sawNoise = mux ((== 1) . (!0) <$> function) (sawWave <$> counter) (unpack <$> lfsrF (seed :: BitVector 16))
    counter = register 0 $ mux nextSample (counter + 1) counter

--- Tests

testWaveGen16
  :: Clock System
  -> Reset System
  -> Enable System
  -> BitVector 16
  -> Signal System (Bool)
  -> Signal System (BitVector 2)
  -> Signal System (Unsigned 16)
testWaveGen16 = exposeClockResetEnable waveGen16

testBenchWaveGen16
  :: KnownNat n
  => Vec n Bool
  -> Vec n (BitVector 2)
  -> Vec n (Unsigned 16)
  -> Signal System Bool
testBenchWaveGen16 nextSample function expected = done
  where
    testNextSample = stimuliGenerator clk rst $ nextSample
    testSelect     = stimuliGenerator clk rst $ function
    expectOutput   = outputVerifier' clk rst $ expected
    done           = expectOutput (testWaveGen16 clk rst en 0x7654 testNextSample testSelect)
    en             = enableGen
    clk            = tbSystemClockGen (not <$> done)
    rst            = systemResetGen

testGeneratesSquareWave = sampleN 10 $ testBenchWaveGen16 nextSample function expected
  where
    nextSample = replicate (SNat :: SNat 65535) True
    function = replicate (SNat :: SNat 65535) 0b11
    expected = fmap testSquare $ iterate (SNat :: SNat 65535) (+1) 0

testGeneratesTriangleWave = sampleN 10 $ testBenchWaveGen16 nextSample function expected
  where
    nextSample = replicate (SNat :: SNat 65535) True
    function = replicate (SNat :: SNat 65535) 0b01
    expected = iterate (SNat :: SNat 65535) (+1) 0

testGeneratesSawWave = sampleN 10 $ testBenchWaveGen16 nextSample function expected
  where
    nextSample = replicate (SNat :: SNat 65535) True
    function = replicate (SNat :: SNat 65535) 0b10
    expected = iterate (SNat :: SNat 65535) (+2) 0

testSquare x
  | x < 0x7FFF  = 0
  | x >= 0x8000 = 0xFFFF
