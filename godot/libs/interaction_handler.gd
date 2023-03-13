extends Node

var objects = {
	"AAB" = func(): Globals.chat("This is a plant"), # Generic plant
}


func interact(id : String):
	if objects.has(id):
		objects[id].call()
	else:
		Globals.chat("Lt. Oak says: This itsn't the time to use that.")
