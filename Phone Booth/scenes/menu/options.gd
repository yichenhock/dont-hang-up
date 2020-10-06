extends Control

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func show(): 
	$bookAnim.play("show")
	$back.visible = true

func hide(): 
	$bookAnim.play("hide")

func _on_fullscreenCheck_pressed():
	OS.window_fullscreen = $book/table/fullscreenCheck.is_pressed()


func _on_clearData_pressed():
	pass # Replace with function body.

func _on_volSlider_value_changed(value):
	AudioServer.set_bus_volume_db(AudioServer.get_bus_index("Master"), linear2db(value))
	Data.set_data("volume",value)

func _on_back_pressed():
	$back.visible = false
