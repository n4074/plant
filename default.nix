let
  _overlay = self: super: {
    haskell = super.haskell // {
      compiler = super.haskell.compiler // {
        ghc844 = (super.haskell.compiler.ghc844
          .override({
            enableRelocatedStaticLibs = true;
#            enableIntegerSimple = true;
          }))
          .overrideAttrs(_: {
            # not necessary but leaving here as an example
            preConfigure = builtins.trace "preConf" _.preConfigure + ''
              pwd
              '';
          });
      };
      packages = super.haskell.packages // {
        ghc844 = super.haskell.packages.ghc844.override (old: {
          overrides = pkgs.lib.composeExtensions (old.overrides or (_: _: {})) (hself: hsuper: {
            mkDerivation = args: hsuper.mkDerivation (args // {
                configureFlags = (args.configureFlags or []) ++ ["--ghc-option=-fPIC"];
            });
         });
        });
      };
    };
  };
  pkgs = import <nixpkgs> { overlays = [ _overlay ]; };

in 
pkgs.haskell.packages.ghc844.extend (
  pkgs.haskell.lib.packageSourceOverrides {
    plant-core = ./plant-core;
    plant-module = ./plant-module;
    ghc-hotswap = ./ghc-hotswap;
  }
)
