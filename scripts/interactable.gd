extends StaticBody3D

@export var is_interactable:bool = true

signal on_interact()
signal interact_finished()

func interact():
	on_interact.emit()

func mark_interaction_finished():
	interact_finished.emit()
