extends Node

const SAVE_PATH = "user://main.save"

# save data
var data = {}

# things to be loaded
var files = {}
var phone_dialogues = {}
var number_nodes = {}

const DIALOGUE_PATH = "res://data/files/"

func _ready(): 
	load_files()
	phone_dialogues = format_dialogues()
	
	var num_nodes = phone_dialogues["n0"]["children"] #start node, children contains nodeID for nodes with numbers
	for id in num_nodes: 
		number_nodes [phone_dialogues[id]["#text"]] = id
	
func get_data(key,default = null):
	if data.has(key): 
		return data[key]
	return default
	
func set_data(key,val): 
	data[key] = val
	print(str(key) + ": " + str(val))
	
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
	
func load_files():  
	var file = File.new()
	var dialogue_paths = dir_contents(DIALOGUE_PATH)
	
	for path in dialogue_paths: 
		file.open(DIALOGUE_PATH+path,file.READ)
		var text = file.get_as_text()
		data = parse_json(text)
		path = path.trim_suffix(".json")
		files[path] = data
		file.close()
	
func format_dialogues(): 
	var dialogue_data = files["phone_dialogues"]["graphml"]["graph"]
	var edges = dialogue_data["edge"]
	var nodes = dialogue_data["node"]
	var node_dict = {}
	
	for node in nodes: 
		node_dict[node["@id"]] = node["data"]
	
	for edge in edges: 
		if node_dict[edge["@source"]].has("children"):
			node_dict[edge["@source"]]["children"].append(edge["@target"])
		else: 
			node_dict[edge["@source"]]["children"] = [edge["@target"]]
	return node_dict

