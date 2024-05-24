extends Node

var player : CharacterBody2D = null
var player_camera: Camera2D = null

func set_player(player_node):
	player = player_node
	player_camera = player_node.get_node("Camera2D")  # Adjust the path if necessary

	# Connect to player's death signal
	if player.has_signal("died"):
		player.died.connect(_on_Player_died)
		print("Connected to player's died signal")
	else:
		print("Player singleton does not have a 'died' signal")

func _on_Player_died():
	respawn_player()

func respawn_player():
	var spawn_points = get_tree().get_nodes_in_group("respawn")

	if spawn_points.size() == 0:
		print("No spawn points found!")
		return

	# assume the first spawn node is closest
	var nearest_spawn_point = spawn_points[0]

	# look through spawn nodes to see if any are closer
	for spawn_point in spawn_points:
		if spawn_point.global_position.distance_to(player.global_position) < nearest_spawn_point.global_position.distance_to(player.global_position):
			nearest_spawn_point = spawn_point

	# reposition player
	player.global_position = nearest_spawn_point.global_position

	# Optionally, reset player state or trigger respawn animations/effects
	player.reset_state()  # You can implement this function in the player script
