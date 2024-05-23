extends Area2D

@onready var lights = $"../Lights"
@onready var canvas_modulate = $"../CanvasModulate"
@onready var animated_sprite_2d = $AnimatedSprite2D

signal button_pressed


var player_in_area = false

func _on_body_entered(body):
	if body.is_in_group("Player"):
		animated_sprite_2d.play("pressed")
		player_in_area = true

func _on_body_exited(body):
	if body.is_in_group("Player"):
		player_in_area = false
		
func _process(delta):
	if player_in_area and Input.is_action_just_pressed("interact"):  # Assuming "ui_select" is mapped to the "E" key
		button_pressed.emit()
		lights.hide()
		canvas_modulate.hide()
		
