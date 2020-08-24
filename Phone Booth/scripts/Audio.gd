extends Node

# Called when the node enters the scene tree for the first time.
func _ready():
	pass

func play(sound):
	get_node(sound).play()

func stop(sound): 
	get_node(sound).stop()
	
func play_phone(sound): #only one plays at a time
	stop_phone()
	$phone.get_node(sound).play()

func stop_phone(): 
	for node in $phone.get_children():
		if node.get_class() == "AudioStreamPlayer":
			node.stop()
	
func pause(sound): 
	get_node(sound).stream_paused = true

func unpause(sound): 
	get_node(sound).stream_paused = false
	
func stop_all(): 
	for node in get_children(): 
		if node.get_class() == "AudioStreamPlayer":
			node.stop()
			
	for node in $phone.get_children(): 
		if node.get_class() == "AudioStreamPlayer":
			node.stop()

func rain(): 
	pass
