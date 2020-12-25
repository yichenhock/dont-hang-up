extends Control

# Called when the node enters the scene tree for the first time.
func _ready():
	Audio.play_bgm("endingBGM")

func _on_clouds_clouds_finished():
	$booth/ColorRect/AnimationPlayer.play("fadeIn")
