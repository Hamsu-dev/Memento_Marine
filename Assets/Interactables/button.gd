extends Area2D

signal button_pressed

func _ready():
	pass

func _on_body_entered(body):
	if body.is_in_group("Player"):
		button_pressed.emit()
