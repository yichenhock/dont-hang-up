extends Node
var phone_picked_up = false

func _ready():
	AudioServer.set_bus_volume_db(AudioServer.get_bus_index("Master"), linear2db(Data.get_data("volume",0.8)))
	Audio.play("rainOutside")
	Audio.play("rainInside")
	add_scene("menu")
	$CanvasLayer/menu.connect("enter_pressed",self,"_on_menu_enter_pressed")
	$CanvasLayer/inventory.visible = false
	$phoneBooth.set_process_input(false)
	$phoneBooth.set_interaction(false)

func _unhandled_input(event):
	if event.is_action_pressed("toggle_fullscreen"): 
		OS.window_fullscreen = !OS.window_fullscreen
	if event.is_action_pressed("ui_cancel"): 
		add_scene("pauseMenu")

func _on_menu_enter_pressed():
	first_speech()

func first_speech(): # the "talking to self" speech the player does upon starting the game
	var dialogue = Data.files["self_dialogues"]["001"]
	$CanvasLayer/speechSelf.type_texts(dialogue)
	
func _on_speechSelf_self_dialogue_finished():
	add_scene("howToPlay")
	$CanvasLayer/howToPlay.connect("window_closed",self,"initialise")

func initialise(): 
	$phoneBooth.zoom_enabled = true
	$phoneBooth.initialise()
	$CanvasLayer/inventory.visible = true
	for i in range(1,5):
		Data.set_data("wallet_coin"+str(i),true)

func _on_phoneBooth_phone_call_begun(nodeID):
	var dialogue_finished = false
	$DialogueNode.initialise_default()
	do_the_dialogue_thing(nodeID)

func do_the_dialogue_thing(nodeID): 
	$DialogueNode.identify_next_node(nodeID)
	if $DialogueNode.type == null: 
		if $CanvasLayer/speechPhone.visible: 
			$CanvasLayer/speechPhone.hide() # end of conversation - play hang up tone?
		$phoneBooth/phone.end_call()
		
	elif $DialogueNode.type == "speech": 
		$CanvasLayer/speechPhone.show()
		$CanvasLayer/speechPhone.type_texts([$DialogueNode.speech_text])
		yield($CanvasLayer/speechPhone,"phone_dialogue_finished")
		do_the_dialogue_thing($DialogueNode.nodeID_speech)
		
	elif $DialogueNode.type == "choice": 
		if phone_picked_up: 
			$CanvasLayer/speechOptions.show_options($DialogueNode.choices)

func _on_speechPhone_line_started():
	$phoneBooth.shake_handset()

func _on_speechOptions_pressed(nodeID):
	if nodeID == null: 
		Data.set_data("left_people_hanging", Data.get_data("left_people_hanging",0) + 1)
		
		$CanvasLayer/speechPhone.show()
		$CanvasLayer/speechPhone.type_text($DialogueNode.reply_on_timeout)
		yield($CanvasLayer/speechPhone,"line_finished")
		end_phone_call()
	else: 
		do_the_dialogue_thing(nodeID)
	
func end_phone_call(): 
	$CanvasLayer/speechPhone.hide()
	$phoneBooth/phone.end_call()
	Audio.stop_phone()

func _on_phoneBooth_phone_picked_up():
	phone_picked_up = true
	
func _on_phoneBooth_phone_hung_up():
	phone_picked_up = false
	$CanvasLayer/speechOptions.terminate_choices()
	$CanvasLayer/speechPhone.hide()

var window_overlay = false

func _process(delta):
	$mouse.position = get_viewport().get_mouse_position()
	if window_overlay: 
		$CanvasLayer/speechOptions.disable_choices(true)
	$CanvasLayer/cursors.item_equipped = Data.get_data("equipped",null)
		
func equip_item(new_item): 
	Data.set_data("equipped",new_item)
	$CanvasLayer/cursors.item_equipped = Data.get_data("equipped",null)

func _input(event):
	if Input.is_action_just_pressed("click"):
		if Data.get_data("equipped", null) == "coin": 
			print($mouse.get_overlapping_areas())
			var useable = false
			for i in $mouse.get_overlapping_areas():
				if i is CoinUse: 
					useable = true
				elif i is BlockerArea: 
					useable = false
					break
			if useable: 
				$CanvasLayer/description.set_text("used a coin")
				Data.set_data("coins",Data.get_data("coins",0)-1)
			else:
				$CanvasLayer/description.set_text("can't use this here")
				$CanvasLayer/inventory/holder/items/coins.num_coins += 1
				equip_item(null)

func _on_phoneBooth_window_overlay_opened():
	window_overlay = true
	$CanvasLayer/speechOptions.disable_choices(true)
	$CanvasLayer/speechPhone.mouse_filter = Control.MOUSE_FILTER_IGNORE

func _on_phoneBooth_window_overlay_closed():
	window_overlay = false
	$CanvasLayer/speechOptions.disable_choices(false)
	$CanvasLayer/speechPhone.mouse_filter = Control.MOUSE_FILTER_PASS

func _on_phoneBooth_phone_dialed_unknown_number():
	Audio.stop_phone()
	$CanvasLayer/speechPhone.show()
	$CanvasLayer/speechPhone.type_texts(["NUMBER NOT RECOGNISED."])
	yield($CanvasLayer/speechPhone, "phone_dialogue_finished")
	Audio.play_phone("hangUpSFX")
	end_phone_call()

func _on_wallet_pressed():
	if $CanvasLayer.has_node("mobile"): 
		remove_child($CanvasLayer/mobile)
	if !$CanvasLayer.has_node("wallet"):
		add_scene("wallet")
		$CanvasLayer/wallet.connect("coin_collected",self,"collect_coin")
	
func collect_coin(): 
	Data.set_data("coins",Data.get_data("coins",0)+1)
	$CanvasLayer/inventory/holder/items/coins.num_coins += 1
	
func _on_mobile_pressed():
	if $CanvasLayer.has_node("wallet"): 
		remove_child($CanvasLayer/wallet)
	if !$CanvasLayer.has_node("mobile"): 
		add_scene("mobile")
	
func add_scene(new_scene): 
	$CanvasLayer.add_child($Scenes.get_resource(new_scene).instance())

func _on_coins_pressed():
	equip_item("coin")
	$CanvasLayer/inventory/holder/items/coins.num_coins -= 1

func _on_phoneBooth_coin_collected():
	$CanvasLayer/inventory/holder/items/coins.num_coins += 1

func _on_notepad_pressed():
	add_scene("notepad")
