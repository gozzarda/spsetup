{ pkgs }:

let
  inherit (pkgs) lib;

  # generated via `nix run nixpkgs#nix-prefetch-docker domjudge/judgehost`
  image = pkgs.dockerTools.pullImage {
    imageName = "domjudge/judgehost";
    imageDigest = "sha256:62638543b44a69a00a076c410671768d702f76f4f035d9a58dfb13794a9f0089";
    sha256 = "sr29ID9XRojQcKuIf0Iztf+QJz/V9BNmiQ2B0XJUmmo=";
    finalImageName = "domjudge/judgehost";
    finalImageTag = "latest";
  };

  rootfs1 =
    pkgs.runCommand "judgehost-rootfs"
      {
        nativeBuildInputs = [ pkgs.undocker ];
      }
      ''
        mkdir $out
        undocker ${image} - | tar x -C $out --exclude='dev/*'
        rm $out/etc/{passwd,group,shadow}
      '';

  rootfs2 = "${rootfs1}/chroot/domjudge";

  mkRun =
    name: rootfs:
    lib.getExe (pkgs.writeShellApplication {
      name = "${name}-run";
      runtimeInputs = [ pkgs.bubblewrap ];
      text = ''
        bwrap \
          --bind ${rootfs} / \
          --overlay-src /etc --overlay-src ${rootfs}/etc --tmp-overlay /etc \
          --setenv PATH /usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin \
          --proc /proc \
          --dev /dev \
          --bind /home /home \
          "$@"
      '';
    });

  mkLdso =
    name: run:
    pkgs.pkgsStatic.runCommandCC "${name}-ldso" { } ''
      cat >ldso.c <<EOF
      #include <unistd.h>
      #include <errno.h>
      int main(int argc, char *argv[], char *envp[]) {
        char **args = malloc(sizeof(char*) * (argc + 2));
        if (!args) return 12;

        /* duplicate the first arg, shift the rest back */
        args[0] = argv[0];
        args[1] = argv[0];
        for (int i = 0; i < argc; i++) {
          args[i+1] = argv[i];
        }
        args[argc+1] = NULL;

        execve("${run}", args, envp);
        return errno;
      }
      EOF
      $CC -Os ldso.c -o $out
    '';
in

let
  run1 = mkRun "domjudge" rootfs1;
  run2 = mkRun "domjudge-chroot" rootfs2;
in

pkgs.runCommand "ubuntu" { } ''
  mkdir -p $out/bin

  wrap() {
    echo exec $1 $2 '"$@"' > $out/bin/$2
    chmod +x $out/bin/$2
  }

  wrap ${run2} gcc
  wrap ${run2} cc
  wrap ${run2} g++
  wrap ${run2} c++

  wrap ${run2} java
  wrap ${run2} javac

  wrap ${run2} pypy3
  wrap ${run1} python3
''
// {
  ldso = mkLdso "domjudge-chroot" run2;
}
