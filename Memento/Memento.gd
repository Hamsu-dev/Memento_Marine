extends Area2D

@export var ability_type : String # "bounce" or "wall_jump"


func _on_body_entered(body):
	if body is Player:
		RelicPickUp.play()
		var message = ""
		if ability_type == "bounce":
			PowerUps.unlock_bounce_ability()
			message = "The memento flashes... bounce jump unlocked."
		elif ability_type == "wall_jump":
			PowerUps.unlock_wall_jump_ability()
			message = "The memento flashes... wall jump unlocked."
		
		# Show the notification message
		var ui_manager = get_tree().root.get_node("World/UINode")
		ui_manager.show_message(message, body.global_position + Vector2(-750,10))
		
		queue_free() # Remove the power-up from the scene after it's collected
