# Slurm Docker

This repository defines a Docker environment for running the
[Slurm](https://slurm.schedmd.com) scheduler.  It has the following
features:

- Runs a Slurm controller, a Slurm daemon, and an ssh server in a
  single container

- Creates a user called "user" who can log in with ssh using a password

- The password is automatically generated and echoed to standard
  output when the container is started

- The "compute node" represented by the Slurm daemon is configured to
  have a single socket with a single core
