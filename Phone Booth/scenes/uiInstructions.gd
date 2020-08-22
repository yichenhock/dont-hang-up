extends HBoxContainer

func _ready():
	pass # Replace with function body.

func show():
	$uiAnim.play("show")
	$Timer.start(3)
	
func _on_Timer_timeout():
	$uiAnim.play("hide")
