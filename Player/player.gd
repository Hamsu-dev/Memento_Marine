extends CharacterBody2D

# Export Variables
@export var acceleration = 400  # Slightly lower for smoother acceleration
@export var max_speed = 250  # Increased for faster gameplay
@export var friction = 1000  # Increased for quick stops
@export var gravity = 500  # Reduced for lighter, longer jumps
@export var jump_force = 250  # Increased for higher jumps
@export var max_fall_velocity = 500  # Increased for more realistic falls
@export var drop_force = 600  # The downward force applied when crouching in air
@export var bounce_multiplier = 1.2  # Multiplier for bounce height
@export var wall_jump_force = 250  # Force applied during wall jump
@export var wall_jump_push_force = 400  # Force pushing away from the wall during wall jump
@export var wall_slide_gravity = 200  # Reduced gravity when sliding down a wall

# Onready variables
@onready var coyote_jump_timer = $CoyoteJumpTimer
@onready var animated_sprite_2d = $AnimatedSprite2D
@onready var top_right = $Raycast/TopRight
@onready var bottom_right = $Raycast/BottomRight
@onready var top_left = $Raycast/TopLeft
@onready var bottom_left = $Raycast/BottomLeft

# Variables
var is_dropping = false
var on_wall = false
var wall_direction = 0
var wall_sliding = false
var wall_jumping = false

# Functions
func _physics_process(delta):
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
	if is_on_floor() and is_dropping:
		bounce()
	check_wall_collision()
	apply_wall_slide(delta)

func check_wall_collision():
	on_wall = false
	wall_direction = 0
	if top_left.is_colliding() or bottom_left.is_colliding():
		on_wall = true
		wall_direction = 1
	elif top_right.is_colliding() or bottom_right.is_colliding():
		on_wall = true
		wall_direction = -1

	if on_wall and not is_on_floor():
		wall_sliding = true
	else:
		wall_sliding = false

func apply_wall_slide(delta):
	if wall_sliding and not Input.is_action_pressed("up"):  # Only slide down if not pressing jump
		velocity.y = min(velocity.y + wall_slide_gravity * delta, max_fall_velocity)
		velocity.x = 0  # Prevent horizontal movement while wall sliding

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
	elif on_wall and Input.is_action_just_pressed("up"):
		velocity.y = -wall_jump_force
		velocity.x = wall_jump_push_force * wall_direction  # Push away from the wall
		animated_sprite_2d.flip_h = wall_direction < 0  # Face away from the wall during wall jump
		wall_jumping = true  # Set wall_jumping to true when wall jumping
		wall_sliding = false  # Stop wall sliding when jumping off the wall
	else:
		wall_jumping = false  # Set wall_jumping to false when not wall jumping
	if Input.is_action_just_pressed("down") and not is_on_floor():
		start_drop()
	if Input.is_action_just_released("up") and velocity.y < -jump_force / 2:
		velocity.y = -jump_force / 2

func start_drop():
	if is_on_floor():
		animated_sprite_2d.play("crouch")
	else:
		velocity.y = drop_force
		is_dropping = true
		animated_sprite_2d.play("crouch")  # Assume this is your falling fast animation

func bounce():
	velocity.y = -jump_force * bounce_multiplier
	is_dropping = false

func update_animations(input_axis):
	var on_ground = is_on_floor()

	if input_axis > 0:
		animated_sprite_2d.flip_h = false
	elif input_axis < 0:
		animated_sprite_2d.flip_h = true

	if wall_jumping:  # Added wall jump animation handling
		if animated_sprite_2d.animation != "walljump":
			animated_sprite_2d.play("walljump")
		animated_sprite_2d.flip_h = wall_direction < 0  # Face away from the wall during wall jump
	elif wall_sliding and not Input.is_action_pressed("up"):  # Only play slide animation if not pressing jump
		if animated_sprite_2d.animation != "wallslide":
			animated_sprite_2d.play("wallslide")
		animated_sprite_2d.flip_h = wall_direction > 0  # Face away from the wall during slide
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
