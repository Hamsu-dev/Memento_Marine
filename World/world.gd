extends Node

@onready var animation_player = $AnimationPlayer
@onready var button = $Button
@onready var player = $Player
@onready var player_camera = $Player/Camera2D
@onready var world_camera = $WorldCamera

func _ready():
	# Connect the button's signal to the function
	button.button_pressed.connect(_on_Button_pressed)

func _on_Button_pressed():
	show_cutscene()

func show_cutscene():
	if world_camera:
		world_camera.make_current()
	
	animation_player.play("cutscene")
	print("playing")
	
	# Optionally, disable player controls during the cutscene
	if player:
		player.set_process(false)  # Disable the player's processing

	# You can also use a timer or signals to re-enable controls after the cutscene

func _on_animation_player_animation_finished(anim_name):
	if anim_name == "cutscene":
		# Switch back to the player camera
		if player_camera:
			player_camera.make_current()  # Make the player camera current again
		
		# Re-enable player controls
		if player:
			player.set_process(true)
