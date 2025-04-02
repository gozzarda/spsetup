{ inputs, system }:

inputs.nixos-generators.nixosGenerate {
  inherit system;
  format = "raw-efi";
  modules = [
    inputs.self.nixosModules.base
  ];
}
