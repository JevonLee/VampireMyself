extends Node2D
class_name ExperienceVial

@onready var area_2d: Area2D = $Area2D
@onready var collision_shape_2d: CollisionShape2D = $Area2D/CollisionShape2D
@onready var sprite_2d: Sprite2D = $Sprite2D


func _ready() -> void:
	area_2d.area_entered.connect(on_area_entered)
	
		
func tween_collect(percent:float,start_position:Vector2) -> void:
	var player = get_tree().get_first_node_in_group("Player") as Player
	if player == null :
		return
	global_position = start_position.lerp(player.global_position,percent)
	var target_rotation = (player.global_position - start_position).angle() + PI/2
	rotation = lerp_angle(rotation,target_rotation,percent/2.0) #旋转的插值函数
	#0rad代表向右
	
	
func collect() -> void:
	GameEvents.emit_experience_vial_collected(1)
	queue_free()
	
	
func disable_collision() -> void:
	collision_shape_2d.disabled = true


func on_area_entered(area:Area2D) -> void:
	#player拾取掉落物的area2d要单独一个节点，同时层级也可能会影响，
	#在这种共同的作用下，拾取物品可以有很好的效果，之前星露谷的拾取物品就达不到这个效果
	Callable(disable_collision).call_deferred()
	
	var tween = create_tween()
	tween.set_parallel()
	tween.tween_method(tween_collect.bind(global_position),0.0,1.3,0.5)\
	.set_ease(Tween.EASE_IN)\
	.set_trans(Tween.TRANS_BACK)
	tween.tween_property(sprite_2d,"scale",Vector2.ZERO,.05).set_delay(.45)
	
	tween.chain()# 用在set_parallel后面，会在前两条完成后执行。
	tween.tween_callback(collect)
	##tween动画性能优于process里执行
