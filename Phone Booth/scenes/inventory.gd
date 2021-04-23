extends Control
var hidden = true

func _process(delta): 
	if $Area2D.monitoring != visible: 
		$Area2D.monitoring = visible

func hide_inv(): 
	if hidden == false: 
		$AnimationPlayer.play("hideInv")
		yield($AnimationPlayer,"animation_finished")
		hidden = true

func _on_Area2D_area_entered(area):
	if hidden: 
		Data.set_data("description","Inventory")
		$holder.material.set_shader_param("outline",true)
		$AnimationPlayer.play("showInv")
		yield($AnimationPlayer,"animation_finished")
		hidden = false

func _on_Area2D_area_exited(area):
	if !hidden: 
		Data.set_data("description","")
		emit_signal("change_description","")
		$holder.material.set_shader_param("outline",false)
		$AnimationPlayer.play("hideInv")
		yield($AnimationPlayer,"animation_finished")
		hidden = true
