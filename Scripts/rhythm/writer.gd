extends Node2D
var event: FmodEvent = null
var beatStr: String = ""
var beatCount: int = 0
var currTime: int = 0
var currSong = "recipe 2"
var currDiff = "easy"
var currFile = "res://assets/assets - music/beatmaps/"+currSong+" "+currDiff+".txt"
var hold: bool = false
var holdStartPos = 0
var bpm = 0
var written: bool = false

# Called when the node enters the scene tree for the first time.
func _ready():
	print_debug("wha")
	event = FmodServer.create_event_instance("event:/recipes/"+currSong+"/"+currDiff)
	event.set_callback(Callable(self, "markerManage"), FmodServer.FMOD_STUDIO_EVENT_CALLBACK_ALL)
	event.set_2d_attributes(self.global_transform)
	event.volume = 0.1
	event.start()

func _process(delta):
	if hold == true:
		var passed = event.position - holdStartPos
		if (passed > (60000/(bpm*4))):
			beatCount += 1
			holdStartPos = event.position

func markerManage(dict: Dictionary, _type: int):
	#print_debug(dict)
	if dict.has("beat"):
		if dict["beat"] == 1:
			currTime = dict["time_signature_upper"]
			bpm = dict["tempo"]
	if dict.has("name"):
		if dict["name"] == "end":
			event.stop(FmodServer.FMOD_STUDIO_STOP_IMMEDIATE)
			print_debug("song over, writing to file...")
			var file = FileAccess.open(currFile, FileAccess.WRITE)
			beatStr += str(beatCount)
			file.store_string(beatStr)
			file.close()
			print_debug("done! please check "+currFile)
			written = true
		else:
			print_debug("detected beat "+str(dict["name"]))
			beatStr += dict["name"]
			beatStr += ","
			beatStr += str(currTime)
			beatStr += ","
			beatStr += str(dict["position"])
			beatStr += "\n"
			beatCount += 1
			if dict["name"].right(2) == "hd":
				hold = true
				holdStartPos = dict["position"]
			if dict["name"].right(2) == "hu":
				hold = false

func _notification(what):
	if what == NOTIFICATION_WM_CLOSE_REQUEST:
		if written == false:
			event.stop(FmodServer.FMOD_STUDIO_STOP_IMMEDIATE)
			print_debug("program quit, writing to file...")
			var file = FileAccess.open(currFile, FileAccess.WRITE)
			if beatStr:
				beatStr += str(beatCount)
				file.store_string(beatStr)
			file.close()
			print_debug("done! please check "+currFile)
			get_tree().quit() # default behavior
