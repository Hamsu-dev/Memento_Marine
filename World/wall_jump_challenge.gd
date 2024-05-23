extends Node2D

@onready var door = $Door
@onready var animated_sprite_2d = $Door/AnimatedSprite2D
@onready var collision_shape_2d = $Door/CollisionShape2D


func _ready():
	animated_sprite_2d.play("close")
	collision_shape_2d.disabled = true

func _on_animated_sprite_2d_animation_finished():
	animated_sprite_2d.play("close")
	door.visible = false
