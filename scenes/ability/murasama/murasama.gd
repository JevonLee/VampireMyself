extends Node2D
class_name Murasama

@onready var animation_player: AnimationPlayer = $AnimationPlayer

@export var hit_box:HitBoxComponent
@export var sfx_1:AudioStream
@export var sfx_2:AudioStream

enum State{
	NONE,
	SWING1 = 1,
	SWING2 = 2,
	SWING3 = 3
}

var current_state:State = State.SWING1
var is_attack:bool = true


func _ready() -> void:
	animation_player.animation_finished.connect(on_animation_finished)
	animation_player.play("swing")

func _process(delta: float) -> void:
	var direction = global_position.direction_to(get_global_mouse_position())
	rotation = direction.angle()
	var swing_sign = sign(-direction.x)
	if swing_sign != 0:
		scale = Vector2(1,-swing_sign)
	if get_tree().paused:
		queue_free()
		
	#match current_state:
		#State.SWING1:
			#animation_player.play("swing1")
		#State.SWING2:
			#animation_player.play("swing2")
		#State.SWING3:
			#animation_player.play("swing3")
	

func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_released("left_click"):
		queue_free()


func play_sfx(sfx:AudioStream) -> void:
	AudioManager.play_sfx(sfx)
	

func attack(anim_name:String) -> void:
	animation_player.play(anim_name)


func on_animation_finished(anim_name:StringName) -> void:
	current_state += 1
