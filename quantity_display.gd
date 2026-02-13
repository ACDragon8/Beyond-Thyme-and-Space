extends Label

var quantity

signal QuantityUpdated(val)


# Called when the node enters the scene tree for the first time.
func _ready():
	quantity = 0


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
	

func add_quantity():
	quantity += 1
	update_text()
	
func minus_quantity():
	if quantity > 0:
		quantity -= 1
	update_text()

func set_quantity(val):
	if quantity >= 0:
		quantity = val
	else:
		quantity = 0
	update_text()

func update_text():
	text = "Quantity: " + str(quantity)
	QuantityUpdated.emit(quantity)
	
