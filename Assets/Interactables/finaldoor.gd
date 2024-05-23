extends Area2D

@onready var animated_sprite_2d = $AnimatedSprite2D

signal door_interact

var player_in_area = false

func _on_body_entered(body):
	if body.is_in_group("Player"):
		player_in_area = true

func _on_body_exited(body):
	if body.is_in_group("Player"):
		player_in_area = false
		
func _process(delta):
	if player_in_area:  # Assuming "ui_select" is mapped to the "E" key
		door_interact.emit()
