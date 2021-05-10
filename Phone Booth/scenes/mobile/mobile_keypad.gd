tool
extends TextureButton
export(String) var number setget set_number
export(String) var letters setget set_letters
signal key_pressed(number)

func set_number(new_number): 
	number = new_number
	$HBoxContainer/number.text = str(number)
	
func set_letters(new_letters): 
	letters = new_letters
	$HBoxContainer/letters.text = letters

# Called when the node enters the scene tree for the first time.
func _ready():
	$ColorRect.visible = false

func _on_key_button_down():
	$ColorRect.visible = true

func _on_key_button_up():
	$ColorRect.visible = false

func _on_key_pressed():
	emit_signal("key_pressed",number)
