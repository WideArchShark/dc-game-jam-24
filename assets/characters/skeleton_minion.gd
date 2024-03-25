extends Node3D

const DUNGEON_SCENE = "res://scenes/dungeon_maze.tscn"
@onready var fps_fader = $"../FPSGridPlayer/Fader"
const SKELETON = preload("res://dialogue_resources/skeleton.dialogue")
func _ready():
	$AnimationPlayer.play("Idle")

func _on_interact():
	#load_dungeon_maze()
	DialogueManager.show_dialogue_balloon(SKELETON, "first_meeting")
	await DialogueManager.dialogue_ended
	$Interactable.mark_interaction_finished()
	
func load_dungeon_maze():
	var tween = get_tree().create_tween()
	tween.tween_property(fps_fader, "modulate", Color(0,0,0,1), 2).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN)
	await tween.finished
	get_tree().change_scene_to_file(DUNGEON_SCENE)
