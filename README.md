# ats-pkg

This is a build system for ATS written in Haskell and configured with Dhall.

## Example

To build a binary package from source, run

```bash
 $ atspkg remote https://github.com/vmchale/polyglot/archive/0.3.34.tar.gz
```

## Installation

The easiest way to install is via a script, viz.

```bash
 $ curl -sSl https://raw.githubusercontent.com/vmchale/atspkg/master/bash/install.sh | bash -s
```

Alternately, you can download
[Cabal](https://www.haskell.org/cabal/download.html) and
[GHC](https://www.haskell.org/ghc/download.html) and install with

```bash
 $ cabal new-install ats-pkg --symlink-bindir ~/.local/bin
```
