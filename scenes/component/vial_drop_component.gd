extends Node
class_name VialDropComponent

@export var drop_percent:float = .5 #概率掉落
@export var vial_drop:PackedScene
@export var health_component:HealthComponent

func _ready() -> void:
	health_component.died.connect(on_died)
	
func on_died() -> void:
	var adjusted_drop_percent = drop_percent
	if MetaProgression.get_upgrade_count("experience_gain") > 0:
		adjusted_drop_percent += .1
	
	if randf() > adjusted_drop_percent: #生成一个随机数和概率对比
		return
	
	if vial_drop == null:
		return 
	if not owner is Node2D:
		return
		
	var vial_drop_instance = vial_drop.instantiate() as ExperienceVial
	var entities_layer = get_tree().get_first_node_in_group("EntitiesLayer")
	entities_layer.add_child(vial_drop_instance) ##发送信号那里有延迟调用，让其queue_free之后再执行这行
	vial_drop_instance.global_position = (owner as Node2D).global_position
