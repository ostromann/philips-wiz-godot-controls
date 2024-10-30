extends Node



var ncat_path = "C:/Program Files (x86)/Nmap/ncat.exe"

@onready var AUTO_KILL_PROCESS = preload("res://AutoKillProcess.tscn")
@onready var BULB = preload("res://Bulb.tscn")

func _ready():
	pass


# Example: you can trigger these functions from UI buttons or other events
func _process(delta: float):
	$PidList.clear()
	for process in $Processes.get_children():
		$PidList.add_item(str(process.pid))


func _on_turn_on_button_pressed() -> void:
	set_light_rgb()
	
func send_rgb_command():
	pass

func set_light_rgb(ip: String = "192.168.0.47", red: int = 255, green: int = 255, blue: int = 255, dimming: int = 100) -> void:
	dimming = clamp(dimming, 11, 100)
	red = clamp(red, 0, 255)
	green = clamp(green, 0, 255)
	blue = clamp(blue, 0, 255)
	
	
	# Create the JSON command for the lights
	var json_command = '{"id":1,"method":"setPilot","params":{"r":%d,"g":%d,"b":%d,"dimming":%d}}' % [red, green, blue, dimming]

	
	var ncat_path = "C:\\Program Files (x86)\\Nmap\\ncat.exe"
	var command = 'echo %s | "%s" -u -w 1 %s 38899' % [json_command, ncat_path, ip]
	#print(command)
	
	var exit_code = OS.execute("cmd", ["/c", command])

	if exit_code == OK:
		print("Command sent successfully!")
	else:
		print("Failed to send command, exit code:", exit_code)

func set_light_rgb_bat(ip: String = "192.168.0.47", red: int = 255, green: int = 255, blue: int = 255, dimming: int = 75) -> void:
	dimming = clamp(dimming, 11, 99)
	red = clamp(red, 0, 255)
	green = clamp(green, 0, 255)
	blue = clamp(blue, 0, 255)
	
	var command = 'send_light_command.bat %d %d %d %d %s' % [red, green, blue, dimming, ip]
	var pid = OS.create_process('send_light_command.bat', [red, green, blue, dimming, ip])
	var process = AUTO_KILL_PROCESS.instantiate()
	process.pid = pid
	$Processes.add_child(process)
	
	
	
	$ColorUpdateCooldown.start()

	print("created process ", pid)


func _on_color_picker_button_color_changed(color: Color) -> void:
	if $ColorUpdateCooldown.is_stopped():
		$ColorRect.color = color
		set_light_rgb_bat("192.168.0.47", int(color.r*255), int(color.g*255), int(color.b*255), 75)
