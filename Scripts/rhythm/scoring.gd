extends Node2D

@export var recipedisp: Sprite2D
@export var recipeName: RichTextLabel
@export var diffText: RichTextLabel
@export var gradeText: RichTextLabel
@export var comboText: RichTextLabel
@export var hitText: RichTextLabel
@export var accText: RichTextLabel
@export var monText: RichTextLabel
@onready var recipeDataNode = get_node("../center")
@onready var fmodManager = get_node("../rhythm interface/timeline")
var recipeData
var currSong
var currDiff
var moneyDict = {
	"recipe 1": {
		"easy": 15,
		"normal": 18.75,
		"hard": 22.5
	},
	"recipe 2": {
		"easy": 25,
		"normal": 31.25,
		"hard": 37.5
	},
	"recipe 3": {
		"easy": 35,
		"normal": 43.75,
		"hard": 52.5
	}
}

func _ready():
	currSong = fmodManager.getCurrSong()
	currDiff = fmodManager.getCurrDiff()
	recipeData = recipeDataNode.getRecipeData()
	recipeName.clear()
	recipeName.append_text(recipeData[currSong]["name"])
	diffText.append_text(currDiff.to_upper())
	loadRecipeDisplay()

func loadRecipeDisplay():
	var img = load(recipeData[currSong]["final"])
	var tex = ImageTexture.create_from_image(img.get_image())
	var texSize = tex.get_size()
	tex.set_size_override(Vector2(1000, texSize.y*(1000/texSize.x)))
	recipedisp.texture = tex

func sum(accum, number):
	return accum + number

func setScores(seen, hit, combos, max):
	var max_combo = combos.max()
	if (max_combo >= max):
		gradeText.append_text("PERFECT")
	elif (float(max_combo)/max <= 0.8):
		gradeText.append_text("GREAT")
	elif (float(max_combo)/max <= 0.6):
		gradeText.append_text("OKAY")
	elif (float(max_combo)/max <= 0.5):
		gradeText.append_text("FAIL")
	comboText.append_text(str(max_combo))
	if combos.size() > 1:
		hitText.append_text(str(combos.reduce(sum, 0)))
	else:
		hitText.append_text(str(max_combo))
	accText.append_text(str((hit/seen)*100).left(4)+"%")
	monText.append_text("$"+str(moneyDict[currSong][currDiff]))
