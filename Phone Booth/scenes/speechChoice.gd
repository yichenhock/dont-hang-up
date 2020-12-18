extends TextureButton
var nodeID = "" 
var choice_text = "" setget set_text
signal option_chosen(nodeID)
signal animation_finished()

func _ready():
	pass # Replace with function body.

func set_text(new_text): 
	choice_text = new_text
	$NinePatchRect/Label.text = choice_text

func _on_speechChoice_mouse_entered():
	$NinePatchRect/Label.add_color_override("font_color","ff1400")
	$NinePatchRect.self_modulate = Color("ff1400")

func _on_speechChoice_mouse_exited():
	$NinePatchRect/Label.add_color_override("font_color","efffe9")
	$NinePatchRect.self_modulate = Color("efffe9")

func choice_pressed():
	emit_signal("option_chosen",nodeID)
	
func show(): 
	$choiceAnim.play("show")

func hide(): 
	$choiceAnim.play("hide")

func _on_choiceAnim_animation_finished(anim_name):
	emit_signal("animation_finished")
