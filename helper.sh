#!/usr/bin/env bash

# ===> COMMON SECTION START  ===>
# http://bash.cumulonim.biz/NullGlob.html
shopt -s nullglob

if [ -z "$this_folder" ]; then
  this_folder="$(cd "$(dirname "${BASH_SOURCE[0]}")" >/dev/null 2>&1 && pwd)"
  if [ -z "$this_folder" ]; then
    this_folder=$(dirname $(readlink -f $0))
  fi
fi
parent_folder=$(dirname "$this_folder")

. "$this_folder/helper.inc"
# -------------------------------
# --- FUNCTIONS SECTION ---

commands() {
  cat <<EOM
        commands:
              start dev server:                         hugo server -D
              build static pages:                       hugo -D
EOM
}

prereqs()
{
    info "[prereqs|in]"

    which az
    return_value=$?
    if [[ ! "$return_value" -eq "0" ]]; then
        err "[prereqs] please install azure cli: https://learn.microsoft.com/en-us/cli/azure/install-azure-cli-macos"
        exit 1
    fi

    which terraform
    return_value=$?
    if [[ ! "$return_value" -eq "0" ]]; then
        err "[prereqs] please install terraform: https://developer.hashicorp.com/terraform/tutorials/aws-get-started/install-cli"
        exit 1
    fi

    which hugo
    return_value=$?
    if [[ ! "$return_value" -eq "0" ]]; then
        err "[prereqs] please install hugo: https://gohugo.io/installation/macos/"
        exit 1
    fi


    info "[prereqs|out]"
}

# -------------------------------
# --- MAIN SECTION ---

usage() {
  cat <<EOM
      usages:
        $(basename $0) {commands}
            commands              : show useful commands
            prereqs               : check development requirements
EOM
}

info "starting [ $0 $1 $2 $3 $4 ] ..."
_pwd=$(pwd)

case "$1" in
commands)
  commands
  ;;
prereqs)
  prereqs
  ;;
*)
  usage
  ;;
esac
info "...[ $0 $1 $2 $3 $4 ] done."