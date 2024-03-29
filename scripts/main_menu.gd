extends Control

@onready var play_button = $Background/VBoxContainer/PlayButton

func _ready():
	fade_in()
	GameManager.set_script(null)
	GameManager.set_script(preload("res://scripts/game_manager.gd"))
	play_button.grab_focus()
	
func _on_play_button_pressed():
	$Background/VBoxContainer/PlayButton.disabled = true
	await fade_out()
	get_tree().change_scene_to_file(GameManager.MAIN)

func fade_out():
	var tween = get_tree().create_tween()
	tween.tween_property($Background/Fader, "color:a", 1, 1).set_trans(Tween.TRANS_SINE)
	await tween.finished
	
func fade_in():
	var tween = get_tree().create_tween()
	tween.tween_property($Background/Fader, "color:a", 0, 1.5).set_trans(Tween.TRANS_SINE)
	await tween.finished
