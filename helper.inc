
# -------------------------------
debug(){
    local __msg="$@"
    echo " [DEBUG] `date` ... $__msg "
}
info(){
    local __msg="$@"
    echo " [INFO]  `date` ->>> $__msg "
}
warn(){
    local __msg="$@"
    echo " [WARN]  `date` *** $__msg "
}
err(){
    local __msg="$@"
    echo " [ERR]   `date` !!! $__msg "
}

# ---------- CONSTANTS ----------
export FILE_VARIABLES=${FILE_VARIABLES:-".variables"}
export FILE_LOCAL_VARIABLES=${FILE_LOCAL_VARIABLES:-".local_variables"}
export FILE_SECRETS=${FILE_SECRETS:-".secrets"}
export DEFAULT_TFVARS_FILE="main.tfvars"
# -------------------------------
if [ ! -f "$this_folder/$FILE_VARIABLES" ]; then
  warn "we DON'T have a $FILE_VARIABLES variables file"
else
  . "$this_folder/$FILE_VARIABLES"
fi

if [ ! -f "$this_folder/$FILE_LOCAL_VARIABLES" ]; then
  warn "we DON'T have a $FILE_LOCAL_VARIABLES local variables file"
else
  . "$this_folder/$FILE_LOCAL_VARIABLES"
fi

if [ ! -f "$this_folder/$FILE_SECRETS" ]; then
  warn "we DON'T have a $FILE_SECRETS secrets file"
else
  . "$this_folder/$FILE_SECRETS"
fi

# --- COMMON FUNCTION SECTION ---
add_entry_to_variables()
{
  info "[add_entry_to_variables|in] ($1, $2)"
  [ -z "$1" ] && err "no parameters provided" && return 1

  variables_file="${this_folder}/${FILE_VARIABLES}"

  if [ -f "$variables_file" ]; then
    sed -i '' "/export $1/d" "$variables_file"

    if [ ! -z "$2" ]; then
      echo "export $1=$2" | tee -a "$variables_file" > /dev/null
    fi
  fi
  info "[add_entry_to_variables|out]"
}

add_entry_to_secrets()
{
  info "[add_entry_to_secrets|in] ($1, ${2:0:7})"
  [ -z "$1" ] && err "no parameters provided" && return 1

  secrets_file="${this_folder}/${FILE_SECRETS}"

  if [ -f "$secrets_file" ]; then
    sed -i '' "/export $1/d" "$secrets_file"

    if [ ! -z "$2" ]; then
      echo "export $1=$2" | tee -a "$secrets_file" > /dev/null
    fi
  fi
  info "[add_entry_to_secrets|out]"
}

verify_prereqs(){
  info "[verify_prereqs] ..."
  for arg in "$@"
  do
      debug "[verify_prereqs] ... checking $arg"
      which "$arg" 1>/dev/null
      if [ ! "$?" -eq "0" ] ; then err "[verify_prereqs] please install $arg" && return 1; fi
  done
  info "[verify_prereqs] ...done."
}

verify_env(){
  info "[verify_env] ..."
  for arg in "$@"
  do
      debug "[verify_env] ... checking $arg"
      if [ -z "$arg" ]; then err "[verify_env] please define env var: $arg" && return 1; fi
  done
  info "[verify_env] ...done."
}

infraOn(){
  info "[infraOn|in] ($1)"
  
  tfvars_file="$DEFAULT_TFVARS_FILE"
  if [ ! -z "$1" ]; then
    tfvars_file="$1"
  fi

  terraform init
  terraform plan -var-file="$tfvars_file"
  terraform apply -auto-approve -lock=true -lock-timeout=10m -var-file="$tfvars_file"
  info "[infraOn|out]"
}

infraOff(){
  info "[infraOff|in] ($1)"

  tfvars_file="$DEFAULT_TFVARS_FILE"
  if [ ! -z "$1" ]; then
    tfvars_file="$1"
  fi

  terraform init
  terraform destroy -auto-approve -lock=true -lock-timeout=10m -var-file="$tfvars_file"
  info "[infraOff|out]"
}
