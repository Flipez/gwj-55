extends Control
class_name Journal

var pages = ["03/10/2023 - Herzmut Games, Munich\n\nI arrived 10:03 at the crime scene - the lunch room in the HQ of the famous Game-Studio.\n"]
var current_page = 0

@onready var left_page = $Page/Left/Content
@onready var right_page = $Page/Right/Content

func _ready():
	Globals.connect("update_journal", _on_update_journal)
	turn_page(0)

func turn_page(direction):
	current_page += direction
	
	left_page.text = pages[current_page]
	if current_page + 1 < len(pages):
		right_page.text = pages[current_page+1]
	else:
		right_page.text = ""
	
	if current_page == 0:
		$PrevPage.hide()
	else:
		$PrevPage.show()
		
	if current_page < len(pages) - 1:
		$NextPage.show()
	else:
		$NextPage.hide()

func _process(_delta):
	pass

func _on_prev_page_pressed():
	turn_page(-2)

func _on_next_page_pressed():
	turn_page(2)

func _on_update_journal(content: String):
	var page_data = pages.pop_back()
	var char_count = page_data.count("\n") * 42 + len(page_data)
	
	for word in content.split(" ", false):
		page_data += word
		page_data += " "
		char_count += len(word) + 1

		# No additional checking on page wrap for another overflow 
		# since the text-chunks are small
		if char_count >= 800:
			pages.push_back(page_data)
			page_data = ""
	page_data += "\n"
	char_count += 42
	pages.push_back(page_data)
	if char_count > 700:
		pages.push_back("")

	# Refresh
	turn_page(0)
