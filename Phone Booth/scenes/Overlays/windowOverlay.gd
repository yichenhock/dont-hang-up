extends Control
signal window_closed()

func _ready():
	pass 

func _on_back_pressed():
	Audio.play("menuClickSFX")
	visible = false
	emit_signal("window_closed")
	queue_free()
