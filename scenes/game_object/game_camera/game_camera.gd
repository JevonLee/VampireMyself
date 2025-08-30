extends Camera2D
class_name GameCamera

var target_position:Vector2 = Vector2.ZERO



func _ready() -> void:
	make_current()
	
func _process(delta: float) -> void:
	get_target()
	global_position = global_position.lerp(target_position,1.0 - exp(-delta * 25))
	#这行代码意思是位置平滑的移动,说人话就是从global_position到target_position有个加速过程
	
func get_target():
	var player = get_tree().get_first_node_in_group("Player") as Player
	if player == null :
		return
	target_position = player.global_position


func apply_shake(intensity:float,duration:float) -> void:
	##相机震动，默认1，0.1
	var rand_offset = randf_range(1,2.5) * intensity
	var tween = create_tween()
	tween.tween_property(self,"offset",Vector2(rand_offset,rand_offset),duration/2.0)
	tween.parallel()
	tween.tween_property(self,"offset",Vector2(rand_offset,rand_offset),duration/2.0)
	
	tween.tween_property(self,"offset",Vector2(0,0),duration)
	

func apply_scaling(intensity:float,duration:float) -> void:
	##相机缩放,默认1，0.1
	var rand_offset = randf_range(1.01,1.05) * intensity
	var tween = create_tween()
	tween.tween_property(self,"zoom",Vector2(rand_offset,rand_offset),duration/2.0)
	tween.parallel()
	tween.tween_property(self,"zoom",Vector2(rand_offset,rand_offset),duration/2.0)
	
	tween.tween_property(self,"zoom",Vector2(1,1),duration)
	
	
