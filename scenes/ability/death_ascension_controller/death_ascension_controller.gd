extends Node
class_name  DeathAscensionController

@onready var timer: Timer = $Timer

@export var death_ability:PackedScene

var damage = 5
var knock_back = 30

func _ready() -> void:
	timer.timeout.connect(on_timeout)
	
func on_timeout() -> void:
	var player = get_tree().get_first_node_in_group("Player") as Player
	if player == null :
		return
	
	var enemies = get_tree().get_nodes_in_group("Enemy") as Array[BasicEnemy]
	if enemies == null :
		return
	
	enemies.sort_custom(func(a:Node2D,b:Node2D):
		var a_distance = a.global_position.distance_squared_to(player.global_position)
		var b_distance = b.global_position.distance_squared_to(player.global_position)
		return a_distance<b_distance
	)
	
	if enemies[0].global_position.distance_squared_to(player.global_position) < pow(60,2):
		var death_instance = death_ability.instantiate() as DeathAscension
		death_instance.hit_box.damage = damage #剑的伤害
		death_instance.hit_box.knock_back = knock_back

		if player.global_position.x - (enemies[0] as BasicEnemy).global_position.x > 0:
			death_instance.get_child(0).flip_h = true
		
		player.add_child(death_instance) 
		death_instance.global_position = player.global_position + Vector2(0,-4)
			
			
