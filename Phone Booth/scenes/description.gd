extends Control

func set_text(new_text): 
	$Label.text = new_text.to_upper()
	
	var timeout = 1.5 + ceil(new_text.length()/10)
	$Timer.start(timeout)

func _on_Timer_timeout():
	$Label.text = ""
