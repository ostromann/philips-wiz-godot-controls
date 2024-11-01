extends Node

var pid : int = -1

func _process(delta: float) -> void:
	if OS.is_process_running(pid):
		queue_free()

func _on_timeout_timeout() -> void:
	if not pid == -1:
		if OS.is_process_running(pid):
			OS.kill(pid)
			print("Killing process with pid ", pid)
			queue_free()
