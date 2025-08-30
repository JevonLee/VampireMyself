extends CanvasLayer
class_name MainMenu

@onready var play_button: Button = %PlayButton
@onready var option_button: Button = %OptionButton
@onready var quit_button: Button = %QuitButton
@onready var upgrades_button: Button = %UpgradesButton
@onready var check_button: CheckButton = $CheckButton


@export var music:AudioStream


func _ready() -> void:
	play_button.pressed.connect(on_play_button)
	upgrades_button.pressed.connect(on_upgrades_button)
	option_button.pressed.connect(on_option_button)
	quit_button.pressed.connect(on_quit_button)
	check_button.toggled.connect(on_toggled)
	AudioManager.play_music(music)
	
	
func on_play_button() -> void:
	ScreenTransition.transition_in()
	await ScreenTransition.transition_finished
	AudioManager.stop_music()
	get_tree().change_scene_to_file("res://scenes/main/main.tscn")
	
	
func on_upgrades_button() -> void:
	get_tree().change_scene_to_file("res://scenes/ui/meta_menu.tscn")
	
	
func on_option_button() -> void:
	var option_menu = (load("res://scenes/ui/option_menu.tscn") as PackedScene).instantiate() as OptionMenu
	add_child(option_menu)
	option_menu.back_pressed.connect(on_back_pressed.bind(option_menu))
	
	
func on_quit_button() -> void:
	get_tree().quit()


func on_back_pressed(option_menu:Node) -> void:
	option_menu.queue_free()


func on_toggled(toggled_on:bool)-> void:
	if toggled_on:
		AudioManager.stop_music()
	else:
		AudioManager.play_music(music)
