extends CanvasLayer

@onready var status_message = $UI/StatusMessage
@onready var hide_status = $UI/HideStatus
@onready var journal = $Journal

func _ready():
	journal.connect("update_journal", _update_journal)

func _process(delta):
	pass

func _update_journal(_msg):
	status_message.text = "Journal updated"
	hide_status.start()
	
func _on_hide_status_timeout():
	status_message.text = ""

func _on_button_pressed():
	journal.emit_signal("update_journal", "Hello World")
	if journal.visible:
		journal.hide()
	else:
		journal.show()
