extends "res://light_sources/light_source_template.gd"

@export var source_color : Color = Color.WHITE


func _process(delta: float) -> void:
	super._process(delta)

func get_color(pos : Vector2):
	return source_color

func _on_color_picker_button_color_changed(color: Color) -> void:
	source_color = color
	
