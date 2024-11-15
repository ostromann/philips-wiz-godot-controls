extends "res://draggable.gd"

@export var is_emitting : bool = false

func _process(delta: float) -> void:
	super._process(delta)
	

func get_color(pos : Vector2):
	assert(false, "get_color() must be implemented in subclasses")
