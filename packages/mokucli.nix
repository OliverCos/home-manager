{ pkgs, ... }:

# mokucli is a proprietary Liquid Instruments tool shipped as a PyInstaller
# "onedir" bundle (a `mokucli` launcher next to an `_internal/` dir). It expects
# the FHS dynamic loader (/lib64/ld-linux-x86-64.so.2), so we run it inside a
# buildFHSEnv sandbox rather than patchelf-ing the bundle. The Python `moku`
# package shells out to whatever `mokucli` is on PATH.

let
  mokucli-unwrapped = pkgs.stdenvNoCC.mkDerivation {
    pname = "mokucli-unwrapped";
    version = "4.3.0.0";

    src = pkgs.fetchurl {
      url = "https://download.liquidinstruments.com/software/mokucli/linux/mokucli-linux.tar.gz";
      hash = "sha256-FjB+1fFSt8Ua0xeqT1NVNdngOkUrkxSae3g+NXGYeUQ=";
    };

    sourceRoot = ".";
    dontConfigure = true;
    dontBuild = true;
    # Keep the bundle untouched; the FHS env supplies the loader at runtime.
    dontFixup = true;

    installPhase = ''
      runHook preInstall
      mkdir -p $out/opt/mokucli
      cp -r mokucli python-runner _internal $out/opt/mokucli/
      runHook postInstall
    '';
  };

  mokucli = pkgs.buildFHSEnv {
    name = "mokucli";
    runScript = "${mokucli-unwrapped}/opt/mokucli/mokucli";
    targetPkgs = pkgs: with pkgs; [
      zlib
      glib
      stdenv.cc.cc.lib
      libusb1
      openssl
    ];
  };
in
{
  home.packages = [ mokucli ];

  # Make the wrapped binary discoverable by the Python `moku` library.
  home.sessionVariables.MOKU_CLI_PATH = "${mokucli}/bin/mokucli";
}
