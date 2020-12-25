extends Node
var current_scene = null
var states = ["menu", "playing", "paused", "ending"]
var current_state = "menu"

# var left_people_hanging = 0 # the amount of times player spent too long choosing an option
# var hung_up_on_someone = 0 # the amount of times the player hangs up on somebody

var phone_picked_up = false

func _ready():
#	change_state("phoneBooth")
	AudioServer.set_bus_volume_db(AudioServer.get_bus_index("Master"), linear2db(Data.get_data("volume",0.8)))
	Audio.play("rainOutside")
	Audio.play("rainInside")
	
	$CanvasLayer/menu.visible = true
	$CanvasLayer/pauseMenu.visible = false
	$CanvasLayer/menu.modulate = Color(1.0,1.0,1.0,1.0)
	
	$phoneBooth.set_process_input(false)
	$phoneBooth.set_interaction(false)

func add_scene(new_scene): 
	add_child($Scenes.get_resource(new_scene).instance())
	
func _unhandled_input(event):
	if event.is_action_pressed("fullscreen_toggle"): 
		OS.window_fullscreen = !OS.window_fullscreen
		
	if event.is_action_pressed("ui_cancel"): 
		if $CanvasLayer/menu.visible == false: 
			$CanvasLayer/pauseMenu.visible = true

func _on_menu_enter_pressed():
	first_speech()
	$phoneBooth.set_interaction(true)

var first_part_done = false

func first_speech(): # the "talking to self" speech the player does upon starting the game
	var dialogue = Data.files["self_dialogues"]["001"]
	$CanvasLayer/speechSelf.type_texts(dialogue)
	
func _on_speechSelf_self_dialogue_finished():
	if not first_part_done: 
		first_part_done = true
		$phoneBooth.zoom_enabled = true
		$phoneBooth.initialise()

#func change_state(new_scene_name):
#	remove_child(current_scene)
#	current_scene = $Scenes.get_resource(new_scene_name).instance()
#	add_child(current_scene)
#	#current_scene.connect("change_state",self,"change_state")

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
		$phoneBooth/CanvasLayer/remainingTime.stop()
		
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
		print(Data.get_data("left_people_hanging"))
		
		$CanvasLayer/speechPhone.show()
		$CanvasLayer/speechPhone.type_text($DialogueNode.reply_on_timeout)
		yield($CanvasLayer/speechPhone,"line_finished")
		end_phone_call()
	else: 
		do_the_dialogue_thing(nodeID)
	
func end_phone_call(): 
	$CanvasLayer/speechPhone.hide()
	$phoneBooth/phone.end_call()
	$phoneBooth/CanvasLayer/remainingTime.stop()
	Audio.stop_phone()

func _on_phoneBooth_phone_picked_up():
	phone_picked_up = true
	
func _on_phoneBooth_phone_hung_up():
	phone_picked_up = false
	$CanvasLayer/speechOptions.terminate_choices()
	$CanvasLayer/speechPhone.hide()
	$phoneBooth/CanvasLayer/remainingTime.stop()

var window_overlay = true
func _process(delta):
	if window_overlay: 
		$CanvasLayer/speechOptions.disable_choices(true)

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
	$CanvasLayer/speechPhone.type_texts(["We're sorry. You have reached a number that has been disconnected or is no longer in service. ",
								"If you feel that you have reached this recording in error, please check the number and try your call again. "])
	yield($CanvasLayer/speechPhone, "phone_dialogue_finished")
	Audio.play_phone("hangUpSFX")
	end_phone_call()

func _on_phoneBooth_out_of_time(): # if no more possibility for more coins to be inserted, something special happens
	$CanvasLayer/speechPhone.hide()
	Audio.stop_phone()

func _on_phoneBooth_mobile_clicked_first_time():
	$CanvasLayer/speechSelf.type_texts(["Oh! That's my phone..."])
