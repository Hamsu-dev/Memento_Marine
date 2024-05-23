extends Node

@onready var final_door = $FinalDoor
@onready var player = $"../Player"
@onready var skelly_animation = $"../Player/AnimatedSprite2D"
@onready var world_camera = $WorldCamera
@onready var player_camera = $"../Player/Camera2D"
@onready var animation_player = $AnimationPlayer
@onready var door_2 = $Door2
@onready var animated_sprite_2d = $Door2/AnimatedSprite2D
@onready var collision_shape_2d = $Door2/CollisionShape2D
@onready var door = $Door
@onready var door_collision_shape_2d = $Door/CollisionShape2D
@onready var popup_panel = $"../UINode/PopupPanel"
@onready var popup_label_1 = $"../UINode/PopupPanel/PopupLabel1"
@onready var key = $Key


var has_key = false

func _ready():
	final_door.door_interact.connect(_on_Door_interact)
	key.key_collected.connect(_on_Key_collected)
	animated_sprite_2d.play("close")
	popup_panel.hide()
	
	var player = MainInstances.player as Player
	if player:
		player.camera_disabled.connect(_on_camera_disabled)
		player.camera_enabled.connect(_on_camera_enabled)

func _on_Door_interact():
	var message = ""
	if not has_key:
		message = "It seems to be locked! Find the key to unlock the door!"
	else:
		message = "The door is unlocked!"
	show_message(message, player.global_position + Vector2(0, -50)) # Adjust the offset as needed

	
func _on_animated_sprite_2d_animation_finished():
	animated_sprite_2d.play("close")
	collision_shape_2d.disabled = true
	door_2.visible = false


func show_message(message: String, position: Vector2):
	popup_label_1.text = message
	popup_panel.position = position
	popup_panel.show()
	await get_tree().create_timer(3.0).timeout
	popup_panel.hide()


func _on_Key_collected():
	has_key = true
	#show_message("You found the key! Now you can unlock the door.")
	show_cutscene()

func show_cutscene():
	animation_player.play("cutscene")
	var player = MainInstances.player as Player
	if player:
		player.disable()  # This will emit the camera_disabled signal

func _on_camera_disabled():
	print("Player camera disabled")
	if world_camera:
		world_camera.make_current()  # Activate world camera

func _on_animation_player_animation_finished(anim_name):
	if anim_name == "cutscene":
		var player = MainInstances.player as Player
		if player:
			player.enable()  # This will emit the camera_enabled signal

func _on_camera_enabled():
	print("Player camera enabled")
	if player_camera:
		player_camera.make_current()  # Activate player camera
