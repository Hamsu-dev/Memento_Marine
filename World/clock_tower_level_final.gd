extends Node

@onready var button = $Button
@onready var world_camera = $WorldCamera
@onready var animation_player = $AnimationPlayer
@onready var player_camera = $"../Player/Camera2D"
@onready var color_rect = $"God Ray/ColorRect"

func _ready():
	button.button_pressed.connect(_on_Button_pressed)

func _on_Button_pressed():
	godray()

func godray():
	color_rect.visible = true
