tool
extends Control
signal line_finished() 
signal self_dialogue_finished()
signal fade_in_request(rest_of_text)

var dialogue = []
var n = 0
var typing_text = false
export var delay = 0.05 setget set_delay

export(String) var blip_sfx = "" setget set_blip_sfx

var indicator_up = false

func _ready():
	$speechBubble/indicator.visible = false
	
	var indicator_position_y = $speechBubble.rect_global_position.y + $speechBubble.rect_size.y - 19
	$speechBubble/Tween.interpolate_property($speechBubble/indicator,"rect_global_position:y",indicator_position_y,indicator_position_y+4,0.2,Tween.TRANS_LINEAR,Tween.EASE_IN_OUT)
	$speechBubble/Tween.start()
	hide()

func _on_Tween_tween_completed(object, key):
	var indicator_position_y = $speechBubble.rect_global_position.y + $speechBubble.rect_size.y - 19
	if indicator_up: 
		$speechBubble/Tween.interpolate_property($speechBubble/indicator,"rect_global_position:y",indicator_position_y+4,indicator_position_y,0.2,Tween.TRANS_LINEAR,Tween.EASE_IN_OUT)
	else:
		$speechBubble/Tween.interpolate_property($speechBubble/indicator,"rect_global_position:y",indicator_position_y,indicator_position_y+4,0.2,Tween.TRANS_LINEAR,Tween.EASE_IN_OUT)
	indicator_up=!indicator_up

func hide(): 
	visible = false

func show(): 
	visible = true

func type_texts(texts: PoolStringArray): 
	dialogue = texts
	n = 0
	type_text(dialogue[n])

var clicked = false

func _process(delta): 
	$speechBubble/indicator.rect_position.x = $speechBubble.rect_position.x + $speechBubble.rect_size.x - 50
	#$speechBubble/indicator.rect_position.y = 26
	
	if Input.is_action_just_pressed("click"): 
		if not clicked: 
			clicked = true
			if dialogue.size() != 0 and not typing_text: 
				n+=1
				if n == dialogue.size(): 
					dialogue = []
					emit_signal("self_dialogue_finished")
					hide()
				elif dialogue[n]=="[fade_in]": 
					var remaining_texts = []
					for i in range(n+1,dialogue.size()):
						remaining_texts.push_back(dialogue[i])
					emit_signal("fade_in_request",remaining_texts)
					hide()
					dialogue = []
				else: 
					type_text(dialogue[n])
			elif typing_text: 
				$dialogue.display_all()
				
	if Input.is_action_just_released("click"): 
		clicked = false

func type_text(new_text): 
	if new_text != "": 
		$speechBubble/indicator.visible = false
		visible = true
		$dialogue.type_text(new_text)
		typing_text = true

func set_blip_sfx(new_sfx): 
	blip_sfx = new_sfx
	$dialogue.blip_sfx = blip_sfx
	
func set_delay(new_delay): 
	delay = new_delay
	$dialogue.delay = delay

func resize_speech(): 
	var font = $dialogue.get_font("normal_font")
	var font_height = font.get_height() + font.get_spacing(0)
	
	if $dialogue.visible_characters== -1: 
		set_speech_size($dialogue.text.length(),font_height)
	else: 
		set_speech_size($dialogue.visible_characters,font_height)

func set_speech_size(char_displayed, font_height): 
	$speechBubble.rect_size.y = 45 + floor(char_displayed/36)*font_height
	if char_displayed < 36: 
		$speechBubble.rect_size.x = char_displayed * 11 + 22.0
	else: 
		$speechBubble.rect_size.x = 36 * 10.5 + 22.0
		
	$speechBubble.rect_global_position.y = 700 - $speechBubble.rect_size.y
	$dialogue.rect_global_position = $speechBubble.rect_global_position + Vector2(6,1)

func _on_dialogue_character_displayed():
	resize_speech()

func _on_dialogue_fully_displayed():
	typing_text = false
	$speechBubble/indicator.visible = true
	emit_signal("line_finished")
