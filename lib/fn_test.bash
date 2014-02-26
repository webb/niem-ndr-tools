
if [[ is-set != "${LOADED_FN_TEST_BASH:+is-set}" ]]
then LOADED_FN_TEST_BASH=true

    if test is-set != "${NDR_ROOT_DIR:+is-set}"
    then printf "%s\n" 'Error: $NDR_ROOT_DIR not set' >&2
        exit 1
    fi

    test_begin () {
        TEST_EXPECTED_STDOUT=$(mktemp)
        TEST_ACTUAL_STDOUT=$(mktemp)
    }

    test_end () {
        rm -f "$TEST_EXPECTED_STDOUT" "$TEST_ACTUAL_STDOUT"
    }

    test_run () {
        printf "# test_run\n"
        printf "#   called from %s:%d\n" "${BASH_SOURCE[n - 1]}" "${BASH_LINENO[n - 2]}"
        printf "# "
        printf " %q" "$@"
        printf "\n"
        local OPTIND=1 OPTION PREFIX=""
        while getopts p: OPTION
        do
            case "$OPTION" in
                p ) PREFIX="$OPTARG"
            esac
        done
        shift $((OPTIND-1))
        local n=${#BASH_SOURCE[@]}
        "$@" > "$TEST_ACTUAL_STDOUT" || true
        diff "$TEST_EXPECTED_STDOUT" "$TEST_ACTUAL_STDOUT" || true
    }

    test_set_stdout () {
        cat > "$TEST_EXPECTED_STDOUT"
    }

    test_fail () {
        printf "Test failed: %s\n" "$*"
    }

    test_begin
    
    trap test_end 0

fi

