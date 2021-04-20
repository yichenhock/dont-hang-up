extends Control
signal window_closed()

func _ready():
	initialise()

func initialise(): 
	visible = true
	$ColorRect/page1.visible = true
	$ColorRect/page2.visible = false
	$ColorRect/next/Label.text = "NEXT"

func _on_next_pressed():
	if $ColorRect/next/Label.text == "NEXT": 
		$ColorRect/page1.visible = false
		$ColorRect/page2.visible = true
		$ColorRect/next/Label.text = "OK"
	else: 
		emit_signal("window_closed")
		queue_free()
