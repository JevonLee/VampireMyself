extends Node2D
class_name AxeAbility

const MAX_RADIUS = 100

@export var hit_box:HitBoxComponent

func _ready() -> void:
	var tween = create_tween()
	tween.tween_method(tween_method,0.0,2.0,3)
	tween.tween_callback(queue_free)
	
	
func tween_method(rotations:float) -> void:
	##展现效果是转0圈到两圈
	var percent = rotations / 2 #这只是一个计算
	
	var current_radius = percent * MAX_RADIUS #转的半径
	var current_direction = Vector2.RIGHT.rotated(rotations * TAU)#转的方向，2*TAU就是两圈
	##转圈核心就是半径和方向
	
	var player = get_tree().get_first_node_in_group("Player") as Player
	if player == null:
		return
		
	global_position = player.global_position + current_direction * current_radius
	rotation = current_direction.angle() + PI;
