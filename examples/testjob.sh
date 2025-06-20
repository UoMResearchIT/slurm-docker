#!/bin/bash

#SBATCH --job-name testjob
#SBATCH --ntasks 1
#SBATCH --output testjob_%j.log

set -eu
echo "Hello World starting"
echo "Sleeping for 10 s"
sleep 10
echo "Finished"
