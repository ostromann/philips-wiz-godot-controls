extends "res://bulbs/bulb_template.gd"

@export var IPAdress : String = "192.168.0.47"
const port : int = 38899

var packet_peer = PacketPeerUDP.new()

func _ready() -> void:
	packet_peer.connect_to_host(IPAdress, port)

func _process(delta):
	super._process(delta)
	
	new_state_data = packet_peer.get_packet()
	if len(new_state_data) > 0:
		has_new_state = true
		

func _update_state(state_data):
	if len(state_data) > 0:
		var received_data = _read_json_string(state_data.get_string_from_ascii())
		if received_data:
			if received_data.method == "getPilot":
				# Set current color
				current_color = get_color(received_data.result)
				
				# Set current toggle
				is_on = received_data.result.state
				$ToggleLightButton.set_pressed_no_signal(is_on)
				$ToggleLightButton.disabled = false
		
	state_data = null

func _read_json_string(json_string : String):
	# Retrieve data
	var json = JSON.new()
	var error = json.parse(json_string)
	if error == OK:
		var data_received = json.data
		return data_received
	else:
		print("JSON Parse Error: ", json.get_error_message(), " in ", json_string, " at line ", json.get_error_line())
		return null


func get_color(data : Dictionary) -> Color:
	if data.has("r") and data.has("g") and data.has("b") and data.has("dimming"):
		return Color(data.r / 255, data.g / 255, data.b /255, dimming_to_value(data.dimming))
	return Color.BLACK
	
# Converts from Wiz dimming value (11–98) to alpha value (0.0 - 1.0)
func dimming_to_value(dimming: int) -> float:
	var min_val = 11
	var max_val = 98
	dimming = clamp(dimming, min_val, max_val)
	
	var alpha_val = float(dimming - min_val) / float(max_val - min_val)
	
	return alpha_val

# Converts from alpha value (0.0 - 1.0) to Wiz dimming value (11–98)
func value_to_dimming(value: float) -> int:
	var min_val = 11
	var max_val = 98
	
	value = clamp(value, 0.0, 1.0)
	return int(value * ( max_val - min_val) + min_val)
	
func get_state():
	var command = '{"method":"getPilot","params":{}}'
	packet_peer.put_packet(command.to_ascii_buffer())

func turn_off() -> void:
	var command = '{"id":1,"method":"setState","params":{"state":false}}'
	print(IPAdress, " Turn off ", command)
	packet_peer.put_packet(command.to_ascii_buffer())

func turn_on() -> void:
	var command = '{"id":1,"method":"setState","params":{"state":true}}'
	print(IPAdress, " Turn on ", command)
	packet_peer.put_packet(command.to_ascii_buffer())

func _set_color(color : Color) -> void:
	var dimming = int(clamp(color.a * 98, 11, 98))
	var red = int(clamp(color.r * 255, 0, 255))
	var green = clamp(color.g * 255, 0, 255)
	var blue = int(clamp(color.b * 255, 0, 255))
	
	var command = '{"id":1,"method":"setPilot","params":{"r":%d,"g":%d,"b":%d,"dimming":%d}}' % [red, green, blue, dimming]
	print(IPAdress, " setRGB ", command)
	packet_peer.put_packet(command.to_ascii_buffer())

func _on_get_state_timer_timeout() -> void:
	get_state()
