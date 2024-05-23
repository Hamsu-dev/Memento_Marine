extends Area2D

signal key_collected

func _on_body_entered(body):
	if body is Player:
		key_collected.emit()
		queue_free()  # Remove the key from the scene
