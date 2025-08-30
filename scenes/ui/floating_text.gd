extends Node2D
class_name FloatingText
##传统的飘字，哪个性能优化版的飘字后面再做


func start(text:String) -> void:
	$Label.text = text
	
	var tween = create_tween()
	#这里的global_position都是生成节点时的位置，不会因为tween改变了值，后面的就被影响
	tween.tween_property(self,"global_position",global_position + Vector2.UP * 16,0.3)\
	.set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_QUART)
	tween.tween_property(self,"global_position",global_position + Vector2.UP * 48,0.3)\
	.set_ease(Tween.EASE_IN).set_trans(Tween.TRANS_QUART)
	
	tween.tween_callback(queue_free)
	
	var scale_tween = create_tween() #两个tween是并行执行，分开创建是因为一起创建有影响导致不能改变scale
	scale_tween.tween_property(self,"scale",Vector2.ONE * 1.5,0.3)\
	.set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_QUART)
	scale_tween.tween_property(self,"scale",Vector2.ZERO,0.3)\
	.set_ease(Tween.EASE_IN).set_trans(Tween.TRANS_QUART)
