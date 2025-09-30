#!/usr/bin/env bash
set -euo pipefail # e: exit on error; u: exit on missing variables
source ./lib.sh

check --type cmd nix ssh rsync git

TARGET_HOSTNAME=""
TARGET_IP=""
TARGET_USER=${TARGET_USER:-"nixos"}
SSH_PORT=22
ROOT=$(git rev-parse --show-toplevel)

help() {
    print -i "Usage: $0 [OPTIONS]"
    echo
    echo "Required:"
    echo "  -n, --target-host-name <name>  Target hostname"
    echo "  -i, --target-host-ip <ip>      Target IP address"
    echo
    echo "Optional:"
    echo "  -p, --ssh-port <port>          SSH port (default: 22)"
    echo "  -h, --help                     Show this help"
}

while (("$#")); do
    case $1 in
    -n | --target-host-name)
        TARGET_HOSTNAME="$2"
        shift 2
        ;;
    -i | --target-host-ip)
        TARGET_IP="$2"
        shift 2
        ;;
    -p | --ssh-port)
        SSH_PORT="$2"
        shift 2
        ;;
    -h | --help)
        help
        exit 0
        ;;
    *)
        echo "Unknow arg: $1. See $0 --help"
        exit 1
        ;;
    esac
done

check --type var TARGET_HOSTNAME TARGET_IP

echo
print -i "Current install options:"
print -i "  Hostname: $TARGET_HOSTNAME"
print -i "  User: $TARGET_USER"
print -i "  IP: $TARGET_IP"
print -i "  Port: $SSH_PORT"
echo

if ! confirm "Continue deploying?"; then
    exit 0
fi

TARGET_ADDRESS="${TARGET_USER}@${TARGET_IP}"
#@ Step 1: Boostrap NixOs installation with a minimal flake
print -w "Installing minimal flake on ${TARGET_ADDRESS}."
print -w "Wiping known_hosts of $TARGET_ADDRESS."
ssh-keygen -R "$TARGET_IP" >/dev/null 2>&1 || true
nix run nixpkgs#nixos-anywhere -- \
    --show-trace \
    --flake "$ROOT/host#$TARGET_HOSTNAME" \
    --target-host "$TARGET_ADDRESS"

#@ Step 2: Fetch host SSH public key
if confirm "Start fetching host pub key?" "y"; then
    # ssh-keygen -R "$TARGET_IP" >/dev/null 2>&1 || true

    print -i "Fetching SSH host key from $TARGET_ADDRESS."
    TEMP=$(mktemp -d)
    cleanup() { rm -rf "$TEMP"; }
    trap cleanup EXIT

    rsync -q "$TARGET_ADDRESS:/etc/ssh/ssh_host_ed25519_key.pub" \
        "${TEMP}/${TARGET_HOSTNAME}_key.pub"

    PUBKEY=$(<"${TEMP}/${TARGET_HOSTNAME}_key.pub")
    print -i "$PUBKEY"
    ssh-keyscan -p "$SSH_PORT" "$TARGET_IP" | grep -v '^#' >>~/.ssh/known_hosts || true
fi

#@ Step 3: Update .sops.yaml in nix-secrets with new key if not already present

#@ Step 4: Generate hardware-configuration.nix and copy from host to main flake using rsync
if ! confirm "Allow copying hardware config into main repo?"; then
    exit 0
fi

ARCH=$(ssh "$TARGET_ADDRESS" nix eval --raw --impure --expr 'builtins.currentSystem')
HOST_HARDWARE_CONFIG="$ROOT/host/$ARCH/$TARGET_HOSTNAME"

print -w "Copying hardware-configuration.nix from host machine to $HOST_HARDWARE_CONFIG"
print -i "$ARCH"

if [ ! -f "$HOST_HARDWARE_CONFIG/hardware-configuration.nix" ]; then
    rsync -q "$TARGET_ADDRESS:/etc/nixos/hardware-configuration.nix" \
        "$HOST_HARDWARE_CONFIG/hardware-configuration.nix"
fi

#@ Step 5: Commit & push changes of nix-config and nix-secrets

#@ Step 6: Reinstall system with the main flake
# print -w "Installing full config on ${TARGET_ADDRESS}."
# nix run nixpkgs#nixos-anywhere -- \
#     --flake "$ROOT#${TARGET_HOSTNAME}" \
#     --target-host "${TARGET_ADDRESS}"

# print -d "Succesfully deploying system!"

#@ Step 7: Copy nix-config over new host
