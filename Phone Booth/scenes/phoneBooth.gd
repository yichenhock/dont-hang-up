extends Node2D
var zoom_enabled = false
var camera_following_cursor = false

var coins_collected = 0
var taking_call = false
var phone_picked_up = false

var seconds_since_last_interaction = 0

signal phone_picked_up()
signal phone_hung_up()
signal phone_call_begun(nodeID)
signal phone_dialed_unknown_number()
signal out_of_time()

signal window_overlay_opened()
signal window_overlay_closed()

func _ready():
	$doorClosed.visible = true
	$doorClosed.modulate = Color(1.0,1.0,1.0,1.0)
	$doorOpened.visible = false
	Data.set_data("coins", coins_collected)

func set_interaction(can_interact): 
	$CanvasLayer/blocker.visible = !can_interact

func initialise(): 
	$CanvasLayer/uiInstructions.show()
	$CanvasLayer/remainingTime.visible = true
	$CanvasLayer/phonebookIcon.visible = true
	$CanvasLayer/coins.visible = true
	$secondsTimer.start()

func _on_doorOpenedHandle_pressed():
	$doorAnim.play("close")
	$doorOpened/doorOpenedHandle.visible = false
	$doorClosed/doorClosedHandle.visible = true
	Audio.play("doorSFX")
	Audio.stepOutside()
	set_process_input(false)
	
func _on_doorClosedHandle_pressed():
	$doorAnim.play("open")
	$doorOpened/doorOpenedHandle.visible = true
	$doorClosed/doorClosedHandle.visible = false
	Audio.play("doorSFX")
	Audio.stepInside()
	set_process_input(true)
	
func _unhandled_input(event):
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

func _input(event):
	if event.is_action_pressed("x"): # Pick up the phone
		phone_picked_up = true
		$phone.pick_up()
		emit_signal("phone_picked_up")
	if event.is_action_released("x"): # Hang up
		if phone_picked_up: 
			$phone.hang_up()
			phone_picked_up = false

func _process(delta):
	$doorOpened/doorOpenedHandle.visible = !phone_picked_up
	
	if camera_following_cursor: # Camera stuff
		$Camera2D.offset = get_viewport().get_mouse_position()*0.5 + get_viewport().size*0.25
	else: 
		$Camera2D.offset = get_viewport().size*0.5
		
	if Input.is_action_pressed("click") or Input.is_action_pressed("right_click"): 
		seconds_since_last_interaction = 0

func _on_secondsTimer_timeout():
	if seconds_since_last_interaction != null: 
		seconds_since_last_interaction += 1
		print("seconds since last click: ", seconds_since_last_interaction)
		if seconds_since_last_interaction > 40:
			seconds_since_last_interaction = null
			$phone.ring_phone()  # a death??

func _on_paperclip_pressed():
	$paperclip.visible = false
	$CanvasLayer/items/vbox/paperclipInv.visible = true
	
func _on_paperclipInv_pressed():
	$CanvasLayer/cursors.item_equipped = "paperclip"
	
func enable_zoom(): 
	zoom_enabled = true
	
func on_window_closed(): 
	emit_signal("window_overlay_closed")
	zoom_enabled = true

func _on_wallet_pressed():
	$CanvasLayer/wallet.visible = true
	zoom_enabled = false
	emit_signal("window_overlay_opened")

func _on_tartCard_pressed():
	$CanvasLayer/tartCard.visible = true
	zoom_enabled = false
	emit_signal("window_overlay_opened")

func _on_crumpledPaper_pressed():
	Audio.play("uncrumpleSFX")
	$CanvasLayer/crumpledPaper.visible = true
	zoom_enabled = false
	emit_signal("window_overlay_opened")

func add_coin(): 
	coins_collected += 1
	$CanvasLayer/coins.increment()
	Data.set_data("coins", coins_collected)

func _on_phone_coin_inserted():
	use_coin()
	$CanvasLayer/remainingTime.add_time()

func _on_phone_coin_collected():
	add_coin()
	
func use_coin(): 
	coins_collected -= 1
	$CanvasLayer/coins.decrement()
	Data.set_data("coins", coins_collected)

func _on_phone_return_handle_pressed():
	$CanvasLayer/remainingTime.decrement_time()

func _on_phone_picked_up(number):
	zoom_enabled = false
	var free_calls = ["0","999","1808255"]
	
	if Data.number_nodes.has(number): 
		Audio.play_phone("recieverPickupSFX")
		if not number in free_calls: 
			$CanvasLayer/remainingTime.start()
		emit_signal("phone_call_begun", Data.number_nodes[number])
	else: 
		$CanvasLayer/remainingTime.start()
		emit_signal("phone_dialed_unknown_number")
		
func shake_handset(): 
	$phone.shake_handset()

func _on_phone_hang_up():
	emit_signal("phone_hung_up")
	$CanvasLayer/remainingTime.stop()
	zoom_enabled = true

func _on_remainingTime_timeout(): # phone call abruptly ends bcos no money bcos poor
	Audio.play_phone("deadlineSFX")
	$phone.display_no_coins(true)
	emit_signal("out_of_time")

var mobile_clicked = false
signal mobile_clicked_first_time()

func _on_mobile_pressed():
	if not mobile_clicked: 
		emit_signal("mobile_clicked_first_time")
		mobile_clicked = true
	else: 
		$CanvasLayer/mobile.visible = true

func _on_suicideRip_pressed():
	$booth/suicideAd.visible = false
	# Audio.play("tearSFX")

func _on_phonebookIcon_pressed():
	$CanvasLayer/phonebook.show()
