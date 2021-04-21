extends TextureButton
export(int) var num_coins = 0 setget set_coin_num

func set_coin_num(new_num):
	num_coins = new_num
	if num_coins == 0: 
		visible = false
	else: 
		visible = true
		for coin in get_children(): 
			coin.visible = false
		get_node("coins"+str(num_coins)).visible = true

func _ready():
	set_coin_num(num_coins)

func _on_coins_mouse_entered():
	$coins1.material.set_shader_param("outline",true)
	if num_coins == 1: 
		Data.set_data("description","a coin")
	else: 
		Data.set_data("description",str(num_coins)+" coins")

func _on_coins_mouse_exited():
	$coins1.material.set_shader_param("outline",false)
	Data.set_data("description","")
