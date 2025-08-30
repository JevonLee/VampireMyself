@tool
extends Line2D
class_name JianQiComponent

@export var target_position:Node2D

func _ready() -> void:
	clear_points()
	
	
func _process(delta: float) -> void:
	add_point(to_local(target_position.global_position))
	if points.size() > 60:
		remove_point(0)
		remove_point(1)
