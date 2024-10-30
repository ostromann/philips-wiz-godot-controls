extends Node

var pid : int = -1



func _on_timeout_timeout() -> void:
	print("Time out!")
	if not pid == -1:
		if OS.is_process_running(pid):
			OS.kill(pid)
			print("Killing process with pid ", pid)
			queue_free()
		else:
			print("Process ", pid, " finished before timeout!")
			queue_free()
