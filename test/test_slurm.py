import subprocess
import sys

def test_sinfo():
    result = subprocess.run(["sinfo", "--noheader", "--Format=Partition,Available"], check=True, capture_output=True)
    assert result.stdout.decode().strip().split() == ["compute*", "up"]

def test_srun_serial():
    result = subprocess.run(["srun", "--ntasks=1", "bash", "-c", "echo $SLURM_NTASKS"], check=True, capture_output=True)
    assert result.stdout.decode().strip() == "1"

def test_srun_parallel():
    result = subprocess.run(["srun", "--ntasks=2", "bash", "-c", "echo $SLURM_NTASKS"], check=True, capture_output=True)
    assert result.stdout.decode().strip() == "2\n2"

def test_salloc_mpirun_ntasks_1():
    result = subprocess.run(["salloc", "--quiet", "--ntasks=1", "bash", "-c",
        "module load openmpi; mpirun -np 1 hostname"], check=True, capture_output=True)
    assert result.stdout.decode().strip() == "cluster"
    
def test_salloc_mpirun_ntasks_2():
    result = subprocess.run(["salloc", "--quiet", "--ntasks=2", "bash", "-c",
        "module load openmpi; mpirun -np 2 hostname"], check=True, capture_output=True)
    assert result.stdout.decode().strip() == "cluster\ncluster"

def test_salloc_mpirun_ntasks_1_try_2():
    result = subprocess.run(["salloc", "--quiet", "--ntasks=1", "bash", "-c",
        "module load openmpi; mpirun -np 2 hostname"], check=False, capture_output=True)
    assert result.returncode == 1
    assert "There are not enough slots available in" in result.stderr.decode().strip()
    
def test_salloc_mpirun_ntasks_2_helloworld():
        result = subprocess.run(["salloc", "--quiet", "--ntasks=2", "bash", "-c",
            "set -e; module load openmpi; mpicc -o mpi_hello_world mpi_hello_world.c; mpirun mpi_hello_world"], check=False, capture_output=True)
        if result.returncode != 0:
            print(result.stderr.decode(), file=sys.stderr)
        
        assert(result.returncode == 0)
        assert sorted(result.stdout.decode().strip().splitlines()) == ["0 of 2", "1 of 2"]
