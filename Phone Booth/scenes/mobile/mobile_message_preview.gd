extends TextureButton
export(String) var sender_name setget set_sender_name
#export(String) var latest_message
var latest_message = ""
var max_characters = 14
var scrolling_text
signal message_selected(sender_name)

func set_sender_name(new_name): 
	sender_name = new_name
	get_last_message(Data.text_log_nodes[sender_name])
	set_static_preview()
	reset_scrolling_text()

func get_last_message(nodeID): 
	if Data.text_logs[nodeID].has("children"): 
		get_last_message(Data.text_logs[nodeID]["children"][0])
	else: 
		latest_message = Data.text_logs[nodeID]["#text"]

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


func _on_messagePreview_pressed():
	emit_signal("message_selected",sender_name)
