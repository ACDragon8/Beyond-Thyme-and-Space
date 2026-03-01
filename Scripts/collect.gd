extends Button

var wait_until: int = Time.get_unix_time_from_system()
var lock: bool = false


# Called when the node enters the scene tree for the first time.
func _ready():
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	var current_time = Time.get_unix_time_from_system()
	if(current_time < wait_until):
		lock = true
	else:
		lock = false
