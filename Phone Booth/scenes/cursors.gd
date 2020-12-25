extends Control
var item_equipped = null

func _ready():
	pass # Replace with function body.

func _process(delta):
	if item_equipped != null: 
		if get_tree().paused == true: 
			Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
			for cursor in get_children(): 
				cursor.visible = false
		else: 
			Input.set_mouse_mode(Input.MOUSE_MODE_HIDDEN)
			get_node(str(item_equipped)+"Cursor").visible = true
			get_node(str(item_equipped)+"Cursor").position = get_global_mouse_position()
	else: 
		Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
		for cursor in get_children(): 
			cursor.visible = false
