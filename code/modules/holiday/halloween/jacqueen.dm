//Conversation
#define JACQ_HELLO (1<<0)
#define JACQ_CANDIES (1<<1)
#define JACQ_HEAD (1<<2)
#define JACQ_FAR (1<<3)
#define JACQ_WITCH (1<<4)
#define JACQ_EXPELL (1<<5)
#define JACQ_DATE (1<<6)

/////// EVENT
/datum/round_event_control/jacqueen
	name = "Jacqueline's visit"
	holidayID = "jacqueen"
	typepath = /datum/round_event/jacqueen
	weight = -1							//forces it to be called, regardless of weight
	max_occurrences = 1
	earliest_start = 0 MINUTES

/datum/round_event/jacqueen/start()
	..()

	for(var/mob/living/carbon/human/H in GLOB.carbon_list)
		playsound(H, 'sound/spookoween/ahaha.ogg', 100, 0.25)

	for(var/obj/effect/landmark/barthpot/bp in GLOB.landmarks_list)
		new /obj/item/barthpot(bp.loc)
		new /mob/living/simple_animal/jacq(bp.loc)

/////// MOBS

//Whacha doing in here like? Yae wan tae ruin ta magicks?
/mob/living/simple_animal/jacq
	name = "Jacqueline the Pumpqueen"
	real_name = "Jacqueline"
	icon = 'icons/obj/halloween_items.dmi'
	icon_state = "jacqueline"
	maxHealth = 25
	health = 25
	density = FALSE
	speech_span = "spooky"
	friendly_verb_continuous = "pets"
	friendly_verb_simple = "pet"
	response_help_continuous = "chats with"
	response_help_simple = "chat with"
	light_range = 3
	light_color = "#ff9842"
	var/last_poof
	var/progression = list() //Keep track of where people are in the story.
	var/active = TRUE //Turn this to false to keep normal mob behavour
	var/cached_z
	/// I'm busy chatting, don't move.
	var/busy_chatting = FALSE

/mob/living/simple_animal/jacq/Initialize()
	..()
	cached_z = z
	poof()

/mob/living/simple_animal/jacq/BiologicalLife(seconds, times_fired)
	if(!(. = ..()))
		return
	if(!ckey)
		if((last_poof+3 MINUTES) < world.realtime)
			poof()

/mob/living/simple_animal/jacq/Destroy() //I.e invincible
	visible_message("<b>[src]</b> cackles, <span class='spooky'>\"You'll nae get rid a me that easily!\"</span>")
	playsound(loc, 'sound/spookoween/ahaha.ogg', 100, 0.25)
	var/mob/living/simple_animal/jacq/Jacq = new src.type(loc)
	Jacq.progression = progression
	..()

/mob/living/simple_animal/jacq/death() //What is alive may never die
	visible_message("<b>[src]</b> cackles, <span class='spooky'>\"You'll nae get rid a me that easily!\"</span>")
	playsound(loc, 'sound/spookoween/ahaha.ogg', 100, 0.25)
	health = 25
	poof()

/mob/living/simple_animal/jacq/attack_hand(mob/living/carbon/human/M)
	if(!active)
		say("Hello there [gender_check(M)]!")
		return ..()
	if(!ckey)
		busy_chatting = FALSE
		chit_chat(M)
		busy_chatting = TRUE
	..()

/mob/living/simple_animal/jacq/attack_paw(mob/living/carbon/monkey/M)
	if(!active)
		say("Hello there [gender_check(M)]!")
		return ..()
	if(!ckey)
		busy_chatting = FALSE
		chit_chat(M)
		busy_chatting = TRUE
	..()

/mob/living/simple_animal/jacq/proc/poof()
	last_poof = world.realtime
	var/datum/reagents/R = new/datum/reagents(100)//Hey, just in case.
	var/datum/effect_system/smoke_spread/chem/s = new()
	R.add_reagent(/datum/reagent/fermi/secretcatchem, 10)
	s.set_up(R, 0, loc)
	s.start()
	visible_message("<b>[src]</b> disappears in a puff of smoke!")
	busy_chatting = TRUE
	health = 25

	//Try to go to populated areas
	var/list/pop_areas = list()
	for(var/mob/living/L in GLOB.player_list)
		var/area/A = get_area(L)
		pop_areas += A

	var/list/targets = list()
	for(var/H in GLOB.network_holopads)
		var/area/A = get_area(H)
		if(!A || findtextEx(A.name, "AI") || !(A in pop_areas) || !is_station_level(H))
			continue
		targets += H

	if(!targets)
		targets = GLOB.generic_event_spawns

	for(var/i in 1 to 6) //Attempts a jump up to 6 times.
		var/atom/A = pick(targets)
		if(do_teleport(src, A, channel = TELEPORT_CHANNEL_MAGIC))
			return TRUE
		targets -= A
	return FALSE

/mob/living/simple_animal/jacq/proc/gender_check(mob/living/carbon/C)
	var/gender = "lamb"
	if(C)
		if(C.gender == MALE)
			gender = "laddie"
		if(C.gender == FEMALE)
			gender = "lassie"
	return gender

//Ye wee bugger, gerrout of it. Ye've nae tae enjoy reading the code fer mae secrets like.
/mob/living/simple_animal/jacq/proc/chit_chat(mob/living/carbon/C)
	//Very important
	var/gender = gender_check(C)
	if(C)
		if(C.gender == MALE)
			gender = "laddie"
		if(C.gender == FEMALE)
			gender = "lassie"

	if(!progression["[C.real_name]"] ||  !(progression["[C.real_name]"] & JACQ_HELLO))
		visible_message("<b>[src]</b> smiles ominously at [C], <span class='spooky'>\"Well halo there [gender]! Ah'm Jacqueline, tae great Pumpqueen, great tae meet ye.\"</span>")
		sleep(20)
		visible_message("<b>[src]</b> continues, <span class='spooky'>\"Ah'm sure yae well stunned, but ah've got nae taem fer that. Ah'm after the candies around this station. If yae get mae enoof o the wee buggers, Ah'll give ye a treat, or if yae feeling bold, Ah ken trick ye instead.</span>\" giving [C] a wide grin.")
		if(!progression["[C.real_name]"])
			progression["[C.real_name]"] = NONE //TO MAKE SURE THAT THE LIST ENTRY EXISTS.

		progression["[C.real_name]"] = progression["[C.real_name]"] | JACQ_HELLO

	var/choices = list("Trick", "Treat", "How do I get candies?")
	var/choice = input(C, "Trick or Treat?", "Trick or Treat?") in choices
	switch(choice)
		if("Trick")
			trick(C)
			return
		if("Treat")
			if(check_candies(C))
				treat(C, gender)
			else
				visible_message("<b>[src]</b> raises an eyebrow, <span class='spooky'>\"You've nae got any candies Ah want! They're the orange round ones, now bugger off an go get em first.\"</span>")
			return
		if("How do I get candies?")
			visible_message("<b>[src]</b> says, <span class='spooky'>\"Gae find my familiar; Bartholomew. Ee's tendin the cauldron which ken bring oot t' magic energy in items scattered aroond. Knowing him, ee's probably gone tae somewhere with books.\"</span>")
			return

/mob/living/simple_animal/jacq/proc/treat(mob/living/carbon/C, gender)
	visible_message("<b>[src]</b> gives off a glowing smile, <span class='spooky'>\"What ken Ah offer ye? I can magic up an object, a potion or a plushie fer ye.\"</span>")
	var/choices_reward = list("Object - 3 candies", "Potion - 2 candies", "Jacqueline Tracker - 2 candies", "Plushie - 1 candy", "Can I get to know you instead?", "Become a pumpkinhead dullahan (perma) - 4 candies")
	var/choice_reward = input(usr, "Trick or Treat?", "Trick or Treat?") in choices_reward

	//rewards
	switch(choice_reward)
		if("Become a pumpkinhead dullahan (perma) - 4 candies")
			if(!take_candies(C, 4))
				visible_message("<b>[src]</b> raises an eyebrown, <span class='spooky'>\"It's 4 candies for that [gender]! Thems the rules!\"</span>")
				return
			visible_message("<b>[src]</b> waves their arms around, <span class='spooky'>\"Off comes your head, a pumpkin taking it's stead!\"</span>")
			C.reagents.add_reagent(/datum/reagent/mutationtoxin/pumpkinhead, 5)
			sleep(20)
			poof()
			return

		if("Object - 3 candies")
			if(!take_candies(C, 3))
				visible_message("<b>[src]</b> raises an eyebrown, <span class='spooky'>\"It's 3 candies per trinket [gender]! Thems the rules!\"</span>")
				return

			var/new_obj = pick(subtypesof(/obj))
			//for(var/item in blacklist)
			//	if(new_obj == item)
			//  	panic()
			var/reward = new new_obj(C.loc)
			C.put_in_hands(reward)
			visible_message("<b>[src]</b> waves her hands, magicking up a [reward] from thin air, <span class='spooky'>\"There ye are [gender], enjoy! \"</span>")
			sleep(20)
			poof()
			return
		if("Potion - 2 candies")
			if(!take_candies(C, 2))
				visible_message("<b>[src]</b> raises an eyebrow, <span class='spooky'>\"It's 2 candies per potion [gender]! Thems the rules!\"</span>")
				return

			var/reward = new /obj/item/reagent_containers/potion_container(C.loc)
			C.put_in_hands(reward)
			visible_message("<b>[src]</b> waves her hands, magicking up a [reward] from thin air, <span class='spooky'>\"There ye are [gender], enjoy! \"</span>")
			sleep(20)
			poof()
			return
		if("Plushie - 1 candy")
			if(!take_candies(C, 1))
				visible_message("<b>[src]</b> raises an eyebrow, <span class='spooky'>\"It's 1 candy per plushie [gender]! Thems the rules!\"</span>")
				return

			new /obj/item/toy/plush/random(C.loc)
			visible_message("<b>[src]</b> waves her hands, magicking up a plushie from thin air, <span class='spooky'>\"There ye are [gender], enjoy! \"</span>")
			sleep(20)
			poof()
			return
		if("Jacqueline Tracker - 2 candies")
			if(!take_candies(C, 2))
				visible_message("<b>[src]</b> raises an eyebrow, <span class='spooky'>\"It's 1 candy per plushie [gender]! Thems the rules!\"</span>")
				return
			new /obj/item/pinpointer/jacq(C.loc)
			visible_message("<b>[src]</b> waves her hands, magicking up a tracker from thin air, <span class='spooky'>\"Feels weird to magic up a tracker fer meself but, here ye are [gender], enjoy! \"</span>")
			sleep(20)
			poof()
			return

		//chitchats!
		if("Can I get to know you instead?")
			var/choices = list()
			//Figure out where the C is in the story
			if(!progression["[C.real_name]"]) //I really don't want to get here withoot a hello, but just to be safe
				progression["[C.real_name]"] = NONE
			if(!(progression["[C.real_name]"] & JACQ_FAR))
				if(progression["[C.real_name]"] & JACQ_CANDIES)
					choices += "You really came all this way for candy?"
				else
					choices += "Why do you want the candies?"
			if(!(progression["[C.real_name]"] & JACQ_HEAD))
				choices += "What is that on your head?"
			if(!(progression["[C.real_name]"] & JACQ_EXPELL))
				if(progression["[C.real_name]"] & JACQ_WITCH)
					choices += "So you got ex-spell-ed?"
				else
					choices += "Are you a witch?"

			//for Kepler, delete this, or just delete the whole story aspect if you want.
			//If fully completed
			/*
			if(progression["[C.real_name]"] & JACQ_FAR)//Damnit this is a pain
				if(progression["[C.real_name]"] & JACQ_EXPELL) //I give up
					if(progression["[C.real_name]"] & JACQ_HEAD) //This is only an event thing
						choices += "Can I take you out on a date?"
			*/
			if(progression["[C.real_name]"] == 63)//Damnit this is a pain
				choices += "Can I take you out on a date?"

			//If you've nothing to ask
			if(!LAZYLEN(choices))
				visible_message("<b>[src]</b> sighs, <span class='spooky'>\"Ah'm all questioned oot fer noo, [gender].\"</span>")
				return
			//Otherwise, lets go!
			visible_message("<b>[src]</b> says, <span class='spooky'>\"A question? Sure, it'll cost you a candy though!\"</span>")
			choices += "Nevermind"
			//Candies for chitchats
			var/choice = input(C, "What do you want to ask?", "What do you want to ask?") in choices
			if(!take_candies(C, 1))
				visible_message("<b>[src]</b> raises an eyebrow, <span class='spooky'>\"It's a candy per question [gender]! Thems the rules!\"</span>")
				return
			//Talking
			switch(choice)
				if("Why do you want the candies?")
					visible_message("<b>[src]</b> says, <span class='spooky'>\"Ave ye tried them? They're full of all sorts of reagents. Ah'm after them so ah ken magic em up an hopefully find rare stuff fer me brews. Honestly it's a lot easier magicking up tatt fer ye lot than runnin aroond on me own like. I'd ask me familiars but most a my familiars are funny fellows 'n constantly bugger off on adventures when given simple objectives like; Go grab me a tea cake or watch over me cauldron. Ah mean, ye might run into Bartholomew my cat. Ee's supposed tae be tending my cauldron, but I've nae idea where ee's got tae.\"</span>")
					progression["[C.real_name]"] = progression["[C.real_name]"] | JACQ_CANDIES
					sleep(30)

				if("You really came all this way for candy?")
					visible_message("<b>[src]</b> l ooks tae the side sheepishly, <span class='spooky'>\"Aye, well, tae be honest, Ah'm here tae see me sis, but dunnae let her knew that. She's an alchemist too like, but she dunnae use a caldron like mae, she buggered off like tae her posh ivory tower tae learn bloody chemistry instead!\"</span> <b>[src]</b> scowls, <span class='spooky'>\"She's tae black sheep o' the family too, so we dunnae see eye tae eye sometimes on alchemy. Ah mean, she puts <i> moles </i> in her brews! Ye dunnae put moles in yer brews! Yae threw your brews at tae wee bastards an blew em up!\"</span> <b>[src]</b> sighs, <span class='spooky'>\"But she's a heart o gold so.. Ah wanted tae see her an check up oon her, make sure she's okay.\"</span>")
					progression["[C.real_name]"] = progression["[C.real_name]"] | JACQ_FAR
					sleep(30)

				if("What is that on your head?")
					visible_message("<b>[src]</b> pats the pumpkin atop her head, <span class='spooky'>\"This thing? This ain't nae ordinary pumpkin! Me Ma grew this monster ooer a year o love, dedication an hard work. Honestly it felt like she loved this thing more than any of us, which Ah knew ain't true an it's not like she was hartless or anything but.. well, we had a falling oot when Ah got back home with all me stuff in tow. An all she had done is sent me owl after owl over t' last year aboot this bloody pumpkin and ah had enough. So ah took it, an put it on me head. You know, as ye do. Ah am the great Pumpqueen after all, Ah deserve this.\"</span>")
					progression["[C.real_name]"] = progression["[C.real_name]"] | JACQ_HEAD
					sleep(30)

				if("Are you a witch?")
					visible_message("<b>[src]</b> grumbles, <span class='spooky'>\"If ye must know, Ah got kicked oot of the witch academy fer being too much of a \"loose cannon\". A bloody loose cannon? Nae they were just pissed off Ah had the brass tae proclaim myself as the Pumpqueen! And also maybe the time Ah went and blew up one of the towers by trying tae make a huge batch of astrogen might've had something tae do with it. Ah mean it would've worked fine if the cauldrons weren't so shite and were actually upgraded by the faculty. So technically no, I'm not a witch.\"</span>")
					progression["[C.real_name]"] = progression["[C.real_name]"] | JACQ_WITCH
					sleep(30)

				if("So you got ex-spell-ed?")
					visible_message("<b>[src]</b> Gives you a blank look at the pun, before continuing, <span class='spooky'>\"Not quite, Ah know Ah ken get back into the academy, it's only an explosion, they happen all the time, but, tae be fair it's my fault that things came tae their explosive climax. You don't know what it's like when you're after a witch doctorate, everyone else is doing well, everyone's making new spells and the like, and I'm just good at making explosions really, or fireworks. So, Ah did something Ah knew was dangerous, because Ah had tae do something tae stand oot, but Ah know this life ain't fer me, Ah don't want tae be locked up in dusty towers, grinding reagent after reagent together, trying tae find new reactions, some of the wizards in there haven't left fer years. Ah want tae live, Ah want tae fly around on a broom, turn people into cats fer a day and disappear cackling! That's what got me into witchcraft!\"</span> she throws her arms up in the arm, spinning the pumpkin upon her head slightly. She carefully spins it back to face you, giving oot a soft sigh, <span class='spooky'>\"Ah know my mother's obsession with this dumb thing on my head is just her trying tae fill the void of me and my sis moving oot, and it really shouldn't be on my head. And Ah know that I'm really here tae get help from my sis.. She's the sensible one, and she gives good hugs.\"</span>")
					sleep(30)
					visible_message("<b>[src]</b> says, <span class='spooky'>\"Thanks [C], Ah guess Ah didn't realise Ah needed someone tae talk tae but, I'm glad ye spent all your candies talking tae me. Funny how things seem much worse in yer head.\"</span>")
					progression["[C.real_name]"] = progression["[C.real_name]"] | JACQ_EXPELL
					sleep(30)

				if("Can I take you out on a date?")
					visible_message("<b>[src]</b> blushes, <span class='spooky'>\"...You want tae ask me oot on a date? Me? After all that nonsense Ah just said? It seems a waste of a candy honestly.\"</span>")
					//progression["[C.real_name]"] = progression["[C.real_name]"] | JACQ_DATE
					visible_message("<b>[src]</b> looks to the side, deep in thought.</span>")
					dating_start(C, gender)

				if("Nevermind")
					visible_message("<b>[src]</b> shrugs, <span class='spooky'>\"Suit yerself then, here's your candy back.\"</span>")
					new /obj/item/reagent_containers/food/snacks/special_candy(loc)


/mob/living/simple_animal/jacq/proc/trick(mob/living/carbon/C, gender)
	var/option
	if(ishuman(C))
		option = rand(1,6)
	else
		option = rand(1,5)
	switch(option)
		if(1)
			visible_message("<b>[src]</b> waves their arms around, <span class='spooky'>\"Hocus pocus, making friends is now your focus!\"</span>")
			var/message = pick("make a tasty sandwich for", "compose a poem for", "aquire a nice outfit to give to", "strike up a conversation about pumpkins with", "write a letter and deliver it to", "give a nice hat to")
			var/mob/living/L2 = pick(GLOB.player_list)
			message += " [L2.name]."
			to_chat(C, "<span class='big warning'> You feel an overwhelming desire to [message]")
		if(2)
			visible_message("<b>[src]</b> waves their arms around, <span class='spooky'>\"If only you had a better upbringing, your ears are now full of my singing!\"</span>")
			var/client/C2 = C.client
			C2.chatOutput.sendMusic("https://puu.sh/ExBbv.mp4", 1)//I hope this works!
		if(3)
			visible_message("<b>[src]</b> waves their arms around, <span class='spooky'>\"You're cute little bumpkin, On your head is a pumpkin!\"</span>")
			if(C.head)
				var/obj/item/W = C.head
				C.dropItemToGround(W, TRUE)
			var/jaqc_latern = new /obj/item/clothing/head/hardhat/pumpkinhead/jaqc
			C.equip_to_slot(jaqc_latern, SLOT_HEAD, 1, 1)
		if(4)
			visible_message("<b>[src]</b> waves their arms around, <span class='spooky'>\"In your body there's something amiss, you'll find it's a chem made by my sis!\"</span>")
			C.reagents.add_reagent(/datum/reagent/fermi/eigenstate, 30)
		if(5)
			visible_message("<b>[src]</b> waves their arms around, <span class='spooky'>\"A new familiar for me, and you'll see it's thee!\"</span>")
			C.reagents.add_reagent("secretcatchem", 30)
		if(6)
			visible_message("<b>[src]</b> waves their arms around, <span class='spooky'>\"While you may not be a ghost, for this sheet you'll always be it's host.\"</span>")
			var/mob/living/carbon/human/H = C
			if(H.wear_suit)
				var/obj/item/W = H.wear_suit
				H.dropItemToGround(W, TRUE)
			var/ghost = new /obj/item/clothing/suit/ghost_sheet/sticky
			H.equip_to_slot(ghost, SLOT_WEAR_SUIT, 1, 1)
	poof()

//Blame Fel
/mob/living/simple_animal/jacq/proc/dating_start(mob/living/carbon/C, gender)
	var/candies = pollGhostCandidates("Do you want to go on a date with [C] as Jacqueline the great pumpqueen?")
	//sleep(30) //If the poll doesn't autopause.
	if(candies)
		candies = shuffle(candies)//Shake those ghosts up!
		for(var/mob/dead/observer/C2 in candies)
			if(C2.key && C2)
				key = C2.key
				message_admins("[C2]/[C2.key] has agreed to go on a date with [C] as Jacqueline.")
				log_game("HALLOWEEN: [C2]/[C2.key] has agreed to go on a date with [C] as Jacqueline")
				to_chat(src, "<span class='big spooky'>You are Jacqueline the great pumpqueen, witch Extraordinaire! You're a very Scottish lass with a kind heart, but also a little crazy. You also blew up the wizarding school and you're suspended for a while, so you visited the station before heading home. On your head lies the prize pumpkin of your Mother's pumpkin patch. You're currently on a date with [C] and well, I didn't think anyone would get this far. <i> Please be good so I can do events like this in the future. </i> </span>")
				return
			else
				candies =- C2
	visible_message("<b>[src]</b> looks to the side, <span class='spooky'>\"Look, Ah like ye but, Ah don't think Ah can right now. If ye can't tell, the stations covered in volatile candies, I've a few other laddies and lassies running after me treats, and tae top it all off, I've the gods breathing down me neck, watching every treat Ah make fer the lot of yous.\" she sighs, \"But that's not a no, right? That's.. just a nae right noo.\"</span>")
	sleep(20)
	visible_message("<b>[src]</b> takes off the pumpkin on her head, a rich blush on her cheeks. She leans over planting a kiss upon your forehead quickly befere popping the pumpkin back on her head.")
	sleep(10)
	visible_message("<b>[src]</b> waves their arms around, <span class='spooky'>\"There, that aught tae be worth a candy.\"</span>")
	sleep(20)
	poof()

/mob/living/simple_animal/jacq/update_mobility()
	. = ..()
	if(busy_chatting)
		DISABLE_BITFIELD(., MOBILITY_MOVE)
		mobility_flags = .

/obj/item/clothing/head/hardhat/pumpkinhead/jaqc
	name = "Jacq o' latern"
	desc = "A jacqueline o' lantern! You can't seem to get rid of it."
	icon_state = "hardhat0_pumpkin_j"
	item_state = "hardhat0_pumpkin_j"
	hat_type = "pumpkin_j"
	brightness_on = 4

/obj/item/clothing/head/hardhat/pumpkinhead/jaqc/Initialize()
	. = ..()
	ADD_TRAIT(src, TRAIT_NODROP, GLUED_ITEM_TRAIT)

/obj/item/clothing/suit/ghost_sheet/sticky

/obj/item/clothing/suit/ghost_sheet/sticky/Initialize()
	. = ..()
	ADD_TRAIT(src, TRAIT_NODROP, GLUED_ITEM_TRAIT)

/obj/item/clothing/suit/ghost_sheet/sticky/attack_hand(mob/user)
	if(iscarbon(user))
		to_chat(user, "<span class='spooky'><i>Boooooo~!</i></span>")
		return
	else
		..()

/obj/item/clothing/suit/ghost_sheet/sticky/attack_hand(mob/user)
	if(iscarbon(user))
		to_chat(user, "<span class='spooky'><i>Boooooo~!</i></span>")
		return
	else
		..()

/datum/reagent/mutationtoxin/pumpkinhead
	name = "Pumpkin head mutation toxin"
	race = /datum/species/dullahan/pumpkin
	mutationtext = "<span class='spooky'>The pain subsides. You feel your head roll off your shoulders... and you smell pumpkin."
	//I couldn't get the replace head sprite with a pumpkin to work so, it is what it is.

/mob/living/simple_animal/jacq/proc/check_candies(mob/living/carbon/C)
	var/invs = C.get_contents()
	var/candy_count = 0
	for(var/item in invs)
		if(istype(item, /obj/item/reagent_containers/food/snacks/special_candy))
			candy_count++
	return candy_count

/mob/living/simple_animal/jacq/proc/take_candies(mob/living/carbon/C, candy_amount = 1)
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

//Potions
/obj/item/reagent_containers/potion_container
	name = "potion"
	icon = 'icons/obj/halloween_items.dmi'
	icon_state = "jacq_potion"
	desc = "A potion with a strange concoction within. Be careful, as if it's thrown it explodes in a puff of smoke like Jacqueline."

/obj/item/reagent_containers/potion_container/Initialize()
	.=..()
	var/R = get_random_reagent_id()
	reagents.add_reagent(R, 30)
	name = "[R] Potion"

/obj/item/reagent_containers/potion_container/throw_impact(atom/hit_atom, datum/thrownthing/throwingdatum)
	..()
	sleep(20)
	var/datum/effect_system/smoke_spread/chem/s = new()
	s.set_up(src.reagents, 3, src.loc)
	s.start()
	qdel(src)

//Candies
/obj/item/reagent_containers/food/snacks/special_candy
	name = "Magic candy"
	icon = 'icons/obj/halloween_items.dmi'
	icon_state = "jacq_candy"
	desc = "A candy with strange magic within. Be careful, as the magic isn't always helpful."

/obj/item/reagent_containers/food/snacks/special_candy/Initialize()
	.=..()
	reagents.add_reagent(get_random_reagent_id(), 5)
