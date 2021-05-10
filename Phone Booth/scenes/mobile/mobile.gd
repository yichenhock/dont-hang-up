extends Control

var current_screen = "home"
var btn_config = [null,null]

var screen_btns = {"home":["menu","contacts"],
					"dialling":["clear","home"],
					"menu":["call history","home"],
					"call history":["alert","menu"],
					"contacts":[null,"home"],
					"calendar":[null,null],
					"games":[null,null],
					"messages":["textlog","menu"],
					"textlog":["alert","messages"],
					"memo":[null,"menu"],
					"radio":[null,"menu"],
					"gallery":[null,"menu"],
					"settings":[null,"menu"],
					"alert":[null,null]
					}

func _ready():
	switch_screen("home")
	for key in $keys/numbers.get_children():
		key.connect("key_pressed",self,"on_number_key_pressed")
	if Data.get_data("calendar_clicked",false):
			$screen/menu/GridContainer/calendar.hide()
	
func on_number_key_pressed(number): 
	if current_screen == "home": 
		switch_screen("dialling")
		$screen/dialling/ScrollContainer/numberEntry.text=number
	elif current_screen == "dialling": 
		$screen/dialling/ScrollContainer/numberEntry.text+=number
	yield($screen/dialling/ScrollContainer.get_v_scrollbar(),"changed")
	$screen/dialling/ScrollContainer.scroll_vertical = $screen/dialling/ScrollContainer.get_v_scrollbar().max_value
		
func _on_acceptCall_pressed():
	if current_screen == "dialling": 
		showAlert()
	
func showAlert(): 
	current_screen = "alert"
	$screen.get_node("alert").visible = true
	yield(get_tree().create_timer(1.5), "timeout")
	switch_screen("home")
	
func _on_dialling_empty_dialling_screen():
	switch_screen("home")
	
func _process(delta):
	if visible: 
		if Data.get_data("window_overlay",false)==false:
			Data.set_data("window_overlay",true)
	btn_config = screen_btns[current_screen]
	
func _on_back_pressed():
	Audio.play("menuClickSFX")
	visible = false
	Data.set_data("window_overlay",false)
	queue_free()

func switch_screen(screen): 
	var dont_hide = ["lcdShader","leftBtn","rightBtn"]
	
	for s in $screen.get_children(): 
		if not s.get_name() in dont_hide:
			s.visible = false
			
	$screen.get_node(screen).visible = true
	
	if current_screen == "home" and screen == "contacts":
		screen_btns["contacts"] = [null,"home"]
		
	current_screen = screen
	
	if screen == "menu": 
		$screen/menu/GridContainer/callHistory.grab_focus()
	elif screen == "messages": 
		$screen/messages.set_focus()
	elif screen == "calendar":
		if Data.get_data("calendar_clicked",false) == false:
			calendar_glitch()
			Data.set_data("calendar_clicked",true)
			$screen/menu/GridContainer/calendar.hide()
	elif screen == "call history":
		$"screen/call history/ScrollContainer/VBoxContainer/mumM".grab_focus()
	
func calendar_glitch(): 
	$screen/calendar/movingGlitch.visible = false
	yield(get_tree().create_timer(1.2), "timeout")
	$screen/calendar/movingGlitch.visible = true
	
func _on_leftBtn_pressed():
	if btn_config[0] == "clear":
		$screen/dialling.clear()
	elif btn_config[0] == "alert":
		showAlert()
	elif btn_config[0] != null: 
		switch_screen(btn_config[0])

func _on_rightBtn_pressed():
	if btn_config[1] != null: 
		switch_screen(btn_config[1])

func _on_menu_change_destination(next_screen):
	if next_screen == "":
		screen_btns["menu"] = [null,"home"]
	else:
		screen_btns["menu"] = [next_screen,"home"]
	screen_btns["contacts"] = [null,"menu"]

func _on_declineCall_pressed():
	#if not taking call
	if current_screen!="calendar":
		switch_screen("home")

func _on_messages_change_textlogs(sender_name):
	$screen/textlog.sender = sender_name
