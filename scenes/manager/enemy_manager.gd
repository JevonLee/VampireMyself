extends Node
class_name EnemyManager

const SPAWN_RANGE = 375

@onready var timer: Timer = $Timer

@export var basic_enemy_scene:PackedScene
@export var wizard_enemy_scene:PackedScene
@export var arena_time_manager:ArenaTimeManager

var base_spawn_time = 0
var enemy_table = WeightedTable.new()

func _ready() -> void:
	enemy_table.add_item(basic_enemy_scene,10)
	base_spawn_time = timer.wait_time
	timer.timeout.connect(on_timer_timeout)
	arena_time_manager.arena_difficulty_increased.connect(on_arena_difficulty_increased)
	
	
func get_spawn_position() -> Vector2:
	var player = get_tree().get_first_node_in_group("Player") as Player
	if player == null :
		return Vector2.ZERO + Vector2(8,8) #因为0，0是墙外
		
	var random_direction =  Vector2.RIGHT.rotated(randf_range(0,TAU))
	##这会在一个圆周的位置随机生成
	var spawn_position = Vector2.ZERO + Vector2(8,8)
	for i in 16:
		spawn_position = player.global_position + (random_direction * SPAWN_RANGE)
		var additional_check_offset = random_direction * 20
		var parameters = PhysicsRayQueryParameters2D.create(player.global_position,spawn_position + additional_check_offset,1)##要检测的碰撞层的值value
		var result = get_tree().root.world_2d.direct_space_state.intersect_ray(parameters)
		## 返回一个字典，用于场景树中获得两点之间连线的目标mask碰撞
		if result.is_empty():#字典判空不能null
			break
		else:
			random_direction = random_direction.rotated(deg_to_rad(90))
	#还是会有个别生成在墙外
	return spawn_position
	

func spawn_enemy() -> void:
	timer.start()
	##更新了wait_time之后要重新启动
	var player = get_tree().get_first_node_in_group("Player") as Player
	if player == null :
		return
	
	var enemy_scene = enemy_table.pick_item()
	var enemy = enemy_scene.instantiate() as BasicEnemy
	var entities_layer :Node2D= get_tree().get_first_node_in_group("EntitiesLayer")
	entities_layer.call_deferred("add_child",enemy)
	
	enemy.global_position = get_spawn_position()
	#var enemy:BasicEnemy = ObjectPoolManager.get_object("Enemy")
	enemy.appear()
	#enemy.visible = true
	#enemy.global_transform.origin = get_spawn_position()
	
	
func on_timer_timeout() -> void:
	
	spawn_enemy()
	

func on_arena_difficulty_increased(arena_difficulty:int) -> void:
	var time_off = (.1 / 12) * arena_difficulty #
	time_off = min(time_off,.7) ##生成敌人的频率最小不低于（1-0.7）= 0.3
	timer.wait_time = base_spawn_time - time_off

	if arena_difficulty == 6: #30s之后
		enemy_table.add_item(wizard_enemy_scene,20)
		
