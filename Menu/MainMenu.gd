extends ColorRect

@onready var animated_sprite_2d = $AnimatedSprite2D

func _ready():
	animated_sprite_2d.play("default")

func _on_start_pressed():
	SceneManager.change_scene("res://World/world.tscn")
