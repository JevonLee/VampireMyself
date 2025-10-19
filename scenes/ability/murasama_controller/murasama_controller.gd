extends Node
class_name MurasamaController

@onready var timer: Timer = $Timer

@export var murasama_scene:PackedScene
@export var sparkle:PackedScene

var base_damage = 3
var additional_damage_percent = 1
var knock_back = 30

var murasama:Murasama
var is_press:bool = false

func _ready() -> void:
	timer.timeout.connect(on_timertimeout)
	set_process_unhandled_input(true)
	GameEvents.ability_upgrade_added.connect(on_ability_upgrade_added)
	

func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("left_click"):
		spawn_weapon()
		is_press = true
	if event.is_action_released("left_click"):
		is_press = false



func spawn_weapon() -> void:
	murasama = murasama_scene.instantiate()
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
	murasama.attack("swing")
	timer.start()




func on_ability_upgrade_added(upgrade: AbilityUpgrade, current_upgrades: Dictionary) -> void:
	match upgrade.id:
		"murasama_damage":
			additional_damage_percent = 1 + (current_upgrades["murasama_damage"]["quantity"] * 0.1)


func on_timertimeout()->void:
	if murasama == null:
		return
	if is_press:
		murasama.attack("swing")
	else:
		murasama.queue_free()
