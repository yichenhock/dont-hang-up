extends Control
signal window_closed()

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func _on_back_pressed():
	Audio.play("menuClickSFX")
	visible = false
	emit_signal("exit_window")
