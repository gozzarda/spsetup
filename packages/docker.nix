{ inputs, system }:

inputs.nixos-generators.nixosGenerate {
  inherit system;
  format = "docker";
  modules = [
    inputs.self.nixosModules.base
  ];
}
