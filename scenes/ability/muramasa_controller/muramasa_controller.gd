extends Node2D
class_name MuramasaController

@onready var attack_timer: Timer = $AttackTimer

@export var muramasa_scene:PackedScene


var damage = 5
var knockback = 10

func _ready() -> void:
	set_process_unhandled_input(true)
	
	
func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("left_click"):
		if muramasa_scene == null :
			return
		var muramasa = muramasa_scene.instantiate() as Muramasa
		var player = get_tree().get_first_node_in_group("Player") as Player
		if player == null :
			return
		if player.has_node("Muramasa"):
			return
		player.add_child(muramasa)
		muramasa.global_position = player.global_position
		muramasa.hit_box.damage = damage
		muramasa.hit_box.knock_back = knockback
