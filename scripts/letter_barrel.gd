extends StaticBody3D

#var is_lerping:bool = false
#var lerp_progress:float = 0
#var current_rot:float
#var target_rot:float

@export var letters:String
var steps:int = 0

func get_barrel_letter_selected() -> String:
	return letters[steps%8]
	
func _ready():
	$letter_barrel/barrel_small/Label0.text = letters[0]
	$letter_barrel/barrel_small/Label1.text = letters[1]
	$letter_barrel/barrel_small/Label2.text = letters[2]
	$letter_barrel/barrel_small/Label3.text = letters[3]
	$letter_barrel/barrel_small/Label4.text = letters[4]
	$letter_barrel/barrel_small/Label5.text = letters[5]
	$letter_barrel/barrel_small/Label6.text = letters[6]
	$letter_barrel/barrel_small/Label7.text = letters[7]

func _on_barrel_interact(interactable:Interactable):
	steps += 1
	var target_rot:float = ((TAU/8) * steps)
	print(get_barrel_letter_selected())
	var tween = get_tree().create_tween()
	tween.tween_property($letter_barrel/barrel_small, "rotation:x", target_rot, 0.4)
	interactable.mark_interaction_finished()
