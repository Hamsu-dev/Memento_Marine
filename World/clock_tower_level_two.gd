extends Node

@onready var button = $Button
@onready var world_camera = $WorldCamera
@onready var animation_player = $AnimationPlayer
@onready var player_camera = $"../Player/Camera2D"

func _ready():
	button.button_pressed.connect(_on_Button_pressed)
	# Connect signals from the player
	var player = MainInstances.player as Player
	if player:
		player.camera_disabled.connect(_on_camera_disabled)
		player.camera_enabled.connect(_on_camera_enabled)

func _on_Button_pressed():
	show_cutscene()

func show_cutscene():
	animation_player.play("cutscene_two")
	var player = MainInstances.player as Player
	if player:
		player.disable()  # This will emit the camera_disabled signal

func _on_camera_disabled():
	print("Player camera disabled")
	if world_camera:
		world_camera.make_current()  # Activate world camera

func _on_animation_player_animation_finished(anim_name):
	if anim_name == "cutscene_two":
		var player = MainInstances.player as Player
		if player:
			player.enable()  # This will emit the camera_enabled signal

func _on_camera_enabled():
	print("Player camera enabled")
	if player_camera:
		player_camera.make_current()  # Activate player camera
	#if world_camera:
		#world_camera.current = false  # Deactivate world camera
