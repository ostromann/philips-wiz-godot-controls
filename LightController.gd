extends Node

var queued_color: Color = Color.WHITE

func _on_turn_on_button_pressed() -> void:
	for bulb in $Bulbs.get_children():
		print("turn on ", bulb)
		bulb.turn_on()
	
func _on_turn_off_button_pressed() -> void:
	for bulb in $Bulbs.get_children():
		bulb.turn_off()

func _on_color_picker_button_color_changed(color: Color) -> void:	
	queued_color = color
	$QueuedColorRect.color = color
		
