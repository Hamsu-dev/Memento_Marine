extends Node

@onready var final_door = $FinalDoor
@onready var player = $"../Player"
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
@onready var tutorial_msg_popups = $"Tutorial Msg Popups"


var has_key = false
var tutorial_shown = false
var door_interacted = false

func _ready():
	tutorial_msg_popups.tutorial_interact.connect(_on_tutorial_msg)
	final_door.door_interact.connect(_on_Door_interact)
	key.key_collected.connect(_on_Key_collected)
	animated_sprite_2d.play("close")
	collision_shape_2d.disabled = true
	popup_panel.hide()
	
	var player = MainInstances.player as Player
	if player:
		player.camera_disabled.connect(_on_camera_disabled)
		player.camera_enabled.connect(_on_camera_enabled)

func _on_tutorial_msg():
	if not tutorial_shown:
		var message = "I need to escape...."
		show_message(message, player.global_position + Vector2(-750,10))
		tutorial_shown = true

func _on_Door_interact():
	if not door_interacted:
		var message = ""
		if not has_key:
			message = "It's locked. There must be a key nearby."
		else:
			message = "Door unlocked."
		show_message(message, player.global_position + Vector2(-750,10))
		door_interacted = true

func _on_animated_sprite_2d_animation_finished():
	animated_sprite_2d.play("close")
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
	if player:
		player.disable()  # This will emit the camera_disabled signal

func _on_camera_disabled():
	if world_camera:
		world_camera.make_current()  # Activate world camera

func _on_animation_player_animation_finished(anim_name):
	if anim_name == "cutscene":
		if player:
			player.enable()  # This will emit the camera_enabled signal

func _on_camera_enabled():
	if player_camera:
		player_camera.make_current()  # Activate player camera
