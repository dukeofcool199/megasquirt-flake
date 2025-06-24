{ pkgs, img }:

pkgs.writeShellApplication {
  name = "run-pi-emulator";

  runtimeEnv = {
    KERNEL = pkgs.fetchurl {
      url =
        "https://github.com/dhruvvyas90/qemu-rpi-kernel/raw/refs/heads/master/kernel-qemu-4.14.79-stretch";
      hash = "sha256-xe1yRuai7cg2fB2YKu2TKysRY1F+MqeSP1xTbxqibmA=";
    };
    DTB = pkgs.fetchurl {
      url =
        "https://github.com/dhruvvyas90/qemu-rpi-kernel/raw/refs/heads/master/native-emulation/dtbs/bcm2711-rpi-4-b.dtb";
      hash = "sha256-eIvg6uyim1MExjmKwxEWnJKhXWBNpTFmeODR/BWJnfg=";
    };
    DRIVE = img;

  };
  runtimeInputs = with pkgs; [ qemu_full ];
  text = builtins.readFile ./run.sh;

}

