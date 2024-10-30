extends Node



var ncat_path = "C:/Program Files (x86)/Nmap/ncat.exe"
var queuedColor

@onready var AUTO_KILL_PROCESS = preload("res://AutoKillProcess.tscn")
@onready var BULB = preload("res://Bulb.tscn")

func _ready():
	pass


# Example: you can trigger these functions from UI buttons or other events
func _process(delta: float):
	$PidList.clear()
	for process in $Processes.get_children():
		$PidList.add_item(str(process.pid))

func create_auto_kill_process(command, arguments):
	var pid = OS.create_process(command, arguments)
	var process = AUTO_KILL_PROCESS.instantiate()
	process.pid = pid
	$Processes.add_child(process)

func set_light_off(ip: String = "192.168.0.47"):
	create_auto_kill_process('send_light_off_command.bat', [ip])
	
func set_light_on(ip: String = "192.168.0.47"):
	create_auto_kill_process('send_light_on_command.bat', [ip])

func set_light_rgb(ip: String = "192.168.0.47", red: int = 255, green: int = 255, blue: int = 255, dimming: int = 75) -> void:
	dimming = clamp(dimming, 11, 99)
	red = clamp(red, 0, 255)
	green = clamp(green, 0, 255)
	blue = clamp(blue, 0, 255)
	
	create_auto_kill_process('send_light_command.bat', [red, green, blue, dimming, ip])
	$ColorUpdateCooldown.start()

func set_color(color):
	$ColorRect.color = color
	set_light_rgb("192.168.0.47", int(color.r*255), int(color.g*255), int(color.b*255), 75)
	queuedColor = null
	
func _on_turn_on_button_pressed() -> void:
	set_light_on()
	
func _on_turn_off_button_pressed() -> void:
	set_light_off()

func _on_color_picker_button_color_changed(color: Color) -> void:	
	queuedColor = color

func _on_color_update_cooldown_timeout() -> void:
	if queuedColor:
		set_color(queuedColor)
		
