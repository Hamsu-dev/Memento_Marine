extends Node

@onready var world_camera = $WorldCamera
@onready var animation_player = $AnimationPlayer
@onready var player_camera = $"../Player/Camera2D"
@onready var animated_sprite_2d = $Door/AnimatedSprite2D
@onready var collision_shape_2d = $Door/CollisionShape2D
@onready var door = $Door
@onready var popup_panel = $"../UINode/PopupPanel"
@onready var popup_label_1 = $"../UINode/PopupPanel/PopupLabel1"
@onready var key = $Key

var has_key = false

func _ready():
	collision_shape_2d.disabled = true
	key.key_collected.connect(_on_Key_collected)
	animated_sprite_2d.play("close")
	popup_panel.hide()
	if not has_key:
		show_message("Another key has appeared in the world.")

	var player = MainInstances.player as Player
	if player:
		player.camera_disabled.connect(_on_camera_disabled)
		player.camera_enabled.connect(_on_camera_enabled)

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

func _on_animated_sprite_2d_animation_finished():
	animated_sprite_2d.play("close")
	collision_shape_2d.disabled = true
	door.visible = false

func show_message(message: String):
	popup_label_1.text = message
	popup_panel.show()
	await get_tree().create_timer(3.0).timeout
	popup_panel.hide()

func _on_Key_collected():
	has_key = true
	#show_message("You found the key! Now you can unlock the door.")
	show_cutscene()
