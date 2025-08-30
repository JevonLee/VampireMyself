extends Node
class_name HealthComponent

signal died
signal health_changed

@export var max_health :float = 5

var current_health:float

func _ready() -> void:
	current_health = max_health

func damage(damage_account:float) ->void:
	current_health = max(current_health - damage_account,0)
	#current_health = clampf(current_health - damage_account,0,100)同样的效果
	health_changed.emit()
	Callable(check_death).call_deferred()##有点像c#的委托
	
	
func get_health_percent():
	var percent = current_health / max_health
	return min(percent,1)
	

func check_death() -> void:
	if current_health == 0:
		died.emit()
		owner.queue_free()
