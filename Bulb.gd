extends Node

@export var IPAdress : String = "192.168.0.47"

var packet_peer = PacketPeerUDP.new()

func _ready() -> void:
	packet_peer.connect_to_host(IPAdress, 38899)
	set_light_off()

func set_light_off():
	print(IPAdress, " light off")
	var command = '{"id":1,"method":"setState","params":{"state":false}}'
	packet_peer.put_packet(command.to_ascii_buffer())
	$ColorPolygon.color = Color.BLACK
	
func set_light_on():
	print(IPAdress, " light on")
	var command = '{"id":1,"method":"setState","params":{"state":true}}'
	packet_peer.put_packet(command.to_ascii_buffer())
	$ColorPolygon.color = Color.WHITE

func set_light_rgb(color : Color):
	var dimming = clamp(color.a * 99, 80, 99)
	var red = clamp(color.r * 255, 0, 255)
	var green = clamp(color.g * 255, 0, 255)
	var blue = clamp(color.b * 255, 0, 255)
	
	var command = '{"id":1,"method":"setPilot","params":{"r":%d,"g":%d,"b":%d,"dimming":%d}}' % [red, green, blue, dimming]
	packet_peer.put_packet(command.to_ascii_buffer())
	$ColorPolygon.color = color
