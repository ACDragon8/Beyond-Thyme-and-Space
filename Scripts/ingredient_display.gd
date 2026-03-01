extends Container

var index

signal ToggleSelected(ing,index,b)
signal display(index)

# Called when the node enters the scene tree for the first time.
func _ready():
	$ColorRect.visible = false
	#$TextureButton/Container/Ingredient.texture.current_frame = 1


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func set_ingredient(ing):
	$TextureButton.set_ingredient(ing)

func set_index(val):
	index = val
func _on_texture_button_pressed():
	$ColorRect.visible = not $ColorRect.visible
	if index != null:
		ToggleSelected.emit($TextureButton.ingredient,index, $ColorRect.visible)
		
	
