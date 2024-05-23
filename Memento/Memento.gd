extends Area2D

@export var ability_type : String # "bounce" or "wall_jump"


func _on_body_entered(body):
	if body is Player:
		if ability_type == "bounce":
			PowerUps.unlock_bounce_ability()
		elif ability_type == "wall_jump":
			PowerUps.unlock_wall_jump_ability()
		queue_free() # Remove the power-up from the scene after it's collected
