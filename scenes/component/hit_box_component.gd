extends Area2D
class_name HitBoxComponent


@export var sparkle:PackedScene
var damage = 0 ##在对应武器controller实例化武器的时候赋值，为什么不直接用@export来控制武器的属性？也许是因为后面更改武器属性的物品这样更好控制
var knock_back :float = 1 ##击退
