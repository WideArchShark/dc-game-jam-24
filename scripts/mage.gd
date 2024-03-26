extends CharacterBody3D
@onready var animation_tree = $AnimationTree
const MAGE = preload("res://dialogue_resources/mage.dialogue")


func _ready():
	$AnimationPlayer.play("Idle")
	
func mage_interact():
	animation_tree.get("parameters/playback").travel("Cheer")
	DialogueManager.show_dialogue_balloon(MAGE)
	await DialogueManager.dialogue_ended
	$Interactable.mark_interaction_finished()
	#animation_tree.set("parameters/conditions/sleeping", true)

func _on_interact():
	mage_interact()
