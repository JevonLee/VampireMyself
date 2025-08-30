extends Node
class_name AxeAbilityController

@onready var timer: Timer = $Timer

@export var axe_ability:PackedScene

var damage = 3
var knock_back = 15

func _ready() -> void:
	timer.timeout.connect(on_timeout)
	

func on_timeout() -> void:
	var axe_instance = axe_ability.instantiate() as AxeAbility
	axe_instance.hit_box.damage = damage
	axe_instance.hit_box.knock_back = knock_back
	var foreground = get_tree().get_first_node_in_group("ForegroundLayer")
	if foreground == null :
		return
		
	foreground.add_child(axe_instance)
