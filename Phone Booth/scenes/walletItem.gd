extends TextureButton


func _ready():
	$item.visible = true
	$itemHover.visible = false

func mouse_entered():
	$item.visible = false
	$itemHover.visible = true

func mouse_exited():
	$item.visible = true
	$itemHover.visible = false

