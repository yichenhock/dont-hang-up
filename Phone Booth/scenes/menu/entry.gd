extends HBoxContainer
var number = "" setget set_number
var details = "" setget set_details

func set_details(new_detail): 
	details = new_detail
	$details.text = details
	
func set_number(new_number): 
	number = new_number
	if number.length() > 3: 
		number = number.insert(3,"-")
	$number.text = number
	
func _ready():
	pass # Replace with function body.
