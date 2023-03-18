extends Node

signal interaction_started
signal interaction_stopped

signal falko_forwards
signal falko_backwards

signal fridge_open
signal fridge_close

var milestones = []
var objects = {
	"AAB" = func(): chat("DJ", "This is a plant"), # Generic plant
	"ANG" = Callable(self, "angie"),
	"GAB" = Callable(self, "gabi"),
	"C00" = func(): Globals.toggle_dream(), # Couch that triggers dream mode
	"KAR" = Callable(self, "karen"),
	"FAL" = Callable(self, "falko"),
	"HEL" = Callable(self, "helmine"),
	"JOH" = func(): chat("Johannes", "I've learned to not ask questions I don't want the answer to."),
	"FRE" = Callable(self, "fred"),
	"D00" = func(): chat("DJ", "A normal desk full of stuff for work"), # Generic desk
	"P00" = func(): chat("DJ", "This is a plant. They absorb CO2 from the air."), # Generic plant
	"INT" = Callable(self, "intro"),
	"FRI" = Callable(self, "fridge"),
	"S00" = func(): chat("DJ", "A vending machine full of Spezi. I should ask Robert which one is the best!"),
	"TOL" = func(): chat("DJ", "Ugh. Where does this smell come from?"),
	"TLC" = Callable(self, "left_toilet"),
	"TOR" = Callable(self, "locked_toilet"),
	"KEY" = Callable(self, "missing_key"),
}
func _ready():
	randomize()
	Globals.new_game.connect(intro)

func chat(speaker : String, message : String):
	Globals.emit_signal("initiate_chat", speaker, message)

func add_to_chat(speaker : String, message : String):
	Globals.emit_signal("continue_chat", speaker, message)
	
func event_to_chat(event : Callable):
	Globals.emit_signal("continue_chat_event", event)
	
func journal(message : String):
	Globals.emit_signal("update_journal", message)

func unlock(milestone):
	milestones.push_back(milestone)
	
func has_found(milestone) -> bool:
	return milestones.find(milestone) > -1
	
func is_dreaming() -> bool:
	return Globals.dream_mode

func interact(id : String):
	# Do not allow interaction in dream mode except couch to end it
	if Globals.dream_mode && ["C00", "TLC", "KEY"].find(id) == -1:
		return

	if objects.has(id):
		emit_signal("interaction_started")
		objects[id].call()
	else:
		chat("Lt. Oak", "This itsn't the time to use that.")

func intro():
	# TODO: DJ walks into the Kitchen
	chat("DJ", "Hi I'm Detective Dave Jackson. Did you call us?")
	add_to_chat("Karen", "I did. Because some horrible monster ate my baby!")
	add_to_chat("DJ", "SOMEONE ATE YOUR BABY! That's horri... wait. Why did you bring your baby to the office.")
	add_to_chat("Karen", "Obviously, because I wanted to eat it.")
	event_to_chat(func(): InteractionHandler.emit_signal("falko_forwards"))
	add_to_chat("DJ", "YOU WANTED TO EAT YOUR BABY!")
	add_to_chat("Falko", "Karen, why are you yelling again? Some of us are trying to work here...")
	add_to_chat("Karen", "I'm not yelling. The detective is, because...")
	add_to_chat("DJ", "STOP! Let's start again with the earing babys part. Karen was it? Please tell me what happened. In order, please.")
	add_to_chat("Karen", "Ok. So this morning I brought this super delicious, triple choclate, jumbo yoghurt and put it into my fridge.")
	add_to_chat("Falko", "The fridge isn't yours Karen. Everyone is allowed to use it.")
	add_to_chat("Karen", "Stop interupting your betters. Don't you have something to clean?")
	add_to_chat("Falko", "How often shall I explain to you that 'Clean Code' has nothing to do with tidying...")
	add_to_chat("Karen", "Stop wasting my time. Leave!")
	event_to_chat(func(): InteractionHandler.emit_signal("falko_backwards"))
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
	InteractionHandler.emit_signal("fridge_open")
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
	event_to_chat(func(): InteractionHandler.emit_signal("fridge_close"))
	
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
	elif has_found("STINKY_STUFF") and has_found("PRANKSTER_HELMINE"):
		chat("DJ", "Someone threw up in your bathroom. Do you know of anyone else having allergies besides Karen?")
		add_to_chat("Falko", "No. She is the only one I know of. She makes sure everyone knows that.")
		add_to_chat("DJ", "Has anyone left early today, or did someone look ill?")
		add_to_chat("Falko", "I don't think so....wait. I haven't seen Adam in quite some time.")
		add_to_chat("DJ", "Adam? Whos that?")
		add_to_chat("Falko", "Our apprentice. He was supposed to bring Gabi my notes for the upcoming meeting.")
		add_to_chat("DJ", "Thanks. I'll see if I can find him.")
		unlock("ADAMS_MISSING")
	else:
		chat("Falko", "I'm in an important meeting. Can you come back later?")

func helmine():
	if has_found("PRANKSTER_HELMINE") and not has_found("HELMINE_IS_INNOCENT"):
		chat("DJ", "I heard that you don't like Karen.")
		add_to_chat("Helmine", "Hardly a secret. No one likes her.")
		add_to_chat("DJ", "But you in particular, have poisoned her food. That sounds more that a little dislike.")
		add_to_chat("Helmine", "(giggles) A glorious day. She made noises like a thunderstorm and you should have seen the toi....")
		add_to_chat("DJ", "No need for details. But why? And did you try that again, today?")
		add_to_chat("Helmine", "No, why would I do that? That would be boring. I don't do these things twice.")
		add_to_chat("DJ", "So today you just ate her yoghurt instead of exchanging it?")
		add_to_chat("Helmine", "Is that the reasons she's yelling all the time? No. In fact. I haven't been to the kitchen today. Ask Fred over there.")
		journal("Helmine claims to be innocent and that she hasn't been in the kitchen today. Someone named Fred could confirm that.")
		unlock("HELMINE_IS_INNOCENT")
	elif has_found("HELMINE_IS_INNOCENT") and has_found("CHILLI"):
		chat("DJ", "I found the missing yoghurt. Or whatever remains of it. Do you know what I found there?")
		add_to_chat("Helmine", "How should I know?")
		add_to_chat("DJ", "Someone put Chilli into it. Maybe someone that wanted to try a 'different' prank than last time?")
		add_to_chat("Helmine", "I have been here all the time, remember?")
		if has_found("EDDI"):
			add_to_chat("Well actually. Eddi told me he did saw you sending Fred to the kitchen with ramen and a glas of chilli-sauce.")
			add_to_chat("Helmine", "Whatever. Doesn't prove anything.")
			if has_found("ACCOMPLICE_FRED"):
				add_to_chat("DJ", "It does. Because Fred admitted to poison the yoghurt on your behalf.")
			if has_found("FOUND_ADAM"):
				_helmine_adam()
			else:
				add_to_chat("Helmine", "Maybe I have done that. But she never ate it. So what's the issue?")
				add_to_chat("DJ", "Someone ate it and threw up in the bathroom!")
				add_to_chat("Helmine", "And who is this 'victim' of yours?")
				add_to_chat("DJ", "I'll find out.")
				return
		elif has_found("ACCOMPLICE_FRED"):
			add_to_chat("You're wrong, because Fred admitted to poison the yoghurt on your behalf.")
			if has_found("FOUND_ADAM"):
				_helmine_adam()
			else:
				add_to_chat("Helmine", "Maybe I have done that. But she never ate it. So what's the issue?")
				add_to_chat("DJ", "Someone ate it and threw up in the bathroom!")
				add_to_chat("Helmine", "And who is this 'victim' of yours?")
				add_to_chat("DJ", "I'll find out.")
				return
		else:
			add_to_chat("DJ", "I'm coming back!")
	else:
		chat("Helmine", "Don't interrupt me. I have to keep my community happy.")
		
func _helmine_adam():
	add_to_chat("DJ", "And I have found Adam, that poor boy. He's having a nightmare in the bathroom, because of you!")
	add_to_chat("Helmine", "Adam? I haven't seen him today. Why would I be responsible for his misery?")
	add_to_chat("DJ", "Because he saw Fred meddling with Karens yoghurt. So he took it to check what you have done this time.")
	add_to_chat("DJ", "Unfortunately he didn't smell the chilli and ate quite a bit until it kicked in.")
	add_to_chat("Helmine", "Such an idiot. He should have just let her eat it so she would finally leave us.")
	add_to_chat("DJ", "So you're admitting that you have trying to poison your coworker?")
	add_to_chat("Helmine", "Poison? Nah. Just a little spice to get this ***** out of the office. She's a plague...")
	add_to_chat("DJ", "You'll have plenty of time to tell me all the details at the police station. Follow me.")
	Globals.game_over.emit(len(milestones))

func fred():
	if has_found("HELMINE_IS_INNOCENT") and not has_found("ONLYFANS"):
		chat("DJ", "Can you confirm that Helmine hasn't been to the kitchen today?")
		add_to_chat("Fred", "Absolutely.")
		add_to_chat("DJ", "Why so sure?")
		add_to_chat("Fred", "Well. We've entered the office together today and went straight to our desks.")
		add_to_chat("DJ", "Hardly a proof. Couldn't she have left the room for a couple of minutes without you noticing?")
		add_to_chat("Fred", "Impossible. I constantly watch here onlyfans livestream.")
		add_to_chat("DJ", "Aren't you supposed to be working?")
		add_to_chat("Fred", "What do you think I'm doing. I'm her stream moderator.")
		add_to_chat("DJ", "But... anyhow. Have you been to the kitchen today?")
		add_to_chat("Fred", "No I haven't. Niclas was kind enough the bring me a coffee so I can focus on my task.")
		add_to_chat("DJ", "Ok. Niclas then...")
		unlock("ONLYFANS")
		journal("Helmine is streaming on OnlyFans while Fred constanly watches here. And both get PAID for that?")
		journal("Niclas has been to the kitchen to fetch Fred a coffee.")
	else:
		chat("Fred", "A lot of trolls today...")

func gabi():
	if has_found("GABI"):
		if has_found("ADAMS_MISSING") and not has_found("ADAM_NEVER_SHOWED_UP") and not has_found("FOUND_ADAM"):
			chat("DJ", "Have you seen Adam today? Falko said he was supposed to bring you something.")
			add_to_chat("Gabi", "No. I have been waiting for him. But so far he hasn't showed up.")	
		else:
			chat("Gabi", "Sorry detective. My meeting starts soon and I have a lot to prepare. Can we talk later?")
		return
	
	if has_found("ANGIE"):
		chat("DJ", "Uhm. Didn't I just see you down in the office?")
		add_to_chat("Gabi", "Ehm. No. I have been here all the time. But you might have seen my twin sister Gabi.")
		add_to_chat("DJ", "That make sense. And whats your name and what are you doing here?")
	else:
		chat("DJ", "Excuse me Madame. Can I have 5 minutes of our time?")
		add_to_chat("Gabi", "Sure. How may I help you?")
		add_to_chat("DJ", "I'm Detective Dave Jackson looking into a misdeed. May I ask who you are and what you are doing here?")
	add_to_chat("Gabi", "I'm Gabi. Lead Programmer for Herzmut Games. I'm preparing our next meeting.")
	add_to_chat("DJ", "How long have you been here and have you been to the kitchen today?")
	add_to_chat("Gabi", "Let's see. What time is it.... oh my. 11:30 already? So I have been here for 2,5 hours and no I haven't been in the kitchen.")
	add_to_chat("DJ", "Did you see anything suspicious today?")
	add_to_chat("Gabi", "Well, Someone has been blocking the bathroom for ages. But that's probably Karen again. She basically lives there.")
	add_to_chat("DJ", "What do you mean? She told me she was only 5 minutes in there.")
	add_to_chat("Gabi", "Ha. This tarted up slug. Every day she comes in. Goes straight to the kitchen for some coffee and then hides the rest of the day in the bathroom playing on here phone only coming out every know and then for food or drinks.")
	if has_found("ADAMS_MISSING") and not has_found("FOUND_ADAM"):
		add_to_chat("DJ", "Have you seen Adam today? Falko said he was supposed to bring you something.")
		add_to_chat("Gabi", "No. I have been waiting for him. But so far he hasn't showed up.")
		unlock("ADAM_NEVER_SHOWED_UP")
		journal("Adam hasn't reached Gabi. Where is he?")
	add_to_chat("DJ", "Thank you for your time. You have been really helpful.")
	unlock("GABI")
	journal("Gabi has told me that Karen actually stays most of the time in the bathroom. Not just 5 minutes as she claimed. Why has she lied to me?")
	journal("Gabi noticed that someone is blocking the bathroom for hours. Since Karen is in the kitchen someone else must be in there.")
	
func angie():
	unlock("GABI")

func locked_toilet():
	if has_found("SPARE_KEY"):
		chat("DJ", "I'm coming in.")
		Globals.open_toilet_door.emit()
		return
		
	if has_found("ANGIE"):
		chat("DJ", "Hey. Is anyone in there?")
		add_to_chat("???", "Go away. I'm...")
		add_to_chat("DJ", "Are you okay?")
		add_to_chat("???", "No I'm not ok...")
		add_to_chat("DJ", "Open the door!")
		add_to_chat("???", "Can't...move...find spare key.")
		unlock("MISSING_KEY")
		journal("Someone is stuck in the toilet and is obviously sick. I have to find the spare key.")
	else:
		chat("DJ", "The door is locked.")
	
func left_toilet():
	if is_dreaming():
		chat("DJ", "It smells even worse. How is this even possible, but wait. Something is in that goo...")
		add_to_chat("DJ", "The remains of a yoghurt cup. 'super delicious, triple choclate' that must be Karens.")
		add_to_chat("DJ", "So whoever ate it, has upset it's stomach. But what is that smell?")
		add_to_chat("DJ", "Is that chilli ... absolutely! Someone put chilli in Karens yoghurt. But why poison it first and then eat it? Or are there, multiple culprits?")
		unlock("CHILLI")
		journal("Someone put chilli into Karens yoghurt. What's wrong with these people!")
		return
	
	if has_found("STINKY_STUFF"):
		chat("DJ", "I'm wouldn't dream of looking at this mess any longer. Or would I?")
		return
	
	chat("DJ", "Absolutely disgusting. What happened here. Wait... Is that half-digested yoghurt?")
	if has_found("PRANKSTER_HELMINE"):
		add_to_chat("DJ", "Maybe the thief had an allergic reaction. But Falko mentioned only Karens soy allergy. I should ask him about that.")
	else:
		add_to_chat("DJ", "I'm not touching that.")
	unlock("STINKY_STUFF")
	journal("Someone, probably the thief has made a mess in the bathroom.")
	
func missing_key():
	if is_dreaming() and has_found("MISSING_KEY"):
		chat("DJ", "I got the key!")
		unlock("SPARE_KEY")
		journal("I have found the key for the locked toilet.")
	elif has_found("MISSING_KEY"):
		chat("DJ", "There is a key blocking the door! Looks like a task for disembodied me.")
	else:
		chat("DJ", "Out of order. Something seems to be stuck in there.")
