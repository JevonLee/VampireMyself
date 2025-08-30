extends Node
class_name ArenaTimeManager
##竞技场时间管理器

const DIFFICULTY_INTERVAL = 5 ##难度增加的频率，每5s敌人生成逐渐增加

signal arena_difficulty_increased(arena_difficulty:int)

@onready var timer: Timer = $Timer

@export var end_screen:PackedScene

var arena_difficulty :int = 0

func _ready() -> void:
	timer.timeout.connect(on_timer_timeout)


func _process(delta: float) -> void:
	var next_time_target = timer.wait_time - ((arena_difficulty + 1)*DIFFICULTY_INTERVAL)
	#剩下next_time_target时间，说人话就是剩下的时间开始增加难度
	if timer.time_left <= next_time_target:
		arena_difficulty += 1
		arena_difficulty_increased.emit(arena_difficulty)
	

func get_time_elapsed():##获得流逝的时间
	return timer.wait_time - timer.time_left


func show_end_screen() ->void:
	var end_instance = end_screen.instantiate() as EndScreen
	add_child(end_instance)
	

func on_timer_timeout() -> void:
	#show_end_screen()
	pass
	MetaProgression.save()
