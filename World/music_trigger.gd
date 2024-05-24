extends Area2D

var playing = false

func _on_body_entered(body):
	if body is Player:
		if playing == false:
			ClockTowerBgm.play()
			ClockTowerAmbience.play()
			playing = true
