extends Node

@onready var final_door = $FinalDoor
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
	final_door.door_interact.connect(_on_Door_interact)
	animated_sprite_2d.play("close")
	
func _on_Door_interact():
	pass

func _on_animated_sprite_2d_animation_finished():
	animated_sprite_2d.play("close")
	collision_shape_2d.disabled = true
	door_2.visible = false


func _on_final_door_area_entered(area):
	pass # Replace with function body.
