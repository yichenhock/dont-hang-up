extends TextureRect

var left = Vector2(82,126)
var right = Vector2(114,114)

func _ready():
	pass # Replace with function body.

func _on_Timer_timeout():
	update_position()

func update_position(): 
	$leftEye.rect_position = left + Vector2(rand_range(-0.6,0.6),rand_range(-0.6,0.6))
	$rightEye.rect_position = right + Vector2(rand_range(-0.6,0.6),rand_range(-0.6,0.6))
	
