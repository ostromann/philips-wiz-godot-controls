extends Node

var queued_color: Color = Color.WHITE

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
func _process(_delta: float):
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
		bulb.set_color(new_color)



	
func _on_turn_on_button_pressed() -> void:
	for bulb in $Bulbs.get_children():
		bulb.turn_on()
	
func _on_turn_off_button_pressed() -> void:
	for bulb in $Bulbs.get_children():
		bulb.turn_off()

func _on_color_picker_button_color_changed(color: Color) -> void:	
	queued_color = color
	$QueuedColorRect.color = color
		

func _on_speed_slider_value_changed(value: float) -> void:
	speed = value
