extends CanvasLayer

@onready var status_message = $UI/StatusMessage
@onready var hide_status = $UI/HideStatus
@onready var journal = $Journal
@onready var chatbox = $Text/Panel/Box/Content
@onready var chat = $Text
@onready var menu = $Menu

var message_queue = []

func _ready():
	Globals.connect("update_journal", _update_journal)
	Globals.connect("initiate_chat", _start_chat)
	Globals.connect("continue_chat", _append_message)
	Globals.connect("abort_chat", _abort_chat)
	menu.show()
	chat.hide()
	journal.hide()
	
func _unhandled_input(event):
	if event.is_action_pressed("help"):
		menu.visible = !menu.visible

func _process(_delta):
	if Input.is_action_just_pressed("ui_interact") && chat.visible:
		_on_next_text_pressed()

func _update_journal(_msg):
	status_message.text = "Journal updated"
	status_message.show()
	hide_status.start(2.0)
	
func _on_hide_status_timeout():
	status_message.text = ""

func _on_button_pressed():
	if journal.visible:
		journal.hide()
	else:
		journal.show()

func _on_next_text_pressed():
	if len(message_queue) == 0:
		_abort_chat()
	else:
		var msg = message_queue.pop_front()
		chatbox.text = "[b]%s[/b]: " % msg[0]
		chatbox.text += msg[1]

# TODO, support "complex" chats with questions and different paths
func _start_chat(speaker : String, message : String):
	message_queue = []
	chat.show()
	chatbox.text = "[b]%s[/b]: " % speaker
	chatbox.text += message

func _abort_chat():
	message_queue.clear()
	chat.hide()
	chatbox.text = ""
	InteractionHandler.emit_signal("interaction_stopped")

func _append_message(speaker : String, message : String):
	message_queue.push_back([speaker, message])
