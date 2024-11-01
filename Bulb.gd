extends Node

@export var IPAdress : String = "192.168.0.47"
@onready var AUTO_KILL_PROCESS = preload("res://AutoKillProcess.tscn")

func _process(delta: float) -> void:
	if $Processes.get_child_count() > 0:
		$ProcessCount.text = str($Processes.get_child_count())
	else:
		$ProcessCount.text = "..."
	

func create_auto_kill_process(command, arguments):
	var pid = OS.create_process(command, arguments)
	var process = AUTO_KILL_PROCESS.instantiate()
	process.pid = pid
	$Processes.add_child(process)

func set_light_off():
	create_auto_kill_process('send_light_off_command.bat', [IPAdress])
	$ColorPolygon.color = Color.BLACK
	
func set_light_on():
	create_auto_kill_process('send_light_on_command.bat', [IPAdress])
	$ColorPolygon.color = Color.WHITE

func set_light_rgb(color : Color):
	var dimming = clamp(color.a * 99, 80, 99)
	var red = clamp(color.r * 255, 0, 255)
	var green = clamp(color.g * 255, 0, 255)
	var blue = clamp(color.b * 255, 0, 255)
	
	create_auto_kill_process('send_light_command.bat', [red, green, blue, dimming, IPAdress])
	$ColorPolygon.color = color
