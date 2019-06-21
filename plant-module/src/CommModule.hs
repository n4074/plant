-- Copyright 2017-present, Facebook, Inc.
-- All rights reserved.
--
-- This source code is licensed under the license found in the
-- LICENSE file in the root directory of this source tree.

{-# LANGUAGE OverloadedStrings #-}

module CommModule
  ( hsPlantModule
  ) where

import Foreign
import PlantModule
import Crypto.RNG

foreign export ccall "hs_plantModule"
  hsPlantModule :: IO (StablePtr PlantModule)

hsPlantModule :: IO (StablePtr PlantModule)
hsPlantModule = newStablePtr PlantModule
  { someData = "Win2"
  , someFn = myFunction
  }

myFunction :: Int -> IO ()
myFunction i = do
    i <- randInt
    putStrLn $ "Adding to 20: " ++ show (20 + i)


randInt :: IO Int
randInt = do
    rngS <- newCryptoRNGState
    runCryptoRNGT rngS (randomR (0,100))
