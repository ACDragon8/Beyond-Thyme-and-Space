extends TextureButton

@onready var recipeSelect = get_node("../../../../ui/recipe select/recipe select")
var clickMask: BitMap
var img = load("res://Assets/Assets - UI/select-bg.png")

func _init():
	clickMask = BitMap.new()
	clickMask.create_from_image_alpha(img.get_image())
	self.texture_click_mask = clickMask

func _pressed():
	recipeSelect.setRecipe(self.name)
