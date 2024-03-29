extends Node3D

func _ready():
	GameManager.main_scene = self
	$AnimationPlayer.play("crypt_hide")
	
	$Crypt/Skeleton_Minion/AnimationPlayer.play("Cheer")
	await get_tree().create_timer(0.25).timeout
	$Crypt/Mage/AnimationPlayer.play("Cheer")
	await get_tree().create_timer(0.25).timeout
	$Crypt/Barry/Barbarian/AnimationPlayer.play("Cheer")
	$Crypt/character_rogue/AnimationPlayer.play("rock")
	
	$Crypt.visible = false
	
func _on_garden_entered():
	$Crypt.visible = true
	#$Walls/CryptDoor/Interactable.is_interactable = false
	#$Walls/CryptDoor.close_door()
	$DirtTiles/DirtTile37/ActionableArea.mark_action_finished()
