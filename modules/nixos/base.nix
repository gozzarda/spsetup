{ flake, ... }:

{
  pkgs,
  modulesPath,
  lib,
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
    wheelNeedsPassword = false;
    extraConfig = "Defaults lecture = never";
  };

  users.users = {
    root = {
      hashedPassword = "$y$j9T$s66mNSUxB3hgkFT07I3r5/$ke1ga.qcfuAxTtOlY24vnR5NPkNESOIqKgUO2Rt7YxB";
    };

    team = {
      password = "team";
      isNormalUser = true;
      uid = 1000; # provide uid for determinism
    };

    admin = {
      hashedPassword = "$y$j9T$s66mNSUxB3hgkFT07I3r5/$ke1ga.qcfuAxTtOlY24vnR5NPkNESOIqKgUO2Rt7YxB";
      extraGroups = [
        "wheel"
        "networkmanager"
      ];
      isNormalUser = true;
      uid = 1001;
    };
  };

  time.timeZone = "Australia/Perth"; # TODO: is this correct?
  # services.automatic-timezoned.enable = true;

  # Some basic good defaults:
  boot.initrd.systemd.enable = true;
  boot.tmp.useTmpfs = true;
  boot.kernelPackages = pkgs.linuxKernel.packages.linux_6_12; # latest lts
  zramSwap.enable = true;
  boot.kernelParams = [ "console=tty0" ];
  hardware.graphics.enable = true;

  nix.enable = false;
  # nix.settings = {
  #   trusted-users = [ "@wheel" ];
  #   experimental-features = [
  #     "nix-command"
  #     "flakes"
  #   ];

  #   # auto gc when there's less than 100MiB available
  #   # freeing up to 1GiB of space.
  #   min-free = 100 * 1024 * 1024;
  #   max-free = 1024 * 1024 * 1024;
  # };

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
  services.xserver.enable = true;
  services.xserver.desktopManager.xfce.enable = true;
  services.xserver.displayManager.lightdm.enable = true;
  services.displayManager.autoLogin = {
    enable = true;
    user = "team";
  };
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

  environment.systemPackages =
    let
      ubuntu = flake.packages.${pkgs.system}.ubuntu;
    in
    with pkgs;
    [
      (writeShellApplication {
        name = "spsetup";
        runtimeInputs = [ fzy ];
        text = builtins.readFile ../../spsetup.sh;
      })

      hyperfine
      man-pages
      p7zip
      sysstat
      zip
      htop
      btop
      wget

      ubuntu
      (ubuntu.provide "gcc")
      (ubuntu.provide "g++")
      (ubuntu.provide "cc")
      (ubuntu.provide "c++")
      (ubuntu.provide "javac")
      (ubuntu.provide "java")
      (ubuntu.provide "python3")
      (ubuntu.provide "pypy3")

      neovim
      vim
      emacs
      sublime4
      vscode
      gedit
      geany
      (pkgs.lowPrio python311Full) # includes idle, lower priority so ubuntu python takes precedence
    ];

  environment.ldso = flake.packages.${pkgs.system}.ubuntu.ldso;

  services.nixseparatedebuginfod.enable = true;

  programs.git.enable = true;
}
