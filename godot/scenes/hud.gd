extends CanvasLayer

@onready var status_message = $UI/StatusMessage
@onready var hide_status = $UI/HideStatus
@onready var journal = $Journal
@onready var chatbox = $Text/Panel/Box/Content
@onready var chat = $Text

func _ready():
	Globals.connect("update_journal", _update_journal)
	Globals.connect("initiate_chat", _start_chat)

func _process(delta):
	pass

func _update_journal(_msg):
	print_debug(hide_status.wait_time)
	status_message.text = "Journal updated"
	hide_status.start(2.0)
	
func _on_hide_status_timeout():
	status_message.text = ""

func _on_button_pressed():
	Globals.emit_signal("update_journal", "Hello World")
	if journal.visible:
		journal.hide()
	else:
		journal.show()

func _on_next_text_pressed():
	chat.hide()
	chatbox.text = ""

# TODO, support "complex" chats with questions and different paths
func _start_chat(message):
	chat.show()
	chatbox.text = message
