# spsetup

## Building the image

You will need Nix installed on your system. This is distinct from NixOS and can be installed on any Linux distribution, likely via your distro's package manager.

You will also need to configure the following settings in `/etc/nix/nix.conf`:

```
experimental-features = nix-command flakes
trusted-users = <your username>
```

From there, you should be able to run `nix run .#x86` in this repo, which will generate a disk image named `main.raw`.

If this command presents you with a prompt to accept a binary cache, you must say yes, because the embedded Ubuntu image is built from the latest apt packages, but pinned to a specific hash. This means that unless you're using the cache, your generated image will be different from the expected one.

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

### Updating/changing Ubuntu dependencies

In `packages/ubuntu.nix` you'll find all the code necessary to create an Ubuntu rootfs as a Nix package. You can ignore most of this file, because the important input variables are defined at the top.

<!-- An important fact to note about Nix is that all packages that fetch data from the internet are defined with a specific output hash, which is used to verify that the package resolves to the same content every time it's built. However, this means that if you change the definition of a package but keep the hash the same, Nix will think that the package hasn't changed and won't rebuild it.

If you want to force a rebuild, like when you change the input variables, you must replace the hash with a dummy value. `nixpkgs` provides a variable called `lib.fakeHash` which is used for exactly this purpose. -->

> [!NOTE]
> Any Nix package that fetches data from the internet must define a fixed output hash.
>
> This means that if you change the definition of a package but keep the hash the same, Nix will think that the package hasn't changed and won't rebuild it.
>
> Therefore, whenever you change the inputs of a network-dependent package, you must also replace the hash with a different value.
>
> The standard procedure for this is to replace the hash with `lib.fakeHash`, which will allow the package to rebuild. This build will fail with an error message like `error: hash mismatch, expected '<THE CORRECT HASH>', but got 'sha256-00000000'`.
>
> You can now take the hash from the error message and replace the `lib.fakeHash` with it. Now, you can run your build a second time, and it will succeed.

To update the major version of Ubuntu, you can set the `release` variable to the name of the new major version, and update the `debsHash`.

To change the installed list of packages, edit the `aptPackages` list, and update the `aptHash`.

## Potential future improvements

- automatic builds in ci (https://github.com/tombl/spsetup/pull/1)
- raspberry pi images
- move archive script to btrfs snapshots
