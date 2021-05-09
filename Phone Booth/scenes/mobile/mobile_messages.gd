extends Control
signal change_textlogs(sender_name)

func _ready():
	print(Data.text_log_nodes.keys())
	
	for k in Data.text_log_nodes.keys(): 
		var message_preview = $ResourcePreloader.get_resource("messagePreview").instance()
		$ScrollContainer/VBoxContainer.add_child(message_preview)
		message_preview.sender_name = k
		message_preview.connect("message_selected",self,"change_msg_destination")

func change_msg_destination(sender_name): 
	emit_signal("change_textlogs",sender_name)
