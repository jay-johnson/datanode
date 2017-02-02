export ENV_SCP_VENV_BASE_DIR="."
export ENV_SCP_VENV_NAME="dn-dev"
export ENV_SCP_VENV_PATH="${ENV_SCP_VENV_BASE_DIR}/${ENV_SCP_VENV_NAME}"
export ENV_SCP_VENV_BIN="${ENV_SCP_VENV_PATH}/bin"
export ENV_SCP_VENV_ACTIVATE="${ENV_SCP_VENV_BIN}/activate"
export ENV_SCP_VENV_DEACTIVATE="${ENV_SCP_VENV_BIN}/deactivate"
if [[ -e ${ENV_SCP_VENV_ACTIVATE} ]]; then
    source $ENV_SCP_VENV_ACTIVATE .
else
    echo "Did not find Scipype VirtualEnv At Path(${ENV_SCP_VENV_ACTIVATE}). Please install it with: scipype$ ./setup-new-dev.sh"
fi

