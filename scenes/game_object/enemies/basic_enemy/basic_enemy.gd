extends CharacterBody2D
class_name BasicEnemy

const MAX_SPEED = 50

@onready var visuals: Node2D = $Visuals
@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var hurt_box_component: HurtBoxComponent = $HurtBoxComponent

@export var hurt_sfx:AudioStream ##受击音效应该从武器那边传过来
@export var footstep_sfx:AudioStream


func _ready() -> void:
	hurt_box_component.hurting.connect(on_hurting)
	
	
func _process(delta: float) -> void:
	#if is_hurt: 留个纪念，之前都是根据信号改变bool值，然后在process里操作
		#velocity -= get_player_direction() * knockback
	#else:
	velocity = velocity.lerp(get_player_direction() * MAX_SPEED,1-exp(-delta * 10))
	move_and_slide()
	update_animation(get_player_direction())
	
	
func update_animation(direction:Vector2) -> void:
	var move_sign = sign(direction.x)
	if move_sign != 0:
		visuals.scale = Vector2(move_sign,1)
		animation_player.play("move")
		


func get_player_direction() -> Vector2:
	var player = get_tree().get_first_node_in_group("Player") as Player
	if player != null:
		return global_position.direction_to(player.global_position)
	return Vector2.ZERO


func apply_knockback(knockback:float,start_position:Vector2) -> void:
	##击退效果
	var target_pos = start_position - get_player_direction() * knockback
	global_position = lerp(start_position,target_pos,0.5)
	##这里使用start_position.lerp(target_pos,0.5)更好，类型安全，为了标记新学的不一样的知识就不改了
	
	
func apply_shake() -> void:##屏幕震动
	var camera_2d = get_tree().get_first_node_in_group("GameCamera") as GameCamera
	if camera_2d == null:
		return
	#camera_2d.apply_scaling(1,0.1)
	camera_2d.apply_shake(1,0.1)


func enemy_shake(intensity:float,duration:float) -> void:##敌人本体受伤效果
	var scale_intensity = Vector2(1.2,1.2)*intensity
	var tween = create_tween()
	tween.tween_property(visuals,"scale",scale_intensity,duration/2)
	tween.parallel()
	tween.tween_property(visuals,"scale",scale_intensity,duration/2)
	
	tween.tween_property(visuals,"scale",Vector2(1,1),duration)


func play_sfx()-> void:
	AudioManager.play_sfx(footstep_sfx)



func on_hurting(knockback:float) -> void:
	var tween = create_tween()
	tween.set_parallel()
	tween.tween_method(apply_knockback.bind(global_position),0.0,knockback,0.5)\
	.set_ease(Tween.EASE_OUT)\
	.set_trans(Tween.TRANS_EXPO)
	
	AudioManager.play_sfx(hurt_sfx)
	
	tween.tween_callback(apply_shake)
	tween.tween_callback(enemy_shake.bind(1,0.1))
	
