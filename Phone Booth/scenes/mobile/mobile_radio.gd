extends Control
var radio_channel

# Called when the node enters the scene tree for the first time.
func _ready():
	radio_channel = $HSlider.value
	update_channel()


func update_channel():
	$channel.text=str(radio_channel).pad_decimals(1)+" MHz"

func _on_HSlider_value_changed(value):
	radio_channel = value
	update_channel()
	
func _on_volSlider_value_changed(value):
	AudioServer.set_bus_volume_db(AudioServer.get_bus_index("Master"), linear2db(value))
	Data.set_data("volume",value)

func _on_play_toggled(button_pressed):
	$play/play.visible = !button_pressed
	$play/stop.visible = button_pressed
