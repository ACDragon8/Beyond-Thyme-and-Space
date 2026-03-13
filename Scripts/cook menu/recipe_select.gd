extends TextureButton

@onready var recipeDataNode = get_node("../../../center")
@export var dishDisplay: Sprite2D
@export var popup: Node2D
@export var recipes: Node2D
var clickMask: BitMap
var img = load("res://Assets/Assets - UI/select-bg.png")
var currSong: String = "recipe 1"
var recipeData


func _init():
	if Global.currSong:
		currSong = Global.currSong
	clickMask = BitMap.new()
	clickMask.create_from_image_alpha(img.get_image())
	self.texture_click_mask = clickMask

func _ready():
	recipeData = recipeDataNode.getRecipeData()
	loadRecipeDisplay()

func loadRecipeDisplay():
	var img = load(recipeData[currSong]["final"])
	var tex = ImageTexture.create_from_image(img.get_image())
	var texSize = tex.get_size()
	tex.set_size_override(Vector2(600, texSize.y*(600/texSize.x)))
	dishDisplay.texture = tex

func _pressed():
	popup.show()

func setRecipe(str):
	currSong = str
	Global.currSong = str
	for node in recipes.get_children():
		if node.name == currSong:
			node.get_child(2).show()
		else:
			if (node.get_child_count() > 2):
				node.get_child(2).hide()
	loadRecipeDisplay()
