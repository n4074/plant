-- Copyright 2017-present, Facebook, Inc.
-- All rights reserved.
--
-- This source code is licensed under the license found in the
-- LICENSE file in the root directory of this source tree.
--
{-# OPTIONS_GHC -debug #-}
{-# LANGUAGE RecordWildCards #-}

module Main (main) where

import Control.Concurrent
import Control.Exception
import Control.Monad
import System.Environment

import GHC.Hotswap
import PlantModule

-- | Waits a bit, then does things with data from the shared object
looper :: UpdatableSO PlantModule -> Int -> IO ()
looper so 0 = pure ()
looper so n = do
  -- Sleep for a second
  threadDelay 5000000
  -- Do something with the data
  withSO so $ \PlantModule{..} -> do
    putStrLn $ "someData = " ++ show someData
    someFn 7
  looper so (n - 1)

main :: IO ()
main = do
  args <- getArgs
  so_path <- case args of
    [p] -> return p
    _ -> throwIO (ErrorCall "must give filepath of first .so as an arg")

  -- Register a shared object
  so <- registerHotswap "hs_plantModule" so_path

  -- While doing things in the background, read a filepath for the next shared
  -- object and update it
  bracket (forkIO (looper so 10)) killThread $ \_ -> forever $ do
    putStrLn "Next SO to use: "
    nextSO <- getLine
    so <- registerHotswap "hs_plantModule" nextSO
    forkIO (looper so 10)
