extends TextureButton
export(Texture) var icon_img
export(String) var icon_name

signal icon_selected(icon_name)

func _ready():
	set_icon(icon_img)

func set_icon(newTexture):
	icon_img = newTexture
	$TextureRect.texture = icon_img

func _on_menuItem_pressed():
	emit_signal("icon_selected",icon_name)

func _on_menuItem_focus_entered():
	emit_signal("icon_selected",icon_name)
