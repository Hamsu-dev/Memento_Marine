extends Area2D

var playing = false
# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_body_exited(body):
	if body is Player:
		print(playing)
		if playing == false:
			RumblingSFX.play()
			playing = true