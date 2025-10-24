extends Node
class_name UpgradeManager

@export var experience_manager:ExperienceManager
@export var upgrade_screen:PackedScene
@export_category("升级的能力")
@export var upgrade_axe:AbilityUpgrade
@export var upgrade_death:AbilityUpgrade
@export var upgrade_murasama:AbilityUpgrade
@export var upgrade_murasama_damage:AbilityUpgrade
@export var upgrade_sword_rate:AbilityUpgrade
@export var upgrade_sword_damage:AbilityUpgrade
@export var upgrade_terra_blade:AbilityUpgrade
@export var upgrade_muramasa:AbilityUpgrade
@export var upgrade_pink_cubic:AbilityUpgrade

var current_upgrades = {}
var upgrade_pool:WeightedTable = WeightedTable.new()


func _ready() -> void:
	#upgrade_pool.add_item(upgrade_axe,10)
	#upgrade_pool.add_item(upgrade_death,10)
	upgrade_pool.add_item(upgrade_murasama,10)
	#upgrade_pool.add_item(upgrade_sword_damage,10)
	#upgrade_pool.add_item(upgrade_sword_rate,10)
	upgrade_pool.add_item(upgrade_terra_blade,10)
	upgrade_pool.add_item(upgrade_muramasa,10)
	upgrade_pool.add_item(upgrade_pink_cubic,15)
	
	experience_manager.level_up.connect(on_level_up)
	
func pick_upgrades():
	var chosen_upgrades:Array[AbilityUpgrade] = []
	for i in 3:#添加的卡片数量，同时选择的能力不能重复
		if upgrade_pool.items.size() == chosen_upgrades.size():
			##原本是通过数组的filter函数过滤重复的升级,新的upgrade_pool会直接移除到达max_quantity的item
			break
		var chosen_upgrade = upgrade_pool.pick_item(chosen_upgrades)#这里传参直接过滤掉这个
		chosen_upgrades.append(chosen_upgrade)
	
	return chosen_upgrades
	
	
func apply_upgrade(upgrade:AbilityUpgrade) -> void:
	##要应用的升级的能力
	var has_upgrade = current_upgrades.has(upgrade.id)
	if !has_upgrade: #如果字典里没有就添加，else就数量加一
		current_upgrades[upgrade.id] = {
			"resource" : upgrade,
			"quantity" : 1,
		}
		#最终效果是 "物品id":{
		#"resource": xxx,
		#"quantity": x,
		#}双重字典的形式
	else:
		current_upgrades[upgrade.id]["quantity"] += 1
	
	#通过upgrade的max_quantity来限制选择的次数
	var current_quantity = current_upgrades[upgrade.id]["quantity"]
	if current_quantity == upgrade.max_quantity:
		##升级次数到上限之后直接移除加权表
		upgrade_pool.remove_item(upgrade)
	
	update_upgrade_pool(upgrade)
	GameEvents.emit_ability_upgrade_added(upgrade,current_upgrades)


func update_upgrade_pool(chosen_upgrade:AbilityUpgrade) -> void:
	return
	##此项升级需要依赖另一项升级
	if chosen_upgrade.id == upgrade_murasama.id :
		upgrade_pool.add_item(upgrade_murasama_damage,10)


func on_level_up(current_level:int) -> void:
	if upgrade_pool.items.is_empty():
		return
	var upgrade_screen_instance = upgrade_screen.instantiate() as UpgradeScreen
	add_child(upgrade_screen_instance)
	upgrade_screen_instance.set_ability_upgrades(pick_upgrades())
	upgrade_screen_instance.upgrade_selected.connect(on_upgrade_selected)


func on_upgrade_selected(upgrade:AbilityUpgrade) -> void:
	apply_upgrade(upgrade)
	
