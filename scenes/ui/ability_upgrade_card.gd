extends PanelContainer
class_name AbilityUpgradeCard

signal selected

@onready var name_label: Label = %NameLabel
@onready var description_label: Label = %DescriptionLabel
@onready var animation_player: AnimationPlayer = $AnimationPlayer

@export var sfx_array:Array[AudioStream]

var disabled:bool = false ##防止多次点击

func _ready() -> void:
	mouse_entered.connect(on_mouse_entered)
	mouse_exited.connect(on_mouse_exited)
	

func set_ability_upgrade(upgrade:AbilityUpgrade) -> void:
	name_label.text = upgrade.name
	description_label.text = upgrade.description


func play_in(delay:float) -> void:
	modulate = Color.TRANSPARENT
	await get_tree().create_timer(delay).timeout
	modulate = Color.WHITE
	animation_player.play("in")


func select_card() -> void:
	AudioManager.play_random_sfx(sfx_array)
	disabled = true
	var tween = create_tween()
	tween.tween_property(self.material,"shader_parameter/val",1.0,1.0)
	tween.parallel()
	tween.tween_callback(func():
		var discards = get_tree().get_nodes_in_group("upgrade_card") as Array[AbilityUpgradeCard]
		for i in discards:
			if i == self:
				continue
			i.animation_player.play("disselected")
			i.disabled = true
	)
	tween.tween_callback(func():selected.emit())
	

func _gui_input(event: InputEvent) -> void:
	if disabled:
		return
	if event.is_action_pressed("left_click"):
		select_card()


func on_mouse_entered() -> void:
	if disabled:
		return ##只有点击选中的卡片才会防二次点击
	var tween = create_tween().set_ease(Tween.EASE_IN_OUT).set_trans(Tween.TRANS_ELASTIC)
	tween.tween_property(self,"scale",Vector2(1.2,1.2),0.2)
	AudioManager.set_volume(AudioManager.Bus.SFX,0.5)
	AudioManager.play_random_sfx(sfx_array)


func on_mouse_exited() -> void:
	if disabled:
		return
	var tween = create_tween().set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_BOUNCE)
	tween.tween_property(self,"scale",Vector2(1,1),0.2)
