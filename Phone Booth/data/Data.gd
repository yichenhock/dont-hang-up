extends Node

const SAVE_PATH = "user://main.save"

# save data
var data = {}

# things to be loaded
var dialogues = {}
const DIALOGUE_PATH = "res://data/dialogues/"

func get_data(key,default = null):
	if data.has(key): 
		return data[key]
	return default
	
func set_data(key,val): 
	data[key] = val
	
func save_data(): 
	var save_file = File.new()
	save_file.open(SAVE_PATH, File.WRITE)
	save_file.store_string(to_json(data))
	save_file.close()
		
func load_default_data(): 
	data = {}
#	data.SAVE_VERSION = SAVE_VERSION
#	data.zone_completed = []
#	data.zones_unlocked = [0]
#	data.zones_just_unlocked = []

#	var file = File.new()
#
#	if not file.file_exists(path): 
#		reset_data() 
#		return
#
#	file.open(path,file.READ)
#
#	var text = file.get_as_text()
#
#	data = parse_json(text)
#
#	file.close()
	
func dir_contents(path):
	var files = []
	var dir = Directory.new()
	if dir.open(path) == OK:
		dir.list_dir_begin()
		var file_name = dir.get_next()
		while file_name != "":
			if dir.current_is_dir():
				print("Found directory: " + file_name)
			else:
				print("Found file: " + file_name)
				files.append(file_name)
				
			file_name = dir.get_next()
	else:
		print("An error occurred when trying to access the path.")
	return files
	
func load_dialogues():  
	var file = File.new()
	var dialogue_paths = dir_contents(DIALOGUE_PATH)
	
	for path in dialogue_paths: 
		file.open(DIALOGUE_PATH+path,file.READ)
		var text = file.get_as_text()
		data = parse_json(text)
		path = path.trim_suffix(".json")
		dialogues[path] = data
		file.close()
	
func _ready(): 
	load_dialogues()

