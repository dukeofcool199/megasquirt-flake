{
  description = "a flake for all things megasquirt or something like that";
  inputs.nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
  inputs.systems.url = "github:nix-systems/default";
  inputs.flake-utils = {
    url = "github:numtide/flake-utils";
    inputs.systems.follows = "systems";
  };

  outputs = { nixpkgs, flake-utils, ... }:
    flake-utils.lib.eachDefaultSystem (system:
      let
        pkgs = nixpkgs.legacyPackages.${system};

        tsdashApp = pkgs.fetchzip {
          url =
            "https://www.efianalytics.com/TSDash/download/TSDash_v0.9.09.02_Beta.zip";
          sha256 = "sha256-GL4III3SPXN28KXPQaPWMU4+kDdwB+Ig/+ABPRpX03g=";
          stripRoot = false;
        };

        tsdashImg = pkgs.fetchurl {
          url =
            "https://www.efianalytics.com/TSDash/download/2022-10-19_TSDash_Reference.img.gz";
          sha256 = "sha256-u8+VgSJ9scM2PZ1uue8yGafriZAK9oTPXkUoF/icxQ8=";
        };
      in {
        packages = {
          emulator =
            pkgs.callPackage ./emulator/default.nix { img = tsdashImg; };

        };
        devShells.default = pkgs.mkShell {
          packages = with pkgs; [
            bashInteractive
            qemu_full
            virt-manager
            virt-manager-qt
          ];
          shellHook = ''
            rm -rf deps
            mkdir -p deps
            ln -s ${tsdashImg} ./deps/tsdash
            ln -s ${tsdashApp} ./deps/tsdash-app
          '';
        };
      });
}
