extends "res://light_sources/light_source_template.gd"

@export var gradient : Gradient

func _ready() -> void:
	update_gradient_display()

func _process(delta: float) -> void:
	super._process(delta)

func get_color(pos : Vector2):
	var relative_distance = pos.distance_to(position) / $Area2D/CollisionShape2D.shape.radius
	var sampled = gradient.sample(relative_distance)
	print(relative_distance)
	print(sampled)
	return sampled
	
func update_gradient_display():
	var gradient_texture = GradientTexture2D.new()
	gradient_texture.gradient = gradient
	
	gradient_texture.fill = GradientTexture2D.FILL_RADIAL
	gradient_texture.fill_from = Vector2(0.5, 0.5)
	gradient_texture.fill_to = Vector2(1.0, 0.5)
	var resize_scale = $Area2D/CollisionShape2D.shape.radius / (gradient_texture.width / 2)
	$Area2D/CollisionShape2D/Sprite2D.scale = Vector2(resize_scale, resize_scale)
	$Area2D/CollisionShape2D/Sprite2D.texture = gradient_texture
	
"fill_from"
