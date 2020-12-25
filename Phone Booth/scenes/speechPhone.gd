tool
extends Control
signal line_finished() 
signal line_started() 
signal phone_dialogue_finished()

var dialogue = []
var n = 0
var typing_text = false
var resizing = false
var showing = false
var hiding = false

var speech_pos = Vector2(0,0)

#export var delay = 0.03 setget set_delay
export(String) var blip_sfx = "" setget set_blip_sfx

func _ready():
	if not Engine.editor_hint: 
		visible = false
	#type_texts(["thank you very much im actually really thankful for how much you have you know done for me and i believe in a ","different universe maybe you would be a better person, idk"])

func hide(): 
	visible = false
	$Tween.interpolate_property(self, "rect_scale", Vector2(1,1), Vector2(0,0),0.2, Tween.TRANS_LINEAR,Tween.EASE_IN_OUT)
	$Tween.start()
	# yield($Tween,"tween_completed")
	
func show(): 
	if not visible: 
		visible = true
		rect_scale.x = 0
		rect_scale.y = 0
		$Tween.interpolate_property(self, "rect_scale", Vector2(0,0), Vector2(1,1),0.2, Tween.TRANS_LINEAR,Tween.EASE_IN_OUT)
		$Tween.start()

#func resize(): 
#	$dialogue.rect_size.y = $dialogue.get_content_height()
#	$dialogue.rect_position = speech_pos + Vector2(-$dialogue/speechBubble.margin_left,-$dialogue.rect_size.y-$dialogue/speechBubble.margin_bottom)

func type_texts(texts: PoolStringArray): 
	dialogue = texts
	n = 0
	type_text(dialogue[n])

var clicked = false

func _process(delta): 
	if Input.is_action_pressed("click"): 
		if not clicked: 
			clicked = true
			
			if visible: 
				if dialogue.size() != 0 and not typing_text: 
					n+=1
					if n == dialogue.size(): 
						dialogue = []
						n = 0
						emit_signal("phone_dialogue_finished")
					else: 
						type_text(dialogue[n])
				elif typing_text: 
					$dialogue.display_all()
					# emit_signal("phone_dialogue_finished")
			else: 
				n = 0
				dialogue = []
				
	if Input.is_action_just_released("click"): 
		clicked = false
				
#	if resizing: 
#		$dialogue.rect_size.y = lerp($dialogue.rect_size.y,$dialogue.get_content_height(),25*delta) 
#		if $dialogue.rect_size.y == $dialogue.get_content_height(): 
#			resizing = false
			
	if rect_scale == Vector2(0,0): 
		visible = false
	$dialogue.rect_size.y = lerp($dialogue.rect_size.y,min(110,$dialogue.get_content_height()),10*delta) 
	$dialogue.rect_position = speech_pos + Vector2(-$dialogue/speechBubble.margin_left,-$dialogue.rect_size.y-$dialogue/speechBubble.margin_bottom)
	
		
func type_text(new_text): 
	if new_text != "": 
		emit_signal("line_started")
		visible = true
		$dialogue.type_text(new_text)
		typing_text = true
		$indicator.visible = false

func set_blip_sfx(new_sfx): 
	blip_sfx = new_sfx
	$dialogue.blip_sfx = blip_sfx
	
#func set_delay(new_delay): 
#	delay = new_delay
#	$dialogue.delay = delay

func _on_dialogue_character_displayed(): 
	pass
#	resizing = true

func _on_dialogue_fully_displayed():
	$indicator.visible = true
	typing_text = false
	emit_signal("line_finished")
