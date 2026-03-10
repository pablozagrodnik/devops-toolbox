#!/bin/bash

SRC="__"
DEST="__"
RETENTION=5

usage() {
	echo "Użycie: $0 [-s ścieźka źródła] [-d ścieźka docelowa] [-r liczba backupów]"
	exit 1
}

# sprawdzenie flag
while getopts "s:d:r:h" opt; do
  case ${opt} in
    s ) SRC=$OPTARG ;;
    d ) DEST=$OPTARG ;;
    r ) RETENTION=$OPTARG ;;
    h ) usage ;;
    * ) usage ;;
  esac
done

if [[ "$SRC" = "__" ]] || [[ "$DEST" = "__" ]]; then
	echo "Błąd. Podaj -s i -d"
	exit 1
fi

if [[ ! -d ${SRC} ]] || [[ ! -d $DEST ]]; then
	echo "Błąd. Ścieżki nie są katalogami"
	exit 1
fi

# konwersja na ścieżki absolutne
SRC_ABS=$(realpath -m "$SRC")
DEST_ABS=$(realpath -m "$DEST")

FILE_NAME="backup_$(date +%Y.%m.%d_%H-%M).tar.gz"

if [[ -f "$DEST_ABS/$FILE_NAME" ]]; then
	FILE_NAME="backup_$(date +%Y.%m.%d_%H-%M-%S).tar.gz"
fi

echo "Tworzenie archiwum"
tar -czvf "$DEST_ABS/$FILE_NAME" -C "$SRC_ABS" .

COUNT=$(ls ${DEST_ABS}/backup_*.tar.gz | wc -l)

if [[ COUNT -ge RETENTION+1 ]]; then
	echo -e "Usuwanie:\n$(ls -t $DEST_ABS/backup_*.tar.gz | tail -n +$((RETENTION + 1)))"
	ls -t "$DEST_ABS"/backup_*.tar.gz | tail -n +$((RETENTION + 1)) | xargs -d '\n' rm -f
fi

echo "Ok"
