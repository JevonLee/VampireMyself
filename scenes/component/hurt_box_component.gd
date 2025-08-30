extends Area2D
class_name HurtBoxComponent

const FLOATING_TEXT = preload("res://scenes/ui/floating_text.tscn")
#这种并非此组件父节点有特殊的场景，preload也可以使用，@export也可以使用，这样可以使检视器面板更整洁

signal hurting(knockback:int)##受伤时发出信号

@onready var basic_enemy: BasicEnemy = $".."

@export var health_component:HealthComponent

func _ready() -> void:
	area_entered.connect(on_area_entered)
	
	
func on_area_entered(area:Area2D) -> void:
	if not area is HitBoxComponent:
		return
	if health_component == null :
		return	
	var direction = (owner as BasicEnemy).get_player_direction().angle() - PI/2
	var hit_box = area as HitBoxComponent
	health_component.damage(hit_box.damage)
	hurting.emit(hit_box.knock_back)
	
	var foreground = get_tree().get_first_node_in_group("ForegroundLayer")
	if foreground == null :
		return
		
	var floating_text = FLOATING_TEXT.instantiate() as FloatingText
	foreground.add_child(floating_text)
	floating_text.global_position = global_position + Vector2.UP * 16
	floating_text.start(str("%.1f"%hit_box.damage))
	
	#var player = get_tree().get_first_node_in_group("Player") as Player
	#if player == null:
		#return
	
	
	if hit_box.sparkle == null :
		return
	var sparkle = hit_box.sparkle.instantiate() as Node2D
	sparkle.global_position = global_position
	
	foreground.add_child(sparkle)
	sparkle.rotation = direction
	
	Global.hitstop(basic_enemy)
