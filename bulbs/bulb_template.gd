extends "res://draggable.gd"

@export var update_frequency : float

var color_queue : Array[Color]
var current_color : Color
var is_on : bool
var can_update : bool
var has_new_state : bool
var new_state_data

func _ready() -> void:
	pass

func _process(_delta) -> void:
	_process_bulb_template(_delta)
	
func _process_bulb_template(_delta) -> void:
	_process_draggable(_delta)
	
	if has_new_state:
		_update_state(new_state_data)
		
	if can_update:
		_apply_color_queue()
	
	$CurrentColorPolygon.color = current_color

func get_state():
	assert(false, "get_state() must be implemented in subclasses")

func turn_off() -> void:
	assert(false, "turn_off() must be implemented in subclasses")

func turn_on() -> void:
	assert(false, "turn_on() must be implemented in subclasses")

func _set_color(color : Color) -> void:
	assert(false, "_set_color() must be implemented in subclasses")

func toggle() -> void:
	if is_on:
		turn_off()
	else:
		turn_on()

func set_color(color : Color) -> void:
	if color_queue:
		color_queue = [] # Keep only one color in color_queue
	color_queue.push_front(color)


func _apply_color_queue():
	if color_queue:
		_set_color(color_queue.pop_front())
		can_update = false
		$UpdateTimer.start()

func _update_state(new_state_data):
	assert(false, "_update_state() must be implemented in subclasses")

func _on_update_timer_timeout() -> void:
	can_update = true


func _on_color_picker_button_color_changed(color: Color) -> void:
	set_color(color)


func _on_toggle_light_button_toggled(toggled_on: bool) -> void:
	# TODO: Disable next toggle until next state has been registered
	toggle()
