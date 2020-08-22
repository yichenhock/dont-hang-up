extends TextureButton

var open = false

func _ready():
	set_lid_state()

func _on_changeLid_pressed():
	open = !open
	set_lid_state()
	
func set_lid_state(): 
	$lidClose.visible = !open
	$lidOpen.visible = open
	if open: 
		mouse_filter = Control.MOUSE_FILTER_PASS
	else: 
		mouse_filter = Control.MOUSE_FILTER_STOP
		
	
	
