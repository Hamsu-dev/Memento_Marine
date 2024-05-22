extends Node

@onready var button = $Button
@onready var player = $"../Player"
@onready var world_camera = $"../WorldCamera"
@onready var player_camera = $"../Player/Camera2D"
@onready var animation_player = $AnimationPlayer
@onready var door_2 = $Door2
@onready var animated_sprite_2d = $Door2/AnimatedSprite2D
@onready var collision_shape_2d = $Door2/CollisionShape2D
@onready var door = $Door
@onready var door_collision_shape_2d = $Door/CollisionShape2D


func _ready():
	button.button_pressed.connect(_on_Button_pressed)
	animated_sprite_2d.play("close")
	
func _on_Button_pressed():
	show_cutscene()

func show_cutscene():
	if world_camera:
		world_camera.make_current()  # Activate world camera
	# Disable player controls during the cutscene
	if player:
		player.disable()
	animation_player.play("cutscene")

func _on_animation_player_animation_finished(anim_name):
	if anim_name == "cutscene":
		# Switch back to the player camera
		if player_camera:
			player_camera.make_current()  # Activate player camera
	if player:
		player.enable()

func _on_animated_sprite_2d_animation_finished():
	animated_sprite_2d.play("close")
	collision_shape_2d.disabled = true
	door_2.visible = false
