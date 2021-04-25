extends Control
var all_logs
	
func display_message(sender):
	$sender.text = sender
	all_logs = Data.files["text_logs"]
	
	if $ScrollContainer/VBoxContainer.get_child_count() > 0:
		for c in $ScrollContainer/VBoxContainer.get_children(): 
			c.queue_free()
			
	#use resource preloader to add stuff
	
	#also scroll to the bottom??
