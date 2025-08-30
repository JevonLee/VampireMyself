extends Node
class_name ExperienceManager
##用于管理拾取的经验数据，事件监听用额外的场景GameEvents

const TARGET_EXPERIENCE_GROWTH = 5#让其升级越来越困难

signal experience_updated(current_experience:float,target_experience:float)
signal level_up(current_level:int)

var current_experience :float =0
var current_level :int= 1 #经验到达目标经验时提升等级
var target_experience:float = 5

func _ready() -> void:
	GameEvents.experience_vial_collected.connect(on_experience_vial_collected)


func increment_experience(number:float) -> void:
	current_experience = min(current_experience + number, target_experience)
	experience_updated.emit(current_experience,target_experience)
	if current_experience == target_experience:
		current_level += 1
		target_experience += TARGET_EXPERIENCE_GROWTH
		current_experience = 0
		experience_updated.emit(current_experience,target_experience)
		level_up.emit(current_level)
		
	
func on_experience_vial_collected(number:float) -> void:
	#信号函数和普通函数分开写，以便普通函数直观的在其他地方能够被调用
	increment_experience(number)
