extends TextureButton

func _on_callLogEntry_focus_entered():
	$ColorRect.color = Color(0.25,0.25,0.46,1.0)

func _on_callLogEntry_focus_exited():
	$ColorRect.color = Color(0.20,0.20,0.20,1.0)
