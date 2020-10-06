extends Control

var locked = true
var opened = false

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func _on_Area2D_input_event(viewport, event, shape_idx):
	if Input.is_action_pressed("click"): 
		if not locked: 
			if opened: 
				$metaldoorAnim.play("open")
				opened = false
			else: 
				$metaldoorAnim.play("close")
