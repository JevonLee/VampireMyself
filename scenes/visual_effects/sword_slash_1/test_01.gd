@tool
extends Line2D

# 圆属性
@export var center: Vector2 = Vector2.ZERO  # 圆心位置
@export var radius: float = 100.0          # 半径
@export var points_count: int = 64         # 点的数量，越多越平滑
@export var rotation_angle: float = 0.0:  # 旋转角度
	set(val):
		rotation_angle = val + rotation_speed
		draw_circles()
		
@export var rotation_speed: float = 10  # 旋转速度


func draw_circles():
	# 清空现有点
	clear_points()
	
	# 计算圆上的点并添加到Line2D
	for i in range(points_count + 1):
		# 计算角度（0到2π）
		var angle = i * TAU / points_count + rotation_angle
		# 计算圆上点的坐标
		var x = center.x + radius * cos(angle)
		var y = center.y + radius * sin(angle)
		add_point(Vector2(x, y))


#func _process(delta):
	#rotation_angle += rotation_speed * delta
	#draw_circles()
