#!/usr/bin/env bash
set -euo pipefail # e: exit on error; u: exit on missing variables
source ./lib.sh

check --type cmd nix ssh git

SOURCE_HOSTNAME=$(hostname)
TARGET_HOSTNAME=""
TARGET_USER=${TARGET_USER:-"devon"}
TARGET_IP=""
AUTH_KEY=${AUTH_KEY:-"/run/secrets/keys/default/private"}
SSH_PORT=${SSH_PORT:-22}
ROOT=$(git rev-parse --show-toplevel)

help() {
    print -i "Usage: $0 [OPTIONS]"
    echo
    echo "Required:"
    echo "  -n, --target-host-name <name>  Target hostname"
    echo "  -a, --target-host-ip <ip>      Target IP address"
    echo
    echo "Optional:"
    echo "  -u, --target-user <username>   Default user login (default: '$TARGET_USER')"
    echo "  -i, --input-private-key <key>  Authentication key (default: $AUTH_KEY)"
    echo "  -p, --ssh-port <port>          SSH port (default: 22)"
    echo "  -h, --help                     Show this help"
}

while (("$#")); do
    case $1 in
    -n | --target-host-name)
        TARGET_HOSTNAME="$2"
        shift 2
        ;;
    -a | --target-host-ip)
        TARGET_IP="$2"
        shift 2
        ;;
    -u | --target-user)
        TARGET_USER="$2"
        shift 2
        ;;
    -i | --input-private-key)
        AUTH_KEY="$2"
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
print -i "  Key: $AUTH_KEY"
print -i "  IP: $TARGET_IP"
print -i "  Port: $SSH_PORT"
echo

if ! confirm "Confirm deploying options?"; then
    exit 0
fi

# Check list:
# - fetch host key
# - convert it to age key
# - update sops with host age key
# - ensure there is a client key for current source host
# - rebuild system

TEMP=$(mktemp -d)
cleanup() { rm -rf "$TEMP"; }
trap cleanup EXIT

TARGET_USER="nixos"
TARGET_ADDRESS="${TARGET_USER}@${TARGET_IP}"
print -w "Stage 1: Bootstraping system at $TARGET_ADDRESS with minimal flake!"

# PRE-INSTALL
print -i "Removing existed public key of $TARGET_IP in ~/.ssh/known_hosts."
ssh-keygen -R "$TARGET_IP" >/dev/null 2>&1 || true
[ "$SSH_PORT" != "22" ] && ssh-keygen -R "[${TARGET_IP}]:${SSH_PORT}" >/dev/null 2>&1 || true

print -i "Adding ssh host fingerprint at $TARGET_IP to ~/.ssh/known_hosts"
ssh-keyscan -t ed25519 -p "$SSH_PORT" "$TARGET_IP" >>~/.ssh/known_hosts 2>/dev/null

print -i "Preparing bootstrap key for secrets repo installation."
install -d -m700 "$TEMP/home/nixos/.ssh"
cat "$AUTH_KEY" >"$TEMP/home/nixos/.ssh/id_bootstrap"
chmod 600 "$TEMP/home/nixos/.ssh/id_bootstrap"

bootstrap=(
    nix run nixpkgs#nixos-anywhere --
    -i "$KEY"
    --show-trace
    --extra-files "$TEMP"
    --ssh-port "$SSH_PORT"
    --flake "$ROOT/host#$TARGET_HOSTNAME"
    --target-host "$TARGET_ADDRESS"
)

if confirm "Generate and copy target hardware-configuration.nix?"; then
    ARCH=$(ssh "$TARGET_ADDRESS" nix eval --raw --impure --expr 'builtins.currentSystem')
    TARGET_HARDWARE="$ROOT/host/$ARCH/$TARGET_HOSTNAME"
    bootstrap+=(--generate-hardware-config nixos-generate-config "$TARGET_HARDWARE")
fi

# BOOTSTRAP
# - disk format
# - change to default user
# - remove bootstrap key
# - setup permanent ssh host key pairs
if confirm "Run nixos-anywhere to install bootstrap system?"; then
    "${bootstrap[@]}"
else
    print -d "Script terminated because user refused to bootstrap system."
    exit 0
fi

echo
print -d "System has been bootstaped."
print -i "Current system is only suitable for testing purposes."
echo

# POST-BOOTSTRAP
if ! confirm "To continue install please confirm"; then
    exit 0
fi

print -i "Update known_hosts fingerprint."
ssh-keygen -R "$TARGET_IP" >/dev/null 2>&1 || true
[ "$SSH_PORT" != "22" ] && ssh-keygen -R "[${TARGET_IP}]:${SSH_PORT}" >/dev/null 2>&1 || true
ssh-keyscan -t ed25519 -p "$SSH_PORT" "$TARGET_IP" >>~/.ssh/known_hosts 2>/dev/null

#@ Step 2: Fetch host SSH public key and convert it to age key
scp -p "$SSH_PORT" -i "$AUTH_KEY" \
    "${TEMP}/${TARGET_HOSTNAME}_key.pub" \
    "$TARGET_ADDRESS:/etc/ssh/ssh_host_ed25519_key.pub"

TARGET_KEY=$(<"${TEMP}/${TARGET_HOSTNAME}_key.pub")
print -i "$TARGET_KEY"
