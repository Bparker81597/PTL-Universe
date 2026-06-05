extends CharacterBody3D

## Basic third-person movement controller for the prototype player.
## The player moves relative to the camera rig, jumps, and turns to face motion.

@export var move_speed: float = 6.0
@export var jump_velocity: float = 5.0
@export var turn_speed: float = 10.0

@onready var camera_pivot: Node3D = $CameraPivot

var gravity: float = ProjectSettings.get_setting("physics/3d/default_gravity")


func _physics_process(delta: float) -> void:
	apply_gravity(delta)
	handle_jump()
	handle_movement(delta)
	move_and_slide()


func apply_gravity(delta: float) -> void:
	# CharacterBody3D does not apply gravity automatically, so we add it each frame.
	if not is_on_floor():
		velocity.y -= gravity * delta


func handle_jump() -> void:
	# The player can only jump while standing on the floor.
	if Input.is_action_just_pressed("jump") and is_on_floor():
		velocity.y = jump_velocity


func handle_movement(delta: float) -> void:
	var input_direction := Input.get_vector("move_left", "move_right", "move_forward", "move_back")

	if input_direction == Vector2.ZERO:
		velocity.x = move_toward(velocity.x, 0.0, move_speed)
		velocity.z = move_toward(velocity.z, 0.0, move_speed)
		return

	# Use the camera pivot basis so WASD feels like third-person movement.
	var camera_basis := camera_pivot.global_transform.basis
	var forward := -camera_basis.z
	var right := camera_basis.x
	forward.y = 0.0
	right.y = 0.0
	forward = forward.normalized()
	right = right.normalized()

	var move_direction := (right * input_direction.x + forward * -input_direction.y).normalized()
	velocity.x = move_direction.x * move_speed
	velocity.z = move_direction.z * move_speed

	# Rotate the placeholder body toward the movement direction.
	var target_yaw := atan2(-move_direction.x, -move_direction.z)
	rotation.y = lerp_angle(rotation.y, target_yaw, turn_speed * delta)
