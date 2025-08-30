extends Node2D
class_name TerraBladeController
##controller负责管理这把武器的生成，弹幕生成，特效生成，统一使用接口管理

@export var terra_blade_scene:PackedScene
@export var projectile_scene:PackedScene
@export var sparkle_scene:PackedScene

var damage = 5
var knockback = 10

func _ready() -> void:
	set_process_unhandled_input(true)
	
	
func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("left_click"):
		if terra_blade_scene == null :
			return
		var terra_blade = terra_blade_scene.instantiate() as TerraBlade
		var player = get_tree().get_first_node_in_group("Player") as Player
		if player == null :
			return
		if player.has_node("TerraBlade"):
			return
		terra_blade.direction = global_position.direction_to(get_global_mouse_position())
		player.add_child(terra_blade)
		terra_blade.global_position = player.global_position
		terra_blade.hit_box.damage = damage
		terra_blade.hit_box.knock_back = knockback
		
		
		

func spawn_effects() -> void:##生成专属于这把武器的打击特效
	if sparkle_scene == null:
		return
	var sparkle = sparkle_scene.instantiate() as Node2D
	var foreground = get_tree().get_first_node_in_group("ForegroundLayer")
	if foreground == null :
		return
	#正确的应该是在hitbox里检测hurtbox，然后生成特效，不同武器有不同的特效
	#或者是通过hitbox将特效变量传到hurtbox
	var enemy
	

func spawn_projectile() -> void: ##这个应该做成组件
	if projectile_scene == null :
		return
	var projectile = projectile_scene.instantiate() as TerraBladeProj
	var foreground = get_tree().get_first_node_in_group("ForegroundLayer")
	if foreground == null :
		return
	var player = get_tree().get_first_node_in_group("Player")
	if player == null:
		return
	foreground.add_child(projectile)
	projectile.hit_box.damage = damage
	projectile.global_position = player.global_position
	
