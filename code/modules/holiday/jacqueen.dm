//Conversation
#define JACQ_HELLO (1<<0)
#define JACQ_CANDIES (1<<1)
#define JACQ_HEAD (1<<2)
#define JACQ_FAR (1<<3)
#define JACQ_WITCH (1<<4)
#define JACQ_EXPELL (1<<5)
#define JACQ_DATE (1<<6)
//Tricks
#define JACQ_TRICKED (1<<0)
#define JACQ_LATERN (1<<1)
#define JACQ_DULLA (1<<2)

////ROUND EVENT

/datum/round_event_control/jacqueline
	name = "Jacqueline the Pumpqueen"
	holidayID = "Jacqueline"
	typepath = /datum/round_event/jacq
	weight = -1							//forces it to be called, regardless of weight
	max_occurrences = 1
	earliest_start = 0 MINUTES

/datum/round_event/jaqc/start()
	..()
	for(var/mob/living/simple_animal/pet/dog/corgi/Ian/Ian in GLOB.mob_living_list)
		new /mob/living/jacq(Poly.loc)//She poofs on init, so it doesn't matter, so long as Ian exists.

/////// MOBS

//Whacha doing in here like? Yae wan tae ruin ta magicks?
/mob/living/jacq
	name = "Jacqueline the Pumpqueen"
	real_name = "Jacqueline"
	icon = 'icons/obj/halloween_items.dmi'
	icon_state = "jacqueline"
	maxHealth = INFINITY
	health = 20
	density = FALSE
	var/destinations = list("Bar", "Brig", "Bridge", "Chapel", "Chemistry", "Cyrogenics", "Engineering", "Xenobiology")
	var/tricked = list() //Those who have been tricked
	var/progression = list() //Keep track of where people are in the story.

/mob/living/jacq/Initialize()
	poof()

/mob/living/jacq/Destroy() //I.e invincible
	visible_message("<b>[src]</b> cackles, <span class='spooky'>\"You'll nae get rid a me that easily!\"</span>")
	playsound(loc, 'sound/spookoween/ahaha.ogg', 100, 1)
	var/mob/living/jacq/Jacq = new src.type(loc)
	Jacq.tricked = tricked
	Jacq.progression = progression
	..()

/mob/living/jacq/death() //What is alive may never die
	visible_message("<b>[src]</b> cackles, <span class='spooky'>\"You'll nae get rid a me that easily!\"</span>")
	playsound(loc, 'sound/spookoween/ahaha.ogg', 100, 1)
	health = 20
	poof()


/mob/living/jacq/proc/poof()
	var/datum/reagents/R = new/datum/reagents(100)//Hey, just in case.
	var/datum/effect_system/smoke_spread/chem/s = new()
	R.add_reagent("secretcatchem", (10))
	s.set_up(R, 2, loc)
	s.start()

	for(var/i = 1, i <= 5, i+=1)//try 5 times to teleport
		var/area/A = GLOB.sortedAreas["[pick(destinations)]"]
		if(A && istype(A))
			if(forceMove(safepick(get_area_turfs(A))))
				return TRUE
	return FALSE

/mob/living/jacq/on_click(whatever this proc is called)
 	chit_chat(L)
	C.stun(0)//Okay, you're done talking now.

//Ye wee bugger, gerrout of it. Ye've nae tae enjoy reading the code fer mae secrets like.
/mob/living/jacq/proc/chit_chat(mob/living/L)
	var/mob/living/carbon/C = L
	if(!iscarbon)
		//Maybe? It seems like a lot of faff for something that is very unlikely to happen.
		return
	C.stun(1000)//You're talking, don't leave.
	//Very important
	var/gender = "lamb"
	if(C)
		if(C.gender == MALE)
			gender = "laddie"
		if(C.gender == FEMALE)
			gender = "lassie"

	if(!progression["[C.real_name]"] ||  !(progression["[C.real_name]"] & JACQ_HELLO))
		visible_message("<b>[src] smiles ominously at [L],</b> <span class='spooky'>\"Well hal� there [gender]! Ah�m Jacqueline, tae great Pumpqueen, great tae meet ye.\"</span>")
		sleep(20)
		visible_message("<span class='spooky'><b>[src] continues,</b> says, ”Ah’m sure yae well stunned, but ah’ve got nae taem fer that. Ah’m after the candies around this station. If yae get mae enoof o the wee buggers, Ah'll give ye a treat, or if yae feeling bold, Ah ken trick ye instead.</span>” giving [L] a wide grin.")
		if(!progression["[C.real_name]"])
		 	progression["[C.real_name]"] += JACQ_HELLO //TO MAKE SURE THAT THE LIST ENTRY EXISTS.
		else
			progression["[C.real_name]"] = progression["[C.real_name]"] | JACQ_HELLO
		return

	var/choices = list("Trick", "Treat", "How do I get candies?")
	var/choice = input(usr, "Trick or Treat?", "Trick or Treat?") in choices
	switch(choice)
		if("Trick")
			trick(C)
			return
		if("Treat")
			if(check_candies(C))
				treat(C, gender)
			else
				visible_message("<b>[src] raises an eyebrown,</b> <span class='spooky'>\"You've nae got any candies Ah want! They're the orange round ones, now bugger off an go get em first.\"</span>")
			return
		if("How do I get candies?")
			visible_message("<b>[src] says,</b> <span class='spooky'>\"Gae find my familiar; Bartholomew. Ee's tendin the cauldron which ken bring oot t' magic energy in items scattered aroond. Knowing him, ee's probably gone tae somewhere with books.\"</span>")
			return

/mob/living/jacq/proc/treat(mob/living/carbon/C, gender)
	visible_message("<b>[src] gives off a glowing smile,</b> <span class='spooky'>\"What ken Ah offer ye? I can magic in you an object, A potion or a plushie. \"</span>")
	var/choices_reward = list("Object - 3 candies", "Potion - 2 candies", "Plushie - 1 candy", "Can I ask you a question instead?")
	var/choice_reward = input(usr, "Trick or Treat?", "Trick or Treat?") in choices
	switch(choice_reward)
		if("Object - 3 candies")
			var/new_obj = pick(subtypesof(/obj))
			//for(var/item in blacklist)
			//	if(new_obj == item)
			//  	panic()
			new new_obj(C.loc)
		if("Potion - 2 candies")
			new /obj/item/reagent_containers/potion_container(C.loc)
		if("Plushie - 1 candy")
			new /obj/item/toy/plush/random(C.loc)
		if("Can I ask you a question instead?")

			var/choices = list()
			//Figure out where the C is in the story
			if(!progression["[C.real_name]"]) //I really don't want to get here withoot a hello, but just to be safe
				progression["[C.real_name]"] += JACQ_HELLO
			if(!progression["[C.real_name]"] & JACQ_FAR)
				if(progression["[C.real_name]"] & JACQ_CANDIES)
					choices += "You really came all this way for candy?"
				else
					choices += "Why do you want the candies?"
			if(!progression["[C.real_name]"] & JACQ_HEAD)
				choices += "What is that on your head?"
			if(!progression["[C.real_name]"] & JACQ_EXPELL)
				if(progression["[C.real_name]"] & JACQ_WITCH & JACQ_FAR)
					choices += "So you got ex-spell-ed?"
				else
					choices += "Are you a witch?"

			//for Kepler, delete this, or just delete the whole story aspect if you want.
			//If fully completed
			if(progression["[C.real_name]"] JACQ_FAR & JACQ_EXPELL & JACQ_HEAD)
				choices = "Can I take you out on a date?"

			//If you've nothing to ask
			if(!LAZYLEN(choices))
				visible_message("<b>[src] raises an eyebrown,</b> <span class='spooky'>\"Ah'm all questioned oot fer noo, [gender].\"</span>")
				return
			//Otherwise, lets go!
			visible_message("<b>[src] says,</b> <span class='spooky'>\"A question? Sure, it'll cost you a candy though!\"</span>")
			choices += "Nevermind"
			//Candies for chitchats
			var/choice = input(usr, "What do you want to ask?", "What do you want to ask?") in choices
			if(!take_candies(C, 1))
				visible_message("<b>[src] raises an eyebrown,</b> <span class='spooky'>\"It's a candy per question [gender]! Thems the rules!\"</span>")
				return
			//Talking
			switch(choice)
				if("Why do you want the candies?")
					visible_message("<b>[src] says,</b> <span class='spooky'>\”Ave ye tried them? They’re full of all sorts of reagents. Ah’m after them so ah ken magic em up an hopefully find rare stuff fer me brews. Honestly it’s a lot easier magicking up tatt fer ye lot than runnin aroond on me own like. I'd ask me familiars but most a my familiars are funny fellows 'n constantly bugger off on adventures when given simple objectives like; Go grab me a tea cake or watch over me cauldron. Ah mean, ye might run into Bartholomew my cat. Ee’s supposed tae be tending my cauldron, but I’ve nae idea where ee’s got tae.\"</span>")
					progression["[C.real_name]"] = progression["[C.real_name]"] | JACQ_CANDIES

				if("You really came all this way for candy?")
					visible_message("<b>[src] looks tae the side sheepishly,</b> <span class='spooky'>\"Aye, well, tae be honest, Ah’m here tae see me sis, but dunnae let her knew that. She’s an alchemist too like, but she dunnae use a caldron like mae, she buggered off like tae her posh ivory tower tae learn bloody chemistry instead!” [src] scowls, “She’s tae black sheep o’ the family too, so we dunnae see eye tae eye sometimes on alchemy. Ah mean, she puts <i> moles </i> in her brews! Ye dunnae put moles in yer brews! Yae threw your brews at tae wee bastards an blew em up!” [src] sighs ”But she’s a heart o gold so.. Ah wanted tae see her an check up oon her, make sure she’s okay.\"</span>")
					progression["[C.real_name]"] = progression["[C.real_name]"] | JACQ_FAR

				if("What is that on your head?")
					visible_message("<b>[src] pats the pumpkin atop her head,</b> <span class='spooky'>\"This thing? This ain’t nae ordinary pumpkin! Me Ma grew this monster ooer a year o love, dedication an hard work. Honestly it felt like she loved this thing more than any of us, which Ah knew ain’t true an it’s not like she was hartless or anything but.. well, we had a falling oot when Ah got back home with all me stuff in tow. An all she had done is sent me owl after owl over t' last year aboot this bloody pumpkin and ah had enough. So ah took it, an put it on me head. You know, as ye do. Ah am the great Pumpqueen after all, Ah deserve this.\"</span>")
					progression["[C.real_name]"] = progression["[C.real_name]"] | JACQ_HEAD

				if("Are you a witch?")
					visible_message("<b>[src] grumbles,</b> <span class='spooky'>\"If ye must know, Ah got kicked oot of the witch academy fer being too much of a “loose cannon”. A bloody loose cannon? Nae they were just pissed off Ah had the brass tae proclaim myself as the Pumpqueen…. And also maybe the time Ah went and blew up one of the towers by trying tae make a huge batch of astrogen might’ve had something tae do with it. Ah mean it would’ve worked fine if the cauldrons weren’t so shite and were actually upgraded by the faculty. So technically no, I’m not a witch.\"</span>")
					progression["[C.real_name]"] = progression["[C.real_name]"] | JACQ_WITCH

				if("So you got ex-spell-ed?")
					visible_message("<b>[src] Gives you a blank look at the pun, before continuing,</b> <span class='spooky'>\"Not quite, Ah know Ah ken get back into the academy, it’s only an explosion, they happen all the time, but, tae be fair it’s my fault that things came tae their explosive climax. You don’t know what it’s like when you’re after a witch doctorate, everyone else is doing well, everyone’s making new spells and the like, and I’m just good at making explosions really, or fireworks. So, Ah did something Ah knew was dangerous, because Ah had tae do something tae stand oot, but Ah know this life ain’t fer me, Ah don’t want tae be locked up in dusty towers, grinding reagent after reagent together, trying tae find new reactions, some of the wizards in there haven’t left fer years. Ah want tae live, Ah want tae fly around on a broom, turn people into cats fer a day and disappear cackling! That’s what got me into witchcraft!” she throws her arms up in the arm, spinning the pumpkin upon her head slightly. She carefully spins it back to face you, giving oot a soft sigh, ”Ah know my mother’s obsession with this dumb thing on my head is just her trying tae fill the void of me and my sis moving oot, and it really shouldn’t be on my head. And Ah know that I’m really here tae get help from my sis… She’s the sensible one, and she gives good hugs.\"</span>")
					sleep(50)
					visible_message("<b>[src] says,</b> <span class='spooky'>\"Thanks [C], Ah guess Ah didn’t realise Ah needed someone tae talk tae but, I’m glad ye spent all your candies talking tae me. Funny how things seem much worse in yer head.\"</span>")
					progression["[C.real_name]"] = progression["[C.real_name]"] | JACQ_EXPELL

				if("Can I take you out on a date?")
					visible_message("<b>[src] blushes,</b> <span class='spooky'>\"...You want tae ask me oot on a date? Me? After all that nonsense Ah just said? It seems a waste of a candy honestly.\"</span>")
					progression["[C.real_name]"] = progression["[C.real_name]"] | JACQ_DATE
					dating_start(C, gender)

				if("Nevermind")
					visible_message("<b>[src] shurgs,</b> <span class='spooky'>\"Suit yerself then.\"</span>")


/mob/living/jacq/proc/trick(mob/living/carbon/C, gender)
	var/option = rand(1,6)
	switch(option)
		if(1)
			visible_message("<b>[src] waves their arms around,</b> <span class='spooky'>\"Hocus pocus, making friends is now your focus!\"</span>")
			var/objective = pick("Make a tasty sandwich for", "Compose a poem for", "Aquire a nice outfit to give to", "Strike up a conversation about pumpkins with", "Write a letter and deliver it to", "Give a nice hat to")
			var/mob/living/L2 = pick(GLOB.player_list)
			objective += " [L2.name]."
		if(2)
			visible_message("<b>[src] waves their arms around,</b> <span class='spooky'>\"Off comes your head, atleast you're not dead.\"</span>")
			C.reagents.add_reagent("pumpkinmutationtoxin", 5)
		if(3)
			visible_message("<b>[src] waves their arms around,</b> <span class='spooky'>\"If only you had a better upbringing, your ears are now full of my singing!\"</span>")
			//playsound
		if(4)
			visible_message("<b>[src] waves their arms around,</b> <span class='spooky'>\"A cute little bumpkin, In your hand is a pumpkin!\"</span>")
			//Sticky latern
		if(5)
			visible_message("<b>[src] waves their arms around,</b> <span class='spooky'>\"In your arms a jokester, keep him close if you don't want to be a toaster!\"</span>")
			//sans
		if(6)
			visible_message("<b>[src] waves their arms around,</b> <span class='spooky'>\"A new familiar for me, and you'll see it's thee!\"</span>")
			C.reagents.add_reagent("secretcatchem", 30)
		if(7)
			visible_message("<b>[src] waves their arms around,</b> <span class='spooky'>\"While you may not be a ghost, for this sheet you'll always be it's host.\"</span>")
			C.place_on_head(new /obj/item/clothing/suit/ghost_sheet/sticky(C))

/*Will you go on a date with me?
”…You want tae ask me oot on a date? Me? After all that nonsense Ah just said? It seems a waste of a candy honestly.”
[src] looks to the side.
”Look, Ah like ye but, Ah don’t think Ah can right now. If ye can’t tell, the stations covered in volatile candies, I’ve a few other laddies and lassies running after me treats, and tae top it all off, I’ve the gods breathing down me neck, watching every treat Ah make fer the lot of yous.” she sighs, ”But that’s not a no, right? That’s.. just a not right now.”
[src] takes off the pumpkin on her head, a rich blush on her cheeks. She leans over planting a kiss upon your forehead quickly befere popping the pumpkin back on her head.

” There, that aught tae be worth a candy.”

Ondeath:
visible_message("<span class='spooky'><b>[src] cackles,</b> "You'll nae get rid a me that easily!"</span>")
(the last message is if I can't get a ghost/a person in it)
*/

/obj/item/clothing/suit/ghost_sheet/sticky
	item_flags = NODROP

var/datum/reagent/mutationtoxin/pumpkinhead
	name = "Pumpkin head mutation toxin"
	id = "pumpkinmutationtoxin"
	race = /datum/species/dullahan/pumpkin
	mutationtext = "<span class='spooky'>The pain subsides. You feel your head roll off your shoulders."

/mob/living/jacq/proc/check_candies(mob/living/carbon/C)
	var/invs = C.get_contents()
	var/candy_count = 0
	for(var/item in invs)
		if(istype(item, /obj/item/reagent_containers/food/snacks/special_candy))
			candy_count++
	return candy_count

/mob/living/jacq/proc/take_candies(mob/living/carbon/C, candy_amount = 1)
	var/inv = C.get_contents()
	var/candies = list()
	for(var/item in inv)
		if(istype(item, /obj/item/reagent_containers/food/snacks/special_candy))
			candies += item
		if(LAZYLEN(candies) == candy_amount)
			break
	if(LAZYLEN(candies) == candy_amount) //I know it's a double check but eh, to be safe.
		for(var/candy in candies)
			qdel(candy)
		return TRUE
	return FALSE

/mob/living/jacq/proc/trick(C)
//var/area/A = input(usr, "Pick an area.", "Pick an area") in GLOB.sortedAreas|null


//Potions
/obj/item/reagent_containers/potion_container
	name = "potion"
	//TODO icons

/obj/item/reagent_containers/potion_container/Initialize()
	..()
	var/datum/reagent/R = pick(subtypesof(/datum/reagent))
	reagents.add_reagent(R.id, 30)
	name = "[R.id] Potion"

/obj/item/reagent_containers/potion_container/throw_impact(atom/target)
	var/datum/effect_system/smoke_spread/chem/s = new()
	s.set_up(src.reagents, 3, target.loc)
	s.start()
	..()

//Candies
/obj/item/reagent_containers/food/snacks/special_candy
	name = "Magic candy"

/obj/item/reagent_containers/food/snacks/special_candy/Initialize()
	reagents.add_reagent(get_random_reagent_id(), 5)
	..()
