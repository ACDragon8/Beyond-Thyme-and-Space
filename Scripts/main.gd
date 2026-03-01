extends Node2D
signal GameStart

var time_begin
var time_delay
var game_start

# Called when the node enters the scene tree for the first time.
func _ready():
	game_start = false


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if not game_start:
		if Input.is_action_just_released("Space"):
			game_start = true
			GameStart.emit()
			time_begin = Time.get_ticks_usec()
			time_delay = AudioServer.get_time_to_next_mix() + AudioServer.get_output_latency()
			$AudioStreamPlayer2D.play()
