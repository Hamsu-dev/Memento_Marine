extends Area2D


func _on_area_entered(area):
	if area.is_in_group("EndCreds"):
		print("End credits reached the area. Changing scene to Main Menu.")
		get_tree().change_scene_to_file("res://Menu/MainMenu.tscn")
		#SceneManager.change_scene("res://Menu/MainMenu.tscn")
