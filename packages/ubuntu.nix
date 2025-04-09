{ pkgs }:

let
  inherit (pkgs) lib;

  release = "noble"; # 24.04
  mirror = "http://au.archive.ubuntu.com/ubuntu/";
  debsHash = "sha256-sD5Ckx6O8kaRM+edWRY673sW7A8LXGYjmDbfF0yzR7Y=";

  aptPackages = [
    "build-essential"
    "gcc"
    "g++"
    "python3"
    "openjdk-17-jdk"
    "openjdk-17-jre"
    "pypy3"
  ];
  aptExtraRepos = [ "universe" ];
  aptHash = "sha256-wqLXdz0xigA1nMu0S3e6M4dYkqUxLI8EZs6auh3Z1Ks=";

  debootstrap = pkgs.debootstrap.overrideAttrs {
    postInstall = ''
      substituteInPlace $out/bin/debootstrap \
        --replace-fail "PATH='" "PATH="$PATH":'"
    '';
  };

  debootstrap-args = "--variant=minbase ${release} out ${mirror}";

  basedebs = pkgs.runCommand "ubuntu-packages.tar" {
    nativeBuildInputs = [ debootstrap ];
    outputHashMode = "flat";
    outputHashAlgo = "sha256";
    outputHash = debsHash;
  } "debootstrap --make-tarball=$out ${debootstrap-args}";

  baserootfs = pkgs.vmTools.runInLinuxVM (
    pkgs.runCommand "ubuntu-rootfs.tar"
      {
        nativeBuildInputs = [ debootstrap ];
        disallowedReferences = [ debootstrap ]; # don't allow references to debootstrap in the output
      }
      ''
        debootstrap --unpack-tarball=${basedebs} ${debootstrap-args}
        rm -r $out out/dev/* # can't copy special devices
        rm out/var/log/bootstrap.log # has references to the debootstrap store path
        tar cf $out -C out .
      ''
  );

  apt-cache =
    pkgs.runCommand "ubuntu-apt-cache.tar"
      {
        nativeBuildInputs = [ pkgs.bubblewrap ];
        outputHashMode = "flat";
        outputHashAlgo = "sha256";
        outputHash = aptHash;
      }
      ''
        mkdir out
        tar xf ${baserootfs} -C out

        bwrap \
          --bind out / \
          --bind /etc/resolv.conf /etc/resolv.conf \
          --setenv PATH /bin \
          bash -c '
            for repo in ${lib.concatStringsSep " " aptExtraRepos}; do
              echo "deb ${mirror} ${release} $repo" >> /etc/apt/sources.list
            done
            apt-get update
            apt-get install --download-only -y ${lib.concatStringsSep " " aptPackages}
          '

        tar cf $out -C out .
      '';

  rootfs = pkgs.vmTools.runInLinuxVM (
    pkgs.runCommand "ubuntu-rootfs"
      {
        memSize = 4 * 1024;
        nativeBuildInputs = [ pkgs.util-linux ];
      }
      ''
        mkdir out
        tar xf ${apt-cache} -C out

        mount --bind /proc out/proc
        mount --bind /dev out/dev

        chroot out /bin/apt install -y ${lib.concatStringsSep " " aptPackages}

        umount out/proc out/dev
        rm -r out/var/cache/* out/etc/{passwd,shadow,group}
        cp -r out/* $out
      ''
  );

  run = pkgs.writeShellApplication {
    name = "ubuntu-run";
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
  };

  ldso = pkgs.pkgsStatic.runCommandCC "ubuntu-ldso" { } ''
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

      execve("${lib.getExe run}", args, envp);
      return errno;
    }
    EOF
    $CC -Os ldso.c -o $out
  '';

  provide =
    program:
    pkgs.writeShellScriptBin program ''
      exec ${lib.getExe run} ${program} "$@"
    '';
in

run
// {
  inherit
    rootfs
    basedebs
    apt-cache
    ldso
    provide
    ;
}
