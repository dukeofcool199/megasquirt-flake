{
  description = "a flake for all things megasquirt or something like that";
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    systems.url = "github:nix-systems/default";
    flake-utils = {
      url = "github:numtide/flake-utils";
      inputs.systems.follows = "systems";
    };
    hardware = { url = "github:nixos/nixos-hardware"; };

    generators = {
      url = "github:nix-community/nixos-generators";
      inputs.nixpkgs.follows = "nixpkgs";
    };

  };

  outputs = { nixpkgs, flake-utils, hardware, generators, ... }:
    flake-utils.lib.eachDefaultSystem (system:
      let
        pkgs = nixpkgs.legacyPackages.${system};

        tsdashApp = pkgs.fetchzip {
          url =
            "https://www.efianalytics.com/TSDash/download/TSDash_v0.9.09.02_Beta.zip";
          sha256 = "sha256-GL4III3SPXN28KXPQaPWMU4+kDdwB+Ig/+ABPRpX03g=";
          stripRoot = false;
        };
        tsdashImg = with pkgs;
          stdenv.mkDerivation {
            name = "tsdash-img";
            src = fetchurl {
              url =
                "https://www.efianalytics.com/TSDash/download/2022-10-19_TSDash_Reference.img.gz";
              sha256 = "sha256-u8+VgSJ9scM2PZ1uue8yGafriZAK9oTPXkUoF/icxQ8=";
            };
            nativeBuildInputs = [ gzip ];
            unpackPhase = ''
              mkdir -p $out
              gunzip -c $src > $out/tsdash.img
            '';
          };

        modules = [
          {
            users.users.tuner = {
              name = "tuner";
              isNormalUser = true;
              initialPassword = "tuner";
              enable = true;
              extraGroups = [ "wheel" ];
            };

          }
          {
            environment.systemPackages = with pkgs; [ tsdashAppExe kitty wofi ];
            programs.hyprland.enable = true;
          }
        ];
      in {
        packages = rec {
          tsdashAppExe = pkgs.writeShellApplication {
            name = "TSdash";
            runtimeInputs = [ pkgs.jre8 ];
            text = ''
              cd ${tsdashApp}
              java -jar TSDash.jar
            '';
          };
          vm = generators.nixosGenerate {
            inherit system modules;

            format = "vm";
          };

          tunerstudio = with pkgs;
            stdenv.mkDerivation rec {
              name = "tuner-studio";
              pname = "TunerStudio";
              version = "3.1.08";
              src = fetchTarball {
                url =
                  "https://www.tunerstudio.com/downloads2/TunerStudioMS_v3.2.03.tar.gz";
                sha256 = "1vr7h7hr8sg4jw3xpwhrs090026bpd85pvgvwz1542yiwdsrc5i7";
              };
              buildInputs = [ sd jdk ];
              patchPhase = ''
                sd 'java' '${jdk}/bin/java' ./TunerStudio.sh
              '';
              installPhase = ''
                mkdir -p $out/bin
                cp -r $src/* $out/bin
                mv $out/bin/TunerStudio.sh $out/bin/${pname}
                chmod 777 $out/bin/${pname}
              '';

            };

        };
        devShells.default = pkgs.mkShell {
          packages = with pkgs; [
            run-emulator
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
