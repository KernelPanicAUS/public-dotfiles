{pkgs}: {
  pname,
  version,
  url,
  hash,
  useHdiutil ? false,
  ...
} @ args: let
  baseAttrs = {
    inherit pname version;
    src = pkgs.fetchurl {
      inherit url hash;
      curlOptsList = ["-HUser-Agent: Wget/1.21.4" "-HAccept: */*"];
    };
    sourceRoot = ".";
  };

  undmgAttrs =
    baseAttrs
    // {
      buildInputs = with pkgs; [undmg];
      installPhase = ''
        runHook preInstall
        mkdir -p "$out/Applications" "$out/bin"
        cp -r *.app "$out/Applications"
      '';
    };

  hdiutilAttrs =
    baseAttrs
    // {
      preferLocalBuild = true;
      allowSubstitutes = false;
      buildCommand = ''
        mkdir -p $out/Applications

        # Create a temporary mount point
        MOUNT_POINT=$(mktemp -d)

        # Mount the DMG
        /usr/bin/hdiutil attach $src -nobrowse -readonly -mountpoint $MOUNT_POINT

        # Copy the app
        cp -pR $MOUNT_POINT/*.app $out/Applications/

        # Unmount
        /usr/bin/hdiutil detach $MOUNT_POINT -force

        # Cleanup
        rm -rf $MOUNT_POINT
      '';
    };
in
  if useHdiutil
  then pkgs.stdenvNoCC.mkDerivation (hdiutilAttrs // builtins.removeAttrs args ["useHdiutil"])
  else pkgs.stdenv.mkDerivation (undmgAttrs // builtins.removeAttrs args ["useHdiutil"])
