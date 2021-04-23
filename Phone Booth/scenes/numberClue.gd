extends TextureButton
export(String) var number
export(String) var description

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func _on_numberClue_pressed():
	if not number in Data.get_data("numbers_discovered",[]): 
		if Data.get_data("first_number_clue",false) == false:
			Data.set_data("first_number_clue",true)
			Data.set_data("description","It's a number I can call...")
			$Timer.start()
		else:
			Data.set_data("description",description)
		Data.append_data_array("numbers_discovered",number) 
		Data.append_data_array("numbers_to_add",number)
		Audio.play_writingSFX()
		$CanvasLayer.add_child($ResourcePreloader.get_resource("number").instance())
		$CanvasLayer/number.text = str(number)
		$Tween.interpolate_property($CanvasLayer/number,"rect_global_position",rect_global_position,Vector2(390,45),1.2,Tween.TRANS_LINEAR,Tween.EASE_IN_OUT)
		$Tween.interpolate_property($CanvasLayer/number,"modulate",Color(1.0,1.0,1.0,1.0),Color(1.0,1.0,1.0,0.0),1.2,Tween.TRANS_LINEAR,Tween.EASE_IN_OUT)
		$Tween.start()
		disabled = true
		visible = false
		yield($Tween,"tween_completed")
		$CanvasLayer/number.queue_free()
		Data.set_data("new_info_in_notepad",true)
	else: 
		print("number already discovered")

func _on_Timer_timeout():
	Data.set_data("description",description)
