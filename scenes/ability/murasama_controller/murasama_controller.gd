extends Node
class_name MurasamaController


@export var murasama_scene:PackedScene
@export var sparkle:PackedScene

var base_damage = 3
var additional_damage_percent = 1
var knock_back = 30

func _ready() -> void:
	set_process_unhandled_input(true)
	GameEvents.ability_upgrade_added.connect(on_ability_upgrade_added)
	

func _unhandled_input(event: InputEvent) -> void:
	if Input.is_action_just_pressed("left_click"):
		spawn_weapon()


func spawn_weapon() -> void:
	var murasama = murasama_scene.instantiate() as Murasama
	if murasama == null :
		return
	var player = get_tree().get_first_node_in_group("Player") as Player
	if player == null :
		return
	if player.has_node("Muramasa"):
		return
	murasama.hit_box.damage = base_damage * additional_damage_percent
	murasama.hit_box.knock_back = knock_back
	if sparkle != null:
		murasama.hit_box.sparkle = sparkle
	player.add_child(murasama)



func on_ability_upgrade_added(upgrade: AbilityUpgrade, current_upgrades: Dictionary) -> void:
	match upgrade.id:
		"murasama_damage":
			additional_damage_percent = 1 + (current_upgrades["murasama_damage"]["quantity"] * 0.1)
