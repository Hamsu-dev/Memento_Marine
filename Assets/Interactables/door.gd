class_name Door
extends Area2D


@export var door_state = DoorState.OPEN
@export_file("*.tscn") var new_level_path
@export var connection : DoorConnection

@onready var animated_sprite_2d = $AnimatedSprite2D
@onready var right_cast = $RightCast
@onready var left_cast = $LeftCast
@onready var bgm_world = $"../../bgm_world"

enum DoorState { CLOSED, OPEN }

var has_key = false

func door_open():
	animated_sprite_2d.play("open")
	door_state = DoorState.OPEN
	DoorOpen.play()

func door_close():
	animated_sprite_2d.play("close")
	door_state = DoorState.CLOSED

func get_direction():
	if left_cast.is_colliding():
		return -1
	if right_cast.is_colliding():
		return 1
	return 0

func _physics_process(delta):
	var player = MainInstances.player as Player
	if not player is Player: return
	if overlaps_body(player) and new_level_path and door_state == DoorState.OPEN:
		var player_direction = sign(player.velocity.x)
		var direction = get_direction()
		if player_direction == direction:
			Events.door_entered.emit(self)
			WorldMusic.stop()
