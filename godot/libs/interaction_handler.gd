extends Node

var objects = {
	"AAB" = func(): Globals.chat("DJ", "This is a plant"), # Generic plant
	"KAR" = Callable(self, "karen"),
	"D00" = func(): Globals.chat("DJ", "A normal desk full of stuff for work"), # Generic desk
	"P00" = func(): Globals.chat("DJ", "This is a plant. They absorb CO2 from the air."), # Generic plant
	"INT" = Callable(self, "intro"),
	"FRI" = Callable(self, "fridge"),
}

func _ready():
	randomize()

func interact(id : String):
	if objects.has(id):
		objects[id].call()
	else:
		Globals.chat("Lt. Oak", "This itsn't the time to use that.")

func intro():
	# TODO: DJ walks into the Kitchen
	Globals.chat("DJ", "Hi I'm Detective Dave Jackson. Did you call us?")
	Globals.add_to_chat("Karen", "I did. Because some horrible monster ate my baby!")
	Globals.add_to_chat("DJ", "SOMEONE ATE YOUR BABY! That's horri... wait. Why did you bring your baby to the office.")
	Globals.add_to_chat("Karen", "Obviously, because I wanted to eat it.")
	Globals.add_to_chat("DJ", "YOU WANTED TO EAT YOUR BABY!")
	# TODO: Falko walks ins
	Globals.add_to_chat("Falko", "Karen, why are you yelling again? Some of us are trying to work here...")
	Globals.add_to_chat("Karen", "I'm not yelling. The detective is, because...")
	Globals.add_to_chat("DJ", "STOP! Let's start again with the earing babys part. Karen was it? Please tell me what happened. In order, please.")
	Globals.add_to_chat("Karen", "Ok. So this morning I brought this super delicious, triple choclate, jumbo yoghurt and put it into my fridge.")
	Globals.add_to_chat("Falko", "The fridge isn't yours Karen. Everyone is allowed to use it.")
	Globals.add_to_chat("Karen", "Stop interupting your betters. Don't you have something to clean?")
	Globals.add_to_chat("Falko", "How often shall I explain to you that 'Clean Code' has nothing to do with tidying...")
	Globals.add_to_chat("Karen", "Stop wasting my time. Leave!")
	# TODO: Falko leaves
	Globals.add_to_chat("DJ", "Ok. Yoghurt, Fridge. What happened next?")
	Globals.add_to_chat("Karen", "So I just went for 5 minutes to the bathroom to check my Make-Up for the upcoming meeting and when I came back. It ... it ... was gone. (sniff)")
	Globals.add_to_chat("DJ", "Your yoghurt? ")
	Globals.add_to_chat("Karen", "Yes. (sniff)")
	Globals.add_to_chat("DJ", "So, you called the police, because someone stole your yoghurt?")
	Globals.add_to_chat("Karen", "Yes.")
	Globals.add_to_chat("DJ", "You know, that we're supposed to track down criminals?")
	Globals.add_to_chat("Karen", "Yes. This yoghurt thief is probably one of the worst bastards you ever had to put in jail.")
	Globals.add_to_chat("DJ", "Oh my... Well. Then I guess I'll start the 'investigation' of this crime scene. See you later.")
	Globals.add_to_chat("Karen", "Do that. I'll wait right here.")
	# TODO: Unfreeze Player-Movement
	
	Globals.journal("An employee named Karen called me, because someone ate her yoghurt. How low have I fallen...")

func karen():
	if randi() % 50 < 25:
		Globals.chat("Karen", "Have you found the killer of my baby yet?")
	else:
		Globals.chat("Karen", "You're wasting my time. I'll talk to your manager!")

func fridge():
	Globals.chat("DJ", "Multiple dishes and yoghurts are in here but one space is noticable empty. One yoghurt though has a 'KAREN' sticker on it.")
	Globals.journal("I found a yoghurt in the fridge labeled 'KAREN'. I should ask her about it.")
	
