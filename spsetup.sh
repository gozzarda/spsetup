#!/usr/bin/env bash
set -euo pipefail

if [ "$EUID" -ne 0 ]; then
    exec sudo "$0" "$@"
fi

ARCHIVE_DIR=/var/spool/sparchive

wipe_team_directory() {
    # TODO: migrate the raspberry pi build over to btrfs,
    # then all the archival code can be simple subvolume operations.
    echo "removing team directory"
    rm -rf /home/team

    # determine these via `find / -type d -writable 2>/dev/null`
    find /dev -user team -exec rm -rf {} \; 2>/dev/null || true
    find /run -user team -exec rm -rf {} \; 2>/dev/null || true
    find /tmp -user team -exec rm -rf {} \; 2>/dev/null || true
    find /var -user team -exec rm -rf {} \; 2>/dev/null || true

    mkdir -p /home/team
    chown -R team /home/team
    chmod 750 /home/team
}

restart_team_processes() {
    echo "killing all team processes"
    sleep 1
    pkill -QUIT -u team || true
    pkill -INT -u team || true
    pkill -KILL -u team || true
}

list_subcommands() {
    if [ -z "$(nft list ruleset)" ]; then
        echo "enable firewall"
    else
        echo "disable firewall"
    fi
    echo "archive team"
    echo "wipe team"
    if [ -d "$ARCHIVE_DIR" ] && [ -n "$(ls -A $ARCHIVE_DIR/)" ]; then
        echo "restore archive"
    fi
    echo "quit"
}

do_subcommand() {
    case "$*" in
        "enable firewall")
            echo "enabling firewall"
            systemctl restart nftables
            ;;
        "disable firewall")
            echo "disabling firewall"
            nft flush ruleset
            ;;
        "archive team")
            echo "archiving team directory"
            
            if who | grep -q "team"; then
                read -r -p "team is currently logged in. continue? (y/n): " confirm
                if [ "$confirm" != "y" ]; then
                    echo "aborting archive operation"
                    return
                fi
            fi
            
            mkdir -p $ARCHIVE_DIR
            
            read -r -p "enter label for archive: " label
            timestamp=$(date -u +"%Y-%m-%dT%H:%M:%SZ")
            
            if [ -n "$label" ]; then
                archive_file="$ARCHIVE_DIR/${timestamp}_${label}.tar.gz"
            else
                archive_file="$ARCHIVE_DIR/${timestamp}.tar.gz"
            fi
            
            echo "creating archive at $archive_file"
            tar -czf "$archive_file" -C /home/team .
            chown admin "$archive_file"
            chmod 600 "$archive_file"
            
            wipe_team_directory
            
            echo "archive completed successfully"
            
            restart_team_processes
            ;;
        "restore archive")
            echo "select an archive to restore:"
            
            archive=$(find $ARCHIVE_DIR/ -maxdepth 1 -type f | fzy)
            if [ -z "$archive" ]; then
                echo "no archive selected"
                return
            fi
            
            if [ -d "/home/team" ]; then
                read -r -p "team directory already exists. overwrite? (y/n): " confirm
                if [ "$confirm" != "y" ]; then
                    echo "aborting restore operation"
                    return
                fi
                wipe_team_directory
            else
                mkdir -p /home/team
                chown -R team /home/team
            fi
            
            echo "restoring archive $archive"
            tar -xzf "$archive" -C /home/team
            chown -R team /home/team
            
            echo "archive restored successfully"
            
            restart_team_processes
            ;;
        "wipe team")
            echo "preparing to wipe team directory"
            
            if who | grep -q "team"; then
                read -r -p "team is currently logged in. continue? (y/n): " confirm
                if [ "$confirm" != "y" ]; then
                    echo "aborting wipe operation"
                    return
                fi
            fi
            
            read -r -p "this will delete all files in the team directory. are you sure? (y/n): " confirm
            if [ "$confirm" != "y" ]; then
                echo "aborting wipe operation"
                return
            fi
            
            wipe_team_directory
            restart_team_processes
            ;;
        ""|"quit")
            exit 0
            ;;
        *)
            echo "unknown subcommand: $*"
            ;;
    esac
}

if [ $# -gt 0 ]; then
    do_subcommand "$@"
else
    while true; do
        do_subcommand "$(list_subcommands | fzy)"
    done
fi
