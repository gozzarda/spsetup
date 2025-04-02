{
  pkgs,
  lib,
  modulesPath,
  ...
}:

{
  system.stateVersion = "24.05";

  nixpkgs.config = {
    allowUnfreePredicate =
      pkg:
      builtins.elem (lib.getName pkg) [
        "sublimetext4"
        "vscode"
      ];
    permittedInsecurePackages = [ "openssl-1.1.1w" ];
  };

  # basic hardware support
  imports = [ "${modulesPath}/profiles/all-hardware.nix" ];
  hardware.cpu.amd.updateMicrocode = true;
  hardware.cpu.intel.updateMicrocode = true;
  # services.xserver.videoDrivers = [
  #   "intel"
  #   "amdgpu"
  #   "nvidia"
  #   "modesetting"
  #   "fbdev"
  # ];

  # Opt out of `useradd`.
  users.mutableUsers = false;

  security.sudo = {
    execWheelOnly = true;
    extraConfig = "Defaults lecture = never";
  };

  users.users = {
    root = {
      # hashedPassword = ""; # TODO: gen via `mkpasswd`
      password = "admin";
    };

    team = {
      password = "team";
      isNormalUser = true;
      uid = 1000; # provide uid for determinism
    };

    admin = {
      # hashedPassword = ""; # TODO: gen via `mkpasswd`
      password = "admin";
      extraGroups = [
        "wheel"
        "networkmanager"
      ];
      isNormalUser = true;
      uid = 1001;
    };
  };

  time.timeZone = "Australia/Perth"; # TODO

  # Some basic good defaults:
  boot.initrd.systemd.enable = true;
  boot.tmp.useTmpfs = true;
  boot.kernelPackages = pkgs.linuxKernel.packages.linux_6_12; # latest lts
  zramSwap.enable = true;
  # programs.nix-ld.enable = true; # TODO: enable if running arbitrary binaries is necessary.
  boot.kernelParams = [ "console=tty0" ];
  hardware.graphics.enable = true;

  nix.settings = {
    trusted-users = [ "@wheel" ];
    experimental-features = [
      "nix-command"
      "flakes"
    ];

    # auto gc when there's less than 100MiB available
    # freeing up to 1GiB of space.
    min-free = 100 * 1024 * 1024;
    max-free = 1024 * 1024 * 1024;
  };

  # Networking things:
  networking.hostName = "spcp";
  networking.networkmanager.enable = true;
  networking.nameservers = [
    "1.1.1.1"
    "8.8.8.8"
  ];

  networking.hosts = {
    "170.64.169.12" = [ "sppcontests.org" ];
    "170.64.253.143" = [ "contest.sppcontests.org" ];
  };

  # common pain point: https://github.com/NixOS/nixpkgs/issues/180175
  systemd.services.NetworkManager-wait-online.serviceConfig.ExecStart = [
    ""
    "${pkgs.networkmanager}/bin/nm-online -q"
  ];
  systemd.network.wait-online.enable = false;

  # disable the standard nixos incoming firewall
  networking.firewall.enable = false;

  # use our own rules
  networking.nftables = {
    enable = true;
    rulesetFile = ./firewall.nft;
  };

  # desktop environment
  services.xserver.desktopManager.gnome.enable = true;
  services.xserver.displayManager.gdm.enable = true;
  services.displayManager.autoLogin = {
    enable = true;
    user = "team";
  };
  services.libinput.enable = true;
  services.printing.enable = true;

  hardware.pulseaudio.enable = false;
  services.pipewire = {
    enable = true;
    audio.enable = true;
    alsa.enable = true;
    pulse.enable = true;
  };
  security.rtkit.enable = true;

  # tools
  programs.firefox = {
    enable = true;
    policies = {
      # https://mozilla.github.io/policy-templates
      Homepage = {
        URL = "http://contest.sppcontests.org";
        Locked = true;
      };
    };
  };

  programs.chromium = {
    enable = true;
    homepageLocation = "http://contest.sppcontests.org";
  };

  environment.systemPackages = with pkgs; [
    hyperfine
    man-pages
    p7zip
    sysstat
    zip
    htop
    btop
    wget

    neovim
    vim
    emacs
    sublime4
    vscode
    python3Full # includes idle
    gedit
    geany

    clang
    gcc # TODO: which version?
    zulu11
    pypy3
  ];

  services.nixseparatedebuginfod.enable = true;

  programs.git.enable = true;

}
