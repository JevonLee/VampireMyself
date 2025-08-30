extends CanvasLayer
class_name EndScreen

@onready var title_label: Label = %TitleLabel
@onready var description_label: Label = %DescriptionLabel
@onready var restart_button: Button = %RestartButton
@onready var quit_button: Button = %QuitButton

func _ready() -> void:
	restart_button.pressed.connect(on_restart_button_pressed)
	quit_button.pressed.connect(on_quit_button_pressed)
	get_tree().paused = true
	
	
func set_defeat() -> void:
	title_label.text = "Defeat"
	description_label.text = "你被打败了！"
	
	
func on_restart_button_pressed() -> void:
	get_tree().paused = false
	get_tree().change_scene_to_file("res://scenes/main/main.tscn")


func on_quit_button_pressed() -> void:
	get_tree().quit()
