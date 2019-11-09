# plant

GHC-Hotswap is a library for dynamic code loading in Haskell. The Haskell runtime system has support for loading object files, and the GHC-Hotswap library provides a mechanism for safely loading and reloading code in a running system while ensuring that unloaded data can be garbage collected. The intended use case is for long-running services with code parts which need to be frequently updated, and for which compiling and deploying an entire new service binary is too expensive.

This repository is an investigation of whether GHC-Hotswap could be used for dynamic code loading in a small agent binary. There are several obstacles to this use case:

* Any dependencies of the dynamic code need to be compiled and loaded separately... Ideally, there would be a mechanism for statically compiling and linking some code with it's dependencies into an object file to be loaded dynamically.. there's no apparent way to achieve this with GHC (it's admittedly a pretty strange use case)
* The recommendation when using GHC-Hotswap is to compile your service (or agent in our use case) with `--f-whole-archive-hs-libs` to solve the above issue with dependencies. This ensures that all code from all Haskell libraries is exposed in the final binary, regardless of whether it is actually used (because it might be used by dynamic code loaded later). This results in very large binaries, and only solves the issue for dependencies which are known in advance.

Essentially, the result of this investigation was that Haskell doesn't have the right tools to achieve the goal of dynamically loading arbitrary code into a small binary.