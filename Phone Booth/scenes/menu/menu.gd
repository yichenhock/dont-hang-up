extends Control
signal enter_pressed()
var offset_amount = Vector2()
var current_screen = "main"

func _ready():
	$main/danglingPhone.position = $main/Title/cableStart.global_position
	$main.visible = true
	$phonebook.visible = false
	$options.visible = false
	$credits.visible = false

func _on_enter_pressed():
	$AnimationPlayer.play("fadeOut")
	yield($AnimationPlayer, "animation_finished")
	emit_signal("enter_pressed")

func _on_phonebook_pressed():
	$main.visible = false
	$phonebook.show()
	current_screen = "phonebook"

func _on_options_pressed():
	$main.visible = false
	$options.show()
	current_screen = "options"

func _on_credits_pressed():
	$main.visible = false
	$credits.show()
	current_screen = "credits"
	
func _on_leave_pressed():
	get_tree().quit()

func _process(delta):
	offset_amount = lerp(offset_amount,(get_global_mouse_position() - Vector2(225,375) )*0.001,2*delta)
	$chromaticAbberation/ColorRect.material.set_shader_param("amount",offset_amount)

func _on_back_pressed():
	get_node(current_screen).hide()
	$main.visible = true

func _on_ig_pressed():
	OS.shell_open("https://www.instagram.com/chen_dll/")

func _on_twt_pressed():
	OS.shell_open("https://twitter.com/chen_dll")

func _on_kofi_pressed():
	OS.shell_open("https://ko-fi.com/chen_dll")