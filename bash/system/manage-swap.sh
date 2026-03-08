#!/bin/bash

SWAP_PATH="/swapfile"
SIZE=""
DELETE=0

# Funkcja pomocy
usage() {
    echo "Użycie: $0 [-s rozmiar, np. 2G] [-p ścieżka] [-d usunięcie]"
    exit 1
}

# sprawdzenie flag
while getopts "s:p:dh" opt; do
  case ${opt} in
    s ) SIZE=$OPTARG ;;
    p ) SWAP_PATH=$OPTARG ;;
    d ) DELETE=1 ;;
    h ) usage ;;
    * ) usage ;;
  esac
done

# konwersja na ścieżke absolutną
SWAP_PATH=$(realpath -m "$SWAP_PATH")

# sprawdzenie uprawnień
if [ "$EUID" -ne 0 ]; then
  echo "Błąd: Wymagane uprawnienia roota."
  exit 1
fi

# usuwanie swapa
if [ $DELETE -eq 1 ]; then
  if ! swapon --show=NAME | grep -q "^${SWAP_PATH}$"; then
    echo "Błąd: $SWAP_PATH nie jest aktywnym plikiem swap."
    exit 1
  fi
  
  swapoff "$SWAP_PATH" 2>/dev/null
  rm -f "$SWAP_PATH"
  sed -i "\|^$SWAP_PATH |d" /etc/fstab
  echo "Usunięto $SWAP_PATH i wpis z /etc/fstab."
  exit 0
fi

# brak rozmiaru
if [ -z "$SIZE" ]; then
  echo "Błąd: Podaj rozmiar (-s, np. 2G)."
  exit 1
fi

# sprawdzenie czy plik już nie istnieje
if [ -f "$SWAP_PATH" ]; then
  echo "Błąd: Plik $SWAP_PATH już istnieje. Usuń go najpierw używając flagi -d."
  exit 1
fi

# konwersja podanego rozmiaru na bajty
REQ_BYTES=$(numfmt --from=iec "$SIZE" 2>/dev/null)
if [ -z "$REQ_BYTES" ]; then
  echo "Błąd: Nieprawidłowy format rozmiaru (np. 2G, 512M)."
  exit 1
fi

# sprawdzenie dostępnego miejsca
TARGET_DIR=$(dirname "$SWAP_PATH")
if [ ! -d "$TARGET_DIR" ]; then
  echo "Błąd: Katalog docelowy $TARGET_DIR nie istnieje."
  exit 1
fi

AVAIL_BYTES=$(df --output=avail -B1 "$TARGET_DIR" | tail -n 1)

if [ "$REQ_BYTES" -ge "$AVAIL_BYTES" ]; then
  echo "Błąd: Za mało wolnego miejsca na dysku w $TARGET_DIR."
  exit 1
fi

# tworzenie swapa
echo "Tworzenie swap: $SWAP_PATH o rozmiarze $SIZE..."
fallocate -l "$SIZE" "$SWAP_PATH" || dd if=/dev/zero of="$SWAP_PATH" bs=1M count=$((REQ_BYTES/1048576)) status=progress

chmod 600 "$SWAP_PATH"
mkswap "$SWAP_PATH"
swapon "$SWAP_PATH"

# jeśli nie ma wpisu
if ! grep -q "^$SWAP_PATH " /etc/fstab; then
  echo "$SWAP_PATH none swap sw 0 0" >> /etc/fstab
  echo "Dodano wpis do /etc/fstab."
fi

echo "Gotowe. Aktualny status SWAP:"
swapon --show
