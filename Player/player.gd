extends CharacterBody2D

@export var acceleration = 1000  # Slightly lower for smoother acceleration
@export var max_speed = 1000  # Increased for faster gameplay
@export var friction = 1000  # Increased for quick stops
@export var gravity = 500  # Reduced for lighter, longer jumps
@export var jump_force = 200  # Increased for higher jumps
@export var max_fall_velocity = 500  # Increased for more realistic falls


@onready var coyote_jump_timer = $CoyoteJumpTimer
@onready var animated_sprite_2d = $AnimatedSprite2D


func _physics_process(delta):
	pass
	apply_gravity(delta)
	var input_axis = Input.get_axis("left", "right")
	if is_moving(input_axis):
		apply_acceleration(delta, input_axis)
	else:
		apply_friction(delta)
	jump_check()
	update_animations(input_axis)
	var was_on_floor = is_on_floor()
	move_and_slide()
	var just_left_edge = was_on_floor and not is_on_floor()
	if just_left_edge:
		coyote_jump_timer.start()


func is_moving(input_axis):
	return input_axis != 0

func apply_gravity(delta):
	if not is_on_floor():
		velocity.y = move_toward(velocity.y, max_fall_velocity, gravity * delta)

func apply_acceleration(delta, input_axis):
	velocity.x = move_toward(velocity.x, input_axis * max_speed, acceleration * delta)


func apply_friction(delta):
	velocity.x = move_toward(velocity.x,  0, friction * delta)

func jump_check():
	if is_on_floor() or coyote_jump_timer.time_left > 0.0:
		if Input.is_action_just_pressed("up"):
			velocity.y = -jump_force
	if not is_on_floor():
		if Input.is_action_just_released("up") and velocity.y < -jump_force / 2:
			velocity.y = -jump_force / 2

func update_animations(input_axis):
	var on_ground = is_on_floor()
	
	if input_axis > 0:
		animated_sprite_2d.flip_h = false
	elif input_axis < 0:
		animated_sprite_2d.flip_h = true
		
	# Handle jumping and falling
	if not on_ground:
		# If moving upwards
		if velocity.y < 0:
			animated_sprite_2d.play("jump")
		# If moving downwards
		else:
			animated_sprite_2d.play("fall")
	else:
		# If on the ground and moving
		if is_moving(input_axis):
			animated_sprite_2d.play("run")
		# If on the ground and not moving
		else:
			animated_sprite_2d.play("idle")
