extends Control

# Called when the node enters the scene tree for the first time.
func _ready():
	pass

func _process(delta): 
	if Input.is_action_pressed("ui_accept"):
		play()
	
func play(): 
	Audio.play_bgm("endingBGM")
	$clouds/ColorRect.visible = false
	$clouds/clouds.play()
	$sunrise.play("sunrise")
	
func _on_trees_finished():
	$clouds/trees.play()

func _on_clouds_finished():
	$clouds/ColorRect/AnimationPlayer.play("fadeIn")
	$booth/ColorRect/AnimationPlayer.play("fadeIn")
