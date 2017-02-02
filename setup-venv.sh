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
popd >> /dev/null

echo ""
echo "---------------------------------------------------------"
echo "Activate the new DataNode virtualenv with:"
echo ""
echo "source ./local-venv.sh"
echo ""

exit 0
