{-# LANGUAGE CPP #-}
{-# LANGUAGE NoRebindableSyntax #-}
{-# OPTIONS_GHC -fno-warn-missing-import-lists #-}
module Paths_ghc_hotswap (
    version,
    getBinDir, getLibDir, getDynLibDir, getDataDir, getLibexecDir,
    getDataFileName, getSysconfDir
  ) where

import qualified Control.Exception as Exception
import Data.Version (Version(..))
import System.Environment (getEnv)
import Prelude

#if defined(VERSION_base)

#if MIN_VERSION_base(4,0,0)
catchIO :: IO a -> (Exception.IOException -> IO a) -> IO a
#else
catchIO :: IO a -> (Exception.Exception -> IO a) -> IO a
#endif

#else
catchIO :: IO a -> (Exception.IOException -> IO a) -> IO a
#endif
catchIO = Exception.catch

version :: Version
version = Version [0,1,0,0] []
bindir, libdir, dynlibdir, datadir, libexecdir, sysconfdir :: FilePath

bindir     = "/Users/carl/.cabal/bin"
libdir     = "/Users/carl/.cabal/lib/x86_64-osx-ghc-8.4.4/ghc-hotswap-0.1.0.0-inplace"
dynlibdir  = "/Users/carl/.cabal/lib/x86_64-osx-ghc-8.4.4"
datadir    = "/Users/carl/.cabal/share/x86_64-osx-ghc-8.4.4/ghc-hotswap-0.1.0.0"
libexecdir = "/Users/carl/.cabal/libexec/x86_64-osx-ghc-8.4.4/ghc-hotswap-0.1.0.0"
sysconfdir = "/Users/carl/.cabal/etc"

getBinDir, getLibDir, getDynLibDir, getDataDir, getLibexecDir, getSysconfDir :: IO FilePath
getBinDir = catchIO (getEnv "ghc_hotswap_bindir") (\_ -> return bindir)
getLibDir = catchIO (getEnv "ghc_hotswap_libdir") (\_ -> return libdir)
getDynLibDir = catchIO (getEnv "ghc_hotswap_dynlibdir") (\_ -> return dynlibdir)
getDataDir = catchIO (getEnv "ghc_hotswap_datadir") (\_ -> return datadir)
getLibexecDir = catchIO (getEnv "ghc_hotswap_libexecdir") (\_ -> return libexecdir)
getSysconfDir = catchIO (getEnv "ghc_hotswap_sysconfdir") (\_ -> return sysconfdir)

getDataFileName :: FilePath -> IO FilePath
getDataFileName name = do
  dir <- getDataDir
  return (dir ++ "/" ++ name)
