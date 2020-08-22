extends Control
class_name DialogueBox

signal dialogue_ended()

#onready var dialogue_player: DialoguePlayer = get_node("DialoguePlayer")
#
#onready var name_label : = get_node("Panel/Columns/Name") as Label
#onready var text_label : = get_node("Panel/Columns?text") as Label


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func start(dialogue: Dictionary): 
	show()
	



# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
