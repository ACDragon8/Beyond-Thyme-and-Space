extends Node2D

signal AddIngredient

var ingredients = {}
var num_boxes = 7

const IngredientButton: PackedScene = preload("res://Prefabs/ingredient_button.tscn")

# Called when the node enters the scene tree for the first time.
func _ready():
	load_game()
	#new_ingredient("chicken")
	var ings = ["Chicken", "Onions", "Rice", "Lettuce", "Carrots", "Beef", "Pork"]
	for i in range(num_boxes):
		add_box(ings[i])
	update_counter()
	


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	pass
	


func update_counter():
	var s = ""
	for i in ingredients:
		s = s + "{0}: {1}\n".format([i, str(ingredients[i])])
	$TextEdit.text = s
	save_game()


func new_ingredient(ing):
	ingredients[ing] = 0


func add_ingredient(ing):
	if not ing in ingredients:
		new_ingredient(ing)
	ingredients[ing] += 1
	
func add_box(ingr):
	var box = IngredientButton.instantiate()
	box.set_ingredient(ingr)
	box.size *= 0.5
	#box.connect("AddIngredient", add_ingredient(ingr))
	$GridContainer.add_child(box)
	
func save_game():
	var save_file = FileAccess.open("user://savegame.save", FileAccess.WRITE)
	var json_string = JSON.stringify(ingredients)
	save_file.store_line(json_string)
	print("saved")
	
func load_game():
	if not FileAccess.file_exists("user://savegame.save"):
		return # Error! We don't have a save to load.
	var save_file = FileAccess.open("user://savegame.save", FileAccess.READ)
	var json_string = save_file.get_line()
	print("a")
	var json = JSON.new()
	var result = json.parse(json_string)
	ingredients = json.data
	for i in ingredients:
		ingredients[i] = int(ingredients[i])
