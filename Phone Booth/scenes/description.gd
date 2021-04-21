extends Control

func set_text(new_text): 
	$Label.text = new_text.to_upper()
	
	var timeout = 1.5 + ceil(new_text.length()/10)
	$Timer.start(timeout)

func _on_Timer_timeout():
	$Label.text = ""

func _process(delta):
	if Data.get_data("description",null) != null: 
		set_text(Data.get_data("description",null))
		Data.set_data("description",null)
