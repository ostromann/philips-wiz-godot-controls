extends "res://draggable.gd"

@export var next_color : Array[Color]

var current_color : Color
var is_light_on : bool

func get_state():
	var state = send_command_get_state()
	return state

func turn_off() -> void:
	if is_light_on:
		send_command_light_off()

func turn_on() -> void:
	if not is_light_on:
		send_command_light_on()
	
func set_light_rgba():
	pass
	
func _on_color_update_cooldown_timeout() -> void:
	send_command_get_state()
	
	if next_color:
		send_command_light_rgb(next_color.pop_front())

func _on_color_picker_button_color_changed(color: Color) -> void:
	if next_color:
		next_color = []
	next_color.push_front(color)

func _on_toggle_light_toggled(toggled_on: bool) -> void:
	$ToggleLight.disabled = true
	if is_light_on:
		next_color = []
		send_command_light_off()
	else:
		send_command_light_on()
