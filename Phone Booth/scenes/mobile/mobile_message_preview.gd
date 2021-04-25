extends TextureButton
export(String) var sender_name
export(String) var latest_message
var max_characters = 14
var scrolling_text

func _ready():
	set_static_preview()
	reset_scrolling_text()

func reset_scrolling_text(): 
	scrolling_text = latest_message
	for i in range(max_characters): 
		scrolling_text += " "
	
func set_text(preview_text):
	$Label.text = "   "+sender_name+"\n "+preview_text

func set_static_preview():
	var preview_text = latest_message
	if preview_text.length()>max_characters: 
		preview_text = preview_text.left(max_characters-2)+"..."
	set_text(preview_text)

func _on_messagePreview_focus_entered():
	$ColorRect.color = Color(0.25,0.25,0.46,1.0)
	if latest_message.length()>max_characters: 
		set_text(latest_message.left(max_characters))
		reset_scrolling_text()
		$Timer.start()

func _on_messagePreview_focus_exited():
	$ColorRect.color = Color(0.20,0.20,0.20,1.0)
	$Timer.stop()
	set_static_preview()

func _on_Timer_timeout():
	var first_character = scrolling_text[0]
	scrolling_text.erase(0,1)
	scrolling_text = scrolling_text + first_character
	set_text(scrolling_text.left(max_characters))
