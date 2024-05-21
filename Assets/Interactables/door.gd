class_name Door
extends Area2D

@onready var animated_sprite_2d = $AnimatedSprite2D

@export_file("*.tscn") var new_level_path

@onready var right_cast = $RightCast
@onready var left_cast = $LeftCast

func door_open():
	animated_sprite_2d.play("open")

func get_direction():
	if left_cast.is_colliding():
		return -1
	if right_cast.is_colliding():
		return 1
	return 0

func _physics_process(delta):
	var player = MainInstances.player as Player
	if not player is Player: return
	if overlaps_body(player):
		var player_direction = sign(player.velocity.x)
		var direction = get_direction()
		if player_direction == direction:
			Events.door_entered.emit(self)
