extends StaticBody3D
class_name Interactable

enum InteractionType { EMIT_SIGNAL, DIALOGUE }

@export var is_interactable:bool = true
@export var dip_camera:bool = false
@export var interaction_type:InteractionType
@export var dialogue_resource:Resource
@export var dialogue_title:String 

signal on_interact(i:Interactable)
signal interact_finished()

func interact():
	if interaction_type == InteractionType.DIALOGUE:
		if dip_camera:
			GameManager.fps_camera.get_node("AnimationPlayer").play("look_down")
			
		DialogueManager.show_dialogue_balloon(dialogue_resource, dialogue_title)
		await DialogueManager.dialogue_ended
		interact_finished.emit()
		
		if dip_camera:
			GameManager.fps_camera.get_node("AnimationPlayer").play_backwards("look_down")
	elif interaction_type == InteractionType.EMIT_SIGNAL:
		on_interact.emit(self)

func mark_interaction_finished():
	interact_finished.emit()
