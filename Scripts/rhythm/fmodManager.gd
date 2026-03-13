extends Node2D

@onready var measureManager = get_node("measureManager")
# stores currently playing fmod event/song
var event: FmodEvent = null
# can be swapped out to swap songs
var currSong: String = "recipe 2"
var currDiff: String = "hard"
# current bpm, beats per measure (can change throughout song)
var bpm: float = 0
var timeUpper: int = 0;
# length between measure bars in pixels
var measureLength: int = 100
# curr measure, starting position of timeline bar
var measure: int = 0;
var startPos: Vector2;
# actual transform position in game where sound is meant to come from
@export var listenerPos: Node2D = null
@export var diffText: RichTextLabel

# sets startpos for scroll calculations
func _init():
	startPos = self.position

# initializes fmod event
func _ready():
	print_debug("wha")
	measureLength = measureManager.getMeasureLength()
	diffText.clear()
	diffText.append_text(currDiff)
	event = FmodServer.create_event_instance("event:/recipes/"+currSong+"/"+currDiff)
	# attach callback to all events emitted by timeline
	# includes events on every beat + any user-defined events as part of beat map
	event.set_callback(Callable(self, "scrollBy"), FmodServer.FMOD_STUDIO_EVENT_CALLBACK_ALL)
	event.set_2d_attributes(listenerPos.global_transform)
	# may want to make volume dynamic later for settings
	event.volume = 1
	event.start()

# constant scrolling in time
func _process(delta):
	if bpm != 0:
		self.position += Vector2(-measureLength/(1/bpm * 60 * timeUpper)*delta,0)

# on each beat, catch any tempo marker changes
# additionally, at the start of each measure, snap to the bar to reduce
# drift over time
func scrollBy(dict: Dictionary, _type: int):
	if dict.has("beat"):
		bpm = dict["tempo"]
		timeUpper = dict["time_signature_upper"]
		if dict["beat"] == 1:
			print_debug("new measure")
			self.position = startPos - Vector2(measure*measureLength, 0)
			measure += 1
	else:
		print_debug(dict)

# returns fmod event for other scripts to see
func getEvent():
	return event

func getBPM():
	return bpm

func getCurrSong():
	return currSong

func getCurrDiff():
	return currDiff
