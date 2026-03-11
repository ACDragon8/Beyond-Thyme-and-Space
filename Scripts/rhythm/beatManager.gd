extends Node2D

@onready var measureManager = get_node("../measureManager")
# distance between each measure bar in pixels
var measureLength: int = 100
# list of beats as parsed from beatmap text file
# has format ["name of event", beat per measure,position(ms) in fmod event]
var beatList = [];
# stores instantiated beats/holds in same order as beatList
var dispList = [];
# preload beat and hold scenes to instantiate later
var beatScene = preload("res://scenes/beat.tscn")
var holdScene = preload("res://scenes/hold.tscn")
# can be swapped out to swap songs
# probably should make this a reference to a global or some other manager later
var currSong = "recipe 2"
var currDiff = "hard"
var fullComboCount = 0

# reads and parses beatmap text file into beatList
func _init():
	var file = FileAccess.open("res://assets/assets - music/beatmaps/"+currSong+" "+currDiff+".txt", FileAccess.READ)
	var content = file.get_as_text()
	var tempList = content.split("\n")
	fullComboCount = int(tempList[tempList.size()-2])
	tempList.remove_at(tempList.size()-2)
	for n in range(0,tempList.size()):
		var temp2 = tempList[n].split(",")
		if temp2.size() > 1:
			beatList.append([])
			beatList[n].append(temp2[0])
			beatList[n].append(temp2[1].to_int())
			beatList[n].append(temp2[2].to_int())

func _ready():
	measureLength = measureManager.getMeasureLength()
	parsePlaceBeats(beatList)

# further parses data from each beatList element and instantiates 
# beat and hold scenes
func parsePlaceBeats(beats: Array):
	var hold: bool = false;
	for n in range(0, beats.size()):
		var curr = beats[n]
		var timecode = curr[0].get_slice(" ",0).split(".")
		var measure = timecode[0].to_int()-1
		var beat = timecode[1].to_int()-1
		var subdiv = timecode[2].to_int()-1
		var currTime = curr[1]
		var type = curr[0].right(2)
		if beatScene:
			var beatInstance = beatScene.instantiate()
			add_child(beatInstance)
			var pos = measure*measureLength
			pos += measureLength*beat/currTime
			pos += measureLength*subdiv/(currTime*4)
			beatInstance.position += Vector2(pos, 0)
			if hold && holdScene && type == "hu":
				var lastPos = dispList.back().position
				var dist = beatInstance.position.distance_to(lastPos)
				var holdInstance = holdScene.instantiate()
				add_child(holdInstance)
				holdInstance.position = lastPos
				holdInstance.scale = Vector2(dist/500, 1)
				dispList.append(holdInstance)
			dispList.append(beatInstance)
		if type == "hd":
			hold = true
		else:
			hold = false

# for use in other scripts
func getBeatlist():
	return beatList

func getDispList():
	return dispList

# called when player uses input to hit a beat
# removes soonest viable beat from beatList
# then destroys the instanced scene to make it disappear
# can be replaced with sprite sub, etc. later
# extra modifications will have to be made for holds
func destroyBeat():
	if beatList.size() > 0:
		var curr = beatList.pop_front()
		dispList.pop_front().queue_free()
		var type = curr[0].right(2)
		if type == "hu":
			dispList.pop_front().queue_free()

# called when beat goes unhit and turns into a miss
# currently identical to _destroyBeat
func missBeat():
	if beatList.size() > 0:
		var curr = beatList.pop_front()
		dispList.pop_front().queue_free()
		var type = curr[0].right(2)
		if type == "hu":
			dispList.pop_front().queue_free()
