{ inputs, system }:

inputs.nixos-generators.nixosGenerate {
  inherit system;
  format = "vm-nogui";
  modules = [
    inputs.self.nixosModules.base
    { virtualisation.diskSize = 20 * 1024; }
  ];
}
