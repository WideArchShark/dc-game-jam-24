extends Node3D

var steps:int = 0
var shutter_open:bool = false

func _ready():
	reset_spinner()
	
func step_spinner():
	steps += 1
	var target_rot:float = (-PI/6) * steps
	var tween = get_tree().create_tween()
	tween.tween_property($mesh/Spinner, "rotation", Vector3(0,0,target_rot), 0.5)

func reset_spinner():
	steps = 0
	open_shutter()
	$mesh/Spinner.rotation.z = 0
	
func open_shutter():
	if !shutter_open:
		$AnimationPlayer.play("open_shutter")
		shutter_open = true

func close_shutter():
	if shutter_open:
		$ShutSound.play()
		$AnimationPlayer.play_backwards("open_shutter")
		shutter_open = false
