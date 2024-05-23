extends ColorRect

@onready var animated_sprite_2d = $AnimatedSprite2D

func _ready():
	animated_sprite_2d.play("default")

func _on_start_pressed():
	SceneManager.change_scene("res://World/world.tscn")
	MenuBgm.stop()
	WorldMusic.play()


func _on_credits_pressed():
	get_tree().change_scene_to_file("res://Menu/Credits.tscn")
