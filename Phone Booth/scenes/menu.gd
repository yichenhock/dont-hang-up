extends Control
signal enter_pressed()
var offset_amount = Vector2()

func _ready():
	$danglingPhone.position = $Title/cableStart.global_position

func _on_enter_pressed():
	$AnimationPlayer.play("fadeOut")
	yield($AnimationPlayer, "animation_finished")
	emit_signal("enter_pressed")

func _on_phonebook_pressed():
	pass # Replace with function body.

func _on_options_pressed():
	pass # Replace with function body.

func _on_credits_pressed():
	pass # Replace with function body.
	
func _on_leave_pressed():
	get_tree().quit()

func _process(delta):
	offset_amount = lerp(offset_amount,(get_global_mouse_position() - Vector2(225,375) )*0.005,2*delta)
	$chromaticAbberation/ColorRect.material.set_shader_param("amount",offset_amount)
