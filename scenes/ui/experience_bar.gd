extends CanvasLayer
class_name ExperienceBar

@onready var progress_bar: ProgressBar = %ProgressBar

@export var experience_manager:ExperienceManager

func _ready() -> void:
	experience_manager.experience_updated.connect(on_experience_updated)
	

func on_experience_updated(current_experience:float,target_experience:float) -> void:
	var percent = current_experience / target_experience
	var tween = create_tween()
	tween.tween_property(progress_bar,"value",percent,0.1)
