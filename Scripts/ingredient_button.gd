extends TextureButton

signal ToggleSelected(ing)

var ingredient


# Called when the node enters the scene tree for the first time.
func _ready():
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func set_ingredient(ing):
	ingredient = ing
	print("set :" + ingredient)

func _on_pressed():
	if ingredient != null:
		ToggleSelected.emit(ingredient)
		pass
	else:
		print("Error: no ingredient selected")
		
	#if ingredient != "":
		#AddIngredient.emit(ingredient) # Replace with function body.
		#print("add " + ingredient + "\n")
