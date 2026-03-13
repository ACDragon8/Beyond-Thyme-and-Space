extends TextureButton

@export var popup: Node2D
var clickMask: BitMap
var img = load("res://Assets/Assets - UI/button_square default.png")

func _init():
	clickMask = BitMap.new()
	clickMask.create_from_image_alpha(img.get_image())
	self.texture_click_mask = clickMask

func _pressed():
	popup.hide()
