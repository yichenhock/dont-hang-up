extends Control
signal pressed(nodeID)
signal timeout()
var time_limit = 10


# Called when the node enters the scene tree for the first time.
func _ready():
	pass
	show_options("n1","I don't know what you mean","n2","Are you talking about that one time you killed an octopus?")
	
func show_options(n1_id, n1_text,n2_id="", n2_text=""): 
	$choices/choice1.nodeID = n1_id
	$choices/choice1.choice_text = n1_text
	$choices/choice2.nodeID = n2_id
	$choices/choice2.choice_text = n2_text
	$barAnim.play("show")
	yield($barAnim,"animation_finished")
	$choices/choice1.show()
	yield($choices/choice1/choiceAnim,"animation_finished")
	if n2_id != "": 
		$choices/choice2.show()
		yield($choices/choice2/choiceAnim,"animation_finished")
		
	$Tween.interpolate_property($timeLimit, "value", 100,0,time_limit,Tween.TRANS_LINEAR,Tween.EASE_IN_OUT)
	$Tween.interpolate_property($timeLimit, "tint_progress", Color("efffe9"),Color("ff1400"),time_limit,Tween.TRANS_LINEAR,Tween.EASE_IN_OUT)
	$Timer.start(time_limit)
	$Tween.start()

func _on_Timer_timeout():
	hide_options()
	
func hide_options(): 
	$choices/choice2.hide()
	yield($choices/choice2/choiceAnim,"animation_finished")
	$choices/choice1.hide()
	yield($choices/choice1/choiceAnim,"animation_finished")
	$barAnim.play("hide")
	
func _on_choice2_option_chosen(nodeID):
	emit_signal("pressed",nodeID)
	print(nodeID)
	hide_options()

func _on_choice1_option_chosen(nodeID):
	emit_signal("pressed",nodeID)
	print(nodeID)
	hide_options()


