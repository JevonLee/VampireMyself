extends CanvasLayer
class_name ArenaTimeUi

@onready var label: Label = %Label

@export var arena_time_manager:ArenaTimeManager

func _process(delta: float) -> void:
	if arena_time_manager == null:
		return
	var time_elapsed = arena_time_manager.get_time_elapsed()
	label.text = format_seconds_to_string(time_elapsed)
	
	
func format_seconds_to_string(seconds:float)->String:
	var minutes = floor(seconds/60) #向下舍入取整
	var remaining_seconds = seconds - (minutes * 60)
	return ("%02d"%minutes)+":"+("%02d"%remaining_seconds)
	
