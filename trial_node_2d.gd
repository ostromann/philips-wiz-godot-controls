extends Node2D

var last_valid_collider

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	var collider = $RayCast2D.get_collider()
	if collider:
		if not last_valid_collider:
			last_valid_collider = collider
			print("Turn on ", last_valid_collider)
			last_valid_collider.pulse(Color.GREEN_YELLOW, 1.2)
	else:
		if last_valid_collider:
			#print("Turn off ", last_valid_collider)
			#last_valid_collider.turn_off()
			last_valid_collider = null
			
	if last_valid_collider:
		$Label.text = last_valid_collider.name
	else:
		$Label.text = "null"
	
