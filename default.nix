let
  _overlay = self: super: {
    haskell = super.haskell // {
      compiler = super.haskell.compiler // {
        ghc844 = (super.haskell.compiler.ghc844.override({
            enableRelocatedStaticLibs = true;
            })).overrideAttrs(_: {
               preConfigure = builtins.trace "ghc" _.preConfigure + ''
                echo wat2
                sleep 100
                cp mk/build.mk /tmp
                rm mk/build.mk
                exit
              '';
            });
      };
      packages = super.haskell.packages // {
        ghc844 = super.haskell.packages.ghc844.override (old: {
          overrides = pkgs.lib.composeExtensions (old.overrides or (_: _: {})) (hself: hsuper: {
            mkDerivation = args: hsuper.mkDerivation (args // {
                configureFlags = builtins.trace "configureFlags" (args.configureFlags or []) ++ ["--ghc-option=-fPIC"];
            });
#hsuper.ghc.overrideAttrs(_: {
#              enableShared = false;
#              preConfigure = builtins.trace "ghc" _.preConfigure + ''
#                echo wat
#                pwd
#                ls
#                sleep 100
#                cp mk/build.mk /tmp
#                rm mk/build.mk
#                exit
#              '';
#
#            }).override({
#              overrides = _:_: { enableRelocatedStaticLibs = true; };
#            });
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
