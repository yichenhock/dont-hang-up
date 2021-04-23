extends TextureButton
export(String) var sender_name
export(String) var latest_message

func _ready():
	set_preview()

func set_preview():
	$Label.text = "   "+sender_name+"\n "+latest_message

func _on_messagePreview_pressed():
	pass # Replace with function body.

func _on_messagePreview_focus_entered():
	$ColorRect.color = Color(0.25,0.25,0.46,1.0)

func _on_messagePreview_focus_exited():
	$ColorRect.color = Color(0.20,0.20,0.20,1.0)
