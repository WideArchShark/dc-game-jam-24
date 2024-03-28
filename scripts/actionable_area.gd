extends Area3D

signal on_action()
signal action_finished()

@export var is_actionable:bool = true

func _on_body_entered(_body):
	add_to_group("Actions")

func _on_body_exited(_body):
	remove_from_group("Actions")

func do_action():
	on_action.emit()
	
func mark_action_finished():
	action_finished.emit()
