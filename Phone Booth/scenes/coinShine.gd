extends TextureButton

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


func _on_coin_mouse_entered():
	$coinAnim.play("shine")


func _on_coin_pressed():
	visible = false
	# play some coin sound?
