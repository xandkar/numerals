#! /bin/bash

binary() {
    for i in `seq 0 100`; do \
        [ $(echo "obase=2; $i" | bc) -eq $(./bin/binary $i) ] || exit 1;
    done
}

case "$1" in
    'binary' ) binary ;;
esac
