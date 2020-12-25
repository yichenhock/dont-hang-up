extends Control

var remaining_time = 0
signal timeout()

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func add_time(): 
	remaining_time +=60
	$time.text =  str(floor(remaining_time/60)).pad_zeros(2)+":" + str(fmod(remaining_time,60)).pad_zeros(2)
	Data.set_data("remaining_time", remaining_time)
	$timeAnim.play("increment")
	
func decrement_time(): 
	remaining_time -=60
	$time.text =  str(floor(remaining_time/60)).pad_zeros(2)+":" + str(fmod(remaining_time,60)).pad_zeros(2)
	Data.set_data("remaining_time", remaining_time)
	$timeAnim.play("red")
	
func start(): 
	$time.add_color_override("font_color",Color("d0cc89"))
	$Timer.start()
	$hourglassAnim.play("time")
	
func stop(): 
	$time.add_color_override("font_color",Color("efffe9"))
	$Timer.stop()
	$hourglassAnim.stop()

func _on_Timer_timeout():
	remaining_time -= 1
	Data.set_data("remaining_time", remaining_time)
	$time.text =  str(floor(remaining_time/60)).pad_zeros(2)+":" + str(fmod(remaining_time,60)).pad_zeros(2)
	if remaining_time == 0: 
#		$time.add_color_override("font_color",Color("efffe9"))
		$Timer.stop()
		$timeAnim.play("flash")
		emit_signal("timeout")
	
