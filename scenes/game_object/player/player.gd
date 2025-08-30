extends CharacterBody2D
class_name Player

# 更改了motion mode

const MAX_SPEED = 125
const ACCELERATION_SMOOTHING = 25

signal current_upgrade_changed(upgrade:Ability)

@onready var collision_area_2d: Area2D = $CollisionArea2D
@onready var damage_interval_timer: Timer = $DamageIntervalTimer
@onready var health_bar: ProgressBar = $HealthBar
@onready var abilities: Node = %Abilities
@onready var visuals: Node2D = $Visuals
@onready var animation_player: AnimationPlayer = $AnimationPlayer

@export var health_component: HealthComponent
@export var initial_ability:Ability

var number_colliding_bodies = 0
var player_direction:Vector2 ##停下时的朝向
var current_upgrade:Ability:set = _set_current_upgrade
var upgrades:Array[Ability] #这是武器能力
var upgrades_index:int = 0:
	set(val):
		if val < 0 :
			val = upgrades.size() - 1
		upgrades_index = val%upgrades.size()
		current_upgrade = upgrades[upgrades_index]


func _ready() -> void:
	collision_area_2d.body_entered.connect(on_body_entered)
	collision_area_2d.body_exited.connect(on_body_exited)
	damage_interval_timer.timeout.connect(on_timeout)
	health_component.health_changed.connect(on_health_changed)
	GameEvents.ability_upgrade_added.connect(on_ability_upgrade_added)
	update_health_bar()
	upgrades.append(initial_ability)
	
	
func _process(delta: float) -> void:
	var direction = get_movement_vector()
	var target_velocity = direction * MAX_SPEED
	velocity = velocity.lerp(target_velocity, 1 - exp(-delta * ACCELERATION_SMOOTHING))
	move_and_slide()##这里的lerp和camera那里同理
	update_animation(direction)
	
	
func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("up"):
		upgrades_index -= 1
	elif event.is_action_pressed("down"):
		upgrades_index += 1
	
	
func update_animation(direction:Vector2) -> void:
	if direction != Vector2.ZERO:
		player_direction = direction
		animation_player.play("move")
	else:
		animation_player.stop()
	
	var move_sign = sign(player_direction.x) #-1,1,0
	if move_sign != 0:
		visuals.scale = Vector2(-move_sign,1)
	
	#下面是之前的代码，方便参考，可以简化代码
	#if player_direction.x >= 0.0:
		#visuals.scale = Vector2.ONE
	#else:
		#visuals.scale = Vector2(-1,1)
		#通过一个node2D节点管理所有可视的部分（身体，腿，手），这样就可以控制所有反转
		
	
func get_movement_vector() -> Vector2:
	var movement_vector := Input.get_vector("move_left","move_right","move_up","move_down")
	return movement_vector
	#var movement_x = Input.get_action_strength("move_right") - Input.get_action_strength("move_left")
	#var movement_y = Input.get_action_strength("move_down") - Input.get_action_strength("move_up")
	#return Vector2(movement_x,movement_y)


func check_deal_damage() -> void:
	if number_colliding_bodies == 0 or !damage_interval_timer.is_stopped():
		return
	health_component.damage(1)
	damage_interval_timer.start()
	

func update_health_bar() -> void:
	var tween = create_tween()
	tween.tween_property(health_bar,"value",health_component.get_health_percent(),.2)


func _set_current_upgrade(val:Ability) ->void:
	#static不能设置setter
	if current_upgrade == val:
		return
	for ability in abilities.get_children():
		ability.queue_free()
	abilities.add_child(val.ability_controller.instantiate())
	current_upgrade = val
	current_upgrade_changed.emit(val)


func on_body_entered(body:Node2D) -> void:
	number_colliding_bodies += 1
	check_deal_damage()
	

func on_body_exited(body:Node2D) -> void:
	number_colliding_bodies -= 1
	
	
func on_timeout() -> void:
	check_deal_damage()
	
	
func on_health_changed() -> void:
	update_health_bar()


func on_ability_upgrade_added(upgrade:AbilityUpgrade,current_upgrades:Dictionary) -> void:
	if not upgrade is Ability:
		return #只有后续拓展的能力才能被添加，也就是有controller场景的
	var ability = upgrade as Ability
	upgrades.append(ability)
	upgrades_index += 1
	current_upgrade = upgrades[upgrades.size()-1]
	
