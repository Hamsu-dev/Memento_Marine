extends Area2D

@onready var player = $"../Player"

func _on_area_entered(area):
	print("working")
	if player.is_in_group("Player"):
		get_tree().change_scene_to_file("res://World/clock_tower_level_one.tscn")
