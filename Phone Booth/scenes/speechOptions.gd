extends Control
signal pressed(nodeID)
signal timeout()
var time_limit = 15
var options = []

# dictionary of choices - get this from data!
var choices = 	{"n1": "I don't know what you mean", 
				"n2": "Are you talking about that one time you killed an octopus?", 
				"n3": "Oh ma lord..."} 

# Called when the node enters the scene tree for the first time.
func _ready():
	pass
	# show_options(choices)
	
func show_options(choices): 
	show_time_limit()
	start_time_limit(time_limit)
	for nodeID in choices: 
		var choice_text = choices[nodeID]
		if options.size() > 0: 
			yield(options[-1], "animation_finished")
		options.append($options.get_resource("choice").instance())
		$choices.add_child(options[-1])
		$choices.move_child(options[-1],0)
		options[-1].nodeID = nodeID
		options[-1].show()
		options[-1].choice_text = choice_text
		options[-1].connect("option_chosen",self,"on_option_chosen")
	
func on_option_chosen(nodeID): 
	print(nodeID + ": " + choices[nodeID])
	hide_options()
	emit_signal("pressed", nodeID)
	
func show_time_limit(): 
	$barAnim.play("show")
	yield($barAnim,"animation_finished")
	
func start_time_limit(time_limit): 
	$Tween.interpolate_property($timeLimit, "value", 100,0,time_limit,Tween.TRANS_LINEAR,Tween.EASE_IN_OUT)
	$Tween.interpolate_property($timeLimit, "tint_progress", Color("efffe9"),Color("ff1400"),time_limit,Tween.TRANS_LINEAR,Tween.EASE_IN_OUT)
	$Timer.start(time_limit)
	$Tween.start()

func _on_Timer_timeout():
	hide_options()
	emit_signal("pressed", null) # nothing pressed, time has run out
	
func hide_options(): 
	options.invert()
	for option in options: 
		option.hide()
		yield(option, "animation_finished")
		$choices.remove_child(option)
	$barAnim.play("hide")
	yield($barAnim,"animation_finished")
