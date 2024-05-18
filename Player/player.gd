extends CharacterBody2D

@export var acceleration = 400  # Slightly lower for smoother acceleration
@export var max_speed = 250  # Increased for faster gameplay
@export var friction = 1000  # Increased for quick stops
@export var gravity = 500  # Reduced for lighter, longer jumps
@export var jump_force = 250  # Increased for higher jumps
@export var max_fall_velocity = 500  # Increased for more realistic falls
@export var slide_speed = 400  # Speed during sliding
@export var slide_duration = 0.5  # Duration of the slide in seconds
@export var drop_force = 600  # The downward force applied when crouching in air
@export var bounce_multiplier = 1.2  # Multiplier for bounce height

@onready var coyote_jump_timer = $CoyoteJumpTimer
@onready var animated_sprite_2d = $AnimatedSprite2D
@onready var slide_timer = $SlideTimer
@onready var speed_label = $SpeedLabel

var sliding = false
var is_dropping = false

func _physics_process(delta):
	apply_gravity(delta)
	var input_axis = Input.get_axis("left", "right")
	if sliding:
		apply_slide(delta)
	elif is_moving(input_axis):
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
	if is_on_floor() and is_dropping:
		bounce()
	handle_slide_input(delta)  # Call to handle slide input
	update_speed_display()

func apply_slide(delta):
	# Calculate the initial sliding speed, considering current velocity and slide_speed.
	var effective_slide_speed = slide_speed
	
	# Check if the current speed is greater than the base slide speed
	if abs(velocity.x) > slide_speed:
		# Increase the speed by 20% if current speed is greater
		effective_slide_speed = abs(velocity.x) * 2.0
	else:
		# Otherwise, use the base slide speed
		effective_slide_speed = slide_speed

	if not is_on_floor():  # If in air, you might want to use a different logic or same speed.
		effective_slide_speed = max(abs(velocity.x), slide_speed)

	# Apply the slide direction based on the character's facing direction.
	velocity.x = effective_slide_speed * (-1 if animated_sprite_2d.flip_h else 1)

	# Apply gravity only once.
	velocity.y += gravity * delta


func is_moving(input_axis):
	return input_axis != 0

func apply_gravity(delta):
	if not is_on_floor():
		velocity.y = min(velocity.y + gravity * delta, max_fall_velocity)

func apply_acceleration(delta, input_axis):
	velocity.x = move_toward(velocity.x, input_axis * max_speed, acceleration * delta)

func apply_friction(delta):
	velocity.x = move_toward(velocity.x,  0, friction * delta)

func jump_check():
	if (is_on_floor() or coyote_jump_timer.time_left > 0.0) and Input.is_action_just_pressed("up"):
		velocity.y = -jump_force
		coyote_jump_timer.stop()  # Stop the coyote timer on jump
	if Input.is_action_just_pressed("down") and not is_on_floor():
		start_drop()
	if Input.is_action_just_released("up") and velocity.y < -jump_force / 2:
		velocity.y = -jump_force / 2

func start_drop():
	if is_on_floor():
		# Crouch if on the ground
		animated_sprite_2d.play("crouch")
	else:
		# Drop down fast if in the air
		velocity.y = drop_force
		is_dropping = true
		animated_sprite_2d.play("crouch")  # Assume this is your falling fast animation

func handle_slide_input(delta):
	if Input.is_action_just_pressed("slide") and is_on_floor() and not sliding:
		start_slide()

func start_slide():
	sliding = true
	slide_timer.start()

func stop_slide():
	sliding = false
	slide_timer.stop()

func bounce():
	velocity.y = -jump_force * bounce_multiplier
	is_dropping = false

func update_animations(input_axis):
	var on_ground = is_on_floor()

	if input_axis > 0:
		animated_sprite_2d.flip_h = false
	elif input_axis < 0:
		animated_sprite_2d.flip_h = true

	if sliding:
		if animated_sprite_2d.animation != "slide":
			animated_sprite_2d.play("slide")
	elif is_dropping:
		if animated_sprite_2d.animation != "crouch":
			animated_sprite_2d.play("crouch")
	elif not on_ground:
		if velocity.y < 0:
			animated_sprite_2d.play("jump")
		else:
			animated_sprite_2d.play("fall")
	else:
		if is_moving(input_axis):
			animated_sprite_2d.play("run")
		else:
			animated_sprite_2d.play("idle")


func _on_slide_timer_timeout():
	stop_slide()


func update_speed_display():
	# Calculate the current speed magnitude
	var current_speed = velocity.length()
	# Update the Label's text to show the current speed
	speed_label.text = "Speed: " + str(current_speed)
