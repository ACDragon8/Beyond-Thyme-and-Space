extends TextureButton

@onready var diffSelect = get_node("..")

func _pressed():
	diffSelect.decDiff()
