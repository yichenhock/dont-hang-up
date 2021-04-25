extends TextureButton
export(String) var memo_entry

var max_characters = 12
var scrolling_text

func _ready():
	set_static_preview()
	reset_scrolling_text()

func reset_scrolling_text(): 
	scrolling_text = memo_entry
	for i in range(max_characters): 
		scrolling_text += " "
	
func set_text(preview_text):
	$HBoxContainer/Label.text = preview_text

func set_static_preview():
	var preview_text = memo_entry
	if preview_text.length()>max_characters: 
		preview_text = preview_text.left(max_characters-2)+"..."
	set_text(preview_text)

func _on_memoPreview_focus_entered():
	$ColorRect.color = Color(0.25,0.25,0.46,1.0)
	if memo_entry.length()>max_characters: 
		set_text(memo_entry.left(max_characters))
		reset_scrolling_text()
		$Timer.start()

func _on_memoPreview_focus_exited():
	$ColorRect.color = Color(0.20,0.20,0.20,1.0)
	$Timer.stop()
	set_static_preview()

func _on_Timer_timeout():
	var first_character = scrolling_text[0]
	scrolling_text.erase(0,1)
	scrolling_text = scrolling_text + first_character
	set_text(scrolling_text.left(max_characters))
