extends Control
signal change_destination(next_screen)

func _ready():
	for c in $GridContainer.get_children(): 
		c.connect("icon_selected",self,"change_description")

func change_description(new_text): 
	$description.text = new_text
	emit_signal("change_destination",new_text.to_lower())
