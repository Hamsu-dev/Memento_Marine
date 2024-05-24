extends Node2D

# Adjust the movement speed in the Y direction
@export var move_speed = 50.0
@onready var water = $Water
@onready var water_shader = $Water_Shader
@onready var collision_shape = $CollisionShape2D

var player = MainInstances.player as Player

func _ready():
	water_shader.position = water.position

func _process(delta):
	water.position.y -= move_speed * delta
	water_shader.position.y -= move_speed * delta
	collision_shape.position.y -= move_speed * delta


func _on_body_entered(body):
	if body is Player:
		body.die()
