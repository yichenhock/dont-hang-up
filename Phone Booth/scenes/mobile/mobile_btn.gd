extends TextureButton
	
func _ready():
	for c in get_children(): 
		c.visible = false

func _on_key_button_down():
	for c in get_children(): 
		c.visible = true

func _on_key_button_up():
	for c in get_children(): 
		c.visible = false
