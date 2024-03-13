{ lib, pythonPackages }:

lib.makeScope pythonPackages.newScope (
  self:
  {
    dust3r = self.callPackage ./package.nix { };
    pythonWithDust3r = self.callPackage (
      {
        python,
        dust3r,
        co3d,
      }:
      python.withPackages (_: [
        dust3r
        co3d
      ])
    ) { };
    pretrained = self.callPackage (
      {
        dust3r,
        runCommand,
        makeWrapper,
        weights,
      }:
      runCommand "pretrained-dust3r" { nativeBuildInputs = [ makeWrapper ]; } ''
        mkdir $out/bin -p
        makeWrapper "${lib.getExe' dust3r "dust3r-demo"}" "$out/bin/pretrained-dust3r" \
          --add-flags --weights=${weights.vit-large-base-dec-512-dpt}
      ''
    ) { };
  }
  // lib.packagesFromDirectoryRecursive {
    inherit (self) callPackage;
    directory = ./nix;
  }
)
