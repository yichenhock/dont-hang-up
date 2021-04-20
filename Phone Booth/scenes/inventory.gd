extends Control
var hidden = true
signal change_description(new_text)

func hide_inv(): 
	if hidden == false: 
		$AnimationPlayer.play("hideInv")
		yield($AnimationPlayer,"animation_finished")
		hidden = true

func _on_Area2D_area_entered(area):
	if hidden: 
		emit_signal("change_description","Inventory")
		$AnimationPlayer.play("showInv")
		yield($AnimationPlayer,"animation_finished")
		hidden = false

func _on_Area2D_area_exited(area):
	if !hidden: 
		emit_signal("change_description","")
		$AnimationPlayer.play("hideInv")
		yield($AnimationPlayer,"animation_finished")
		hidden = true
