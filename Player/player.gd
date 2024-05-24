class_name Player
extends CharacterBody2D

# Acceleration
@export var acceleration = 400  # Slightly lower for smoother acceleration
@export var air_acceleration = 200  # Lower acceleration for air control
@export var wall_jump_air_acceleration = 100  # Lower acceleration for air control during wall jump
@export var max_speed = 250  # Increased for faster gameplay

# Friction
@export var friction = 1000  # Increased for quick stops
@export var air_friction = 5000  # Friction applied in the air for more control
@export var slide_friction = 0.8  # Friction applied to slow down wall sliding

# Gravity
@export var gravity = 500  # Reduced for lighter, longer jumps
@export var jump_force = 250  # Increased for higher jumps
@export var max_fall_velocity = 500  # Increased for more realistic falls
@export var drop_force = 600  # The downward force applied when crouching in air
@export var wall_slide_gravity = 500  # Reduced gravity when sliding down a wall

# Jump
@export var wall_jump_force = 250  # Force applied during wall jump
@export var wall_jump_push_force = 200  # Force pushing away from the wall during wall jump
@export var bounce_multiplier = 1.4  # Multiplier for bounce height

# Onready variables
@onready var coyote_jump_timer = $CoyoteJumpTimer
@onready var top_right = $Raycast/TopRight
@onready var bottom_right = $Raycast/BottomRight
@onready var top_left = $Raycast/TopLeft
@onready var bottom_left = $Raycast/BottomLeft
@onready var player_camera = $Camera2D
@onready var animation_player = $AnimationPlayer
@onready var sprite_2d = $Sprite2D
@onready var animated_sprite_2d = $AnimatedSprite2D
@onready var collision_shape_2d = $CollisionShape2D
@onready var footstep_timer = $footstep_timer
@onready var footsteps = $footsteps
@onready var jump = $jump
@onready var bouncesfx = $bouncesfx

# Variables
var is_dropping = false
var on_wall = false
var wall_direction = 0
var wall_sliding = false
var wall_jumping = false
var bounce_used = false
var is_bouncing = false 
var is_disabled = false

signal camera_enabled
signal camera_disabled
signal died

# Functions
func _enter_tree():
	MainInstances.set_player(self)

func _physics_process(delta):
	if is_disabled:
		return
		
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

	# Check if player is dropping and on the floor to bounce
	if is_on_floor() and is_dropping:
		bounce()
		bouncesfx.play()

	# Reset is_dropping and bounce_used variables when landing on the floor
	if is_on_floor():
		if is_dropping:
			is_dropping = false
		if not is_bouncing:
			bounce_used = false
		else:
			is_bouncing = false

	check_wall_collision()
	apply_wall_slide(delta)

func _exit_tree():
	MainInstances.player = null
	MainInstances.player_camera = null

func disable():
	is_disabled = true
	camera_disabled.emit()

func enable():
	is_disabled = false
	camera_enabled.emit()
	
func check_wall_collision():
	on_wall = false
	wall_direction = 0
	
	if ((top_left.is_colliding() and top_left.get_collider() != null and top_left.get_collider().is_in_group("wall_jumpable")) or 
		(bottom_left.is_colliding() and bottom_left.get_collider() != null and bottom_left.get_collider().is_in_group("wall_jumpable"))):
		on_wall = true
		wall_direction = 1
	elif ((top_right.is_colliding() and top_right.get_collider() != null and top_right.get_collider().is_in_group("wall_jumpable")) or 
		  (bottom_right.is_colliding() and bottom_right.get_collider() != null and bottom_right.get_collider().is_in_group("wall_jumpable"))):
		on_wall = true
		wall_direction = -1
	else:
		wall_sliding = false

	if on_wall and not is_on_floor():
		wall_sliding = true
	else:
		wall_sliding = false

func apply_wall_slide(delta):
	if wall_sliding and not Input.is_action_pressed("up"):  #
		velocity.y += wall_slide_gravity * delta
		velocity.y *= slide_friction 
		velocity.x = 0  

func is_moving(input_axis):
	return input_axis != 0

func apply_gravity(delta):
	if not is_on_floor():
		velocity.y = min(velocity.y + gravity * delta, max_fall_velocity)

func apply_acceleration(delta, input_axis):
	if is_on_floor():
		velocity.x = move_toward(velocity.x, input_axis * max_speed, acceleration * delta)
	else:
		velocity.x = move_toward(velocity.x, input_axis * max_speed, wall_jump_air_acceleration * delta if wall_jumping else air_acceleration * delta)

func apply_friction(delta):
	if is_on_floor():
		velocity.x = move_toward(velocity.x, 0, friction * delta)
	else:
		velocity.x = move_toward(velocity.x, 0, air_friction * delta)

func jump_check():
	if (is_on_floor() or coyote_jump_timer.time_left > 0.0) and Input.is_action_just_pressed("up"):
		velocity.y = -jump_force
		coyote_jump_timer.stop()
		jump.play()
	elif on_wall and PowerUps.wall_jump_unlocked and Input.is_action_just_pressed("up"):  # Check global variable
		velocity.y = -wall_jump_force
		velocity.x = wall_jump_push_force * wall_direction
		sprite_2d.flip_h = wall_direction < 0
		wall_jumping = true
		wall_sliding = false
		jump.play()
	else:
		wall_jumping = false
	if Input.is_action_just_pressed("down") and not is_on_floor():
		start_drop()
	if Input.is_action_just_released("up") and velocity.y < -jump_force / 2:
		velocity.y = -jump_force / 2

func start_drop():
	if is_on_floor():
		animation_player.play("crouch")
	else:
		velocity.y = drop_force
		is_dropping = true
		animation_player.play("crouch")  # Assume this is your falling fast animation

func bounce():
	if PowerUps.bounce_unlocked and not bounce_used:
		velocity.y = -jump_force * bounce_multiplier
		is_dropping = false
		bounce_used = true
		is_bouncing = true

func die():
	died.emit()
	animated_sprite_2d.visible = true
	animated_sprite_2d.play("die")
	collision_shape_2d.disabled = true
	
func reset_state():
	velocity = Vector2.ZERO
	
func update_animations(input_axis):
	var on_ground = is_on_floor()

	if input_axis > 0:
		sprite_2d.flip_h = false
	elif input_axis < 0:
		sprite_2d.flip_h = true

	if wall_jumping:  
		if animation_player.current_animation != "walljump":
			animation_player.play("wall_jump")
		sprite_2d.flip_h = wall_direction < 0 
	elif wall_sliding and not Input.is_action_pressed("up"): 
		if animation_player.current_animation != "wall_slide":
			animation_player.play("wall_slide")
			
		sprite_2d.flip_h = wall_direction < 0  
	elif is_dropping:
		if animation_player.current_animation != "crouch":
			animation_player.play("crouch")

	elif not on_ground:
		if velocity.y < 0:
			animation_player.play("jump")

		else:
			animation_player.play("fall")

	else:
		if is_moving(input_axis):
			animation_player.play("run")
			if footstep_timer.time_left <= 0:
				footsteps.pitch_scale = randf_range(0.8,1.2)
				footsteps.play()
				footstep_timer.start(0.4)
			
		else:
			animation_player.play("idle")



func _on_animated_sprite_2d_animation_finished():
	animated_sprite_2d.visible = false
