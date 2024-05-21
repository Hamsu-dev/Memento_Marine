extends Node

@onready var button = $Button
@onready var player = $"../Player"
@onready var world_camera = $"../WorldCamera"
@onready var player_camera = $"../Player/Camera2D"
@onready var animation_player = $AnimationPlayer

func _ready():
	button.button_pressed.connect(_on_Button_pressed)

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
