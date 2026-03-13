extends Node2D

@export var diffText: RichTextLabel
var diffList = ["easy", "normal", "hard"]
var curr = 1
var currDiff = "normal"

func _ready():
	if Global.currDiff:
		currDiff = Global.currDiff
	diffText.clear()
	diffText.append_text(diffList[curr])

func incDiff():
	if curr < 2:
		curr += 1
	diffText.clear()
	diffText.append_text(diffList[curr])
	currDiff = diffList[curr]
	Global.currDiff = currDiff

func decDiff():
	if curr > 0:
		curr -= 1
	diffText.clear()
	diffText.append_text(diffList[curr])
	currDiff = diffList[curr]
	Global.currDiff = currDiff
