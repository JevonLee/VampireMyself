extends Node
##Autoload

func hitstop(node:Node,time:float=0.3) -> void:
	##多种实现方式：动画暂停，物理帧暂停等
	#目前来说这个游戏实现这种效果很呆，空洞骑士有这个效果
	
	#如果武器刀光是line2d跟随就很丑,动画帧也会暴露原型
	Engine.time_scale = 0.1
	await get_tree().create_timer(time,true,false,true).timeout
	Engine.time_scale = 1.0
	
	#也不能通过传入node的方式，如果node以及释放就会报错
	#node.set_physics_process(false)
	#await get_tree().create_timer(time).timeout
	#node.set_physics_process(true)
	
