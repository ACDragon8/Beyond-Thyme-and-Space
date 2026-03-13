extends TextureButton

var clickMask: BitMap
var img = load("res://Assets/Assets - UI/button_long pressed.png")

func _init():
	clickMask = BitMap.new()
	clickMask.create_from_image_alpha(img.get_image())
	self.texture_click_mask = clickMask

func _pressed():
	var root = get_tree().get_root()
	var scene = root.get_node("CookPrep")
	scene.queue_free()
	
	var rhythm = load("res://Scenes/rhythm.tscn")
	var rhythm_node = rhythm.instantiate()
	root.add_child(rhythm_node)
