#!/bin/bash

curpip=pip2

if [[ -e /venv/bin/pip ]]; then
    curpip=/venv/bin/pip
fi

echo "Installing newest pip"
${curpip} install --upgrade pip && ${curpip} install --upgrade setuptools
echo ""

echo "Listing current pips"
${curpip} list --format=columns
echo ""

echo "Installing pyxattr manually due to the -O2/-03 issue that is still in the 0.5.5 conda build: https://github.com/iustin/pyxattr/issues/13"
mkdir -p -m 777 /tmp/python2
pushd /tmp/python2
git clone https://github.com/iustin/pyxattr.git /tmp/python2/pyxattr
${curpip} install /tmp/python2/pyxattr
last_status="$?"
if [[ "${last_status}" != "0" ]]; then
    echo "Failed to install Primary Python 2 requirement: pyxattr"
    exit 1 
fi
popd

${curpip} install --upgrade Cython
${curpip} install --upgrade numpy==1.12.1rc1
${curpip} install --upgrade scipy==0.19.0

numpips=$(cat /opt/python2/primary-requirements.txt | wc -l)
if [[ "${numpips}" != "0" ]]; then
    echo "Installing Primary set of pips(${numpips})"
    ${curpip} install --upgrade -r /opt/python2/primary-requirements.txt
    last_status="$?"
    if [[ "${last_status}" != "0" ]]; then
        echo "Failed to install Primary Python 2 requirements"
        exit 1
    fi
fi

numpips=$(cat /opt/python2/secondary-requirements.txt | wc -l)
if [[ "${numpips}" != "0" ]]; then
    echo "Installing Secondary set of pips(${numpips})"
    ${curpip} install --upgrade -r /opt/python2/secondary-requirements.txt
    last_status="$?"
    if [[ "${last_status}" != "0" ]]; then
        echo "Failed to install Secondary Python 2 requirements"
        exit 1
    fi
fi

numpips=$(cat /opt/python2/tertiary-requirements.txt | wc -l)
if [[ "${numpips}" != "0" ]]; then
    echo "Installing Ternary set of pips(${numpips})"
    ${curpip} install --upgrade -r /opt/python2/tertiary-requirements.txt
    last_status="$?"
    if [[ "${last_status}" != "0" ]]; then
        echo "Failed to install Ternary Python 2 requirements"
        exit 1 
    fi
fi

echo "Installing custom pips that are in development"
${curpip} install --upgrade git+https://github.com/pydata/pandas-datareader.git

echo "Installing Tensorflow"
/opt/python2/install_tensorflow.sh
last_status="$?"
if [[ "${last_status}" != "0" ]]; then
    echo "Failed to install Python 2: tensorflow"
    exit 1 
fi

echo "Listing updated version of installed pips:"
${curpip} list --format=columns
echo ""

exit 0
