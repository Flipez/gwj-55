extends Control

signal update_journal(content: String)
var pages = ["03/10/2023 - Herzmut Games, Munich\n\nI arrived 10:03 at the crime scene - the lunch room in the HQ of the famous Game-Studio."]
var current_page = 0

@onready var left_page = $Page/Left/Content
@onready var right_page = $Page/Right/Content

func _ready():
	connect("update_journal", _on_update_journal)
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

func _process(delta):
	pass

func _on_prev_page_pressed():
	turn_page(-2)

func _on_next_page_pressed():
	turn_page(2)

func _on_update_journal(content: String):
	var blob = pages[-1]
