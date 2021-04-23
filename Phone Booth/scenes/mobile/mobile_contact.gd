tool
extends Label
export(String) var contact_name = "" setget set_contact_name
export(String) var contact_number = ""
export(String) var number_description = ""

func _ready():
	$numberClue.number = contact_number
	$numberClue.description = number_description
	$numberClue.visible = false
	contract()
	
func _on_TextureButton_focus_entered():
	expand()
	$numberClue._on_numberClue_pressed()

func _on_TextureButton_focus_exited():
	contract()

func set_contact_name(new_name): 
	contact_name = new_name
	text = " " + contact_name

func expand():
	$ColorRect.color = Color(0.25,0.25,0.46,1.0)
	text = " " + contact_name + "\n   " + contact_number
	$mobileIcon.visible = true
	
func contract():
	$ColorRect.color = Color(0.20,0.20,0.20,1.0)
	text = " " + contact_name
	$mobileIcon.visible = false
