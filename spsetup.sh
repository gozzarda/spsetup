#!/usr/bin/env bash
set -euo pipefail

if [ "$EUID" -ne 0 ]; then
    exec sudo "$0" "$@"
fi

list_subcommands() {
    if [ -z "$(nft list ruleset)" ]; then
        echo "enable firewall"
    else
        echo "disable firewall"
    fi
    echo "quit"
}

do_subcommand() {
    case "$*" in
        "enable firewall")
            echo enabling firewall
            systemctl restart nftables
            ;;
        "disable firewall")
            echo disabling firewall
            nft flush ruleset
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
