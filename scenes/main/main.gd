extends Node
class_name Main

@onready var player: Player = %Player

@export var end_screen:PackedScene
@export var pause_menu:PackedScene


func _ready() -> void:
	player.health_component.died.connect(on_player_died)
	


func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("esc"):
		var pause_menu_ins = pause_menu.instantiate() as PauseMenu
		add_child(pause_menu_ins)


func on_player_died() -> void:
	var end_screen_instance = end_screen.instantiate() as EndScreen
	add_child(end_screen_instance)
	end_screen_instance.set_defeat()
	MetaProgression.save()
