extends StaticBody3D

var is_lerping:bool = false
var lerp_progress:float = 0
var current_rot:float
var target_rot:float

func _process(delta):
	if is_lerping:
		$letter_barrel.rotation.x = lerp_angle(current_rot, target_rot, lerp_progress)
		lerp_progress += delta * 2
		
		if lerp_progress > 1:
			is_lerping = false
			$letter_barrel.rotation.x = target_rot
			if abs(TAU - $letter_barrel.rotation.x) < 0.1:
				$letter_barrel.rotation.x = 0
			$Interactable.mark_interaction_finished()
		
func _on_interact():
	lerp_progress = 0
	current_rot = $letter_barrel.rotation.x
	target_rot = current_rot + PI/4
	print("", current_rot, " ", target_rot)
	is_lerping = true
