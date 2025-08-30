extends Node2D
class_name TerraBladeProj

@export var hit_box:HitBoxComponent

var i:int = 0
var speed :float = 50
	
	
func _process(delta: float) -> void:
	i+=1
	var player = get_tree().get_first_node_in_group("Player") as Player
	if player == null :
		return
	var direction = player.global_position.direction_to(get_global_mouse_position())
	var target_position = global_position + direction * speed
	rotation = direction.angle()
	global_position = global_position.lerp(target_position,1 - exp(-delta * 25))
	if i > 1/delta :
		queue_free()
	elif i > 30:
		speed /= 0.02
