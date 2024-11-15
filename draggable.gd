extends CharacterBody2D

var is_dragging : bool = false
signal toggle_drag;


func _process(_delta: float) -> void:
	_process_draggable(_delta)

func _process_draggable(_delta):
	if is_dragging:
		self.position = get_viewport().get_mouse_position()

func _on_toggle_drag() -> void:
	is_dragging = !is_dragging

func _on_input_event(viewport: Node, event: InputEvent, shape_idx: int) -> void:
	#print("Received event!")
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
			emit_signal("toggle_drag")
		elif event.button_index == MOUSE_BUTTON_LEFT and !event.pressed:
			emit_signal("toggle_drag")
	elif event is InputEventScreenDrag:
		pass
