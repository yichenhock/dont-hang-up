extends Node
signal end_of_conversation()

var reply_on_timeout = "Hello...?"
var type = null # speech, choice, flag, reply on timeout, number
var types = {	"#CCFFCC":"speech", 
				"#99CCFF":"choice",
				"#FF99CC":"reply_on_timeout",
				"#CC99FF":"flag"}
var choices = {}
var speech_text = null
var nodeID_speech = null

func initialise_default(): 
	reply_on_timeout = "Hello...?"
	type = null

func identify_next_node(nodeID): 
	if Data.phone_dialogues[nodeID].has("children") == false: 
		type = null
	else: 
		choices = {}
		for nID in Data.phone_dialogues[nodeID]["children"]: 
			if types[Data.phone_dialogues[nID]["@color"]] == "reply_on_timeout": 
				reply_on_timeout = Data.phone_dialogues[nID]["#text"]
			else: 
				type = types[Data.phone_dialogues[nID]["@color"]]
				if type == "choice": 
					choices[nID] = Data.phone_dialogues[nID]["#text"]
				elif type == "speech": 
					speech_text = Data.phone_dialogues[nID]["#text"]
					nodeID_speech = nID

func format_dialogue(dialogue): # detect some special stuff in the dialogue and reformat it
	var regex = RegEx.new()
	regex.compile("\\d+")
	if "[" in dialogue and "]" in dialogue: 
		print("list detected")
	var formatted_dialogue = ""
	#return formatted_dialogue
	return dialogue
