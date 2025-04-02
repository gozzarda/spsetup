SP Setup Scripts
================

Do not run these scripts on a machine you don't intend to turn into a contest image.  
All scripts can be run as root, most have to be.

Installation
------------
`sudo ./install.sh`  
This will install all scripts to `/usr/share/spsetup/` and make a symlink from `/usr/bin/spsetup` to `spsetup.sh`

Running Commands
----------------
As root:  
`spsetup`  
You will be presented with a menu with 5 option:
1. Perform first time setup
    - Does everything required to convert a stock Ubuntu Server 24.04 installation into a contest setup
    - Used for building images, should not need to be run if you received this setup as a preconfigured image
2. Archive and reset team user
    - Archives the team user's home directory in `/usr/share/spsetup/teamarchives`
    - Archive file is owned by root and is non-world readable
    - Wipes all files owned by team user, deletes the account and remakes it
3. Clear team archives
    - Erase all currently archived team home directories
4. Enable firewall
    - Enables the firewall for contest use
5. Disable firewall
    - Disables the firewall for admin use
6. Quit
    - Exits the script

Image Handling
--------------
To create a bootable USB drive of this image, simply clone it to the drive using either

- `dd if=contestant.img of=/path/to/drive` (may leave dead space on drive), or
- `virt-resize --expand /dev/sda1 contestant.img /path/to/drive` (will expand image to fill drive)

where `/path/to/drive` is the path to the drive you want to write the image to.

Note: `virt-resize` is available in the `libguestfs-tools` package.

The image can be converted to different formats using `qemu-img convert` as detailed [here](https://docs.openstack.org/image-guide/convert-images.html). For example, `qemu-img convert -f raw -O vmdk contestant.img contestant.vmdk` will convert the image to VMDK format.

Alternative setups such as a virtual machine are possible, but platform dependent, so instructions are not included here.
