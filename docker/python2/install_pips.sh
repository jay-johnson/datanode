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
pushd /opt/python2
git clone https://github.com/iustin/pyxattr.git pyxattr
${curpip} install ./pyxattr
popd

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

echo "Listing updated version of installed pips:"
${curpip} list --format=columns
echo ""

exit 0
