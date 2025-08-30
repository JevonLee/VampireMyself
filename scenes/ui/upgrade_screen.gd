extends CanvasLayer
class_name UpgradeScreen

signal upgrade_selected(upgrade:AbilityUpgrade)

@onready var card_container: HBoxContainer = %CardContainer

@export var ability_upgrade_card:PackedScene

func _ready() -> void:
	get_tree().paused = true

func set_ability_upgrades(upgrades:Array[AbilityUpgrade]) -> void:
	var delay = 0.2
	for upgrade in upgrades:
		var card_instance = ability_upgrade_card.instantiate() as AbilityUpgradeCard
		card_container.add_child(card_instance)
		card_instance.set_ability_upgrade(upgrade)
		card_instance.play_in(delay)
		card_instance.selected.connect(on_selected.bind(upgrade))
		delay += 0.2
		
		
func on_selected(upgrade:AbilityUpgrade) -> void:
	upgrade_selected.emit(upgrade)
	get_tree().paused = false
	queue_free()
