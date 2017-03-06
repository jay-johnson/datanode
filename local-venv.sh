# This assumes the bash source command is running from the repo's base dir

if [[ "${ENV_DATANODE_REPO}" == "" ]]; then
    export ENV_DATANODE_REPO=$(pwd)
fi

if [[ "${ENV_DEPLOYMENT_TYPE}" == "" ]]; then
    export ENV_DEPLOYMENT_TYPE=Local
fi

export ENV_CL_ENV_DIR=${ENV_DATA_NODE_REPO}/env

export ENV_SCP_VENV_BASE_DIR="."
export ENV_SCP_VENV_NAME="dn-dev"
export ENV_SCP_VENV_PATH="${ENV_SCP_VENV_BASE_DIR}/${ENV_SCP_VENV_NAME}"
export ENV_SCP_VENV_BIN="${ENV_SCP_VENV_PATH}/bin"
export ENV_SCP_VENV_ACTIVATE="${ENV_SCP_VENV_BIN}/activate"
export ENV_SCP_VENV_DEACTIVATE="${ENV_SCP_VENV_BIN}/deactivate"
if [[ -e ${ENV_SCP_VENV_ACTIVATE} ]]; then
    source $ENV_SCP_VENV_ACTIVATE .
else
    echo "Did not find DataNode VirtualEnv At Path(${ENV_SCP_VENV_ACTIVATE}). Please install it with: datanode $ ./setup-venv.sh"
fi

