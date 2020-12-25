extends Control
var amount = 0

# Called when the node enters the scene tree for the first time.
func _ready():
	$amount.text = str(amount)



func increment(): 
	amount += 1
	$amount.text = str(amount)
	$coinAnim.play("spin")
	$textAnim.play("increment")
		
func decrement(): 
	amount -= 1
	$amount.text = str(amount)
	$coinAnim.play("spin")
	
