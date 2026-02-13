extends TextureButton

signal ToggleSelected(ing, )

var ingredient
var selected


# Called when the node enters the scene tree for the first time.
func _ready():
	selected = false

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func set_ingredient(ing):
	ingredient = ing
	print("set :" + ingredient)

func _on_pressed():
	if ingredient != null:
		selected = not selected
		ToggleSelected.emit(ingredient)
		print(ingredient + ": " + str(selected))
	else:
		print(ingredient)
		
	#if ingredient != "":
		#AddIngredient.emit(ingredient) # Replace with function body.
		#print("add " + ingredient + "\n")
