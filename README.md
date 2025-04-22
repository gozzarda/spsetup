# spsetup

## Building the image

You will need Nix installed on your system. This is distinct from NixOS and can be installed on any Linux distribution, likely via your distro's package manager.

You will also need to configure the following settings in `/etc/nix/nix.conf`:

```
experimental-features = nix-command flakes
trusted-users = <your username>
```

From there, you should be able to run `nix run .#x86` in this repo, which will generate a disk image named `main.raw`.

You can also run `nix run .#vm` or `nix run .#vm-nogui` to boot a virtual machine based on the configuration.

## Using the image

Once you generate/download the image, you can flash it to a USB drive using any tool you like, such as `dd`:

```bash
sudo dd if=main.raw of=/dev/sdX bs=4M status=progress
```

This drive will automatically boot to the `team` user. For administrative tasks, you can `su admin`, and then run the `spsetup` command.

```
[team@spcp:~]$ su admin
Password:

[admin@spcp:/home/team]$ spsetup
>
disable firewall
archive team
wipe team
quit
```

## Updating dependencies

### Updating minor OS dependencies

Run `nix flake update` in this repo.

### Updating major OS dependencies

In `flake.nix`, you'll see an input named `nixpkgs`, with a url value that looks something like `github:nixos/nixpkgs/nixos-24.11`. NixOS releases a stable branch every six months, so you'll be able to increment this to `25.05` or similar.

### Updating Ubuntu/Debian dependencies

In `packages/ubuntu.nix` you will find an invocation of `dockerTools.pullImage`. This is fetching the domjudge image from Docker Hub, which we then use to provide the language compilers and runtimes.

With nix installed, you can run `nix run nixpkgs#nix-prefetch-docker domjudge/judgehost`, which will print out a new set of arguments to pass to this invocation.

## Potential future improvements

- ~~automatic builds in ci~~ [download latest build](https://nightly.link/tombl/spsetup/workflows/ci.yaml/nix/x86-img.zip)
- raspberry pi images (https://github.com/tombl/spsetup/pull/6)
- move archive script to btrfs snapshots
