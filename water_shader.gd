extends Node2D

# Adjust the movement speed in the Y direction
@export var move_speed = 50.0
@onready var water = $Water
@onready var water_shader = $Water_Shader

func _process(delta):
	water.position.y -= move_speed * delta
	water_shader.position.y -= move_speed * delta
	print("Updated Sprite Position: y =", water.position.y)
