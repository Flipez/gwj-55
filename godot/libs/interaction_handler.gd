extends Node

var objects = {
	"AAB" = func(): Globals.chat("DJ", "This is a plant"), # Generic plant
	"KAR" = Callable(self, "karen"),
	"D00" = func(): Globals.chat("DJ", "A normal desk full of stuff for work"), # Generic desk
	"P00" = func(): Globals.chat("DJ", "This is a plant. They absorb CO2 from the air."), # Generic plant
	"INT" = Callable(self, "intro"),
}

func _ready():
	randomize()

func interact(id : String):
	if objects.has(id):
		objects[id].call()
	else:
		Globals.chat("Lt. Oak", "This itsn't the time to use that.")

func intro():
	Globals.chat("DJ", "Hello World?")
	Globals.add_to_chat("Karen", "Who are you?")

func karen():
	if randi() % 50 < 25:
		Globals.chat("Karen", "Have you found the killer of my baby yet?")
	else:
		Globals.chat("Karen", "You're wasting my time. I'll talk to your manager!")
