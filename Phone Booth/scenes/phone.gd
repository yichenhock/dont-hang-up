extends Control
var n = 0
var default_display = ["PT PAYPHONES","TO CALL LIFT HANDSET","PRESS × FOR TEXT SERVICES"]
var display_default = true
var receiving_call = false
var taking_call = false
var time_elapsed = 0
var waiting_for_input = false

var number_dialled = ""
var free_calls = ["999","1808255"]

signal picked_up(number) # if number is "0", that means a call is being recieved from the killer
signal hang_up()
signal coin_inserted()

func _ready():
	$display.text = default_display[n]

func _on_displayTimer_timeout():
	if display_default: 
		n += 1
		if n == len(default_display): 
			n = 0
		$display.text = default_display[n]

func ring_phone(): #someone ringing the phone
	if $handset.visible == true: 
		display_default = false
		receiving_call = true
		$display.text = "RINGING"
		Audio.play_phone("ringSFX")
	
func pick_up(): 
	Audio.play("pickupSFX")
	$handsetPicked.visible = true
	$handset.visible = false
	$handset.mouse_filter = Control.MOUSE_FILTER_IGNORE
	$hook.disabled = false
	display_default = false
	
	if receiving_call: # you only ever recieve a call from the killer
		receiving_call = false
		taking_call = true
		time_elapsed = 0
		$callTimer.start()
		$display.text = "00:00"
		Audio.stop_phone()
		emit_signal("picked_up","0")
	else: 
		$display.text = ""
		waiting_for_input = true
		Audio.play_phone("phoneUnhookedSFX")
	
func _on_callTimer_timeout():
	time_elapsed += 1
	$display.text =  str(floor(time_elapsed/60)).pad_zeros(2)+":" + str(fmod(time_elapsed,60)).pad_zeros(2)

func _on_hook_button_down():
	$display.text = ""
	reset_phone()

func _on_hook_button_up():
	if $handsetPicked.visible: 
		pick_up()
	
func hang_up():
	Audio.play("putdownSFX")
	# if handset is not dropped... 
	$handsetPicked.visible = false
	$handset.visible = true
	$handset.mouse_filter = Control.MOUSE_FILTER_STOP
	$hook.disabled = true
	emit_signal("hang_up")
	reset_phone()

func reset_phone(): 
	time_elapsed = 0
	if taking_call: 
		$callTimer.stop()
	$outgoingCallTimer.stop()
	display_default = true
	$display.text = default_display[n]
	waiting_for_input = false
	taking_call = false 
	Audio.stop_phone()
	
func end_call(): 
	taking_call = false
	$callTimer.stop()
	Audio.play_phone("hangUpSFX")
	$display.text = "CALL ENDED"
	$display/displayAnim.play("flash")
	yield($display/displayAnim,"animation_finished")
	$display.text = ""
	
func shake_handset(): 
	$handsetPicked/handsetAnim.play("shake")
	$handsetPicked/handsetAnim.queue("floating")

func _on_insertCoin_mouse_entered():
	if Data.get_data("coins", 0) != 0:
		if not $insertCoin/coin.visible: 
			$insertCoin/popUp/popUpAnim.play("show")
	
func _on_insertCoin_mouse_exited():
	$insertCoin/popUp/popUpAnim.play("hide")
	$insertCoin.pressed = false

func _on_insertCoin_gui_input(event):
	if Input.is_action_pressed("right_click"): 
		if Data.get_data("coins", 0) != 0: 
			$insertCoin/coin.visible = true
			$insertCoin/popUp/popUpAnim.play("hide")
			Audio.play("coinInsertSFX")
	elif Input.is_action_pressed("click"):
		if $insertCoin/coin.visible: 
			$insertCoin/coin.visible = false
			Audio.play("coinDropSFX")	
			emit_signal("coin_inserted")
	elif Input.is_action_just_released("click") or Input.is_action_just_released("right_click"): 
		$insertCoin.pressed = false
	
func display_no_coins(time_ran_out = false): 
	if time_ran_out: 
		$display.text = "OUT OF COINS"
	else: 
		$display.text = "NO COINS"
	Audio.play_phone("deadlineSFX")
	$callTimer.stop()
	$display/displayAnim.play("flash")
	yield($display/displayAnim,"animation_finished")
	$display.text = ""
	
func _on_outgoingCallTimer_timeout():
	if Data.get_data("remaining_time",0) == 0: 
		if number_dialled in free_calls: 
			start_call()
		else: 
			display_no_coins()
	else: 
		start_call()
		
func start_call(): 
	taking_call = true
	time_elapsed = 0
	$callTimer.start()
	$display.text = "00:00"
	emit_signal("picked_up",number_dialled)
		
func numpad_pressed(number):
	if waiting_for_input: 
		Audio.play_phone("btn"+str(number))
		$display.text = $display.text + str(number)
		if $display.text == "999": 
			initiate_call()
		elif $display.text.length() == 7: 
			initiate_call()

func initiate_call(): 
	waiting_for_input = false
	$display/displayAnim.play("flash")
	yield($display/displayAnim,"animation_finished")
	if $handsetPicked.visible: 
		number_dialled = $display.text
		if $display.text in free_calls: 
			$display.text = "DIALLING\n(FREE CALL)"
		$display.text = "DIALLING"
		$outgoingCallTimer.start()  #take phone call
		Audio.play_phone("diallingSFX")

func _on_key_pressed(): # key collected
	pass 

var coins_in_change_compartment = 0

func _on_returnHandle_pressed():
	print(floor(Data.get_data("remaining_time")/60))
	if floor(Data.get_data("remaining_time")/60) > 1: 
		# return_a_coin()
		Data.set_data("remaining_time", Data.get_data("remaining_time") - 60)
		
		print(Data.get_data("remaining_time"))
	print(floor(Data.get_data("remaining_time")/60)) # Number of coins which can be returned
	pass 




