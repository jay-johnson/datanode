#!/bin/bash

source ./docker/bash-common.sh .

venv="./dn-dev"

lg "Creating VirtualEnv(${venv})"

virtualenv ${venv}
last_status=$?
if [[ "${last_status}" != "0" ]]; then
    err "Creating VirtualEnv(${$venv}) Failed. Please confirm virtualenv is setup on this host"
    exit 1
fi

lg "Activating ${venv}/bin/activate"
source ${venv}/bin/activate

lg "Done Activating VirtualEnv"

lg "Install Python 2 Pips into VirtualEnv"
pushd ./docker/python2 >> /dev/null
./venv_install_pips.sh
last_status=$?
popd >> /dev/null

if [[ "${last_status}" != "0" ]]; then
    err "Creating VirtualEnv(${venv}) Failed. Please confirm virtualenv is setup on this host"
    exit 1
else
    lg ""
    lg "---------------------------------------------------------"
    amnt "Activate the new ${venv} virtualenv with:"
    lg ""
    good "source ./local-venv.sh"
    lg ""
fi

exit 0
