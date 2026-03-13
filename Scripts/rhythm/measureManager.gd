extends Node2D

# length between measure bars in pixels
var measureLength = 900
var measure = 0
var measureScene = preload("res://Scenes/measure.tscn")
var pool = []
var startPos

func _ready():
	startPos = self.position
	for i in range(0, 6):
		var newInstance = measureScene.instantiate()
		add_child(newInstance)
		newInstance.position += Vector2(measure*measureLength, 0)
		pool.append(newInstance)
		measure += 1

func _process(delta):
	for bar in pool:
		if bar.global_position.x < 0:
			respawn(bar)

func respawn(meas):
	meas.position = startPos + Vector2(measure*measureLength, 0)
	measure += 1

func getMeasureLength():
	return measureLength
