extends Node

var queuedColor
var ips = [
	"192.168.0.38", # kitchen 2
	"192.168.0.41", # kitchen 1
	"192.168.0.47", # bar 1
	"192.168.0.48", # bar 2
]

@onready var BULB = preload("res://Bulb.tscn")

@export var amplitude : float = 5.0
@export var speed : float = 0.2
@export var noisemap_dimming : FastNoiseLite
#@export var noisemap_r : FastNoiseLite
#@export var noisemap_g : FastNoiseLite
#@export var noisemap_b : FastNoiseLite

var time : float = 0.0

func _ready():
	pass

# Example: you can trigger these functions from UI buttons or other events
func _process(delta: float):
	#self.time += self.speed
	#var perlin_value = noisemap_dimming.get_noise_2d(self.time, 0.0)
	##print(perlin_value + 1)
	#var new_color = $BackgroundColorRect.color
	#new_color.a = perlin_value * amplitude
	#$BackgroundColorRect.color = new_color
	
	
	$PidList.clear()
	for process in $Processes.get_children():
		$PidList.add_item(str(process.pid))



func set_color(color):
	$BackgroundColorRect.color = color
	for bulb in $Bulbs.get_children():
		var process = bulb.set_light_rgb(color, 75)
		$Processes.add_child(process)
	$ColorUpdateCooldown.start()
	queuedColor = null
	
func _on_turn_on_button_pressed() -> void:
	for bulb in $Bulbs.get_children():
		var process = bulb.set_light_on()
		$Processes.add_child(process)
	
func _on_turn_off_button_pressed() -> void:
	for bulb in $Bulbs.get_children():
		var process = bulb.set_light_off()
		$Processes.add_child(process)
	queuedColor = null

func _on_color_picker_button_color_changed(color: Color) -> void:	
	queuedColor = color
	#$QueuedColorRect.color = color

func _on_color_update_cooldown_timeout() -> void:
	if queuedColor:
		set_color(queuedColor)
		
