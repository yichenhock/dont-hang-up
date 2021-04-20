tool
extends TextureButton
export(String) var number setget set_number
export(String) var letters setget set_letters

func set_number(new_number): 
	number = new_number
	$HBoxContainer/number.text = str(number)
	
func set_letters(new_letters): 
	letters = new_letters
	$HBoxContainer/letters.text = letters

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
