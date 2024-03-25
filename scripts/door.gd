extends Node3D

var opened:bool = false

@onready var interactable = $wall_doorway2/wall_doorway/wall_doorway_door/Interactable
@onready var wall_doorway_door = $wall_doorway2/wall_doorway/wall_doorway_door
@onready var door_sign_label = $wall_doorway2/wall_doorway/wall_doorway_door/Sign/SignLabel
@export var door_sign:String = ""

func _ready():
	door_sign_label.text = door_sign
	
func _on_interact():
	print("Yep, got here!")
	if !opened:
		interactable.is_interactable = false # Can only interact with this once.
		var tween = get_tree().create_tween()
		tween.tween_property(wall_doorway_door, "rotation", Vector3(0,PI/2,0), 0.5)
		opened = true
		await tween.finished
		interactable.mark_interaction_finished()
