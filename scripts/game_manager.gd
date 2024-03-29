extends Node
class_name GameManagerSingleton

var starting_pos:Vector3i = Vector3i(12,1,12)
#var starting_pos:Vector3i = Vector3i(0,1,0)
var starting_rot:float = 0

var main_scene:Node3D
var dungeon_maze_scene:Node3D
var fps_camera:CharacterBody3D

var game_completed:bool = false
var moves_remaining:int = 1000

var books_read:int = 0
var book1_read:bool = false
var book2_read:bool = false
var book3_read:bool = false
var book4_read:bool = false

const DUNGEON = "res://scenes/dungeon_maze.tscn"
const PUZZLE_ROOMS = "res://scenes/puzzle_rooms.tscn"
const MAIN = "res://scenes/main_scene.tscn"
const MENU = "res://scenes/main_menu.tscn"

var spoke_to_skeleton:bool = false
var spoke_to_skeleton_after_maze_complete:bool = false
var dungeon_maze_door_unlocked:bool = false

var puzzle_rooms_completed:bool = false
var cosmic_horror_completed:bool = false
var dungeon_maze_completed:bool = false
var beaten_barry:bool = false

var spoke_to_barry:bool = false

var spoken_to_mage:bool = false
var nim_num_matches:int

var current_barrel_word:String

func challenges_completed() -> int:
	var c:int = 0
	c += 1 if puzzle_rooms_completed else 0
	c += 1 if cosmic_horror_completed else 0
	c += 1 if dungeon_maze_completed else 0
	c += 1 if beaten_barry else 0
	return c

func rise_crypt_scene():
	main_scene.get_node("AnimationPlayer").play_backwards("crypt_hide")
	var tween = get_tree().create_tween()
	tween.tween_property(fps_camera, "global_position", Vector3(12,1,8),1)
	tween.parallel().tween_property(fps_camera, "rotation:y", 0,1)
	await tween.finished


func load_dungeon_maze():
	var tween = get_tree().create_tween()
	tween.tween_property(fps_camera.get_node("Fader"), "modulate", Color(0,0,0,1), 2).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN)
	await tween.finished
	GameManager.starting_pos = Vector3i(0,1,0)
	GameManager.starting_rot = -PI
	get_tree().change_scene_to_file(DUNGEON)
	
func load_puzzle_rooms():
	var tween = get_tree().create_tween()
	tween.tween_property(fps_camera.get_node("Fader"), "modulate", Color(0,0,0,1), 2).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN)
	await tween.finished
	GameManager.starting_pos = Vector3i(0,1,0)
	GameManager.starting_rot = PI/2
	get_tree().change_scene_to_file(PUZZLE_ROOMS)
	
func load_main_scene_from_dungeon_scene():
	var tween = get_tree().create_tween()
	tween.tween_property(fps_camera.get_node("Fader"), "modulate", Color(0,0,0,1), 2).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN)
	await tween.finished
	GameManager.starting_pos = Vector3i(10,1,10)
	GameManager.starting_rot = -PI
	get_tree().change_scene_to_file(MAIN)
	
func load_main_scene_from_puzzle_rooms_scene():
	var tween = get_tree().create_tween()
	tween.tween_property(fps_camera.get_node("Fader"), "modulate", Color(0,0,0,1), 2).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN)
	await tween.finished
	GameManager.starting_pos = Vector3i(12,1,-10)
	GameManager.starting_rot = PI
	get_tree().change_scene_to_file(MAIN)	
	
func start_nim():
	nim_num_matches = randi_range(6,11) * 2

func nim_num_matches_to_take() -> int:
	return max(1, (nim_num_matches-1)%4)
