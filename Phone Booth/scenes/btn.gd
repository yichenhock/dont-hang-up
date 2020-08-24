tool
extends TextureButton

export(Texture) var image setget set_image

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func set_image(new_image):
	image = new_image
	$symbol.texture = new_image
	
func button_down():
	$symbol.rect_position.x += 1

func button_up():
	$symbol.rect_position.x -= 1
	Audio.play("keypadSFX")
