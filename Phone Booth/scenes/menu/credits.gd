extends Control

func show(): 
	visible = true

func hide(): 
	visible = false

func _on_back_pressed():
	hide()

func _on_ig_pressed():
	OS.shell_open("https://www.instagram.com/chen_dll/")

func _on_twt_pressed():
	OS.shell_open("https://twitter.com/chen_dll")

func _on_kofi_pressed():
	OS.shell_open("https://ko-fi.com/chen_dll")
