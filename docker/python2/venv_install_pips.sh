#!/bin/bash

curpip=pip2

echo "Installing newest pip"
${curpip} install --upgrade pip && ${curpip} install --upgrade setuptools
echo ""

echo "Listing current pips"
${curpip} list --format=columns
echo ""

echo "Installing pyxattr manually due to the -O2/-03 issue that is still in the 0.5.5 conda build: https://github.com/iustin/pyxattr/issues/13"
pushd ../../$ENV_SCP_VENV_PATH >> /dev/null
git clone https://github.com/iustin/pyxattr.git pyxattr
${curpip} install ./pyxattr
last_status="$?"
if [[ "${last_status}" != "0" ]]; then
    echo "Failed to install Secondary Python 2 requirement: pyxattr"
    exit 1
fi
popd >> /dev/null

${curpip} install --upgrade Cython
${curpip} install --upgrade numpy==1.12.1rc1
${curpip} install --upgrade scipy==0.19.0

numpips=$(cat ./primary-requirements.txt | wc -l)
if [[ "${numpips}" != "0" ]]; then
    echo "Installing Primary set of pips(${numpips})"
    ${curpip} install --upgrade -r ./primary-requirements.txt
    last_status="$?"
    if [[ "${last_status}" != "0" ]]; then
        echo "Failed to install Primary Python 2 requirements"
        exit 1
    fi
fi

numpips=$(cat ./secondary-requirements.txt | wc -l)
if [[ "${numpips}" != "0" ]]; then
    echo "Installing Secondary set of pips(${numpips})"
    ${curpip} install --upgrade -r ./secondary-requirements.txt
    last_status="$?"
    if [[ "${last_status}" != "0" ]]; then
        echo "Failed to install Secondary Python 2 requirements"
        exit 1
    fi
fi

numpips=$(cat ./tertiary-requirements.txt | wc -l)
if [[ "${numpips}" != "0" ]]; then
    echo "Installing Ternary set of pips(${numpips})"
    ${curpip} install --upgrade -r ./tertiary-requirements.txt
    last_status="$?"
    if [[ "${last_status}" != "0" ]]; then
        echo "Failed to install Ternary Python 2 requirements"
        exit 1 
    fi
fi

echo "Installing custom pips that are in development"
${curpip} install --upgrade git+https://github.com/pydata/pandas-datareader.git

echo "Installing Tensorflow"
./install_tensorflow.sh
last_status="$?"
if [[ "${last_status}" != "0" ]]; then
    echo "Failed to install Python 2: tensorflow"
    exit 1
fi

echo "Listing updated version of installed pips:"
${curpip} list --format=columns
echo ""

exit 0
