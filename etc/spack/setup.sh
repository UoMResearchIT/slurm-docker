#!/bin/bash

set -eu

source $SPACK_ROOT/share/spack/setup-env.sh

envname="default"
envpath="/cluster/software/envs/$envname"

if [ ! -d "$envpath" ]; then
    spack env create $envname /opt/spack/envs/$envname/spack.lock
else
    cp -a /opt/spack/envs/$envname/spack.{lock,yaml} /cluster/software/envs/$envname/    
fi

spack env activate $envname
#spack concretize --force # this is a bit dangerous, but needed at the moment
spack install
spack module tcl refresh -y
