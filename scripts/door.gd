extends Node3D

var opened:bool = false

@onready var wall_doorway_door = $wall_doorway2/wall_doorway/wall_doorway_door
@onready var door_sign_label = $wall_doorway2/wall_doorway/wall_doorway_door/Sign/SignLabel

@export var door_sign:String = "NAME HERE"
@export var open_sound:AudioStreamPlayer
@export var close_sound:AudioStreamPlayer

func _ready():
	door_sign_label.text = door_sign

func open_door():
	if !opened:
		var tween = get_tree().create_tween()
		tween.tween_property(wall_doorway_door, "rotation", Vector3(0,PI/2,0), 0.5)
		open_sound.play()
		opened = true

func close_door():
	if opened:
		var tween = get_tree().create_tween()
		tween.tween_property(wall_doorway_door, "rotation", Vector3(0,0,0), 0.5)
		close_sound.play()
		opened = false

