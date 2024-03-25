extends Node
class_name Cell

var pos:Vector2i
var visited:bool = false

func _init(x:int, y:int):
	pos = Vector2i(x,y)
