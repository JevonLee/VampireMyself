class_name WeightedTable

var items:Array[Dictionary] = []
var weight_sum = 0

func add_item(item,weight:int):
	items.append({"item":item,"weight":weight})
	weight_sum += weight
	#假设有两个物品，权重分别是10，20

func pick_item(exclude:Array = []):
	var adjust_items:Array[Dictionary] = items
	var adjust_weight_sum = weight_sum
	if exclude.size() > 0:#如果传进来的数组有值，说明这是需要过滤的
		adjust_items = []
		adjust_weight_sum = 0
		for item in items:
			if item["item"] in exclude:
				continue
			adjust_items.append(item)
			adjust_weight_sum += item["weight"]
		
	var chosen_weight = randi_range(1,adjust_weight_sum)#假设这里随机权重是5，或者25
	var iteration_sum = 0
	for item in adjust_items:#一种比较新奇的计算方式
		iteration_sum += item["weight"] #遍历items数组的权重和，第一次是10，第二次是30
		if chosen_weight <= iteration_sum:#当选中5时返回第一个item，选中25时返回第二个item
			return item["item"]


func remove_item(item_to_remove):
	items = items.filter(func(item): return item["item"] != item_to_remove)
	weight_sum = 0
	for item in items:
		weight_sum += item["weight"]	
