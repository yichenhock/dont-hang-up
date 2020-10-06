extends Control

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func show(): 
	$bookAnim.play("show")
	$back.visible = true

func hide(): 
	$bookAnim.play("hide")


func _on_back_pressed():
	$back.visible = false
