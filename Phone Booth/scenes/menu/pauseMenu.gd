extends Control
var offset_amount = Vector2()
var current_screen = "main"

func _process(delta):
	offset_amount = lerp(offset_amount,(get_global_mouse_position() - Vector2(225,375) )*0.003,2*delta)
	$chromaticAbberation/ColorRect.material.set_shader_param("amount",offset_amount)
	
	if visible: 
		get_tree().paused = true
		Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)

func _ready():
	pass # Replace with function body.

func _on_resume_pressed():
	resume()

func resume(): 
	visible = false
	get_tree().paused = false
	
func _on_phonebook_pressed():
	$main.visible = false
	$phonebook.show()
	current_screen = "phonebook"
	
func _on_quit_pressed():
	get_tree().quit()

func _on_back_pressed():
	get_node(current_screen).hide()
	$main.visible = true


