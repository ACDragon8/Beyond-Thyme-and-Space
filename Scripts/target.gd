extends Area2D

var is_hit


# Called when the node enters the scene tree for the first time.
func _ready():
	is_hit = false


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func hit():
	hide()
	is_hit = true
	$CollisionShape2D.set_disabled(true)
	
	
func get_is_hit():
	return is_hit
