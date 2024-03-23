extends CharacterBody3D

enum PlayerState { WAITING, MOVING, ROTATING, MOVE_DELAY }
var current_state:PlayerState

var current_rot:float
var target_rot:float
var current_pos:Vector3
var target_pos:Vector3
const COLLISION_MASK:int = 1 # The collision layer mask to check before moving.

@export var movement_speed:float = 3
@export var rotation_speed:float = 3
@export var grid_size:float = 2
@export var move_delay:float = 0.1

@export var walk_sound:AudioStreamPlayer
@export var rotate_sound:AudioStreamPlayer

var lerp_progress:float

func _ready():
	current_state = PlayerState.WAITING
	
func _process(delta):
	if current_state == PlayerState.MOVING:
		move_player(delta)
	elif current_state == PlayerState.ROTATING:
		rotate_player(delta)

func _physics_process(_delta):
	if current_state == PlayerState.WAITING:
		var h_rot = transform.basis.get_euler().y
		current_pos = global_position
		current_rot = rotation_degrees.y
		lerp_progress = 0
	
		if Input.is_action_pressed("forwards"):
			var direction = Vector3.FORWARD.rotated(Vector3.UP, h_rot).normalized()
			target_pos = global_position + direction * grid_size
			current_state = PlayerState.MOVING if can_move(current_pos, target_pos) else PlayerState.WAITING
		elif Input.is_action_pressed("backwards"):
			var direction = Vector3.BACK.rotated(Vector3.UP, h_rot).normalized()
			target_pos = global_position + direction * grid_size
			current_state = PlayerState.MOVING if can_move(current_pos, target_pos) else PlayerState.WAITING
		elif Input.is_action_pressed("strafe_right"):
			var direction = Vector3.RIGHT.rotated(Vector3.UP, h_rot).normalized()
			target_pos = global_position + direction * grid_size
			current_state = PlayerState.MOVING if can_move(current_pos, target_pos) else PlayerState.WAITING
		elif Input.is_action_pressed("strafe_left"):
			var direction = Vector3.LEFT.rotated(Vector3.UP, h_rot).normalized()
			target_pos = global_position + direction * grid_size
			current_state = PlayerState.MOVING if can_move(current_pos, target_pos) else PlayerState.WAITING
		elif Input.is_action_pressed("rotate_left"):
			target_rot = current_rot + 90
			current_state = PlayerState.ROTATING
		elif Input.is_action_pressed("rotate_right"):
			target_rot = current_rot - 90
			current_state = PlayerState.ROTATING
			
func move_player(delta):
	global_position = lerp(current_pos, target_pos, lerp_progress)
	lerp_progress += delta * movement_speed
	
	if lerp_progress >= 1:
		global_position = Vector3(round(target_pos.x), global_position.y, round(target_pos.z))
		current_state = PlayerState.MOVE_DELAY
		walk_sound.play()
		await get_tree().create_timer(move_delay).timeout
		current_state = PlayerState.WAITING

func can_move(from:Vector3, to:Vector3):
	var space_state = get_world_3d().direct_space_state
	var query = PhysicsRayQueryParameters3D.create(from, to, COLLISION_MASK, [self])
	var result = space_state.intersect_ray(query)
	return result.size() == 0 # If zero, then nothing stopping us moving forward, so return true!
		
func rotate_player(delta):
	rotation.y = lerp_angle(deg_to_rad(current_rot), deg_to_rad(target_rot), lerp_progress)
	lerp_progress += delta * rotation_speed
	
	if lerp_progress >= 1:
		rotation_degrees.y = round(target_rot)
		current_state = PlayerState.MOVE_DELAY
		rotate_sound.play()
		await get_tree().create_timer(move_delay).timeout
		current_state = PlayerState.WAITING
