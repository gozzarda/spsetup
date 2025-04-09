{ inputs, pkgs }:

pkgs.writeShellScriptBin "mkimg" ''
  exec ${inputs.self.nixosConfigurations.x86.config.system.build.diskoImagesScript}
''
