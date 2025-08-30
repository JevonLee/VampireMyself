extends Node2D
class_name TerraBlade

@onready var animation_player: AnimationPlayer = $AnimationPlayer

@export var hit_box:HitBoxComponent
@export var sfx_1:AudioStream

var direction:Vector2 = Vector2.RIGHT

func _ready() -> void:
	AudioManager.play_sfx(sfx_1)
	animation_player.animation_finished.connect(on_animation_finished.bind("swing2"))
	direction = global_position.direction_to(get_global_mouse_position())
	var camera = get_tree().get_first_node_in_group("GameCamera") as GameCamera
	if camera == null:
		return
	camera.apply_scaling(1,0.2)


func _process(delta: float) -> void:
	rotation = direction.angle()
	var swing_sign = sign(-direction.x)
	if swing_sign != 0:
		scale = Vector2(1,-swing_sign)
	if get_tree().paused:
		queue_free()


#func _unhandled_input(event: InputEvent) -> void:
	#if event.is_action_released("right_click"):
		#queue_free()

func on_animation_finished(anim_name:String,looped = false) -> void:
	queue_free()
