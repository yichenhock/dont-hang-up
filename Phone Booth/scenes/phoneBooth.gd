extends Node2D
var zoom_enabled = false
var camera_following_cursor = false
var interacted_with_something = false
var coins_collected = 0
var taking_call = false
var phone_picked_up = false

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
	$CanvasLayer/coins.visible = true

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
			emit_signal("phone_hung_up")
			
func _process(delta):
	if camera_following_cursor: # Camera stuff
		$Camera2D.offset = get_viewport().get_mouse_position()*0.5 + get_viewport().size*0.25
	else: 
		$Camera2D.offset = get_viewport().size*0.5
	
func enable_zoom(): 
	zoom_enabled = true
	
func on_window_closed(): 
	emit_signal("window_overlay_closed")
	zoom_enabled = true
	
func _on_Timer_timeout(): # change to time since last interaction/last click
	if not interacted_with_something: 
		$phone.ring_phone() # dis is phone call from da killer uwu

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

func use_coin(): 
	coins_collected -= 1
	$CanvasLayer/coins.decrement()
	Data.set_data("coins", coins_collected)

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
func _on_paperclip_pressed():
	pass # Replace with function body.
