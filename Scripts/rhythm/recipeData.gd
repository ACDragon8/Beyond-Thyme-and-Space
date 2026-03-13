extends Node

var ingredients = {
	"cabbage": [
		"res://Assets/Assets - Ingredient/cabbage/cabbage1.png", 
		"res://Assets/Assets - Ingredient/cabbage/cabbage2.png", 
		"res://Assets/Assets - Ingredient/cabbage/cabbage3.png"
	],
	"chicken": [
		"res://Assets/Assets - Ingredient/chicken/chicken1.png",
		"res://Assets/Assets - Ingredient/chicken/chicken2.png",
		"res://Assets/Assets - Ingredient/chicken/chicken3.png"
	],
	"rice": [
		"res://Assets/Assets - Ingredient/rice/rice1.png",
		"res://Assets/Assets - Ingredient/rice/rice2.png",
		"res://Assets/Assets - Ingredient/rice/rice3.png"
	],
	"bread": [
		"res://Assets/Assets - Ingredient/bread/bread1.png",
		"res://Assets/Assets - Ingredient/bread/bread2.png",
		"res://Assets/Assets - Ingredient/bread/bread3.png",
		"res://Assets/Assets - Ingredient/bread/bread4.png"
	],
	"egg": [
		"res://Assets/Assets - Ingredient/egg/egg1.png",
		"res://Assets/Assets - Ingredient/egg/egg2.png",
		"res://Assets/Assets - Ingredient/egg/egg3.png"
	],
	"curry": [
		"res://Assets/Assets - Ingredient/curry/curry0001.png",
		"res://Assets/Assets - Ingredient/curry/curry0002.png",
		"res://Assets/Assets - Ingredient/curry/curry0003.png"
	]
}

var recipeData = {
	"recipe 1": {
		"ingredients": [ingredients["rice"], ingredients["cabbage"], ingredients["chicken"]],
		"final": "res://Assets/Assets - Recipe/TNS_cloudybento.png",
		"name": "Cloudy Bento Box"
	},
	"recipe 2": {
		"ingredients": [ingredients["bread"], ingredients["cabbage"], ingredients["egg"]],
		"final": "res://Assets/Assets - Recipe/TNS_sandwich.png",
		"name": "Someone’s Sandwiches"
	},
	"recipe 3": {
		"ingredients": [ingredients["rice"], ingredients["chicken"], ],
		"final": "res://Assets/Assets - Recipe/TNS_curry.png",
		"name": "Curry Rice"
	}
}

func getRecipeData():
	return recipeData
