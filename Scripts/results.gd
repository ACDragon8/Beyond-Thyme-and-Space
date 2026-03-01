extends Node2D

signal AddIngredient

var ingredients = {}
var num_boxes = 6
var selected_ingredients #list of length num_boxes representing whether the ingredient in the box is selected
var collecting = false
var collect_time = Time.get_unix_time_from_system()
var lock = false

const IngredientButton: PackedScene = preload("res://Prefabs/ingredient_button.tscn")

# Called when the node enters the scene tree for the first time.
func _ready():
	load_game()
	selected_ingredients = []
	var ings = ["Chicken", "Cabbage", "Rice", "Bread", "Egg", "Curry"]
	for i in range(num_boxes):
		add_box(ings[i],i)
	update_counter()
	


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	var current_time = Time.get_unix_time_from_system()
	
	


func update_counter(): # updates the ingredients textbox
	var s = ""
	for i in ingredients:
		s = s + "{0}: {1}\n".format([i, str(ingredients[i])])
	$TextEdit.text = s
	save_game()


func new_ingredient(ing): #creates a new ingredient in the ingredient dictionary
	ingredients[ing] = 0


func add_ingredient(ing): #adds 1 to the ingredient in ingredient dict, creates it if it does not exist
	if not ing in ingredients:
		new_ingredient(ing)
	ingredients[ing] += 1
	update_counter()
	
func add_many_ingredient(ing, val):
	if not ing in ingredients:
		new_ingredient(ing)
	ingredients[ing] += val
	update_counter()

func add_list_of_ingredient(list): #list = [(ing, val)]
	for i in list:
		var ing = i[0]
		var val = i[1]
		add_many_ingredient(ing, val)
		

func _on_collect_pressed():
	print(selected_ingredients)
	for i in selected_ingredients:
		if i != "":
			print("adding "+ i)
			add_many_ingredient(i, $"Quantity Display".quantity)
	update_counter()
	print(Time.get_unix_time_from_system())

func _on_selection_update(ing, index, b):
	print("update")
	if b:
		selected_ingredients[index] = ing
	else:
		selected_ingredients[index] = ""
	
func add_box(ingr,index): #creates an IngredientButton for adding ingredients
	var box = IngredientButton.instantiate()
	box.set_index(index)
	box.set_ingredient(ingr)
	box.ToggleSelected.connect(_on_selection_update)
	$GridContainer.add_child(box)
	selected_ingredients.append("")
	
	
	
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

#debug function
func _on_reset_pressed():
	ingredients = {}
	save_game()
	update_counter()



	
