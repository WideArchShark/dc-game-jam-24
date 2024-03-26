extends StaticBody3D

enum InteractionType { EMIT_SIGNAL, DIALOGUE }

@export var is_interactable:bool = true
@export var interaction_type:InteractionType
@export var dialogue_resource:Resource
@export var dialogue_title:String 

signal on_interact()
signal interact_finished()

func interact():
	if interaction_type == InteractionType.DIALOGUE:
		DialogueManager.show_dialogue_balloon(dialogue_resource, dialogue_title)
		await DialogueManager.dialogue_ended
		interact_finished.emit()
	elif interaction_type == InteractionType.EMIT_SIGNAL:
		on_interact.emit()

func mark_interaction_finished():
	interact_finished.emit()
