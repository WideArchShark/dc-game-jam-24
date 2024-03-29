extends Node3D

@export var barrels:Array[Node3D]

func _ready():
	for i in range(barrels.size()):
		#barrels[i].get_node("Interactable").on_interact.connect(update_sign.bind(i, barrels[i]))
		barrels[i].get_node("Interactable").on_interact.connect(update_sign)
	update_sign(null)
		
func update_sign(interactable:Interactable):
	$SignLabel.text = ""
	for i in range(barrels.size()):
		$SignLabel.text += barrels[i].get_barrel_letter_selected()
	GameManager.current_barrel_word = $SignLabel.text
	
