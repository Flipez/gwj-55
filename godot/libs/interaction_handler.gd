extends Node

var milestones = []
var objects = {
	"AAB" = func(): chat("DJ", "This is a plant"), # Generic plant
	"KAR" = Callable(self, "karen"),
	"FAL" = Callable(self, "falko"),
	"D00" = func(): chat("DJ", "A normal desk full of stuff for work"), # Generic desk
	"P00" = func(): chat("DJ", "This is a plant. They absorb CO2 from the air."), # Generic plant
	"INT" = Callable(self, "intro"),
	"FRI" = Callable(self, "fridge"),
}
func _ready():
	randomize()

func chat(speaker : String, message : String):
	Globals.emit_signal("initiate_chat", speaker, message)

func add_to_chat(speaker : String, message : String):
	Globals.emit_signal("continue_chat", speaker, message)
	
func journal(message : String):
	Globals.emit_signal("update_journal", message)

func unlock(milestone):
	milestones.push_back(milestone)
	
func has_found(milestone) -> bool:
	return milestones.find(milestone) > -1

func interact(id : String):
	if objects.has(id):
		objects[id].call()
	else:
		chat("Lt. Oak", "This itsn't the time to use that.")

func intro():
	# TODO: DJ walks into the Kitchen
	chat("DJ", "Hi I'm Detective Dave Jackson. Did you call us?")
	add_to_chat("Karen", "I did. Because some horrible monster ate my baby!")
	add_to_chat("DJ", "SOMEONE ATE YOUR BABY! That's horri... wait. Why did you bring your baby to the office.")
	add_to_chat("Karen", "Obviously, because I wanted to eat it.")
	add_to_chat("DJ", "YOU WANTED TO EAT YOUR BABY!")
	# TODO: Falko walks ins
	add_to_chat("Falko", "Karen, why are you yelling again? Some of us are trying to work here...")
	add_to_chat("Karen", "I'm not yelling. The detective is, because...")
	add_to_chat("DJ", "STOP! Let's start again with the earing babys part. Karen was it? Please tell me what happened. In order, please.")
	add_to_chat("Karen", "Ok. So this morning I brought this super delicious, triple choclate, jumbo yoghurt and put it into my fridge.")
	add_to_chat("Falko", "The fridge isn't yours Karen. Everyone is allowed to use it.")
	add_to_chat("Karen", "Stop interupting your betters. Don't you have something to clean?")
	add_to_chat("Falko", "How often shall I explain to you that 'Clean Code' has nothing to do with tidying...")
	add_to_chat("Karen", "Stop wasting my time. Leave!")
	# TODO: Falko leaves
	add_to_chat("DJ", "Ok. Yoghurt, Fridge. What happened next?")
	add_to_chat("Karen", "So I just went for 5 minutes to the bathroom to check my Make-Up for the upcoming meeting and when I came back. It ... it ... was gone. (sniff)")
	add_to_chat("DJ", "Your yoghurt? ")
	add_to_chat("Karen", "Yes. (sniff)")
	add_to_chat("DJ", "So, you called the police, because someone stole your yoghurt?")
	add_to_chat("Karen", "Yes.")
	add_to_chat("DJ", "You know, that we're supposed to track down criminals?")
	add_to_chat("Karen", "Yes. This yoghurt thief is probably one of the worst bastards you ever had to put in jail.")
	add_to_chat("DJ", "Oh my... Well. Then I guess I'll start the 'investigation' of this crime scene. See you later.")
	add_to_chat("Karen", "Do that. I'll wait right here.")
	# TODO: Unfreeze Player-Movement
	
	journal("An employee named Karen called me, because someone ate her yoghurt. How low have I fallen...")

func karen():
	if has_found("FRIDGE") and not has_found("MOVED_LABEL"):
		# TODO, 
		chat("DJ", "There is a yoghurt in the fridge with a 'KAREN'-label on it. Is that the one you are missing?")
		add_to_chat("Karen", "Of course not. That's not a super delicious, triple choclate, jumbo yoghurt. Can't you read?")
		add_to_chat("DJ", "But is that your handwriting?")
		add_to_chat("Karen", "It is. The thief must have moved it when he stole my little baby...")
		unlock("MOVED_LABEL")
		journal("The label in the fridge is hers, but it's not her yoghurt. The thief must have moved it. Maybe I can find fingerprints?")
	else:
		if randi() % 50 < 25:
			chat("Karen", "Have you found the killer of my baby yet?")
		else:
			chat("Karen", "You're wasting my time. I'll talk to your manager!")

func fridge():
	if has_found("BIG_FINGERPRINT"):
		chat("DJ", "I already checked this. I should look somewhere else.")
	elif has_found("MOVED_LABEL"):
		chat("DJ", "Indeed. There are multiple finger prints on it. These pointy ones must be Karens. So the big ones are the from the culprit?")
		unlock("BIG_FINGERPRINT")
		journal("I found big fingerprints on the label in the fridge from someone with big hands, probably a men.")
	elif has_found("FRIDGE"):
		chat("DJ", "Nothing else here. Just the label I need to ask Karen about.")
	else:
		chat("DJ", "Multiple dishes and yoghurts are in here but one space is noticable empty. One yoghurt though has a 'KAREN' sticker on it.")
		journal("I found a yoghurt in the fridge labeled 'KAREN'. I should ask her about it.")
		unlock("FRIDGE")
	
func falko():
	if has_found("BIG_FINGERPRINT") and not has_found("PRANKSTER_HELMINE"):
		chat("DJ", "Can you show me your hands?")
		add_to_chat("Falko", "Sure, but why?")
		add_to_chat("DJ", "Kinda big hands for a programmer. Did you by chance, move Karens label. It has big finger prints on it?")
		add_to_chat("Falko", "Yes I did. Because someone put it on my soy milk.")
		add_to_chat("DJ", "Interesting. Do you know why and who might have done that?")
		add_to_chat("Falko", "Probably someone holding a grudge against her. It looks similar to her jumbo thingy and she has a soy allergy.")
		add_to_chat("DJ", "So someone tried to cause an allergic reaction? No trivial offense. Allergic reactions can be fatal...")
		add_to_chat("Falko", "Nah. She's exaggerating. She just starts to fart a lot and spend even more time in the bathroom.")
		add_to_chat("DJ", "How do you know?")
		add_to_chat("Falko", "Because the last time Helmine pulled that off it that toilet was unusable for days.")
		add_to_chat("DJ", "Helmine?")
		add_to_chat("Falko", "Our Lead-Social Media Manager. Shes over in the big office on the other side of the building.")
		journal("Helmine seems to have issues with Karen and has interfered with her food in the past. Shes over in the office on the west side of the building.")
		unlock("PRANKSTER_HELMINE")
	else:
		chat("Falko", "I'm in an important meeting. Can you come back later?")
