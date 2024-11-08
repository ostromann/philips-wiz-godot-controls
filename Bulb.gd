extends CharacterBody2D

@export var IPAdress : String = "192.168.0.47"
var port : int = 38899
@export var next_color : Color

var current_color : Color
var light_on : bool
var packet_peer = PacketPeerUDP.new()

var is_dragging : bool = false
signal toggle_drag;

func _ready() -> void:
	packet_peer.connect_to_host(IPAdress, port)
	send_command_get_state()

func _process(delta: float) -> void:
	var last_packet = packet_peer.get_packet()
	if last_packet:
		var received_data = read_json_string(last_packet.get_string_from_ascii())
		if received_data:
			if received_data.method == "getPilot":
				current_color = get_color(received_data.result)
				$ColorPolygon.color = current_color
	
	if is_dragging:
		self.position = get_viewport().get_mouse_position()

func _toggle_drag():
	print("toggle dragging")
	
func get_color(data : Dictionary) -> Color:
	if data.has("r") and data.has("g") and data.has("b") and data.has("dimming"):
		return Color(data.r / 255, data.g / 255, data.b /255, dimming_to_value(data.dimming) / 255)
	return Color.BLACK
	
# Converts from Wiz dimming value (11–98) to HSV V (0–255)
func dimming_to_value(dimming: int) -> int:
	dimming = clamp(dimming, 11, 98)
	return int((dimming - 11) / (98 - 11) * 255)

# Converts from HSV V (0–255) to Wiz dimming value (11–98)
func value_to_dimming(value: int) -> int:
	value = clamp(value, 0, 255)
	return int(value / 255 * (98 - 11) + 11)

		
func read_json_string(json_string : String):
	# Retrieve data
	var json = JSON.new()
	var error = json.parse(json_string)
	if error == OK:
		var data_received = json.data
		return data_received
	else:
		print("JSON Parse Error: ", json.get_error_message(), " in ", json_string, " at line ", json.get_error_line())
		return null

func send_command_get_state():
	var command = '{"method":"getPilot","params":{}}'
	packet_peer.put_packet(command.to_ascii_buffer())

func send_command_light_off():
	#print(IPAdress, " light off")
	var command = '{"id":1,"method":"setState","params":{"state":false}}'
	packet_peer.put_packet(command.to_ascii_buffer())
	
func send_command_light_on():
	#print(IPAdress, " light on")
	var command = '{"id":1,"method":"setState","params":{"state":true}}'
	packet_peer.put_packet(command.to_ascii_buffer())

func send_command_light_rgb(color : Color):
	var dimming = clamp(color.a * 99, 80, 99)
	var red = clamp(color.r * 255, 0, 255)
	var green = clamp(color.g * 255, 0, 255)
	var blue = clamp(color.b * 255, 0, 255)
	
	var command = '{"id":1,"method":"setPilot","params":{"r":%d,"g":%d,"b":%d,"dimming":%d}}' % [red, green, blue, dimming]
	packet_peer.put_packet(command.to_ascii_buffer())
	current_color = color


func _on_color_update_cooldown_timeout() -> void:
	var command = '{"method":"getPilot","params":{}}'
	packet_peer.put_packet(command.to_ascii_buffer())
	
	if next_color:
		send_command_light_rgb(next_color)

func _on_input_event(viewport: Node, event: InputEvent, shape_idx: int) -> void:
	print("Received event!")
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
			emit_signal("toggle_drag")
		elif event.button_index == MOUSE_BUTTON_LEFT and !event.pressed:
			emit_signal("toggle_drag")
	elif event is InputEventScreenDrag:
		pass

func _on_toggle_drag() -> void:
	is_dragging = !is_dragging
