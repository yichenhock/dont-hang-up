extends Control
var first_instruct = true

func _ready():
	set_visibility(first_instruct)
	
func set_visibility(state):
	$VBox/leftClick.visible = state
	$VBox/interact.visible = state
	$VBox/zBtn.visible = state
	$VBox/zoomIn.visible = state
	$VBox/xBtn.visible = !state
	$VBox/pressHold.visible = !state

func show():
	$VBox/uiAnim.play("show")
	$VBox/Timer.start(8)
	
func _on_Timer_timeout():
	$VBox/uiAnim.play_backwards("show")
	yield($VBox/uiAnim,"animation_finished")
	if first_instruct: 
		first_instruct = false
		set_visibility(first_instruct)
		show()
