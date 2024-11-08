extends Node

var queued_color: Color = Color.WHEAT
var ips = [
	"192.168.0.38", # kitchen 2
	"192.168.0.41", # kitchen 1
	"192.168.0.47", # bar 1
	"192.168.0.48", # bar 2
]

@onready var BULB = preload("res://Bulb.tscn")

@export var amplitude : float = 1.0
@export var speed : float = 0.2
@export var noisemap_dimming : FastNoiseLite
@export var noisemap_r : FastNoiseLite
@export var noisemap_g : FastNoiseLite
@export var noisemap_b : FastNoiseLite

@export var influence_r : FastNoiseLite
@export var influence_g : FastNoiseLite
@export var influence_b : FastNoiseLite


var time : float = 0.0

func _ready():
	
	pass

# Example: you can trigger these functions from UI buttons or other events
func _process(delta: float):
	self.time += self.speed

		
	for bulb in $Bulbs.get_children():
		var new_color = Color.WHITE
		var x = bulb.position.x
		var y = bulb.position.y
		var z = self.time
		
		var influence_r_value = (influence_r.get_noise_3d(x, y, z) + 1) / 2 * amplitude * queued_color.r
		var influence_g_value = (influence_g.get_noise_3d(x, y, z) + 1) / 2 * amplitude * queued_color.g
		var influence_b_value = (influence_b.get_noise_3d(x, y, z) + 1) / 2 * amplitude * queued_color.b
		
		
		new_color.r = (noisemap_r.get_noise_3d(x, y, z) + 1) / 2 * amplitude * influence_r_value
		new_color.g = (noisemap_g.get_noise_3d(x, y, z) + 1) / 2 * amplitude * influence_g_value
		new_color.b = (noisemap_b.get_noise_3d(x, y, z) + 1) / 2 * amplitude * influence_b_value
		new_color.a = (noisemap_dimming.get_noise_3d(x, y, z) + 1) / 2 * amplitude * queued_color.a
		new_color.a = clamp(new_color.a, 0.99, 1.0)
		bulb.next_color = new_color



func set_color(color):
	$BackgroundColorRect.color = color
	for bulb in $Bulbs.get_children():
		bulb.send_command_light_rgb(color)
	$ColorUpdateCooldown.start()
	
func _on_turn_on_button_pressed() -> void:
	for bulb in $Bulbs.get_children():
		bulb.send_command_light_on()
	
func _on_turn_off_button_pressed() -> void:
	for bulb in $Bulbs.get_children():
		bulb.send_command_light_off()

func _on_color_picker_button_color_changed(color: Color) -> void:	
	queued_color = color
	$QueuedColorRect.color = color
		

func _on_speed_slider_drag_ended(value_changed: bool) -> void:
	print("Setting speed to ", value_changed)
	speed = value_changed
