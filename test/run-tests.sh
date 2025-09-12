#!/bin/bash
# 
# Run tests for slurm-docker
 
source /etc/profile 
cd /opt/test

if [ ! -r .venv ]; then
    python3 -m venv .venv
    source .venv/bin/activate
    pip install -r requirements.txt
else
    source .venv/bin/activate
    pip-compile
    pip-sync
fi

pytest
