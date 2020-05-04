module I2s

import Clash.Prelude

-- Define a clock domain with 12.288Mhz
createDomain vSystem{vName = "AudioMClk", vPeriod = 8138}

data I2sTx dom = T2sTx {
  txEnable :: Signal dom Bit,
   
}
