extends Area2D

@onready var animated_sprite_2d = $AnimatedSprite2D
@onready var collision_shape = $CollisionShape2D
@onready var timer = $Timer

var current_animation = "off"

func _ready():
	# Ensure the collision shape is correctly updated to match the animations
	animated_sprite_2d.play("on")
	current_animation = "on"
	update_collision_shape()
	timer.start()

func update_collision_shape():
	match animated_sprite_2d.animation:
		"on":
			# Update the collision shape to match the "on" state
			collision_shape.position = Vector2(0, -35)  # Adjust the position based on the actual shape
			collision_shape.shape.set_size(Vector2(collision_shape.shape.size.x, 55))  # Adjust size as needed
		"off":
			# Update the collision shape to match the "off" state
			collision_shape.position = Vector2(0, -10)  # Adjust the position based on the actual shape
			collision_shape.shape.set_size(Vector2(collision_shape.shape.size.x, 10))  # Adjust size as needed

func _on_timer_timeout():
	if current_animation == "on":
		animated_sprite_2d.play("off")
		current_animation = "off"
	else:
		animated_sprite_2d.play("on")
		current_animation = "on"
	update_collision_shape()

func _on_body_entered(body):
	if body.is_in_group("Player"):
		body.die()
