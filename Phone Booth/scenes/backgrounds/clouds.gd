extends Control
signal clouds_finished() 

# Called when the node enters the scene tree for the first time.
func _ready():
	$ColorRect.visible = false

func _on_clouds_finished():
	emit_signal("clouds_finished")
	$ColorRect/AnimationPlayer.play("fadeIn")

func _on_trees_finished():
	$trees.play()
