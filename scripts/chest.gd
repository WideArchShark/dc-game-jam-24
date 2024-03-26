extends StaticBody3D

@onready var chest_lid = $chest2/chest/chest_lid
@export var open_sound:AudioStreamPlayer

var opened:bool = false

func open_chest():
	if !opened:
		opened = true
		var tween = get_tree().create_tween()
		tween.tween_property(chest_lid, "rotation", Vector3(-PI/4,0,0), 1).set_trans(Tween.TRANS_ELASTIC)

func close_chest():
	if opened:
		opened = false
		var tween = get_tree().create_tween()
		tween.tween_property(chest_lid, "rotation", Vector3(0,0,0), 1).set_trans(Tween.TRANS_ELASTIC)

