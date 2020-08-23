extends Node2D
var zoom_enabled = false
var camera_following_cursor = false
var interacted_with_something = false

var coins_collected = 0

func _ready():
	$doorClosed.visible = true
	$doorClosed.modulate = Color(1.0,1.0,1.0,1.0)
	$doorOpened.visible = false
	$CanvasLayer/menu.visible = true
	$CanvasLayer/menu.modulate = Color(1.0,1.0,1.0,1.0)
	Data.set_data("coins", coins_collected)

func _on_menu_enter_pressed():
	first_speech()

func first_speech(): # the "talking to self" speech the player does upon starting the game
	var dialogue = Data.dialogues["self_dialogues"]["001"]
	$CanvasLayer/speechSelf.type_texts(dialogue)

func _on_speechSelf_self_dialogue_finished():
	$CanvasLayer/uiInstructions.show()
	$CanvasLayer/remainingTime.visible = true
	$CanvasLayer/coins.visible = true
	zoom_enabled = true

func _on_doorHandle_pressed():
	$doorAnim.play("open")
	$Timer.start()
	
func _input(event):
	if zoom_enabled: 
		if event.is_action_pressed("z"): 
			$Camera2D.zoom = Vector2(0.5,0.5)
			camera_following_cursor = true
		if event.is_action_released("z"): 
			$Camera2D.zoom = Vector2(1,1)
			camera_following_cursor = false
	else: 
		$Camera2D.zoom = Vector2(1,1)
		camera_following_cursor = false
			
func _process(delta):
	if camera_following_cursor: 
		$Camera2D.offset = get_viewport().get_mouse_position()*0.5 + get_viewport().size*0.25
	else: 
		$Camera2D.offset = get_viewport().size*0.5
	
func enable_zoom(): 
	zoom_enabled = true
	
func _on_Timer_timeout():
	if not interacted_with_something: 
		$phone.ring_phone() # dis is phone call from da killer uwu

func _on_wallet_pressed():
	$CanvasLayer/wallet.visible = true
	zoom_enabled = false

func _on_tartCard_pressed():
	$CanvasLayer/tartCard.visible = true
	zoom_enabled = false

func _on_crumpledPaper_pressed():
	$CanvasLayer/crumpledPaper.visible = true
	zoom_enabled = false

func add_coin(): 
	coins_collected += 1
	$CanvasLayer/coins.increment()
	Data.set_data("coins", coins_collected)

func _on_phone_coin_inserted():
	use_coin()
	#potentially have phone reject the coin?

func use_coin(): 
	coins_collected -= 1
	$CanvasLayer/coins.decrement()
	Data.set_data("coins", coins_collected)

func _on_phone_picked_up(number):
	zoom_enabled = false
	if number == "0": 
		$CanvasLayer/speechPhone.show()
		$CanvasLayer/speechPhone.type_texts(["Oh my, you're still there? i'm very glad you are", "I'm coming to get youuuu! im like right behind u uwu (this is the psychopathic killer or whatever who will be lurking about in the gaem)", "don't you think the dev's speech bubble is so cool?? :D :D :D"])

func _on_speechPhone_line_started():
	$phone.shake_handset()