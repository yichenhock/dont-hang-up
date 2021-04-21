extends Control

var current_screen = "home"
var btn_config = [null,null]

var screen_btns = {"home":["menu",null],
					"menu":[null,"home"]}

func _ready():
	btn_config = screen_btns[current_screen]

func _process(delta):
	if visible: 
		if Data.get_data("window_overlay",false)==false:
			Data.set_data("window_overlay",true)

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
	current_screen = screen
	btn_config = screen_btns[current_screen]
	print(btn_config)

func _on_leftBtn_pressed():
	if btn_config[0] != null: 
		switch_screen(btn_config[0])

func _on_rightBtn_pressed():
	print("right pressed")
	if btn_config[1] != null: 
		switch_screen(btn_config[1])
