extends Node
var current_scene = null

var states = ["menu", "playing", "paused", "ending"]
var current_state = "menu"

func _ready():
#	change_state("phoneBooth")
	AudioServer.set_bus_volume_db(AudioServer.get_bus_index("Master"), linear2db(Data.get_data("volume",0.8)))
	Audio.play("rainOutside")
	Audio.play("rainInside")
	
	$CanvasLayer/menu.visible = true
	$CanvasLayer/pauseMenu.visible = false
	$CanvasLayer/menu.modulate = Color(1.0,1.0,1.0,1.0)
	
	$phoneBooth.set_process_input(false)
	$phoneBooth.set_interaction(false)

func open_eyes(): 
	pass
	

func add_scene(new_scene): 
	add_child($Scenes.get_resource(new_scene).instance())

#func change_state(new_scene_name):
#	remove_child(current_scene)
#	current_scene = $Scenes.get_resource(new_scene_name).instance()
#	add_child(current_scene)
#	#current_scene.connect("change_state",self,"change_state")
	
func _unhandled_input(event):
	if event.is_action_pressed("fullscreen_toggle"): 
		OS.window_fullscreen = !OS.window_fullscreen
		
	if event.is_action_pressed("ui_cancel"): 
		if $CanvasLayer/menu.visible == false: 
			get_tree().paused = true
			$CanvasLayer/pauseMenu.visible = true

func _on_menu_enter_pressed():
	first_speech()
	$phoneBooth.set_interaction(true)

func first_speech(): # the "talking to self" speech the player does upon starting the game
	var dialogue = Data.files["self_dialogues"]["001"]
	$CanvasLayer/speechSelf.type_texts(dialogue)
	
func _on_speechSelf_self_dialogue_finished():
	$phoneBooth.zoom_enabled = true
	$phoneBooth.initialise()
