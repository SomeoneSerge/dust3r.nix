{
  description = "Description for the project";

  nixConfig = {
    extra-substituters = [
      "https://cuda-maintainers.cachix.org"
    ];
    extra-trusted-public-keys = [
      "cuda-maintainers.cachix.org-1:0dq3bujKpuEPMCX6U4WylrUDZ9JyUG0VpVZa7CNfq5E="
    ];
  };

  inputs = {
    flake-parts.url = "github:hercules-ci/flake-parts";
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
  };

  outputs =
    inputs@{ flake-parts, ... }:
    flake-parts.lib.mkFlake { inherit inputs; } {
      imports = [
        {
          perSystem =
            { system, ... }:
            {
              _module.args.pkgsCuda = import inputs.nixpkgs {
                inherit system;

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
            };
        }
      ];
      systems = [
        "x86_64-linux"
        "aarch64-linux"
        "aarch64-darwin"
        "x86_64-darwin"
      ];
      perSystem =
        {
          config,
          self',
          inputs',
          pkgs,
          pkgsCuda,
          system,
          ...
        }:
        {
          formatter = pkgs.nixfmt-rfc-style;
          legacyPackages = pkgsCuda.python3Packages.callPackage ./packages.nix { };
          packages.default = config.legacyPackages.dust3r;
        };
      flake = {
        overlays.default = final: prev: {
          pythonPackagesExtensions = prev.pythonPackagesExtensions ++ [
            (py-fin: py-pre: { dust3rPackages = py-fin.callPackage ./packages.nix { }; })
          ];
          inherit (final.python3Packages) dust3rPackages;
        };
      };
    };
}
