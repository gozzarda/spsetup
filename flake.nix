{
  description = "SPCPA contestant image setup";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-24.11";
    blueprint.url = "github:numtide/blueprint";

    nixos-generators = {
      url = "github:nix-community/nixos-generators";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    disko = {
      url = "github:nix-community/disko";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  nixConfig = {
    extra-substituters = "https://nix.tombl.net/spsetup";
    extra-trusted-public-keys = "spsetup:lQUkW1jLuCJ4870w/AWfLjV7bYB1T9A/rtSlF1vU2V8=";
  };

  outputs =
    inputs:
    inputs.blueprint {
      inherit inputs;
      systems = [
        "x86_64-linux"
        "aarch64-linux"
      ];
    };
}
