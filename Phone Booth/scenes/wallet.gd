extends Control
var current_screen = "wallet"
signal window_closed()
signal coin_collected()

# Called when the node enters the scene tree for the first time.
func _ready():
	pass

func _on_back_pressed():
	Audio.play("menuClickSFX")
	if current_screen == "wallet": 
		visible = false
		emit_signal("window_closed")
	else: 
		get_node(current_screen).visible = false
		$wallet.visible = true
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

func collect_coin():
	emit_signal("coin_collected")
