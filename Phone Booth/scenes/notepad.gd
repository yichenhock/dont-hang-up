extends Control
var current_page
var total_pages = 10

var quest_page = 1
var phone_page = 7

func _ready():
	current_page = Data.get_data("current_page",1)
	set_page_layout()
	set_bookmark_states()
	update_page_num()

func set_page_layout(): 
	$corner.frame = 0
	if current_page == 1:
		$notepad.frame = 0
		$notepad/prevPage.visible = false
		$corner.visible = true
	else: 
		if current_page == total_pages: 
			$corner.visible = false
		else: 
			$corner.visible = true
		$notepad.frame = 6
		$notepad/prevPage.visible = true
	$text.visible = true
	
func set_bookmark_states(): 
	$questSelect.visible = false
	$quest.visible = true
	$quest.frame = 0
	
	$phoneSelect.visible = false
	$phone.visible = true
	$phone.frame=0
	
	if current_page == quest_page: 
		$questSelect.visible = true
		$quest.visible = false
	elif current_page == phone_page: 
		$phoneSelect.visible = true
		$phone.visible = false

func _on_back_pressed():
	Data.set_data("current_page",current_page)
	Audio.play("menuClickSFX")
	visible = false
	emit_signal("window_closed")
	queue_free()

func _on_nextPage_mouse_entered():
	$corner.frame = 1
func _on_nextPage_mouse_exited():
	$corner.frame = 0
func _on_nextPage_pressed():
	current_page+=1
	go_next()
	
func go_next():
	update_page_num()
	set_bookmark_states()
	$notepad/prevPage.visible = true
	$corner.visible = false
	$text.visible = false
	$notepad/AnimationPlayer.play("nextPage")
	yield($notepad/AnimationPlayer,"animation_finished")
	set_page_layout()

func _on_prevPage_mouse_entered():
	$notepad.frame = 5
func _on_prevPage_mouse_exited():
	$notepad.frame = 6
func _on_prevPage_pressed():
	current_page -= 1
	go_prev()
		
func go_prev(): 
	update_page_num()
	$corner.visible = false
	$text.visible = false
	$notepad/AnimationPlayer.play_backwards("nextPage")
	yield($notepad/AnimationPlayer,"animation_finished")
	set_page_layout()
	set_bookmark_states()
	
func update_page_num(): 
	$text/pageNum.text = str(current_page)+"/"+str(total_pages)
	
func flip_to_page(number): 
	if number > current_page: 
		current_page = number
		go_next()
	elif number < current_page: 
		current_page = number
		go_prev()

func _on_qBookmark_mouse_entered():
	if current_page != quest_page: 
		$quest.frame = 1
func _on_qBookmark_mouse_exited():
	$quest.frame = 0
func _on_qBookmark_pressed():
	flip_to_page(quest_page)
	
func _on_pBookmark_mouse_entered():
	if current_page != phone_page: 
		$phone.frame = 1
func _on_pBookmark_mouse_exited():
	$phone.frame = 0
func _on_pBookmark_pressed():
	flip_to_page(phone_page)
