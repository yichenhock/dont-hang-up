extends TextureButton
export(int) var coin_id

func _ready():
	if Data.get_data("wallet_coin"+str(coin_id),true)==false: 
		visible = false

func _on_coin_mouse_entered():
	$coinAnim.play("shine")

func _on_coin_pressed():
	visible = false
	Audio.play("coinPickupSFX")
	Data.set_data("wallet_coin"+str(coin_id),false)
