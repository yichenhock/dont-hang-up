extends Control

func show(): 
	visible = true

func hide(): 
	visible = false

func _input(event): 
	if event.is_action_pressed("toggle_fullscreen"):
		$notepad/fullscreenCheck.pressed = !OS.window_fullscreen

func _on_fullscreenCheck_pressed():
	OS.window_fullscreen = $notepad/fullscreenCheck.is_pressed()

func _on_clearData_pressed():
	pass # Replace with function body.

func _on_volSlider_value_changed(value):
	AudioServer.set_bus_volume_db(AudioServer.get_bus_index("Master"), linear2db(value))
	Data.set_data("volume",value)

func _on_back_pressed():
	hide()
