extends Control
var n = 0
var default_display = ["PT PAYPHONES","TO CALL LIFT HANDSET","PRESS × FOR TEXT SERVICES"]
var display_default = true
var receiving_call = false
var taking_call = false
var time_elapsed = 0

var number_dialled = ""

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
		Audio.play("ringSFX")

func _on_handset_pressed():
	$handsetPicked.visible = true
	$handset.visible = false
	$handset.mouse_filter = Control.MOUSE_FILTER_IGNORE
	$hook.disabled = false
	
	if receiving_call: 
		receiving_call = false
		taking_call = true
		$callTimer.start()
		$display.text = "00:00"
		Audio.stop("ringSFX")
		emit_signal("picked_up","0")
	else: 
		pass # display call prompts
	
func _on_callTimer_timeout():
	time_elapsed += 1
	$display.text =  str(floor(time_elapsed/60)).pad_zeros(2)+":" + str(fmod(time_elapsed,60)).pad_zeros(2)

func _on_hook_pressed():
	# if handset is not dropped... 
	$handsetPicked.visible = false
	$handset.visible = true
	$handset.mouse_filter = Control.MOUSE_FILTER_STOP
	$hook.disabled = true
	emit_signal("hang_up")
	time_elapsed = 0
	if taking_call: 
		$callTimer.stop()
		display_default = true
		$display.text = default_display[n]
		
func shake_handset(): 
	$handsetPicked/handsetAnim.play("shake")
	$handsetPicked/handsetAnim.queue("floating")

func _on_insertCoin_mouse_entered():
	if Data.get_data("coins", 0) != 0:
		if not $insertCoin/coin.visible: 
			$insertCoin/popUp/popUpAnim.play("show")
	
func _on_insertCoin_mouse_exited():
	if $insertCoin/popUp.visible: 
		$insertCoin/popUp/popUpAnim.play("hide")

func _on_insertCoin_gui_input(event):
	if Input.is_action_pressed("right_click"): 
		if Data.get_data("coins", 0) != 0: 
			$insertCoin/coin.visible = true
			$insertCoin/popUp/popUpAnim.play("hide")
	elif Input.is_action_just_pressed("click"):
		if $insertCoin/coin.visible: 
			$insertCoin/coin.visible = false
			emit_signal("coin_inserted")
	
