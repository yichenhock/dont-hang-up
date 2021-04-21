extends Control
var offset_amount = Vector2()

func _process(delta):
	offset_amount = lerp(offset_amount,(get_global_mouse_position() - Vector2(225,375) )*0.003,2*delta)
	$chromaticAbberation/ColorRect.material.set_shader_param("amount",offset_amount)
	if visible: 
		get_tree().paused = true
		Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)

func _on_resume_pressed():
	visible = false
	get_tree().paused = false
	queue_free()
	
func _on_quit_pressed():
	get_tree().quit()

func _on_howToPlay_pressed():
	$CanvasLayer.add_child($ResourcePreloader.get_resource("howToPlay").instance())
