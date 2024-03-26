extends Node
class_name GameManagerSingleton

var fps_camera:CharacterBody3D

const DUNGEON = "res://scenes/dungeon_maze.tscn"

func load_dungeon_maze():
	var tween = get_tree().create_tween()
	tween.tween_property(fps_camera.get_node("Fader"), "modulate", Color(0,0,0,1), 2).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN)
	await tween.finished
	get_tree().change_scene_to_file(DUNGEON)
