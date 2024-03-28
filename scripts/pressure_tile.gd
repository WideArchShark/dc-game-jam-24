extends StaticBody3D
class_name PressureTile

@export var tile_symbol:String:
	set(s):
		tile_symbol = s
		$TileLabel.text = s
	get:
		return tile_symbol
		

signal tile_pressed(pressure_tile:PressureTile)

func _ready():
	$TileLabel.text = tile_symbol

func _on_actionable_entered():
	tile_pressed.emit(self)
	$ActionableArea.mark_action_finished()

