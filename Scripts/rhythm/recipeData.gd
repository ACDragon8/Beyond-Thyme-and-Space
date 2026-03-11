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
	]
}

var recipeData = {
	"recipe 1": {
		"ingredients": [ingredients["rice"], ingredients["cabbage"], ingredients["chicken"]],
		"final": "res://Assets/Assets - Recipe/TNS_cloudybento.png"
	},
	"recipe 2": {
		"ingredients": [],
		"final": ""
	},
	"recipe 3": {
		"ingredients": [],
		"final": ""
	}
}

func getRecipeData():
	return recipeData
