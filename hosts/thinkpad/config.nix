{
  pkgs,
  username,
  ...
}: {
  imports = [
    ./hardware.nix
    ../../modules
  ];

  # modules
  modules = {
    core = {
      bluetooth.enable = true;
      printing.enable = true;
      sound.enable = true;
      networking.enable = true;
    };
    programs = {
      thunar.enable = true;
      discord.enable = true;
      steam.enable = false;
      hyprland.enable = true;
      minecraft.enable = false;
      appimages.enable = false;
    };
    styles = {
      stylix.enable = true;
      fonts.enable = true;
    };
    dm.sddm.enable = true;
  };
  vm.guest-services.enable = false;
  local.hardware-clock.enable = false;
  drivers = {
    intel.enable = true;
    amdgpu.enable = false;
    nvidia.enable = false;
    nvidia-prime = {
      enable = false;
      intelBusID = "";
      nvidiaBusID = "";
    };
  };

  swapDevices = [
    {
      device = "/swapfile";
      size = 4 * 1024; # 4GB
    }
  ];

  time.timeZone = "Asia/Kolkata";
  hardware.logitech.wireless.enable = true;

  programs = {
    java.enable = true;
    noisetorch.enable = true;
  };

  # environment.systemPackages = with pkgs; [ ];

  users.users = {
    "${username}" = {
      homeMode = "755";
      isNormalUser = true;
      description = "${username}";
      extraGroups = [
        "networkmanager"
        "wheel"
        "libvirtd"
        "scanner"
        "lp"
      ];
      shell = pkgs.bash;
      ignoreShellProgramCheck = true;
      packages = with pkgs; [];
    };
  };
}
