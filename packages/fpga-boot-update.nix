{ pkgs, ... }:

let
  fpga-boot-update = pkgs.writeShellScriptBin "fpga-boot-update" ''
    #!/usr/bin/env bash
    set -euo pipefail

    # Surface the failing command instead of exiting silently (e.g. on an
    # authentication failure inside ssh/scp).
    trap 'echo "ERROR: command failed (exit $?) at line $LINENO. Check the SSH/sudo password and host connectivity." >&2' ERR

    usage() {
      echo "Usage: $0 /path/to/petalinux/images/linux <fpga_host>"
      echo
      echo "Arguments:"
      echo "  /path/to/petalinux/images/linux   Directory containing BOOT.BIN, Image, boot.scr"
      echo "  <fpga_host>                       SSH target, e.g. oriole@10.0.51.71"
      echo
      echo "A password is requested automatically only if key-based SSH or"
      echo "passwordless sudo is unavailable (the same password is used for both)."
      echo
      echo "Example:"
      echo "  $0 /home/oliverc/Documents/opticalfundamentals/peta-linux-build/petalinux/images/linux oriole@10.0.51.71"
    }

    POSITIONAL=()
    while [ "$#" -gt 0 ]; do
      case "$1" in
        -h|--help)
          usage; exit 0
          ;;
        --)
          shift; while [ "$#" -gt 0 ]; do POSITIONAL+=("$1"); shift; done
          ;;
        -*)
          echo "Unknown option: $1"; echo; usage; exit 1
          ;;
        *)
          POSITIONAL+=("$1"); shift
          ;;
      esac
    done
    set -- "''${POSITIONAL[@]}"

    if [ "$#" -lt 2 ]; then
      usage
      exit 1
    fi

    IMAGE_DIR="$1"
    FPGA_HOST="$2"

    # accept-new lets us proceed on first contact instead of stalling on the
    # host-key prompt, while still rejecting changed keys.
    SSH_OPTS=(-o StrictHostKeyChecking=accept-new)
    SSH=(ssh "''${SSH_OPTS[@]}")
    SCP=(scp "''${SSH_OPTS[@]}")
    PASSWORD=""
    SUDO_PASS_B64=""

    # Prompt once for a password shared by SSH and remote sudo.
    prompt_password() {
      [ -n "$PASSWORD" ] && return 0
      read -r -s -p "Password for $FPGA_HOST (SSH/sudo): " PASSWORD; echo
      export SSHPASS="$PASSWORD"
      SUDO_PASS_B64="$(printf '%s' "$PASSWORD" | base64 -w0)"
    }

    # If key-based auth doesn't work, prompt and route ssh/scp through sshpass.
    echo "Checking SSH access to $FPGA_HOST..."
    if ! ssh "''${SSH_OPTS[@]}" -o BatchMode=yes -o ConnectTimeout=10 \
         "$FPGA_HOST" true 2>/dev/null; then
      echo "Key-based SSH unavailable; a password is required."
      prompt_password
      SSH=(${pkgs.sshpass}/bin/sshpass -e ssh "''${SSH_OPTS[@]}")
      SCP=(${pkgs.sshpass}/bin/sshpass -e scp "''${SSH_OPTS[@]}")
    fi

    # If passwordless sudo isn't available, ensure we have a password for it.
    echo "Checking sudo access on $FPGA_HOST..."
    if ! "''${SSH[@]}" "$FPGA_HOST" "sudo -n true" 2>/dev/null; then
      echo "Passwordless sudo unavailable; a password is required."
      prompt_password
    fi

    FILES=(
      "BOOT.BIN"
      "Image"
      "boot.scr"
    )

    REMOTE_TMP="/tmp/fpga-boot-update"
    REMOTE_BOOT="/boot"

    echo "Checking local image files..."
    for file in "''${FILES[@]}"; do
      if [ ! -f "''${IMAGE_DIR}/''${file}" ]; then
        echo "Missing required file: ''${IMAGE_DIR}/''${file}"
        exit 1
      fi
    done

    echo
    echo "About to deploy the following files to ''${FPGA_HOST}:''${REMOTE_BOOT}"
    for file in "''${FILES[@]}"; do
      printf '  %s\n' "''${IMAGE_DIR}/''${file}"
    done
    echo
    read -r -p "Proceed? [y/N] " reply
    case "$reply" in
      [yY]|[yY][eE][sS]) ;;
      *) echo "Aborted."; exit 1 ;;
    esac

    echo "Computing local checksums..."
    declare -A LOCAL_SUMS
    for file in "''${FILES[@]}"; do
      LOCAL_SUMS["$file"]="$(sha256sum "''${IMAGE_DIR}/''${file}" | awk '{print $1}')"
    done

    echo "Creating temporary directory on FPGA..."
    "''${SSH[@]}" "$FPGA_HOST" "rm -rf '$REMOTE_TMP' && mkdir -p '$REMOTE_TMP'"

    echo "Copying boot files to FPGA temporary directory..."
    "''${SCP[@]}" \
      "''${IMAGE_DIR}/BOOT.BIN" \
      "''${IMAGE_DIR}/Image" \
      "''${IMAGE_DIR}/boot.scr" \
      "$FPGA_HOST:$REMOTE_TMP/"

    echo "Verifying checksums of copied files..."
    for file in "''${FILES[@]}"; do
      remote_sum="$("''${SSH[@]}" "$FPGA_HOST" "sha256sum '$REMOTE_TMP/$file' | awk '{print \$1}'")"
      if [ "$remote_sum" != "''${LOCAL_SUMS[$file]}" ]; then
        echo "Checksum mismatch for $file:"
        echo "  local:  ''${LOCAL_SUMS[$file]}"
        echo "  remote: $remote_sum"
        echo "Aborting before touching /boot. Cleaning up remote temp..."
        "''${SSH[@]}" "$FPGA_HOST" "rm -rf '$REMOTE_TMP'" || true
        exit 1
      fi
      echo "  OK: $file"
    done

    echo "Installing files into /boot on FPGA..."
    "''${SSH[@]}" -t "$FPGA_HOST" "
      set -e
      SUDO_PASS_B64='$SUDO_PASS_B64'
      if [ -n \"\$SUDO_PASS_B64\" ]; then
        SUDO_PASS=\"\$(printf '%s' \"\$SUDO_PASS_B64\" | base64 -d)\"
        SUDO() { printf '%s\n' \"\$SUDO_PASS\" | sudo -S -p ''' \"\$@\"; }
      else
        SUDO() { sudo \"\$@\"; }
      fi
      echo 'Current /boot contents:'
      ls -lh $REMOTE_BOOT/BOOT.BIN $REMOTE_BOOT/Image $REMOTE_BOOT/boot.scr 2>/dev/null || true
      echo
      echo 'Backing up existing files...'
      SUDO mkdir -p $REMOTE_BOOT/backup-before-update
      for file in BOOT.BIN Image boot.scr; do
        if [ -f $REMOTE_BOOT/\$file ]; then
          SUDO cp -a $REMOTE_BOOT/\$file $REMOTE_BOOT/backup-before-update/\$file
        fi
      done
      echo
      echo 'Installing new files...'
      SUDO cp $REMOTE_TMP/BOOT.BIN $REMOTE_BOOT/BOOT.BIN
      SUDO cp $REMOTE_TMP/Image $REMOTE_BOOT/Image
      SUDO cp $REMOTE_TMP/boot.scr $REMOTE_BOOT/boot.scr
      echo
      echo 'Flushing writes...'
      sync
      SUDO sync
      echo
      echo 'Updated /boot contents:'
      ls -lh $REMOTE_BOOT/BOOT.BIN $REMOTE_BOOT/Image $REMOTE_BOOT/boot.scr
      rm -rf $REMOTE_TMP
    "

    echo
    echo "Done. Boot files deployed to $FPGA_HOST:/boot"
  '';
in
{
  home.packages = [ fpga-boot-update ];
}
