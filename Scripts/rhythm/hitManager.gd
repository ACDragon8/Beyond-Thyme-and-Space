extends Node2D

# references to beatManager and fmodManager
@onready var beatManager = get_node("../beatManager")
@onready var fmodManager = get_node("..")
@onready var recipeDataNode = get_node("../../../center")
# in ms, represents how early you can begin hitting a note
# (ex. how soon an input registers as a hit for the soonest note)
# and how much time after it passes the bar until its considered a miss
var hitWindow: int = 200
var hold: bool = false
# references to callables and stuff from other functions
var destroy
var miss
var beatList
# richtextlabel that displays "miss" or offset from true time
# can be removed/swapped out for juicy feedback later
@export var fb: RichTextLabel
@export var com: RichTextLabel
@export var dishDisplay: Sprite2D
@export var ingredientDisplay: Sprite2D
var seen = 0.0
var hit = 0.0
var combo = 0
var combos = []
var holdStartPos
var recipeData
var currSong
var currIng = [0, 0]
var rotated = false

func _ready():
	destroy = Callable(beatManager, "destroyBeat")
	miss = Callable(beatManager, "missBeat")
	beatList = beatManager.getBeatlist()
	recipeData = recipeDataNode.getRecipeData()
	currSong = fmodManager.getCurrSong()
	loadRecipeDisplay()
	loadFromString(recipeData[currSong]["ingredients"][0][0])

func _process(delta):
	if beatList.size() > 0:
		var curr = beatList[0]
		# if beat has passed bar after hitWindow ms, consider it a miss
		if (curr[2] - fmodManager.getEvent().position) < -hitWindow+1:
			miss.call()
			beatList = beatManager.getBeatlist()
			seen += 4
			combos.append(combo)
			combo = 0
			fb.clear()
			com.clear()
			fb.append_text("miss")
			com.append_text(str(combo))
			hold = false
		# if player input, check if note is within hitWindow ms, then make
		# changes to beatList and display (beats and hold down)
		if Input.is_action_just_pressed("hit"):
			if (curr[2] - fmodManager.getEvent().position < hitWindow) && !hold:
				destroy.call()
				beatList = beatManager.getBeatlist()
				seen += 4
				fb.clear()
				com.clear()
				var offset = curr[2] - fmodManager.getEvent().position
				fb.append_text(score(offset))
				com.append_text(str(combo))
				var type = curr[0].right(2)
				if type == "hd":
					hold = true;
					holdStartPos = curr[2]
				if beatList.size() > 0:
					loadFromString(getNextIng())
				else:
					loadFromStringU(recipeData[currSong]["final"])
		if Input.is_action_pressed("hit"):
			if hold == true:
				var clip = beatManager.getDispList()[0].get_child(0)
				var loc = beatManager.getDispList()[0].get_child(1)
				var bar = clip.get_child(0).get_child(0)
				clip.global_position.x = get_node("../../bar").global_position.x
				bar.global_position.x = loc.global_position.x
				if (holdStartPos > beatList[0][2]):
					holdStartPos = beatList[0][2]
				var passed = fmodManager.getEvent().position - holdStartPos
				if (passed > (60000/(fmodManager.getBPM()*4))) && holdStartPos != beatList[0][2]:
					combo += 1
					holdStartPos += 60000/(fmodManager.getBPM()*4)
					com.clear()
					com.append_text(str(combo))
		# if in a hold, check for released space bar and make changes accordingly
		# (hold up)
		if Input.is_action_just_released("hit"):
			if hold == true:
				hold = false;
				print("what")
				destroy.call()
				beatList = beatManager.getBeatlist()
				seen += 4
				fb.clear()
				com.clear()
				var offset = curr[2] - fmodManager.getEvent().position
				var score = score(offset)
				fb.append_text(score(offset))
				com.append_text(str(combo))
				if score != "miss":
					if beatList.size() > 0:
						loadFromString(getNextIng())
					else:
						loadFromStringU(recipeData[currSong]["final"])

func score(offset):
	if absi(offset) <= 50:
		print_debug("perf")
		hit += 4
		combo += 1
		return "perfect"
	elif absi(offset) <= 100 && absi(offset) > 50:
		print_debug("ok")
		hit += 3
		combo += 1
		return "ok"
	elif offset < -100:
		print_debug("late")
		hit += 1
		combo += 1
		return "late!"
	elif offset > 100 && offset <= 200: 
		print_debug("earl")
		hit += 1
		combo += 1
		return "early!"
	combo = 0
	combos.append(combo)
	return "miss"

func loadRecipeDisplay():
	var img = Image.load_from_file(recipeData[currSong]["final"])
	var tex = ImageTexture.create_from_image(img)
	var texSize = tex.get_size()
	tex.set_size_override(Vector2(600, texSize.y*(600/texSize.x)))
	dishDisplay.texture = tex

func loadFromString(file):
	var img = Image.load_from_file(file)
	var tex = ImageTexture.create_from_image(img)
	var texSize = tex.get_size()
	if (texSize.x >= texSize.y):
		tex.set_size_override(Vector2(500, texSize.y*(500/texSize.x)))
		if rotated == true:
			rotated = false
			ingredientDisplay.rotate(0.95)
	else:
		tex.set_size_override(Vector2(texSize.x*(500/texSize.y), 500))
		if rotated == false:
			rotated = true
			ingredientDisplay.rotate(-0.95)
	ingredientDisplay.texture = tex

func loadFromStringU(file):
	var img = Image.load_from_file(file)
	var tex = ImageTexture.create_from_image(img)
	var texSize = tex.get_size()
	tex.set_size_override(Vector2(700, texSize.y*(700/texSize.x)))
	if rotated == true:
			rotated = false
			ingredientDisplay.rotate(0.95)
	ingredientDisplay.texture = tex

func getNextIng():
	currIng = [currIng[0], currIng[1]+1]
	if currIng[1] >= 3:
		currIng[0] += 1
		currIng[1] = 0
	if currIng[0] >= recipeData[currSong]["ingredients"].size():
		currIng[0] = 0
	return recipeData[currSong]["ingredients"][currIng[0]][currIng[1]]
