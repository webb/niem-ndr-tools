
if test is-set != "${LOADED_COMMON_BASH:+is-set}"
then LOADED_COMMON_BASH=true

    COMMAND_REL=$0
    COMMAND_NAME=$(basename "$COMMAND_REL")
    COMMAND_ABS=$(cd "$(dirname "$COMMAND_REL")"; pwd)/$COMMAND_NAME

fi

