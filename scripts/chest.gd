extends StaticBody3D

@onready var chest_lid = $chest2/chest/chest_lid
@export var open_sound:AudioStreamPlayer

var opened:bool = false

func chest_interact():
	$Interactable.is_interactable = false # Can only interact with this once.
	if !opened:
		var tween = get_tree().create_tween()
		tween.tween_property(chest_lid, "rotation", Vector3(-PI/4,0,0), 1).set_trans(Tween.TRANS_ELASTIC)
		opened = true
		await tween.finished
		$Interactable.mark_interaction_finished()

func _on_interactable_on_interact():
	chest_interact()
