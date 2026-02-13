extends TextureButton

signal AddIngredient(ing)

var ingredient

# Called when the node enters the scene tree for the first time.
func _ready():
	var ingredient = ""


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func set_ingredient(ing):
	ingredient = ing



func _on_pressed():
	AddIngredient.emit(ingredient) # Replace with function body.
	print("add " + ingredient + "\n")
