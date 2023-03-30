#!/bin/sh

verbose_rm() {
    >&2 printf "removing %s\n" "${1}"
    rm "${1}"
}

INSTALL_BIN="/usr/bin"
verbose_rm "${INSTALL_BIN}/msmu-create"
verbose_rm "${INSTALL_BIN}/msmu-config"
verbose_rm "${INSTALL_BIN}/msmu-send"
verbose_rm "${INSTALL_BIN}/msmu-start"
verbose_rm "${INSTALL_BIN}/msmu-stop"

>&2 printf "\033[1;32;92muninstall done!\033[0m\n"
exit 0
