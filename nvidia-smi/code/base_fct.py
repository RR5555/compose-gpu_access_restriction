import torch
import pynvml
from pynvml import NVMLError_DriverNotLoaded
import time
import os


def hello_world():
	print("Hello")

def cuda_dummy_load():
	a = torch.randn([1000, 1000]).cuda()
	time.sleep(10)
	print("Done")

def check_processes():
	for i in range(torch.cuda.device_count()):
		print(repr(torch.cuda.list_gpu_processes(i)))
		list_proc = {}
		s = torch.cuda.list_gpu_processes(i).splitlines()
		print(s[0])
		print(s[1])
		print(s[1:])
		if s[1]=="no processes are running":
			print(s[1])
		else:
			for _s in s[1:]:
				_s=_s.strip().split()
				print(_s[1])
				ns = os.popen(f"ps -aux | grep {_s[1]}")
				list_proc[_s[1]]=[_line for _line in ns.readlines() if _line.strip().split()[1]==str(_s[1])]
				ns.close()
		print(list_proc)

def check_processes2():
	for i in range(torch.cuda.device_count()):
		get_gpu_processes(i)


def get_gpu_processes(device):
	"""
	device:int
	"""
	try:
		pynvml.nvmlInit()
	except NVMLError_DriverNotLoaded:
		return "cuda driver can't be loaded, is cuda enabled?"
	device = torch.cuda._get_nvml_device_index(device)
	handle = pynvml.nvmlDeviceGetHandleByIndex(device)
	procs = pynvml.nvmlDeviceGetComputeRunningProcesses(handle)
	lines = []
	lines.append(f"GPU:{device}")
	if len(procs) == 0:
		lines.append("no processes are running")
	for p in procs:
		print(dir(p))
		print(p.computeInstanceId)
		print(p.gpuInstanceId)
		print(p.pid)

if __name__=="__main__":
	hello_world()
	a = torch.randn([1000, 1000]).cuda()
	check_processes()

