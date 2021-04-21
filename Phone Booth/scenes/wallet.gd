extends Control
var current_screen = "wallet"
signal window_closed()
signal coin_collected()
	
func _on_back_pressed():
	Audio.play("menuClickSFX")
	if current_screen == "wallet": 
		visible = false
		emit_signal("window_closed")
		get_tree().paused = false
		queue_free()
	else: 
		get_node(current_screen).visible = false
		$wallet.visible = true
		$ui/flip.visible = false
		$ui/flip.visible = false
		current_screen = "wallet"

func _on_flip_pressed():
	Audio.play("menuClickSFX")
	get_node(current_screen).get_node("front").visible = !get_node(current_screen).get_node("front").visible
	get_node(current_screen).get_node("back").visible = !get_node(current_screen).get_node("front").visible
		
func item_pressed(next_screen):
	get_node(current_screen).visible = false
	current_screen = next_screen
	get_node(current_screen).visible = true
	if current_screen != "wallet" and current_screen != "banknote":
		$ui/flip.visible = true
		get_node(current_screen).get_node("front").visible = true
		get_node(current_screen).get_node("back").visible = false
	
	if current_screen == "idCard":
		if Data.get_data("discovered_self",false)==false:
			Data.set_data("description","Oh, that's me... guess the wallet and phone are mine too then")
			Data.set_data("discovered_self",true)
		
func collect_coin():
	emit_signal("coin_collected")
