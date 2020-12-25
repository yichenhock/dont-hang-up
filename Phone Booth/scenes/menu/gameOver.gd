extends Control
var offset_amount = Vector2()

func _process(delta):
	offset_amount = lerp(offset_amount,(get_global_mouse_position() - Vector2(225,375) )*0.003,2*delta)
	$chromaticAbberation/ColorRect.material.set_shader_param("amount",offset_amount)

func _ready():
	pass # Replace with function body.

# When try again pressed, 
# some kinda cool wacky rewind sound
# vhs tape rewind
# eyes shut
# open again
# save meta flag

func glitch_text(): 
	pass
	$main/consoleText
