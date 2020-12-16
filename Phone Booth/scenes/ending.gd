extends Control

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func _on_clouds_clouds_finished():
	$booth/ColorRect/AnimationPlayer.play("fadeIn")
