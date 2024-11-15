extends "res://light_sources/light_source_template.gd"

@export var source_color : Color = Color.WHITE


func _process(delta: float) -> void:
	super._process(delta)


func _on_area_2d_body_entered(body: Node2D) -> void:
	body.turn_on()
	body.set_color(source_color)


func _on_area_2d_body_exited(body: Node2D) -> void:
	body.turn_off()


func _on_color_picker_button_color_changed(color: Color) -> void:
	source_color = color
