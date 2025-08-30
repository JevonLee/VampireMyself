extends Node
class_name HitFlashComponent

@export var hurt_box:HurtBoxComponent
@export var visuals:Node2D
@export var flash_shader:ShaderMaterial

var flash_tween:Tween

func _ready() -> void:
	hurt_box.hurting.connect(on_hurting)
	visuals.material = flash_shader


func on_hurting(_knockback:float) -> void:
	if flash_tween != null and flash_tween.is_valid():
		flash_tween.kill()
	
	(visuals.material as ShaderMaterial).set_shader_parameter("lerp_percent",1.0)
	
	flash_tween = create_tween()
	flash_tween.tween_property(visuals.material,"shader_parameter/lerp_percent",0.0,0.2)
