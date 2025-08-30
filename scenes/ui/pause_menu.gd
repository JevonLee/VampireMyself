extends CanvasLayer
class_name PauseMenu

@onready var resume_button: Button = %ResumeButton
@onready var option_button: Button = %OptionButton
@onready var back_button: Button = %BackButton
@onready var panel_container: PanelContainer = $MarginContainer/PanelContainer

var is_closing:bool = false

func _ready() -> void:
	resume_button.pressed.connect(on_resume_pressed)
	option_button.pressed.connect(on_option_pressed)
	back_button.pressed.connect(on_back_pressed)
	
	panel_container.pivot_offset = panel_container.size / 2
	var tween = create_tween().set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_BACK)
	tween.tween_property(panel_container,"scale",Vector2.ZERO,0.1)
	tween.tween_property(panel_container,"scale",Vector2.ONE,0.1)
	get_tree().paused = true
	
	
func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("esc"):
		close()
		get_tree().root.set_input_as_handled()
		##这里的作用，就算添加了子节点option_menu，依然可以关闭
	
	
func close() -> void:
	if is_closing:
		return
	var tween = create_tween().set_ease(Tween.EASE_IN).set_trans(Tween.TRANS_BACK)
	tween.tween_property(panel_container,"scale",Vector2.ONE,0.1)
	tween.tween_property(panel_container,"scale",Vector2.ZERO,0.1)
	is_closing = true
	get_tree().paused = false
	tween.tween_callback(queue_free)
	
	
func on_resume_pressed() -> void:
	close()


func on_option_pressed() -> void:
	var option_menu = (load("res://scenes/ui/option_menu.tscn") as PackedScene).instantiate() as OptionMenu
	add_child(option_menu)
	option_menu.back_pressed.connect(on_option_back_pressed.bind(option_menu))


func on_back_pressed() -> void:
	ScreenTransition.transition_in()
	await ScreenTransition.transition_finished
	get_tree().paused = false ##场景过度bug的罪魁祸首，总是暂停了忘记恢复
	get_tree().change_scene_to_file("res://scenes/main/main_menu.tscn")
	
	
func on_option_back_pressed(option_menu:Node) -> void:
	option_menu.queue_free()
