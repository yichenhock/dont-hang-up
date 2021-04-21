extends Control
signal enter_pressed()
var offset_amount = Vector2()
var current_screen = "main"

func _ready():
	visible = true
	modulate = Color(1.0,1.0,1.0,1.0)
	Audio.play_bgm("menuBGM")
	$main/danglingPhone.position = $main/Title/cableStart.global_position
	$main.visible = true
	for i in $CanvasLayer.get_children():
		i.visible = false
		
func _on_enter_pressed():
	$AnimationPlayer.play("fadeOut")
	yield($AnimationPlayer, "animation_finished")
	Audio.stop_bgm("menuBGM")
	emit_signal("enter_pressed")
	queue_free()

func _on_options_pressed():
	$main.visible = false
	$CanvasLayer/options.show()
	current_screen = "options"

func _on_credits_pressed():
	$main.visible = false
	$CanvasLayer/credits.show()
	current_screen = "credits"
	
func _on_leave_pressed():
	get_tree().quit()

func _process(delta):
	offset_amount = lerp(offset_amount,(get_global_mouse_position() - Vector2(225,375) )*0.001,2*delta)
	$chromaticAbberation/ColorRect.material.set_shader_param("amount",offset_amount)

func _on_back_pressed():
	get_node("CanvasLayer/"+current_screen).hide()
	$main.visible = true
