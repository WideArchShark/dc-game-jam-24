extends Node3D

var _room1_num_moves:int = 0
var _room2_current_total:int = 0
var _room2_started:bool = false
var _room3_failed:bool = false
var pattern1:String = "OXI"
var pattern3:String = "RGB"

func _ready():
	reset_tiles1()
	reset_tiles2()
	reset_tiles3()
	
func _on_tile_pressed1(pressure_tile):
	if pressure_tile.tile_symbol[0] != pattern1[_room1_num_moves % pattern1.length()]:
		$Room1/Walls1/Door2.close_door()
	pressure_tile.tile_symbol = " "
	_room1_num_moves += 1
	
func _on_tile_pressed2(pressure_tile):
	_room2_started = true
	_room2_current_total += int(pressure_tile.tile_symbol)
	_room2_current_total = max(0, _room2_current_total) # Don't drop below zero!
	$Room2/ProgressSign/SignLabel.text = "%d" % _room2_current_total
	pressure_tile.tile_symbol = "-%d" % abs(int(pressure_tile.tile_symbol))
	if $Room2/PatternSign2/SignLabel.text == $Room2/ProgressSign/SignLabel.text:
		$Room2/Walls2/Door3.open_door()
	else:
		$Room2/Walls2/Door3.close_door()
		
func reset_tiles1():
	_room1_num_moves = 0
	$Room1/Walls1/Door2.open_door()
	$Room1/PressureTiles1/PressureTile01.tile_symbol = "O"
	$Room1/PressureTiles1/PressureTile02.tile_symbol = "O"
	$Room1/PressureTiles1/PressureTile03.tile_symbol = "O"
	$Room1/PressureTiles1/PressureTile04.tile_symbol = "X"
	$Room1/PressureTiles1/PressureTile05.tile_symbol = "I"
	$Room1/PressureTiles1/PressureTile06.tile_symbol = "O"
	$Room1/PressureTiles1/PressureTile07.tile_symbol = "O"
	$Room1/PressureTiles1/PressureTile08.tile_symbol = "I"
	$Room1/PressureTiles1/PressureTile09.tile_symbol = "X"
	$Room1/PressureTiles1/PressureTile10.tile_symbol = "I"
	$Room1/PressureTiles1/PressureTile11.tile_symbol = "O"
	$Room1/PressureTiles1/PressureTile12.tile_symbol = "O"

func reset_tiles2():
	_room2_started = false
	_room2_current_total = 0
	$Room2/ProgressSign/SignLabel.text = "0"
	$Room2/Walls2/Door3.close_door() # probable already closed!
	$Room2/PressureTiles2/PressureTile01.tile_symbol = "1"
	$Room2/PressureTiles2/PressureTile02.tile_symbol = "1"
	$Room2/PressureTiles2/PressureTile03.tile_symbol = "1"
	$Room2/PressureTiles2/PressureTile04.tile_symbol = "2"
	$Room2/PressureTiles2/PressureTile05.tile_symbol = "2"
	$Room2/PressureTiles2/PressureTile06.tile_symbol = "2"
	$Room2/PressureTiles2/PressureTile07.tile_symbol = "3"
	$Room2/PressureTiles2/PressureTile08.tile_symbol = "3"
	$Room2/PressureTiles2/PressureTile09.tile_symbol = "3"

func reset_tiles3():
	$Room3/PressureTiles3/PressureTile01/TileLabel.visible = false
	$Room3/PressureTiles3/PressureTile02/TileLabel.visible = false
	$Room3/PressureTiles3/PressureTile03/TileLabel.visible = false
	$Room3/PressureTiles3/PressureTile04/TileLabel.visible = false
	$Room3/PressureTiles3/PressureTile05/TileLabel.visible = false
	$Room3/PressureTiles3/PressureTile06/TileLabel.visible = false
	$Room3/PressureTiles3/PressureTile07/TileLabel.visible = false
	$Room3/PressureTiles3/PressureTile08/TileLabel.visible = false
	$Room3/PressureTiles3/PressureTile09/TileLabel.visible = false
	$Room3/PressureTiles3/PressureTile10/TileLabel.visible = false
	$Room3/PressureTiles3/PressureTile11/TileLabel.visible = false
	$Room3/PressureTiles3/PressureTile12/TileLabel.visible = false
	$Room3/Walls3/Spinner.reset_spinner()
	var tween = get_tree().create_tween()
	tween.tween_property($Room3/Walls3/Spinner, "position:x", -2, 0.5)
	_room3_failed = false

	
func _on_button1_interact():
	if !$Room1/Walls1/Door2.opened:
		reset_tiles1()
		$ResetSound.play()
	$Room1/Button1/Interactable.mark_interaction_finished()

func _on_button2_interact():
	if _room2_started:
		reset_tiles2()
		$ResetSound.play()
	$Room2/Button2/Interactable.mark_interaction_finished()
	
func _on_button3_interact():
	if _room3_failed:
		reset_tiles3()
		$ResetSound.play()
	$Room3/Button3/Interactable.mark_interaction_finished()
	
func _on_room1_complete():
	$Room1/Walls1/Door2.close_door()
	$Room2/FloorTiles2/FloorTile04/ActionableArea.mark_action_finished()
	#$Room1.visible = false

func _on_room2_complete():
	$Room2/Walls2/Door3.close_door()
	$Room3/FloorTiles3/FloorTile04/ActionableArea.mark_action_finished()

func _on_tile_pressed3(pressure_tile):
	if !_room3_failed:
		var tween = get_tree().create_tween()
		tween.tween_property($Room3/Walls3/Spinner, "position:x", pressure_tile.position.x, 0.5)

		if pressure_tile.tile_symbol != pattern3[$Room3/Walls3/Spinner.steps % 3]:
			$Room3/Walls3/Spinner.close_shutter()
			$Room3/Walls3/Door4.close_door()
			_room3_failed = true
		else:
			$Room3/Walls3/Spinner.step_spinner()
			if $Room3/Walls3/Spinner.steps == 12:
				$Room3/Walls3/Door4.open_door()

func _on_room3_complete():
	$Room3/Walls3/Door4.close_door()
	$Room3/FloorTiles3/FloorTile13/ActionableArea.mark_action_finished()
