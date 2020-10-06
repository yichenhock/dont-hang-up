tool
extends TextureButton
export(String) var option_text setget set_text

# Called when the node enters the scene tree for the first time.
func _ready():
	$option.visible = true

func set_text(new_text):
	option_text = new_text
	$option.text = option_text

func _on_menuOption_mouse_entered():
	$optionAnim.play("flash")
	Audio.play("menuClickSFX")
	grab_focus()

func _on_menuOption_mouse_exited():
	$optionAnim.stop()
	$option.visible = true
	release_focus()
