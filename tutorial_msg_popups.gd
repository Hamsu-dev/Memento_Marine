extends Area2D

func _on_body_entered(body):
	if body is Player:
		var message = ""
		message = "Press [E] to interact with the door"
		
		# Show the notification message
		var ui_manager = get_tree().root.get_node("World/UINode")
		ui_manager.show_message(message, body.global_position + Vector2(-160, -100))
