extends Line2D
class_name TrailComponent

@export var sprite:Sprite2D

func _ready() -> void:
	clear_points()
	texture = sprite.texture
	
func _process(delta: float) -> void:
	add_point(sprite.global_position)
	if points.size() > 10:
		remove_point(0)
