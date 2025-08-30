extends CanvasLayer
class_name CurrentUpgradeUi

@onready var upgrade_label: Label = %UpgradeLabel
@onready var panel_container: PanelContainer = $MarginContainer/PanelContainer


var player:Player

func _ready() -> void:
	player = get_tree().get_first_node_in_group("Player") as Player
	if player == null:
		return
	player.current_upgrade_changed.connect(on_current_upgrade_changed)
	upgrade_label.text = player.initial_ability.name
	panel_container.gui_input.connect(on_gui_input)
	panel_container.mouse_entered.connect(on_mouse_entered)
	panel_container.mouse_exited.connect(on_mouse_exited)
	
	
func on_current_upgrade_changed(upgrade:Ability) -> void:
	upgrade_label.text = upgrade.name


func on_gui_input(event:InputEvent) -> void:
	if event.is_action_pressed("left_click"):
		if player == null:
			return
		player.upgrades_index += 1
		
		
func on_mouse_entered() -> void:
	panel_container.modulate = Color.CORNSILK
	
	
func on_mouse_exited() -> void:
	panel_container.modulate = Color.WHITE
