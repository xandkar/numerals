#! /bin/bash

binary() {
    printf "|\tN\t|\texpected\t|\tcomputed\t|\tstatus\t|\n";
    printf "|\t---\t|\t-----\t|\t-----\t|\t-----\t|\n";
    for i in `seq 0 100`; do
        expected=$(echo "obase=2; $i" | bc);
        computed=$(./bin/exe/binary $i);
        printf "| $i\t|\t$expected\t|\t$computed\t|\t";
        if ! [ $expected -eq $computed ]; then
            printf "FAIL\t|\n"
            exit 1;
        else
            printf "OK\t|\n"
        fi
    done
    exit 0;
}

case "$1" in
    'binary' ) binary | column -t ;;
esac
