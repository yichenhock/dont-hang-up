extends Node2D
var zoom_enabled = false
var camera_following_cursor = false
var taking_call = false
var phone_picked_up = false

signal phone_picked_up()
signal phone_hung_up()
signal phone_call_begun(nodeID)
signal phone_dialed_unknown_number()

signal coin_collected()
signal notepad_open_request()

func _ready():
	$doorClosed.visible = true
	$doorClosed.modulate = Color(1.0,1.0,1.0,1.0)
	$doorOpened.visible = false

func initialise(): 
	set_interaction(true)
	$doorAnim.play("handleShine")

func set_interaction(can_interact): 
	$blocker.visible = !can_interact

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
	if Data.get_data("notepad_first_pressed",false) == false:
		Data.set_data("directed_from_door",true)
		yield($doorAnim,"animation_finished")
		emit_signal("notepad_open_request")
	
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
	
func add_scene(new_scene): 
	$CanvasLayer.add_child($Scenes.get_resource(new_scene).instance())

func _on_tartCard_pressed():
	add_scene("tartCard")

func _on_crumpledPaper_pressed():
	add_scene("crumpledPaper")
	Audio.play("uncrumpleSFX")

func _on_phone_picked_up(number):
	zoom_enabled = false
	var free_calls = ["0","999","1808255"]
	
	if Data.number_nodes.has(number): 
		Audio.play_phone("recieverPickupSFX")
		if not number in free_calls: 
			pass
		emit_signal("phone_call_begun", Data.number_nodes[number])
	else: 
		emit_signal("phone_dialed_unknown_number")
		
func shake_handset(): 
	$phone.shake_handset()

func _on_phone_hang_up():
	emit_signal("phone_hung_up")
	zoom_enabled = true

func _on_suicideRip_pressed():
	$booth/suicideAd.visible = false
	# Audio.play("tearSFX")

func _on_phone_coin_collected():
	emit_signal("coin_collected")
