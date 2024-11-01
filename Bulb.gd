extends Node

@export var IPAdress : String = "192.168.0.47"
@onready var AUTO_KILL_PROCESS = preload("res://AutoKillProcess.tscn")

func create_auto_kill_process(command, arguments):
	var pid = OS.create_process(command, arguments)
	var process = AUTO_KILL_PROCESS.instantiate()
	process.pid = pid
	return process

func set_light_off() -> Node:
	var process = create_auto_kill_process('send_light_off_command.bat', [IPAdress])
	$ColorPolygon.color = Color.BLACK
	return process
	
func set_light_on() -> Node:
	var process = create_auto_kill_process('send_light_on_command.bat', [IPAdress])
	$ColorPolygon.color = Color.WHITE
	return process

func set_light_rgb(color : Color) -> Node:
	print("Setting light rgb ", IPAdress)
	var dimming = clamp(color.a * 89, 1, 89) + 10
	var red = clamp(color.r * 255, 0, 255)
	var green = clamp(color.g * 255, 0, 255)
	var blue = clamp(color.b * 255, 0, 255)
	
	
	var process = create_auto_kill_process('send_light_command.bat', [red, green, blue, dimming, IPAdress])
	$ColorPolygon.color = color
	
	return process
