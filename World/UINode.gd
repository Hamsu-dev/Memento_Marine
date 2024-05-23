extends CanvasLayer

@onready var popup_panel = $PopupPanel
@onready var popup_label_1 = $PopupPanel/PopupLabel1

func _ready():
	popup_panel.hide()

func show_message(message: String):
	popup_label_1.text = message
	popup_panel.show()
	await get_tree().create_timer(3.0).timeout
	popup_panel.hide()
