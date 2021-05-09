extends Control

var current_screen = "home"
var btn_config = [null,null]

var screen_btns = {"home":["menu","contacts"],
					"menu":["call history","home"],
					"call history":[null,"menu"],
					"contacts":[null,"home"],
					"calendar":[null,null],
					"games":[null,null],
					"messages":["textlog","menu"],
					"textlog":[null,"messages"],
					"memo":[null,"menu"],
					"radio":[null,"menu"],
					"gallery":[null,"menu"],
					"settings":[null,"menu"]
					}

func _ready():
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
		$screen/menu/GridContainer/menuItem.grab_focus()

func _on_leftBtn_pressed():
	if btn_config[0] != null: 
		switch_screen(btn_config[0])

func _on_rightBtn_pressed():
	if btn_config[1] != null: 
		switch_screen(btn_config[1])

func _on_menu_change_destination(next_screen):
	screen_btns["menu"] = [next_screen,"home"]
	screen_btns["contacts"] = [null,"menu"]

func _on_declineCall_pressed():
	#if not taking call
	switch_screen("home")

func _on_messages_change_textlogs(sender_name):
	$screen/textlog.sender = sender_name
