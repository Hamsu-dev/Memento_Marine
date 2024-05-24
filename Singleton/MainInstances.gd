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
	get_tree().change_scene_to_file("res://death_screen.tscn")
