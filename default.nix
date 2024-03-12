with import <nixpkgs> {
  # "Non-commercial" considered unfree
  config.allowUnfreePredicate =
    p:
    builtins.elem p.meta.license.shortName [
      "cc-by-nc-40"
      "cc-by-nc-sa-40"
      "CUDA EULA"
      "cuDNN EULA"
    ];
  config.cudaSupport = true;
  config.cudaCapabilities = [
    "7.0"
    "8.0"
    "8.6"
  ];
  config.cudaEnableForwardCompat = false;
};
lib.makeScope python3Packages.newScope (
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
