extends TextureButton

func _on_invItem_mouse_entered():
	material.set_shader_param("outline",true)

func _on_invItem_mouse_exited():
	material.set_shader_param("outline",false)
