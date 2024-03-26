@tool
extends Node3D

var cells:Array[Cell]
var trk:Node3D # Visual tracker for @tool mode

var movement_progress:float = 0
@onready var dungeon_maze_dialogue = preload("res://dialogue_resources/dungeon_maze.dialogue")

signal maze_generated

@export var reset:bool:
	set(value):
		clear_dungeon()
		generate_dungeon()
		generate_maze()
		await maze_generated
		generate_pillars()
		place_skeleton()

@export var width:int = 16
@export var height:int = 12
@export var tile_size:int = 2

@export var floor_tile:PackedScene
@export var wall_tile:Array[PackedScene]
@export var pillar:PackedScene
@export var tracker:PackedScene

func _ready():
	if !Engine.is_editor_hint():
		clear_dungeon()
		generate_dungeon()
		generate_maze()
		generate_pillars()
		place_skeleton()

func generate_dungeon() -> void:
	# make the north walls
	# Notice we start at 1. That's because we have a static door top left.
	for x in range(1,width):
		var wl:Node3D = wall_tile.pick_random().instantiate()
		add_child(wl)
		wl.name = "%d,%d - N" % [x,0]
		wl.global_position = Vector3(x * tile_size, 0, 0 - (tile_size/2))
		wl.add_to_group("dungeon")
		
	# make the west walls
	for y in height:
		var wl:Node3D = wall_tile.pick_random().instantiate()
		add_child(wl)
		wl.name = "%d,%d - W" % [0,y]
		wl.global_position = Vector3(0 	- (tile_size/2), 0, y * tile_size)
		wl.rotate_y(deg_to_rad(90))
		wl.add_to_group("dungeon")
	
	# Now generate floor and internal east and south walls
	for x in width:
		for y in height:
			var ft:Node3D = floor_tile.instantiate()
			add_child(ft)
			ft.name = "%d,%d - F" % [x,y]
			ft.global_position = Vector3(x * tile_size, 0, y * tile_size)
			ft.add_to_group("dungeon")
			
			var south_wall:Node3D = wall_tile.pick_random().instantiate()
			south_wall.name = "%d,%d - S" % [x,y]
			add_child(south_wall)
			south_wall.global_position = Vector3(x * tile_size, 0, (y * tile_size) + (tile_size / 2))
			south_wall.add_to_group("dungeon")
			
			var east_wall:Node3D = wall_tile.pick_random().instantiate()
			east_wall.name = "%d,%d - E" % [x,y]
			add_child(east_wall)
			east_wall.rotate_y(deg_to_rad(90))
			east_wall.global_position = Vector3((x * tile_size) + (tile_size / 2), 0, y * tile_size)
			east_wall.add_to_group("dungeon")

func generate_maze() -> void:
	if Engine.is_editor_hint():
		trk = tracker.instantiate()
		add_child(trk)
		trk.add_to_group("dungeon")
	
	var cells_visited:int = 0
	
	# Clear out, then resize the cells array again. This allows for multiple resets.
	cells.clear()
	cells.resize(width*height)
	
	var walk_stack:Array[Cell]
	
	for y in height:
		for x in width:
			cells[x + (y*width)] = Cell.new(x,y)

	var start_cell:int = 0 # randi_range(0, (width*height)-1)
	var current_cell:Cell = cells[start_cell]
	current_cell.visited = true
	cells_visited += 1
	walk_stack.push_back(current_cell)
	
	while cells_visited < width*height:
		if Engine.is_editor_hint():
			trk.global_position = Vector3(current_cell.pos.x * tile_size, 0, current_cell.pos.y * tile_size)
			await get_tree().create_timer(0.01).timeout

		# See if there are any unvisited cells from our current location.
		var av_cells:Array[Cell] = available_cells(current_cell.pos.x,current_cell.pos.y)
		
		# If there are available cells next to this one...
		if av_cells.size() > 0:
			# Add the current cell on to the stack. This does seem like an odd place to put this line,
			# but it seems to work best when using the "trk" visualiser cylinder.
			walk_stack.push_back(current_cell)
			
			# Pick a random neighbouring cell.
			var picked_cell:Cell = av_cells.pick_random()
	
			# Identify which direction this new cell is in, and knock down the appropriate wall.
			# Note that there aren't actually any N or W walls to knock down, so if the direction IS
			# west or north, knock that neighbours S or E wall respectively. Hope that makes sense!
			if picked_cell.pos.x > current_cell.pos.x:
				#print("E ", current_cell.pos, " -> ", picked_cell.pos, " Stack Size=", walk_stack.size())
				get_tree().get_nodes_in_group("dungeon").filter(func(n:Node): return n.name=="%d,%d - E" % [current_cell.pos.x,current_cell.pos.y])[0].free()
			elif picked_cell.pos.y > current_cell.pos.y:
				#print("S ", current_cell.pos, "->", picked_cell.pos, " Stack Size=", walk_stack.size())
				get_tree().get_nodes_in_group("dungeon").filter(func(n:Node): return n.name=="%d,%d - S" % [current_cell.pos.x,current_cell.pos.y])[0].free()
			elif picked_cell.pos.x < current_cell.pos.x:
				#print("W ", current_cell.pos, "->", picked_cell.pos, " Stack Size=", walk_stack.size())
				get_tree().get_nodes_in_group("dungeon").filter(func(n:Node): return n.name=="%d,%d - E" % [current_cell.pos.x-1,current_cell.pos.y])[0].free()
			elif picked_cell.pos.y < current_cell.pos.y:
				#print("N ", current_cell.pos, "->", picked_cell.pos, " Stack Size=", walk_stack.size())
				get_tree().get_nodes_in_group("dungeon").filter(func(n:Node): return n.name=="%d,%d - S" % [current_cell.pos.x,current_cell.pos.y-1])[0].free()
			
			current_cell = picked_cell
			current_cell.visited = true
			cells_visited += 1
		else:
			current_cell = walk_stack.pop_back()
			#print("Popping back to ", current_cell.pos, " Size=", walk_stack.size())
	
	maze_generated.emit()
	
func generate_pillars():
	for x in width:
		for y in height:
			var pillar_required:bool = false
			if get_tree().get_nodes_in_group("dungeon").any(func (n:Node): return n.name == "%d,%d - E" % [x,y]) \
			and !get_tree().get_nodes_in_group("dungeon").any(func (n:Node): return n.name == "%d,%d - E" % [x,y+1]):
				pillar_required = true
			elif !get_tree().get_nodes_in_group("dungeon").any(func (n:Node): return n.name == "%d,%d - E" % [x,y]) \
			and !get_tree().get_nodes_in_group("dungeon").any(func (n:Node): return n.name == "%d,%d - S" % [x,y]):
				pillar_required = true
			elif get_tree().get_nodes_in_group("dungeon").any(func (n:Node): return n.name == "%d,%d - S" % [x,y]) \
			and !get_tree().get_nodes_in_group("dungeon").any(func (n:Node): return n.name == "%d,%d - S" % [x+1,y]):
				pillar_required = true

			if pillar_required:
				var cell_pillar:Node3D = pillar.instantiate()
				cell_pillar.name = "%d,%d - P" % [x,y]
				add_child(cell_pillar)
				cell_pillar.global_position = Vector3((x * tile_size) + 1, 0, (y * tile_size) + 1)
				cell_pillar.add_to_group("dungeon")
	
# Locates the appropriate cells index, and returns whether or not it's been marked as visited.
func cell_visited(x:int, y:int) -> bool:
	return cells[x + y*width].visited

# For a given x,y position, this function returns the array of unvisited neighbouring cells.
func available_cells(x:int, y:int) -> Array[Cell]:
	var av_cells:Array[Cell]
	
	if x == 0 and y == 0:
		av_cells.append(cells[x + ((y+1)*width)])
		return av_cells
	
	if x > 0 and !cell_visited(x-1, y):
		av_cells.append(cells[(x-1) + (y*width)])
	
	if x < width-1 and !cell_visited(x+1, y):
		av_cells.append(cells[(x+1) + y*width])
		
	if y > 0 and !cell_visited(x, y-1):
		av_cells.append(cells[x + ((y-1)*width)])
		
	if y < height-1 and !cell_visited(x, y+1):
		av_cells.append(cells[x + ((y+1)*width)])
	
	return av_cells

func place_skeleton():
	$Skeleton_Minion.global_position = Vector3((width-1)*tile_size,0,(height-1)*tile_size)

# Does a cleanup of the current maze. 
func clear_dungeon() -> void:
	for obj in get_tree().get_nodes_in_group("dungeon"):
		obj.free()

#func _on_entrance_door_interact():
	#$EntranceDoor/Interactable.is_interactable = false
	#DialogueManager.show_dialogue_balloon(dungeon_maze_dialogue, "entrance_door")
	#await DialogueManager.dialogue_ended
	#$EntranceDoor/Interactable.mark_interaction_finished()

