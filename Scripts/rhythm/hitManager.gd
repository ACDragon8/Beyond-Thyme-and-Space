extends Node2D

# references to beatManager and fmodManager
@onready var beatManager = get_node("../beatManager")
@onready var fmodManager = get_node("..")
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
@export var acc: RichTextLabel
@export var com: RichTextLabel
var seen = 0.0
var hit = 0.0
var combo = 0
var combos = []
var holdStartPos

func _ready():
	destroy = Callable(beatManager, "destroyBeat")
	miss = Callable(beatManager, "missBeat")
	beatList = beatManager.getBeatlist()

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
			acc.clear()
			com.clear()
			fb.append_text("miss")
			acc.append_text(str((hit/seen)*100)+"%")
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
				acc.clear()
				com.clear()
				var offset = curr[2] - fmodManager.getEvent().position
				fb.append_text(score(offset))
				acc.append_text(str((hit/seen)*100)+"%")
				com.append_text(str(combo))
				var type = curr[0].right(2)
				if type == "hd":
					hold = true;
					holdStartPos = fmodManager.getEvent().position
		if Input.is_action_pressed("hit"):
			if hold == true:
				var clip = beatManager.getDispList()[0].get_child(0)
				var loc = beatManager.getDispList()[0].get_child(1)
				var bar = clip.get_child(0).get_child(0)
				clip.global_position.x = get_node("../../bar").global_position.x
				bar.global_position.x = loc.global_position.x
				var passed = fmodManager.getEvent().position - holdStartPos
				print(passed)
				print_debug(60000/(fmodManager.getBPM()*4))
				if (passed > (60000/(fmodManager.getBPM()*4))):
					combo += 1
					holdStartPos = fmodManager.getEvent().position
					com.clear()
					com.append_text(str(combo))
		# if in a hold, check for released space bar and make changes accordingly
		# (hold up)
		if Input.is_action_just_released("hit"):
			if hold == true:
				print("what")
				destroy.call()
				beatList = beatManager.getBeatlist()
				hold = false;
				seen += 4
				fb.clear()
				acc.clear()
				com.clear()
				var offset = curr[2] - fmodManager.getEvent().position
				fb.append_text(score(offset))
				acc.append_text(str((hit/seen)*100)+"%")
				com.append_text(str(combo))

func score(offset):
	if absi(offset) <= 50:
		hit += 4
		combo += 1
		return "perfect"
	if absi(offset) <= 100 && absi(offset) > 50:
		hit += 3
		combo += 1
		return "ok"
	if offset < -100:
		hit += 1
		combo += 1
		return "late!"
	if offset > 100 && offset <= 200: 
		hit += 1
		combo += 1
		return "early!"
	combo = 0
	combos.append(combo)
	return "miss"
