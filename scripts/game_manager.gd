extends Node
class_name GameManagerSingleton

var starting_pos:Vector3i = Vector3i(22,1,10)
var starting_rot:float = PI/2

var main_scene:Node3D
var dungeon_maze_scene:Node3D
var fps_camera:CharacterBody3D

var moves_remaining:int = 1000

const DUNGEON = "res://scenes/dungeon_maze.tscn"
const MAIN = "res://scenes/main_scene.tscn"

var spoke_to_skeleton:bool = false
var dungeon_maze_door_unlocked:bool = false
var dungeon_maze_completed:bool = false

var spoke_to_barry:bool = false
var beaten_barry:bool = false

var nim_num_matches:int


func load_dungeon_maze():
	var tween = get_tree().create_tween()
	tween.tween_property(fps_camera.get_node("Fader"), "modulate", Color(0,0,0,1), 2).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN)
	await tween.finished
	GameManager.starting_pos = Vector3i(0,1,0)
	GameManager.starting_rot = -PI
	get_tree().change_scene_to_file(DUNGEON)
	
func load_main_scene_from_dungeon_maze():
	var tween = get_tree().create_tween()
	tween.tween_property(fps_camera.get_node("Fader"), "modulate", Color(0,0,0,1), 2).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN)
	await tween.finished
	GameManager.starting_pos = Vector3i(10,1,10)
	GameManager.starting_rot = -PI
	get_tree().change_scene_to_file(MAIN)
	
func start_nim():
	nim_num_matches = randi_range(6,11) * 2

func nim_num_matches_to_take() -> int:
	return max(1, (nim_num_matches-1)%4)
