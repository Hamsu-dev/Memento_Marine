extends Control

@onready var control = $"."

func _ready():
	control.hide()

func _on_button_pressed():
	get_tree().change_scene_to_file("res://Menu/MainMenu.tscn")
	PowerUps.false_unlock_bounce_ability()
	PowerUps.false_unlock_wall_jump_ability()

func _on_button_2_pressed():
	control.hide()
