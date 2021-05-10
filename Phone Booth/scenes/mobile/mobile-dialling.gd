extends Control
signal empty_dialling_screen()

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func clear(): 
	var s = $ScrollContainer/numberEntry.text
	s.erase(s.length() - 1, 1)
	if s.length() == 0:
		emit_signal("empty_dialling_screen")
	else: 
		$ScrollContainer/numberEntry.text = s
