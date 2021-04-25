extends Control
var current_page = 1
var total_pages = 10
var quest_page = 1
var phone_page = 7
var max_entries_phone_page = 7

var new_info_on_pages = []

func _ready():
	$blocker.visible = false
	
func show(): 
	visible = true
	#Data.set_data("window_overlay",true)
	update_notepad()
	#current_page = Data.get_data("current_page",1)
	set_page_layout()
	set_bookmark_states()
	update_page_num()
	if Data.get_data("notepad_first_opened",false) == false:
		first_time_scribbles()
		Data.set_data("notepad_first_opened",true)
	

func first_time_scribbles(): 
	$back.visible = false
	$blocker.visible = true
	for text in $text/page1.get_children(): 
		text.visible = false
	$Timer.start(0.3)
	yield($Timer,"timeout")
	for text in $text/page1.get_children(): 
		text.visible = true
		Audio.play_writingSFX()
		$Timer.start(1.5)
		yield($Timer,"timeout")
	$back.visible = true
	$blocker.visible = false

func update_notepad(): 
	var phone_dict = Data.files["phone_numbers"]
	var numbers_to_add = Data.get_data("numbers_to_add",[])
	
	for n in numbers_to_add: 
		var new_entry = $ResourcePreloader.get_resource("notepad_number_entry").instance()
		
		floor(Data.get_data("numbers_in_notepad",[]).size()/7)
		var page_entry = phone_page+floor(Data.get_data("numbers_in_notepad",[]).size()/max_entries_phone_page)
		$text.get_node("page"+str(page_entry)).add_child(new_entry)
		if not page_entry in new_info_on_pages:
			new_info_on_pages.push_back(str(page_entry))
		new_entry.set_name(str(n))
		new_entry.text = str(n).insert(3," ") + " - " + phone_dict[str(n)]
		Data.append_data_array("numbers_in_notepad",n)
		
	Data.set_data("numbers_to_add",[])

func _process(delta):
	if visible: 
		if str(current_page) in new_info_on_pages: 
			new_info_on_pages.erase(str(current_page))
		if new_info_on_pages.size() == 0: 
			if Data.get_data("new_info_in_notepad",false)==true:
				Data.set_data("new_info_in_notepad",false)

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
	for i in $text.get_children():
		i.visible = false
	$text/pageNum.visible = true
	if $text.has_node("page"+str(current_page)):
		$text.get_node("page"+str(current_page)).visible = true
	
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
	Audio.play("menuClickSFX")
	visible = false
	#Data.set_data("window_overlay",false)

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
