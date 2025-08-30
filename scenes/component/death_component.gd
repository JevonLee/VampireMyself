extends Node2D
class_name DeathComponent
##使用这个组件的原因是为了在角色死亡之后取消物理检测，同时还能播放动画效果

@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var gpu_particles_2d: GPUParticles2D = $GPUParticles2D

@export var health_component:HealthComponent
@export var sprite:Sprite2D

func _ready() -> void:

	gpu_particles_2d.texture = sprite.texture
	
	health_component.died.connect(on_died)


func on_died() -> void:
	if owner == null || not owner is Node2D:
		return
		
	var spawn_position = owner.global_position
	var spawn_rotation = ((owner as BasicEnemy).get_player_direction()).angle() - PI/2
	
	var entites = get_tree().get_first_node_in_group("EntitiesLayer")
	if entites == null:
		return
	self.reparent(entites)
	
	gpu_particles_2d.rotation = spawn_rotation
	global_position = spawn_position
	animation_player.play("default")
