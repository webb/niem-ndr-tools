
if [[ is-set != "${NDR_TOOLS_LOADED_FN_TEST_BASH:+is-set}" ]]
then NDR_TOOLS_LOADED_FN_TEST_BASH=true

    set -o nounset -o errexit

    . "$(dirname "${BASH_SOURCE[0]}")"/common.bash
    . "$NDR_TOOLS_ROOT_DIR"/lib/temp.bash
    . "$NDR_TOOLS_ROOT_DIR"/lib/fn_opt_verbose.bash

    temp_make_file NDR_TOOLS_TEST_EXPECTED_STDOUT NDR_TOOLS_TEST_ACTUAL_STDOUT NDR_TOOLS_TEST_ACTUAL_STDOUT_CLEAN NDR_TOOLS_TEST_DIFF_OUT

    NDR_TOOLS_TEST_RESULT=0
    
    test_run () {
        local OPTIND=1 OPTION PREFIX=""
        while getopts p: OPTION
        do
            case "$OPTION" in
                p ) PREFIX="$OPTARG"
            esac
        done
        shift $((OPTIND-1))
        local n=${#BASH_SOURCE[@]}
        if is_verbose; then
            printf "# test_run\n"
            printf "#   called from %s:%d\n" "${BASH_SOURCE[n - 1]}" "${BASH_LINENO[n - 2]}"
            printf "# "
            printf " %q" "$@"
            printf "\n"
        fi
        if ! "$@" > "$NDR_TOOLS_TEST_ACTUAL_STDOUT"
        then NDR_TOOLS_TEST_RESULT=1
            return
        fi
        cut -d : -f 1,2,3 "$NDR_TOOLS_TEST_ACTUAL_STDOUT" \
            | sort -t : -k 1n,1 -k 3,3 -k 2,2 > "$NDR_TOOLS_TEST_ACTUAL_STDOUT_CLEAN"
        if ! diff "$NDR_TOOLS_TEST_EXPECTED_STDOUT" "$NDR_TOOLS_TEST_ACTUAL_STDOUT_CLEAN" > "$NDR_TOOLS_TEST_DIFF_OUT"
        then NDR_TOOLS_TEST_RESULT=1
            printf "Diff result:\n  command: %s\n" "$*"
            cat "$NDR_TOOLS_TEST_DIFF_OUT"
        fi
    }

    test_set_stdout () {
        cat > "$NDR_TOOLS_TEST_EXPECTED_STDOUT"
    }

    test_fail () {
        printf "Test failed: %s\n" "$*"
        NDR_TOOLS_TEST_RESULT=1
    }

    test_exit () {
        exit "$NDR_TOOLS_TEST_RESULT"
    }
    
fi

