extends Node

## 预制体列表,TODO 未来读配置比较好
@export var prefabs : Dictionary[String,PackedScene] = {}

@export var common_path : String = "/root/Main/Entities"

# 共同父节点，用于给有y排序需求的对象
var common_parent : Node = null:
	get:
		if not common_parent and not common_path.is_empty():
			common_parent = get_node_or_null(common_path)
		return common_parent

# 所有池子
var object_pools : Dictionary[String,Pool] = {}

# 获取特定类对象
func get_object(_name : String)->Node:
	if not prefabs.has(_name):
		push_error("对象池管理器|获取对象方法|找不到相应预制体：",_name)
		return null
	# 没有对应对象池时，新建对象池
	if not object_pools.has(_name):
		if not common_parent:
			var new_layer := Node2D.new()
			new_layer.name = _name
			new_layer.y_sort_enabled = true
			add_child(new_layer)
			object_pools[_name] = Pool.new(new_layer,prefabs[_name])
		else:
			# 为了处理y排序,直接加到实体下。当前的写法多少有点丑陋了
			object_pools[_name] = Pool.new(common_parent,prefabs[_name])
	
	return object_pools[_name].get_object()

# 释放特定类对象
func release_object(_name : String,obj : Node)->void:
	if not prefabs.has(_name):
		push_error("对象池管理器|释放对象方法|该对象不归对象池管理：",_name)
		return
	if not obj:
		push_error("对象池管理器|释放对象方法|对象为空：",_name)
		return
	# if not obj.is_class(prefabs[_name].instantiate().get_class()):
	# 	push_error("对象池管理器|释放对象方法|释放对象类型不匹配")
	# 	return
	object_pools[_name].release_object(obj)

# 从配置中获取预制体资源位置,需在环境初始化时调用,TODO
func update_prefabs_with_config(config)->void:
	pass

## 池子
class Pool extends RefCounted:
	# NOTE 该对象池的get和release的自身的时间复杂度为O(1)
	# 不再有大小限制，默认直接扩容，取消扩容计数，不再使用queue_free移除超限制对象
	# 不再有池中对象的合法性检测，需要外部有更严谨的使用习惯
	
	# 该池出来的对象的父节点
	var pool_layer : Node = null
	# 池中对象
	var pool_objects : Array[Node]
	# 对象的存在状态
	var is_has_object : Dictionary[Node,bool] = {}
	# 当前对象池大小
	var cur_pool_size : int = 0
	# 预制体
	var pool_prefab : PackedScene
	
	
	func _init(layer : Node,prefab : PackedScene) -> void:
		pool_layer = layer
		pool_prefab = prefab
	
	# 获取对象池物体
	func get_object()->Node:
		var obj : Node = null
		if cur_pool_size > 0:
			# 栈式写法保证了获取时的 O(1)时间复杂度
			# 同时没有pop行为，用脏数据换修改时间，也方便下次直接赋值而非append
			cur_pool_size -= 1
			obj = pool_objects[cur_pool_size]
			is_has_object.erase(obj)
		else:
			var new_obj := pool_prefab.instantiate()
			pool_layer.add_child(new_obj)
			obj = new_obj
		obj.process_mode = Node.PROCESS_MODE_INHERIT
		return obj
	
	# 释放对象池对象
	func release_object(obj : Node)->void:
		# 防重复释放，字典保证其查询的时间复杂度是O(1)
		if is_has_object.has(obj):
			return
		
		# 最耗时的一段了
		if obj.has_method("_release"):
			# 特殊释放行为，需写在对象的脚本中
			obj._release()
		await pool_layer.get_tree().physics_frame
		
		# 默认释放行为
		obj.process_mode = Node.PROCESS_MODE_DISABLED
		# 池子大小索引到最大时
		if cur_pool_size == pool_objects.size():
			pool_objects.append(obj)
		# 池子大小索引只有 和池子一样大 和 比池子小 两种状态
		else:
			pool_objects[cur_pool_size] = obj
		cur_pool_size += 1
		is_has_object[obj] = true
		

	# TODO 目前不是很需要优化内存。有需求时再来搞控制池子容量的事
