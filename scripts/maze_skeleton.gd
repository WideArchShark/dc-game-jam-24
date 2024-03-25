extends CharacterBody3D

func _ready():
	$AnimationPlayer.play("Idle")
	
func _on_fps_grid_player_player_moved(new_pos):
	if round(new_pos.x) < round(global_position.x):
		rotation.y = deg_to_rad(-90)
	else:
		rotation.y = deg_to_rad(180)
