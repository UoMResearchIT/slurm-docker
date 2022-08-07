# Slurm Docker

This repository defines a Docker environment for running the
[Slurm](https://slurm.schedmd.com) scheduler.

## Features

- Runs a Slurm controller, a Slurm daemon, and an ssh server in a
  single container

- Creates a user called "user" who can log in with ssh using a password

- The password is automatically generated and echoed to standard
  output when the container is started

- The "compute node" represented by the Slurm daemxon is configured to
  have a single socket with a single core

## Requirements

- Docker
- Docker Compose

## Quick start

- Bring up the docker-compose stack:
  ```
  docker-compose up -d
  ```
  Check the logs with
  ```
  docker-compose logs
  ```
  and read out the user's password from the start of the log.  It should appear as
  ```
  slurm_1  | Set password for 'user' to 'lav8IeGheuch'
  ```
  but with a different randomly-generated password on each run.
- Log in via ssh:
  ```
  ssh -p 2022 user@localhost
  ```
- Change to the scratch directory (which is a persistent volume):
  ```
  cd /scratch/user
  ```
- Submit a test job:
  ```
  sbatch /usr/share/slurm-examples/testjob.sh
  ```
- Check the output file:
  ```
  cat testjob_*.log
  ```
  The suffix in the log file name is the job ID, so will change for each new job.
- If the log file says "Hello World!", then everything is working!
