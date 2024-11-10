extends Node2D

@export var pixelSize: int = 40



# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var width = get_viewport().get_visible_rect().size[0]
	var height = get_viewport().get_visible_rect().size[1]
	
	for col in range(width/pixelSize):
		for row in range(width/pixelSize):
			var colorRect = ColorRect.new()
			colorRect.position = Vector2(col * pixelSize, row * pixelSize)
			colorRect.size = Vector2(pixelSize, pixelSize)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
	
