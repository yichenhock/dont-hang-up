extends Control
var current_page = 1
var entries_per_page = 6
var total_pages
var total_entries
var all_numbers = []

# Called when the node enters the scene tree for the first time.
func _ready():
	load_entries()

func load_entries(): 
	total_entries = Data.files["phonebook"].size()
	all_numbers = Data.files["phonebook"].keys()
	total_pages = ceil(float(total_entries)/float(entries_per_page))

func refresh_entries(): 
	for n in range(entries_per_page):
		if n+entries_per_page*(current_page-1) < all_numbers.size(): 
			get_node("book/table/entry"+str(n+1)).number = all_numbers[n+entries_per_page*(current_page-1)]
			get_node("book/table/entry"+str(n+1)).details = Data.files["phonebook"][all_numbers[n+entries_per_page*(current_page-1)]]
		else: 
			get_node("book/table/entry"+str(n+1)).number = ""
			get_node("book/table/entry"+str(n+1)).details = ""
	$book/table/page.text = "Page "+str(current_page)+"-"+str(total_pages)
	
	$previous.disabled = false
	$next.disabled = false
	if current_page == 1: 
		$previous.disabled = true
	if current_page == total_pages: 
		$next.disabled = true

func show(): 
	$bookAnim.play("show")
	$back.visible = true
	$previous.visible = true
	$next.visible = true
	current_page = 1
	refresh_entries()

func hide(): 
	$bookAnim.play("hide")

func _on_back_pressed():
	$back.visible = false
	$previous.visible = false
	$next.visible = false

func _on_previous_pressed():
	current_page -= 1
	$bookAnim.play("fadeOutText")
	yield($bookAnim,"animation_finished")
	$bookAnim.play("pageTurnPrev")
	yield($bookAnim,"animation_finished")
	refresh_entries()
	$bookAnim.play("fadeInText")
	
func _on_next_pressed():
	current_page += 1
	$bookAnim.play("fadeOutText")
	yield($bookAnim,"animation_finished")
	$bookAnim.play("pageTurnNext")
	yield($bookAnim,"animation_finished")
	refresh_entries()
	$bookAnim.play("fadeInText")
