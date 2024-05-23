extends Area2D

@export var ability_type : String # "bounce" or "wall_jump"
@onready var relic_sfx = $relic_sfx


func _on_body_entered(body):
	if body is Player:
		RelicPickUp.play()
		var message = ""
		if ability_type == "bounce":
			PowerUps.unlock_bounce_ability()
			message = "You acquired the Bounce ability! Press 'Down' while in the air to bounce higher."
		elif ability_type == "wall_jump":
			PowerUps.unlock_wall_jump_ability()
			message = "Remembers how to walljump..."
		
		# Show the notification message
		var ui_manager = get_tree().root.get_node("World/UINode")
		ui_manager.show_message(message)
		
		queue_free() # Remove the power-up from the scene after it's collected
