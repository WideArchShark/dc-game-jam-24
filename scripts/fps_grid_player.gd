extends CharacterBody3D

@onready var state_chart = $StateChart
const TUTORIAL = preload("res://dialogue_resources/tutorial.dialogue")

var current_rot:float
var target_rot:float
var current_pos:Vector3
var target_pos:Vector3
var lerp_progress:float
const OBSTACLE_COLLISION_MASK:int = 1 # The collision layer mask to check before moving.
const INTERACTABLE_COLLISION_MASK:int = 2 # The collision layer mask to check before moving.

var space_state:PhysicsDirectSpaceState3D
var interactable_in_front:bool = false
var interactable:Node

@export var movement_speed:float = 3
@export var rotation_speed:float = 3
@export var grid_size:float = 2

@export var walk_sound:AudioStreamPlayer
@export var rotate_sound:AudioStreamPlayer

signal player_moved(new_pos:Vector3)

func _ready():
	space_state = get_world_3d().direct_space_state
	#await get_tree().create_timer(2).timeout
	#DialogueManager.show_dialogue_balloon(TUTORIAL)
	var tween = get_tree().create_tween()
	tween.tween_property($Fader, "modulate", Color(0,0,0,0), 2).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN)

func _on_waiting_state_entered():
	#current_rot = rotation_degrees.y
	current_rot = transform.basis.get_euler().y
	current_pos = global_position
	lerp_progress = 0
	_check_for_interactable()

func _check_for_interactable():
	var h_rot = transform.basis.get_euler().y
	var forward = Vector3.FORWARD.rotated(Vector3.UP, h_rot).normalized()
	var query = PhysicsRayQueryParameters3D.create(global_position, global_position + forward * grid_size, INTERACTABLE_COLLISION_MASK, [self])
	var result = space_state.intersect_ray(query)
	if result.size() > 0:
		interactable = result["collider"]
		if interactable.is_interactable:
			interactable_in_front = true
			$InfoLabel.visible = true
		else:
			interactable_in_front = false
			$InfoLabel.visible = false

func _on_waiting_state_physics_processing(_delta):
	if Input.is_action_pressed("forwards"):
		_move(Vector3.FORWARD)
	elif Input.is_action_pressed("backwards"):
		_move(Vector3.BACK)
	elif Input.is_action_pressed("strafe_right"):
		_move(Vector3.RIGHT)
	elif Input.is_action_pressed("strafe_left"):
		_move(Vector3.LEFT)
	elif Input.is_action_pressed("rotate_left"):
		#target_rot = current_rot + 90
		target_rot = current_rot + PI/2
		state_chart.send_event("to_rotating")
	elif Input.is_action_pressed("rotate_right"):
		#target_rot = current_rot - 90
		target_rot = current_rot - PI/2
		state_chart.send_event("to_rotating")
	elif Input.is_action_just_pressed("interact") and interactable_in_front and interactable.is_interactable:
		$InfoLabel.visible = false
		state_chart.send_event("to_interacting")
		#await DialogueManager.dialogue_ended

func _move(direction:Vector3):
	var h_rot = transform.basis.get_euler().y
	var actual_direction = direction.rotated(Vector3.UP, h_rot).normalized()
	target_pos = global_position + actual_direction * grid_size
	
	if _can_move(global_position, target_pos):
		state_chart.send_event("to_moving")
	
func _can_move(from:Vector3, to:Vector3):
	var query = PhysicsRayQueryParameters3D.create(from, to, OBSTACLE_COLLISION_MASK, [self])
	var result = space_state.intersect_ray(query)
	return result.size() == 0 # If zero, then nothing stopping us moving forward, so return true!

func _on_moving_state_entered():
	walk_sound.play()

func _on_moving_state_processing(delta):
	global_position = lerp(current_pos, target_pos, lerp_progress)
	lerp_progress += delta * movement_speed
	
	if lerp_progress >= 1:
		global_position = Vector3(round(target_pos.x), global_position.y, round(target_pos.z))
		player_moved.emit(global_position)
		
		if get_tree().has_group("Actions") and get_tree().get_nodes_in_group("Actions").size()  > 0:
			state_chart.send_event("to_actioning")
		else:
			state_chart.send_event("to_waiting")

func _on_rotating_state_entered():
	rotate_sound.play()

func _on_rotating_state_processing(delta):
	#rotation.y = lerp_angle(deg_to_rad(current_rot), deg_to_rad(target_rot), lerp_progress)
	rotation.y = lerp_angle(current_rot, target_rot, lerp_progress)
	lerp_progress += delta * rotation_speed
	
	if lerp_progress >= 1:
		#rotation_degrees.y = round(target_rot)
		rotation.y = target_rot
		state_chart.send_event("to_waiting")

func _on_waiting_state_exited():
	$InfoLabel.visible = false
	interactable_in_front = false

func _on_interacting_state_entered():
	interactable.call_deferred("interact")
	await interactable.interact_finished
	state_chart.send_event("to_waiting")

func _on_actioning_state_entered():
	for action in get_tree().get_nodes_in_group("Actions"):
		action.call_deferred("do_action")
		await action.action_finished
	state_chart.send_event("to_waiting")

