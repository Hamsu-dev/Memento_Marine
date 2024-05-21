extends Area2D

@onready var animated_sprite_2d = $AnimatedSprite2D

func open_door():
	print("playing")
	animated_sprite_2d.play("open")
