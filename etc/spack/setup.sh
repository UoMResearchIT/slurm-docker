#!/bin/bash

set -eu

envname="default"
envpath="/cluster/software/envs/$envname"

if [ ! -d "$envpath" ]; then
    spack env create $envname /opt/spack/envs/$envname/spack.lock
else
    cp -a /opt/spack/envs/$envname/spack.{lock,yaml} /cluster/software/envs/$envname/    
fi

spack env activate $envname
spack concretize
spack install
