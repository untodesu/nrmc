#!/bin/sh

verbose_copy() {
    >&2 printf "copying %s to %s\n" "${1}" "${2}"
    cp "${1}" "${2}"
}

INSTALL_BIN="/usr/bin"
verbose_copy msmu-create    "${INSTALL_BIN}"
verbose_copy msmu-config    "${INSTALL_BIN}"
verbose_copy msmu-send      "${INSTALL_BIN}"
verbose_copy msmu-start     "${INSTALL_BIN}"
verbose_copy msmu-stop      "${INSTALL_BIN}"

>&2 printf "\033[1;32;92minstall done!\033[0m\n"
exit 0
