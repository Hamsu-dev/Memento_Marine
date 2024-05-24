extends Area2D

signal tutorial_interact

var player_in_area = false

func _on_body_entered(body):
	if body.is_in_group("Player"):
		player_in_area = true

func _on_body_exited(body):
	if body.is_in_group("Player"):
		player_in_area = false
		
func _process(delta):
	if player_in_area:
		tutorial_interact.emit()
