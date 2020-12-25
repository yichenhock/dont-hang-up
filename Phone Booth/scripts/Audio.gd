extends Node

# Called when the node enters the scene tree for the first time.
func _ready():
	pass

func play(sound):
	if sound == "phoneDialSFX": 
		$phoneDialSFX.pitch_scale = rand_range(0.9,1.1)
	elif sound == "metalThudSFX": 
		$metalThudSFX.pitch_scale = rand_range(0.94,1.06)
	get_node(sound).play()

func stop(sound): 
	get_node(sound).stop()
	
func play_bgm(sound): 
	$BGM.get_node(sound).play()
	
func play_phone(sound): #only one plays at a time
	if sound == "phoneDialSFX": 
		$phone/phoneDialSFX.pitch_scale = rand_range(0.8,1.2)
	else: 
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
			
	for node in $BGM.get_children(): 
		if node.get_class() == "AudioStreamPlayer":
			node.stop()

func stepInside():
	$Tween.interpolate_property($rainOutside, "volume_db",0,-50,1,Tween.TRANS_LINEAR,Tween.EASE_IN_OUT)
	$Tween.interpolate_property($rainInside, "volume_db",-50,0,0.6,Tween.TRANS_LINEAR,Tween.EASE_IN_OUT)
	$Tween.start()
	
func stepOutside(): 
	$Tween.interpolate_property($rainInside, "volume_db",0,-50,1,Tween.TRANS_LINEAR,Tween.EASE_IN_OUT)
	$Tween.interpolate_property($rainOutside, "volume_db",-50,0,0.6,Tween.TRANS_LINEAR,Tween.EASE_IN_OUT)
	$Tween.start()
