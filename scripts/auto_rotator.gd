extends Node3D

@export var mesh:Node3D

func rotate_to_target(target:Vector3):
	if round(target.x) < round(mesh.global_position.x):
		rotation.y = deg_to_rad(-90)
	else:
		rotation.y = deg_to_rad(180)

func _on_fps_grid_player_moved(new_pos):
	rotate_to_target(new_pos)
