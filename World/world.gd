extends Node2D

@onready var level = $Prologue

func _ready():
	Events.door_entered.connect(change_levels)

func change_levels(door : Door):
	var player = MainInstances.player as Player
	if not player is Player: return
	
	# Determine the player's entrance direction
	var entrance_direction = sign(player.global_position.x - door.global_position.x)
	
	# Remove the current level
	if level:
		level.queue_free()
	
	# Load the new level
	var new_level = load(door.new_level_path).instantiate()
	if not new_level:
		print("Failed to load new level: ", door.new_level_path)
		return
	
	# Add the new level to the scene tree
	add_child(new_level)
	level = new_level
	
	# Find the corresponding door in the new level
	var doors = new_level.get_tree().get_nodes_in_group("doors")
	for found_door in doors:
		if found_door == door: continue
		if found_door.connection != door.connection: continue
		
		# Adjust player's position to the corresponding door's opposite side
		var yoffset = player.global_position.y - door.global_position.y
		var xoffset = entrance_direction * 30  # Adjust 50 to the appropriate door width offset
		player.global_position = found_door.global_position - Vector2(xoffset, yoffset)
		break  # Exit the loop once the corresponding door is found
