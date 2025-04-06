#!/usr/bin/env bash
echo Starting FastSD CPU please wait...
[[ ( -n "${BASEDIR}" ) && ( -d "${BASEDIR}" ) ]] || BASEDIR="$(pwd)"
[[ ( -n "${PYTHON_COMMAND}" ) && ( -x "${PYTHON_COMMAND}" ) ]] || PYTHON_COMMAND="$(which python3 || which python)"

for args in ${@}
    do case ${args} in
        --python=*)
            [ -x "${args/--python=}" ] && {
                PYTHON_COMMAND="${args/--python=}"
            } || {
                echo "\"${args/--python=}\" Not a vaild Value."
                read -p "Do you want to Continue With ${PYTHON_COMMAND}?\n(y/N) > " choise
                [ "${choise@U}" -eq "Y" ] continue
                echo "[Error] Wrong Python executable file was given" 1>&2
                exit 127
            }
        ;;
        --dir=*)
            [ -d "${args/--dir=}" ] && {
                BASEDIR="${args/--dir=}"
            } || {
                echo "\"${args/--dir=}\" Not a vaild Value."
                read -p "Do you want to Continue With ${BASEDIR}?\n(y/N) > " choise
                [ "${choise@U}" -eq "Y" ] continue
                echo "[Error] Wrong Working Directory was given" 1>&2
                exit 128
            }
        ;;
    esac
done

python_version_string=($(${PYTHON_COMMAND} --version 2>&1 | head -n1))
[ "${python_version_string[0]}" -eq "Python" ] && {
    echo "Found $PYTHON_COMMAND command"
    python_version="${python_version_string[1]}"
    echo "Python version : ${python_version}"
} || {
    echo "[Error] Wrong Python executable file was given" 1>&2
    exit 127
}
echo "Base Dir : ${BASEDIR}"
ACTIVATE_SCRIPT="$( find "${BASEDIR}" -name 'activate' -type f | head -n1 )"
[[ ( -z "${ACTIVATE_SCRIPT}" ) && ( -x "${ACTIVATE_SCRIPT}" ) ]] && {
# shellcheck disable=SC1091
source "${BASEDIR}/env/bin/activate"
${PYTHON_COMMAND} src/app.py --gui
} || echo "[Error] Can't find venv activate script in Working Directory \"${BASEDIR}\""
exit 129
