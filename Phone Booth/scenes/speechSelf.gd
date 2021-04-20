tool
extends Control
signal line_finished() 
signal self_dialogue_finished()

var dialogue = []
var n = 0
var typing_text = false
export var delay = 0.05 setget set_delay

export(String) var blip_sfx = "" setget set_blip_sfx

func _ready():
	$speechBubble/indicator.visible = false
	hide()

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
	
	if Input.is_action_pressed("click"): 
		if not clicked: 
			clicked = true
			if dialogue.size() != 0 and not typing_text: 
				n+=1
				if n == dialogue.size(): 
					dialogue = []
					n = 0
					emit_signal("self_dialogue_finished")
					hide()
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
#		$speechBubble.rect_size.y = 45 + fmod($dialogue.text.length(),32)*font_height
#		if $dialogue.text.length() < 33: 
#			$speechBubble.rect_size.x = $dialogue.text.length() * 10.5 + 22.0
#		else: 
#			$speechBubble.rect_size.x = 33 * 10.5 + 22.0
	else: 
		set_speech_size($dialogue.visible_characters,font_height)
#		$speechBubble.rect_size.x = $dialogue.visible_characters * 10.5 + 22.0

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
