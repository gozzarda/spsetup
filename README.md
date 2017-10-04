SP Setup Scripts
================

Do not run these scripts on a machine you don't intend to turn into a contest image.
All scripts can be run with sudo, most have to be.

Installation
------------
`sudo ./install.sh`
This will install all scripts to `/usr/share/spsetup/` and make a symlink from `/usr/bin/spsetup` to `spsetup.sh`

Running Commands
----------------
`sudo spsetup`
You will be presented with a menu with 5 option:
1. Perform first time setup
    - Does everything required to convert a stock Ubuntu 16.04 installation into a contest setup
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
