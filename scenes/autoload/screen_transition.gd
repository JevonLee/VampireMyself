extends CanvasLayer
##Autoload

@onready var animation_player: AnimationPlayer = $AnimationPlayer

signal transition_finished ##结束信号

var skip_emit := false ##阻止发送两次信号

##过度函数
func transition_in() -> void:
	animation_player.play("in")
	await transition_finished
	skip_emit = true
	animation_player.play("out")


#func transition_out() -> void:
	#animation_player.play("out")
	
func transition_to_scene(scene_path:String) -> void:
	transition_in()
	await transition_finished
	get_tree().change_scene_to_file(scene_path)


func emit_transition_finished():
	if skip_emit:
		skip_emit = false
		return
	transition_finished.emit()
