extends Area2D

@onready var animated_sprite_2d = $AnimatedSprite2D
@onready var player = $Player

func _physics_process(delta):
	animated_sprite_2d.play("on")
	
	
func _on_body_entered(body):
	if body.is_in_group("Player"):
		body.die()
