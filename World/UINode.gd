extends CanvasLayer

const texture = preload("res://dialogue/dialogue1.png")

@onready var popup_panel = $PopupPanel
@onready var popup_label_1 = $PopupPanel/PopupLabel1

func _ready():
	# Set the background image for the PopupPanel
	var style = StyleBoxTexture.new()
	if texture:
		style.texture = texture
		style.texture_margin_top = 0
		style.texture_margin_bottom = 0
		style.texture_margin_left = 0
		style.texture_margin_right = 0
		popup_panel.add_theme_stylebox_override("panel", style)
		print("Texture applied successfully")
	else:
		print("Failed to load texture")
	
	popup_panel.custom_minimum_size = texture.get_size()
	popup_label_1.add_theme_color_override("font_color", Color(1, 1, 1))  # White color for text
	#popup_label_1.horizontal_alignment = Label.PRESET_CENTER
	#popup_label_1.vertical_alignment = Label.PRESET_VCENTER_WIDE
	popup_label_1.custom_minimum_size = Vector2(popup_panel.custom_minimum_size.x - 100, popup_panel.custom_minimum_size.y - 40)  # Adjust for padding
	# Hide the panel initially
	popup_panel.hide()

func show_message(message: String, position: Vector2):
	popup_label_1.text = message
	popup_panel.custom_minimum_size = Vector2(320, 180)
	popup_panel.show()
	await get_tree().create_timer(3.0).timeout
	popup_panel.hide()
