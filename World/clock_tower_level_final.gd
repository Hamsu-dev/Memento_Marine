extends Node

@onready var world_camera = $WorldCamera
@onready var animation_player = $AnimationPlayer
@onready var player_camera = $"../Player/Camera2D"
@onready var color_rect = $"God Ray/ColorRect"
@onready var door = $Door
@onready var animated_sprite_2d = $Door/AnimatedSprite2D
@onready var collision_shape_2d = $Door/CollisionShape2D

func _ready():
	collision_shape_2d.disabled = true
	animated_sprite_2d.play("close")

func _on_animated_sprite_2d_animation_finished():
	animated_sprite_2d.play("close")
	collision_shape_2d.disabled = true
	door.visible = false
