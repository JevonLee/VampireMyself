extends Node
class_name SwordAbilityController
## 观察者模式，监听其他场景发出来的信号,管理那些实例化的场景

const MAX_RANGE = 150

@onready var timer: Timer = $Timer

@export var sword_ability:PackedScene

var damage = 5
var knock_back = 5
var base_wait_time

func _ready() -> void:
	base_wait_time = timer.wait_time
	timer.timeout.connect(on_timeout)
	GameEvents.ability_upgrade_added.connect(on_ability_upgrade_added)
	
func on_timeout() -> void:
	var player = get_tree().get_first_node_in_group("Player") as Player
	if player == null :
		return
	
	var enemies = get_tree().get_nodes_in_group("Enemy")
	enemies = enemies.filter(func(enemy:Node2D):
		return enemy.global_position.distance_squared_to(player.global_position) < pow(MAX_RANGE,2)
	)#满足条件的保留，distance_squared_to()该方法比 distance_to() 运行得更快
	
	if enemies.size() == 0:
		return
	
	enemies.sort_custom(func(a:Node2D,b:Node2D):#按到player的距离排序，攻击距离近的
		var a_distance = a.global_position.distance_squared_to(player.global_position)
		var b_distance = b.global_position.distance_squared_to(player.global_position)
		return a_distance<b_distance
	)
	
	var sword_instance = sword_ability.instantiate() as SwordAbility
	var foreground_layer = get_tree().get_first_node_in_group("ForegroundLayer")
	foreground_layer.add_child(sword_instance) #这样写，仅仅是让生成的实例和player同级
	sword_instance.hit_box.damage = damage #剑的伤害
	sword_instance.hit_box.knock_back = knock_back
	
	sword_instance.global_position = enemies[0].global_position#攻击最近的
	
	var sword_direction = enemies[0].global_position.direction_to(player.global_position)
	sword_instance.rotation = sword_direction.angle()
	
func on_ability_upgrade_added(upgrade:AbilityUpgrade,current_upgrades:Dictionary) -> void:
	if upgrade.id != "sword_rate":
		return #暂时只处理攻速
		
	var percent_reduction = current_upgrades["sword_rate"]["quantity"] *.1
	##剑的数量越多，同一时间生成剑的实例就越多，也就是实际剑的攻速提升是10% * 剑的数量
	timer.wait_time = base_wait_time * (1 - percent_reduction)
	timer.start()
