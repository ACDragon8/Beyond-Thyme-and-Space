extends Area2D

var body
var overlap
var game_start

# Called when the node enters the scene tree for the first time.
func _ready():
	body = null
	game_start = false
	


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if game_start:
		if Input.is_action_just_pressed("Space"):
			hit_check()
		var velocity = Vector2.ZERO
		velocity.x += 200
		position += velocity * delta

func hit_check():
	if body == null:
		print("miss")
	else: 
		print("hit")
		body.hit()
	

func _on_area_entered(area):
	body = area
	
func _on_area_exited(area):
	if body != null and not body.get_is_hit():
		print("not hit")
	body = null


func _on_main_game_start():
	game_start = true
