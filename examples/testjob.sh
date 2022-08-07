#!/bin/bash

#SBATCH --job-name testjob
#SBATCH --ntasks 1
#SBATCH --output testjob_%j.log

set -eu
echo "Hello World!"
