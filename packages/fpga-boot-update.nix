{ pkgs, ... }:

let
  fpga-boot-update = pkgs.writeShellScriptBin "fpga-boot-update" ''
    #!/usr/bin/env bash
    set -euo pipefail

    if [ "$#" -lt 2 ]; then
      echo "Usage: $0 /path/to/petalinux/images/linux <fpga_host>"
      echo
      echo "Arguments:"
      echo "  /path/to/petalinux/images/linux   Directory containing BOOT.BIN, Image, boot.scr"
      echo "  <fpga_host>                       SSH target, e.g. oriole@10.0.51.71"
      echo
      echo "Example:"
      echo "  $0 /home/oliverc/Documents/opticalfundamentals/peta-linux-build/petalinux/images/linux oriole@10.0.51.71"
      exit 1
    fi

    IMAGE_DIR="$1"
    FPGA_HOST="$2"

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
    ssh "$FPGA_HOST" "rm -rf '$REMOTE_TMP' && mkdir -p '$REMOTE_TMP'"

    echo "Copying boot files to FPGA temporary directory..."
    scp \
      "''${IMAGE_DIR}/BOOT.BIN" \
      "''${IMAGE_DIR}/Image" \
      "''${IMAGE_DIR}/boot.scr" \
      "$FPGA_HOST:$REMOTE_TMP/"

    echo "Verifying checksums of copied files..."
    for file in "''${FILES[@]}"; do
      remote_sum="$(ssh "$FPGA_HOST" "sha256sum '$REMOTE_TMP/$file' | awk '{print \$1}'")"
      if [ "$remote_sum" != "''${LOCAL_SUMS[$file]}" ]; then
        echo "Checksum mismatch for $file:"
        echo "  local:  ''${LOCAL_SUMS[$file]}"
        echo "  remote: $remote_sum"
        echo "Aborting before touching /boot. Cleaning up remote temp..."
        ssh "$FPGA_HOST" "rm -rf '$REMOTE_TMP'" || true
        exit 1
      fi
      echo "  OK: $file"
    done

    echo "Installing files into /boot on FPGA..."
    ssh -t "$FPGA_HOST" "
      set -e
      echo 'Current /boot contents:'
      ls -lh $REMOTE_BOOT/BOOT.BIN $REMOTE_BOOT/Image $REMOTE_BOOT/boot.scr 2>/dev/null || true
      echo
      echo 'Backing up existing files...'
      sudo mkdir -p $REMOTE_BOOT/backup-before-update
      for file in BOOT.BIN Image boot.scr; do
        if [ -f $REMOTE_BOOT/\$file ]; then
          sudo cp -a $REMOTE_BOOT/\$file $REMOTE_BOOT/backup-before-update/\$file
        fi
      done
      echo
      echo 'Installing new files...'
      sudo cp $REMOTE_TMP/BOOT.BIN $REMOTE_BOOT/BOOT.BIN
      sudo cp $REMOTE_TMP/Image $REMOTE_BOOT/Image
      sudo cp $REMOTE_TMP/boot.scr $REMOTE_BOOT/boot.scr
      echo
      echo 'Flushing writes...'
      sync
      sudo sync
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
