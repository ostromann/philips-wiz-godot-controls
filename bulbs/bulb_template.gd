extends "res://draggable.gd"

@export var update_frequency : float

var color_queue : Array[Color]
var current_color : Color
var light_source_colors : Array[Color]
var is_on : bool
var can_update : bool
var has_new_state : bool
var new_state_data

func _ready() -> void:
	pass

func _process(delta) -> void:
	super._process(delta)
	
	if has_new_state:
		_update_state(new_state_data)
	
	set_color(get_color_from_light_sources())
	
		
	if can_update:
		_apply_color_queue()
	
	$CurrentColorPolygon.color = current_color

func get_state():
	assert(false, "get_state() must be implemented in subclasses")

func turn_off() -> void:
	assert(false, "turn_off() must be implemented in subclasses")

func turn_on() -> void:
	assert(false, "turn_on() must be implemented in subclasses")
	
func get_color_from_light_sources():
	light_source_colors = []
	for light_source_area in $ColorPickUpArea.get_overlapping_areas():
		light_source_colors.push_back(light_source_area.get_parent().get_color(self.position))

	return average_color(light_source_colors)

func average_color(colors: Array) -> Color:
	if len(colors) == 0:
		return Color(0, 0, 0, 0)  # Default to black with full alpha if the list is empty

	var total_r = 0.0
	var total_g = 0.0
	var total_b = 0.0
	var total_a = 0.0

	for color in colors:
		total_r += color.r
		total_g += color.g
		total_b += color.b
		total_a += color.a
	var count = colors.size()
	return Color(total_r / count, total_g / count, total_b / count, total_a / count)


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
		if color_queue[0].r == 0 and color_queue[0].g == 0 and color_queue[0].b == 0:
			self.turn_off()
		else:
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
