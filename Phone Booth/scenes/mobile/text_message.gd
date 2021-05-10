extends Control
export(bool) var is_left_message = true # recieved message
export(String) var message = "" setget set_message

var max_width = 140

func set_message(new_message): 
	message = new_message
	$Label.text = message
	set_bubble_size()
	
func set_bubble_size(): 
	
	$Label/bubbleL.visible = is_left_message
	$Label/bubbleL.rect_size.x = max_width
	$Label/bubbleL.rect_position.x=-8
	
	$Label.align = Label.ALIGN_LEFT
	
	$Label/bubbleR.visible = !is_left_message
	$Label/bubbleR.rect_size.x = max_width
	$Label/bubbleR.rect_position.x = -5
	
	if !is_left_message:
		$Label.rect_position.x += 20
		$Label.rect_size.x -= 12
		$Label/bubbleR.margin_left = -12
		$Label/bubbleR.margin_right = -10
		#$Label/bubbleR.rect_position.x = -5
	
	rect_min_size.y = 20 + 15*($Label.get_line_count()-1)
	
	if $Label.get_line_count() == 1: 
		if is_left_message:
			$Label/bubbleL.rect_size.x = min(10 + ceil(message.length()*8),max_width-12)
			#$Label/bubbleL.rect_size.x = 10 + ceil(message.length()*8)
		elif !is_left_message:
			$Label.align = Label.ALIGN_RIGHT
			$Label/bubbleR.rect_size.x = min(10 + ceil(message.length()*8),max_width-12)
			#$Label/bubbleR.rect_size.x = 10 + ceil(message.length()*8)
	
	$Label/bubbleR.rect_position.x = max_width - $Label/bubbleR.rect_size.x - 12
