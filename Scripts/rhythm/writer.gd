extends Node2D
var event: FmodEvent = null
var beatStr: String = ""
var currTime: int = 0
var currSong = "recipe 1"
var currFile = "res://assets/assets - music/beatmaps/"+currSong+".txt"

# Called when the node enters the scene tree for the first time.
func _ready():
	print_debug("wha")
	event = FmodServer.create_event_instance("event:/recipes/"+currSong)
	event.set_callback(Callable(self, "markerManage"), FmodServer.FMOD_STUDIO_EVENT_CALLBACK_ALL)
	event.set_2d_attributes(self.global_transform)
	event.volume = 0.1
	event.start()

func markerManage(dict: Dictionary, _type: int):
	#print_debug(dict)
	if dict.has("beat"):
		if dict["beat"] == 1:
			currTime = dict["time_signature_upper"]
	if dict.has("name"):
		if dict["name"] == "end":
			event.stop(FmodServer.FMOD_STUDIO_STOP_IMMEDIATE)
			print_debug("song over, writing to file...")
			var file = FileAccess.open(currFile, FileAccess.WRITE)
			file.store_string(beatStr)
			file.close()
			print_debug("done! please check "+currFile)
		else:
			print_debug("detected beat "+str(dict["name"]))
			beatStr += dict["name"]
			beatStr += ","
			beatStr += str(currTime)
			beatStr += ","
			beatStr += str(dict["position"])
			beatStr += "\n"

func _notification(what):
	if what == NOTIFICATION_WM_CLOSE_REQUEST:
		print_debug("program quit, writing to file...")
		var file = FileAccess.open(currFile, FileAccess.WRITE)
		if beatStr:
			file.store_string(beatStr)
		file.close()
		print_debug("done! please check "+currFile)
		get_tree().quit() # default behavior
