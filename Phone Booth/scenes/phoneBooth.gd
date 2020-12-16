extends Node2D
var zoom_enabled = false
var camera_following_cursor = false
var interacted_with_something = false
var coins_collected = 0
var taking_call = false
var reply_on_timeout = "Hello...?"

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
		$phone.pick_up()
	if event.is_action_released("x"): # Hang up
		$phone.hang_up()
			
func _process(delta):
	if camera_following_cursor: # Camera stuff
		$Camera2D.offset = get_viewport().get_mouse_position()*0.5 + get_viewport().size*0.25
	else: 
		$Camera2D.offset = get_viewport().size*0.5
	
func enable_zoom(): 
	zoom_enabled = true
	
func _on_Timer_timeout(): # change to time since last interaction/last click
	if not interacted_with_something: 
		$phone.ring_phone() # dis is phone call from da killer uwu

func _on_wallet_pressed():
	$CanvasLayer/wallet.visible = true
	zoom_enabled = false

func _on_tartCard_pressed():
	$CanvasLayer/tartCard.visible = true
	zoom_enabled = false

func _on_crumpledPaper_pressed():
	Audio.play("uncrumpleSFX")
	$CanvasLayer/crumpledPaper.visible = true
	zoom_enabled = false

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
	#read from "phone-dialogues here!"
	var free_calls = ["0","999","1808255"]
	
	if Data.number_nodes.has(number): 
		Audio.play_phone("recieverPickupSFX")
		$CanvasLayer/speechPhone.show()
		if not number in free_calls: 
			$CanvasLayer/remainingTime.start()
			
		$CanvasLayer/speechPhone.type_text(Data.phone_dialogues[Data.number_nodes[number]]["#text"]) #this is wrong... this gets the number thats in the starting number node!!!
		identify_next_node(Data.number_nodes[number])
		
	else: 
		Audio.play_phone("phoneDisconnected")
		$CanvasLayer/speechPhone.show()
		$CanvasLayer/speechPhone.type_texts(["We're sorry. You have reached a number that has been disconnected or is no longer in service. If you feel that you have reached this recording in error, please check the number and try your call again. "])

func identify_next_node(nodeID): 
	if Data.phone_dialogues[nodeID].has("children") == false: 
		return false
	else: 
		for node in Data.phone_dialogues[nodeID]["children"]: 
			if Data.phone_dialogues[node]["@color"] == "#CCFFCC": #phonespeech
				print("this is a speech")
				print(Data.phone_dialogues[node]["#text"])
			elif Data.phone_dialogues[node]["@color"] =="#99CCFF": #choice
				print("this is a choice")
				print(Data.phone_dialogues[node]["#text"])
			elif Data.phone_dialogues[node]["@color"] =="#FF99CC": # reply after timeout
				print("this is the reply on timeout")
				reply_on_timeout = Data.phone_dialogues[node]["#text"]
				print(reply_on_timeout)
		return Data.phone_dialogues[nodeID]["children"]

func _on_speechPhone_line_started():
	$phone.shake_handset()

func _on_phone_hang_up():
	#if any speech is going on, terminate it 
	if $CanvasLayer/speechPhone.visible: 
		$CanvasLayer/speechPhone.hide()
	$CanvasLayer/remainingTime.stop()
	zoom_enabled = true

func _on_remainingTime_timeout(): # phone call abruptly ends bcos no money bcos poor
	pass # Print something like no more coins
	# then killer kills you? 
