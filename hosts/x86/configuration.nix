{ inputs, ... }:

{
  imports = [
    inputs.self.nixosModules.base
  ];
  nixpkgs.hostPlatform = "x86_64-linux";
}
