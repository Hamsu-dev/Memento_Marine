extends Camera2D


func _ready():
	Events.camera_limits_changed.connect(_update_limits)

func _update_limits(left, right, top, bottom):
	limit_left = left
	limit_right = right
	limit_top = top
	limit_bottom = bottom
