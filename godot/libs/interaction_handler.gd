extends Node

var objects = {
	"AAB" = func(): Globals.chat("DJ", "This is a plant"), # Generic plant
	"INT" = Callable(self, "intro"),
}

func interact(id : String):
	if objects.has(id):
		objects[id].call()
	else:
		Globals.chat("Lt. Oak", "This itsn't the time to use that.")

func intro():
	Globals.chat("DJ", "Hello World?")
	Globals.add_to_chat("Karen", "Who are you?")
