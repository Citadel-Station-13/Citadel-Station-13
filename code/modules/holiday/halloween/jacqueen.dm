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
	/// I'm busy, don't move.
	var/busy = FALSE
	var/spawn_cars = FALSE

	var/static/blacklisted_items = typecacheof(list(
		/obj/effect,
		/obj/belly,
		/obj/mafia_game_board,
		/obj/docking_port,
		/obj/shapeshift_holder,
		/atom/movable/screen
	))

/mob/living/simple_animal/jacq/Initialize(mapload)
	. = ..() //fuck you jacq, return a hint you shit
	cached_z = z
	poof()

/mob/living/simple_animal/jacq/ComponentInitialize() //she just wants to bring halloween to the station
	. = ..()
	AddComponent(/datum/component/stationloving)

/mob/living/simple_animal/jacq/BiologicalLife(delta_time, times_fired)
	if(!(. = ..()))
		return
	if(!ckey)
		if((last_poof+3 MINUTES) < world.realtime)
			poof()

/mob/living/simple_animal/jacq/death() //What is alive may never die
	visible_message("<b>[src]</b> cackles, <span class='spooky'>\"You'll nae get rid a me that easily!\"</span>")
	playsound(loc, 'sound/spookoween/ahaha.ogg', 100, 0.25)
	fully_heal(FALSE)
	health = 25
	poof()

/mob/living/simple_animal/jacq/gib()
	visible_message("<b>[src]</b> cackles, <span class='spooky'>\"You'll nae get rid a me that easily!\"</span>")
	playsound(loc, 'sound/spookoween/ahaha.ogg', 100, 0.25)
	fully_heal(FALSE)
	health = 25
	poof()

/mob/living/simple_animal/jacq/on_attack_hand(mob/living/carbon/human/M)
	if(spawn_cars)
		spawn_cars(M)
		return ..()
	if(!active)
		say("Hello there [gender_check(M)]!")
		return ..()
	if(!ckey)
		stopmove()
		chit_chat(M)
		canmove()
	..()

/mob/living/simple_animal/jacq/attack_paw(mob/living/carbon/monkey/M)
	if(spawn_cars)
		spawn_cars(M)
		return ..()
	if(!active)
		say("Hello there [gender_check(M)]!")
		return ..()
	if(!ckey)
		stopmove()
		chit_chat(M)
		canmove()
	..()

/mob/living/simple_animal/jacq/proc/canmove()
	busy = FALSE
	update_mobility()

/mob/living/simple_animal/jacq/proc/stopmove()
	if(ckey) //if someone is in her, don't disable her movement!
		canmove()
		return
	busy = TRUE
	update_mobility()

/mob/living/simple_animal/jacq/proc/jacqrunes(message, mob/living/carbon/C) //Displays speechtext over Jacq for the user only.
	var/atom/hearer = C
	var/list/spans = list("spooky")
	new /datum/chatmessage(message, src, hearer, spans)


/mob/living/simple_animal/jacq/proc/poof()
	if(!active)//if disabled, don't poof
		return
	last_poof = world.realtime
	var/datum/reagents/R = new/datum/reagents(100)//Hey, just in case.
	var/datum/effect_system/smoke_spread/chem/s = new()
	R.add_reagent(/datum/reagent/fermi/secretcatchem, 10)
	s.set_up(R, 0, loc)
	s.start()
	visible_message("<b>[src]</b> disappears in a puff of smoke!")
	canmove()
	health = 25

	//Try to go to populated areas
	var/list/pop_areas = list()
	for(var/mob/living/L in GLOB.player_list)
		var/area/A = get_area(L)
		pop_areas += A

	var/list/targets = list()
	for(var/H in GLOB.the_station_areas)
		var/area/A = get_area(H)
		if(!A || findtextEx(A.name, "AI") || !(A in pop_areas) || !is_station_level(H))
			continue
		targets += H

	if(!targets.len)
		targets = GLOB.generic_event_spawns

	for(var/i in 1 to 6) //Attempts a jump up to 6 times.
		var/atom/A = pick(targets)
		if(do_teleport(src, A, channel = TELEPORT_CHANNEL_MAGIC))
			return TRUE
		targets -= A
	return FALSE

/mob/living/simple_animal/jacq/proc/gender_check(mob/living/carbon/C)
	. = "lamb"
	switch(C)
		if(MALE)
			. = "laddie"
		if(FEMALE)
			. = "lassie"

//Ye wee bugger, gerrout of it. Ye've nae tae enjoy reading the code fer mae secrets like.
/mob/living/simple_animal/jacq/proc/chit_chat(mob/living/carbon/C)
	//Very important
	var/gender = gender_check(C)
	// it physicaly cannot fail*. Why is there a fucking dupe

	if(!progression["[C.real_name]"] ||  !(progression["[C.real_name]"] & JACQ_HELLO))
		visible_message("<b>[src]</b> smiles ominously at [C], <span class='spooky'>\"Well halo there [gender]! Ah'm Jacqueline, tae great Pumpqueen, great tae meet ye.\"</span>")
		jacqrunes("Well halo there [gender]! Ah'm Jacqueline, tae great Pumpqueen, great tae meet ye.", C)
		sleep(20)
		visible_message("<b>[src]</b> continues, <span class='spooky'>\"Ah'm sure yae well stunned, but ah've got nae taem fer that. Ah'm after the candies around this station. If yae get mae enoof o the wee buggers, Ah'll give ye a treat, or if yae feeling bold, Ah ken trick ye instead.</span>\" giving [C] a wide grin.")
		jacqrunes("Ah'm sure yae well stunned, but ah've got nae taem fer that. Ah'm after the candies around this station. If yae get mae enoof o the wee buggers, Ah'll give ye a treat, or if yae feeling bold, Ah ken trick ye instead.", C)
		if(!progression["[C.real_name]"])
			progression["[C.real_name]"] = NONE //TO MAKE SURE THAT THE LIST ENTRY EXISTS.

		progression["[C.real_name]"] = progression["[C.real_name]"] | JACQ_HELLO

	var/choices = list("Trick", "Treat", "How do I get candies?", "Do I know you from somewhere?")
	var/choice = input(C, "Trick or Treat?", "Trick or Treat?") in choices
	switch(choice)
		if("Trick")
			trick(C)
			return
		if("Treat")
			if(check_candies(C))
				treat(C, gender)
			else
				visible_message("<b>[src]</b> raises aneyebrow, <span class='spooky'>\"You've nae got any candies Ah want! They're the orange round ones, now bugger off an go get em first.\"</span>")
				jacqrunes("You've nae got any candies Ah want! They're the orange round ones, now bugger off an go get em first.", C)
			return
		if("How do I get candies?")
			visible_message("<b>[src]</b> says, <span class='spooky'>\"Gae find my familiar; Bartholomew. Ee's tendin the cauldron which ken bring oot t' magic energy in items scattered aroond. Knowing him, ee's probably gone tae somewhere with books.\"</span>")
			jacqrunes("Gae find my familiar; Bartholomew. Ee's tendin the cauldron which ken bring oot t' magic energy in items scattered aroond. Knowing him, ee's probably gone tae somewhere with books.", C)
			return
		if("Do I know you from somewhere?")
			visible_message("<b>[src]</b> says, <span class='spooky'>\"Aye ye micht dae, ah was kicking aboot round 'ere aboot a year ago when ah had a wee... altercation wit the witch academy n' ran oot here tae crash oan me sis's floor. Course she pushed me tae git it a' sorted oot lik', bit nae before ah hud a wee bit o' fun oan this station. Or maybe ye jest recognise me ma's prized pumpkin atop me nonce.\"</span>")
			jacqrunes("Aye ye micht dae, ah was kicking aboot round 'ere aboot a year ago when ah had a wee... altercation wit the witch academy n' ran oot here tae crash oan me sis's floor. Course she pushed me tae git it a' sorted oot lik', bit nae before ah hud a wee bit o' fun oan this station. Or maybe ye jest recognise me ma's prized pumpkin atop me nonce.", C)

/mob/living/simple_animal/jacq/proc/treat(mob/living/carbon/C, gender)
	visible_message("<b>[src]</b> gives off a glowing smile, <span class='spooky'>\"What ken Ah offer ye? I can magic up an object, a potion or a plushie fer ye.\"</span>")
	jacqrunes("What ken Ah offer ye? I can magic up an object, a potion or a plushie fer ye.", C)
	var/choices_reward = list("Object - 3 candies", "Potion - 2 candies", "Jacqueline Tracker - 2 candies", "Plushie - 1 candy", "Can I get to know you instead?", "Become a pumpkinhead dullahan (perma) - 4 candies")
	var/choice_reward = input(usr, "Trick or Treat?", "Trick or Treat?") in choices_reward

	//rewards
	switch(choice_reward)
		if("Become a pumpkinhead dullahan (perma) - 4 candies")
			if(!take_candies(C, 4))
				visible_message("<b>[src]</b> raises an eyebrown, <span class='spooky'>\"It's 4 candies for that [gender]! Thems the rules!\"</span>")
				jacqrunes("It's 4 candies for that [gender]! Thems the rules!", C)
				return
			visible_message("<b>[src]</b> waves their arms around, <span class='spooky'>\"Off comes your head, a pumpkin taking it's stead!\"</span>")
			jacqrunes("Off comes your head, a pumpkin taking it's stead!", C)
			C.reagents.add_reagent(/datum/reagent/mutationtoxin/pumpkinhead, 5)
			sleep(20)
			poof()
			return

		if("Object - 3 candies")
			if(!take_candies(C, 3))
				visible_message("<b>[src]</b> raises an eyebrown, <span class='spooky'>\"It's 3 candies per trinket [gender]! Thems the rules!\"</span>")
				jacqrunes("It's 3 candies per trinket [gender]! Thems the rules!", C)
				return

			var/new_obj = pick(subtypesof(/obj))
			for(var/item in blacklisted_items)
				if(is_type_in_typecache(new_obj, blacklisted_items))
					new_obj = /obj/item/reagent_containers/food/snacks/special_candy
			var/reward = new new_obj(C.loc)
			if(new_obj == /obj/item/reagent_containers/food/snacks/special_candy)
				new new_obj(C.loc)
				new new_obj(C.loc) //Giving them back their candies in case it's something from the blacklist or if the game literally rolled candies. What rotten luck.
			C.put_in_hands(reward)
			visible_message("<b>[src]</b> waves her hands, magicking up a [reward] from thin air, <span class='spooky'>\"There ye are [gender], enjoy! \"</span>")
			jacqrunes("There ye are [gender], enjoy!", C)
			sleep(20)
			poof()
			return
		if("Potion - 2 candies")
			if(!take_candies(C, 2))
				visible_message("<b>[src]</b> raises an eyebrow, <span class='spooky'>\"It's 2 candies per potion [gender]! Thems the rules!\"</span>")
				jacqrunes("It's 2 candies per potion [gender]! Thems the rules!", C)
				return

			var/reward = new /obj/item/reagent_containers/potion_container(C.loc)
			C.put_in_hands(reward)
			visible_message("<b>[src]</b> waves her hands, magicking up a [reward] from thin air, <span class='spooky'>\"There ye are [gender], enjoy! \"</span>")
			jacqrunes("There ye are [gender], enjoy!", C)
			sleep(20)
			poof()
			return
		if("Plushie - 1 candy")
			if(!take_candies(C, 1))
				visible_message("<b>[src]</b> raises an eyebrow, <span class='spooky'>\"It's 1 candy per plushie [gender]! Thems the rules!\"</span>")
				jacqrunes("It's 1 candy per plushie [gender]! Thems the rules!", C)
				return

			new /obj/item/toy/plush/random(C.loc)
			visible_message("<b>[src]</b> waves her hands, magicking up a plushie from thin air, <span class='spooky'>\"There ye are [gender], enjoy! \"</span>")
			jacqrunes("There ye are [gender], enjoy!", C)
			sleep(20)
			poof()
			return
		if("Jacqueline Tracker - 2 candies")
			if(!take_candies(C, 2))
				visible_message("<b>[src]</b> raises an eyebrow, <span class='spooky'>\"It's 1 candy per plushie [gender]! Thems the rules!\"</span>")
				jacqrunes("It's 1 candy per plushie [gender]! Thems the rules!", C)
				return
			new /obj/item/pinpointer/jacq(C.loc)
			visible_message("<b>[src]</b> waves her hands, magicking up a tracker from thin air, <span class='spooky'>\"Feels weird to magic up a tracker fer meself but, here ye are [gender], enjoy! \"</span>")
			jacqrunes("Feels weird to magic up a tracker fer meself but, here ye are [gender], enjoy!", C)
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
					choices += "What is it like being a witch?"
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
				jacqrunes("Ah'm all questioned oot fer noo, [gender]", C)
				return
			//Otherwise, lets go!
			visible_message("<b>[src]</b> says, <span class='spooky'>\"A question? Sure, it'll cost you a candy though!\"</span>")
			jacqrunes("A question? Sure, it'll cost you a candy though!", C)
			choices += "Nevermind"
			//Candies for chitchats
			var/choice = input(C, "What do you want to ask?", "What do you want to ask?") in choices
			if(!take_candies(C, 1))
				visible_message("<b>[src]</b> raises an eyebrow, <span class='spooky'>\"It's a candy per question [gender]! Thems the rules!\"</span>")
				jacqrunes("It's a candy per question [gender]! Thems the rules!", C)
				return
			//Talking
			switch(choice)
				if("Why do you want the candies?")
					visible_message("<b>[src]</b> says, <span class='spooky'>\"Ave ye tried them? They're full of all sorts of reagents. Ah'm after them so ah ken magic em up an hopefully find rare stuff fer me brews. Honestly it's a lot easier magicking up tatt fer ye lot than runnin aroond on me own like. I'd ask me familiars but most a my familiars are funny fellows 'n constantly bugger off on adventures when given simple objectives like; Go grab me a tea cake or watch over me cauldron. Ah mean, ye might run into Bartholomew my cat. Ee's supposed tae be tending my cauldron, but I've nae idea where ee's got tae.\"</span>")
					jacqrunes("Ave ye tried them? They're full of all sorts of reagents. Ah'm after them so ah ken magic em up an hopefully find rare stuff fer me brews. Honestly it's a lot easier magicking up tatt fer ye lot than runnin aroond on me own like. I'd ask me familiars but most a my familiars are funny fellows 'n constantly bugger off on adventures when given simple objectives like; Go grab me a tea cake or watch over me cauldron. Ah mean, ye might run into Bartholomew my cat. Ee's supposed tae be tending my cauldron, but I've nae idea where ee's got tae.", C)
					progression["[C.real_name]"] = progression["[C.real_name]"] | JACQ_CANDIES
					sleep(30)

				if("You really came all this way for candy?")
					visible_message("<b>[src]</b> looks to the side sheepishly, <span class='spooky'>\"Aye, well, tae be honest, Ah'm here tae see me sis, but dunnae let her knew that. She's an alchemist too like, but she dunnae use a caldron like mae, she buggered off like tae her posh ivory tower tae learn bloody chemistry instead!\"</span> <b>[src]</b> scowls, <span class='spooky'>\"She's tae black sheep o' the family too, so we dunnae see eye tae eye sometimes on alchemy. Ah mean, she puts <i> moles </i> in her brews! Ye dunnae put moles in yer brews! Yae threw your brews at tae wee bastards an blew em up!\"</span> <b>[src]</b> sighs, <span class='spooky'>\"But she's a heart o gold so.. Ah wanted tae see her an check up oon her, make sure she's okay.\"</span>")
					jacqrunes("Aye, well, tae be honest, Ah'm here tae see me sis, but dunnae let her knew that. She's an alchemist too like, but she dunnae use a caldron like mae, she buggered off like tae her posh ivory tower tae learn bloody chemistry instead", C)
					progression["[C.real_name]"] = progression["[C.real_name]"] | JACQ_FAR
					sleep(10)
					jacqrunes("She's tae black sheep o' the family too, so we dunnae see eye tae eye sometimes on alchemy. Ah mean, she puts moles in her brews! Ye dunnae put moles in yer brews! Yae threw your brews at tae wee bastards an blew em up!", C)
					sleep(10)
					jacqrunes("But she's a heart o gold so.. Ah wanted tae see her an check up oon her, make sure she's okay.", C)
					sleep(10)

				if("What is that on your head?")
					visible_message("<b>[src]</b> pats the pumpkin atop her head, <span class='spooky'>\"This thing? This ain't nae ordinary pumpkin! Me Ma grew this monster ooer a year o love, dedication an hard work. Honestly I got bloody sick o'er harpin' on aboot it, all she had done is sent me owl after owl over aboot this bloody pumpkin since i left the nest and ah had enough after a ... mild altercation like. So I nabbed it last halloween. Caught bloody hell fer it ah did, course me sis talked to me ma and, well, simmered her doon. We've all but made up noo, but seein' as ah'm the great Pumpqueen after all, I cannae be seen withoot it like.\"</span>")
					jacqrunes("This thing? This ain't nae ordinary pumpkin! Me Ma grew this monster ooer a year o love, dedication an hard work. Honestly I got bloody sick o'er harpin' on aboot it, all she had done is sent me owl after owl over aboot this bloody pumpkin since i left the nest and ah had enough after a ... mild altercation like. So I nabbed it last halloween. Caught bloody hell fer it ah did, course me sis talked to me ma and, well, simmered her doon. We've all but made up noo, but seein' as ah'm the great Pumpqueen after all, I cannae be seen withoot it like.", C)
					progression["[C.real_name]"] = progression["[C.real_name]"] | JACQ_HEAD
					sleep(30)

					//Year 1 answer: for anyone who is interested!
					/*This thing? This ain't nae ordinary pumpkin! Me Ma grew this monster ooer a year o love, dedication an hard work. Honestly it felt like she loved this thing more than any of us, which Ah knew ain't true an it's not like she was hartless or anything but.. well, we had a falling oot when Ah got back home with all me stuff in tow. An all she had done is sent me owl after owl over t' last year aboot this bloody pumpkin and ah had enough. So ah took it, an put it on me head. You know, as ye do. Ah am the great Pumpqueen after all, Ah deserve this.*/

				if("Are you a witch?")
					visible_message("<b>[src]</b> smirks, <span class='spooky'>\"Weel, after getting kicked oot over a <i>very minor</i> explosion last year, ah wis able tae git back in 'n' finish me witching degree thanks tae me sis! 'twas bloody brutal finishing th' degree though, ah will tell ye, ye take a peek o'er at t' other witches all prim 'n' proper like 'n' it gets in yer heid, ye'r nae as guid. But ah bloody well ended up summoning Nar'Sie last year for the lot o' yous. Aye a'm a loose cannon - but ah get results.\"</span> thumping her chest with pride as she finishes speaking.")
					jacqrunes("Weel, after getting kicked oot over a very minor explosion last year, ah wis able tae git back in 'n' finish me witching degree thanks tae me sis! 'twas bloody brutal finishing th' degree though, ah will tell ye, ye take a peek o'er at t' other witches all prim 'n' proper like 'n' it gets in yer heid, ye'r nae as guid. But ah bloody well ended up summoning Nar'Sie last year for the lot o' yous. Aye a'm a loose cannon - but ah get results." , C)
					progression["[C.real_name]"] = progression["[C.real_name]"] | JACQ_WITCH
					sleep(30)

					//Year 1 answer for anyone who is interested:
					/* Are you a witch?
					If ye must know, Ah got kicked oot of the witch academy fer being too much of a \"loose cannon\". A bloody loose cannon? Nae they were just pissed off Ah had the brass tae proclaim myself as the Pumpqueen! And also maybe the time Ah went and blew up one of the towers by trying tae make a huge batch of astrogen might've had something tae do with it. Ah mean it would've worked fine if the cauldrons weren't so shite and were actually upgraded by the faculty. So technically no, I'm not a witch.*/

				if("What is it like being a witch?") //What is it like being a witch?

					visible_message("<b>[src]</b> says, <span class='spooky'>\"Tae be honest, ah dunnae. Ah mean ah have a piece o’ paper that implies that a’m, ‘n’ a few folk who seem keen in shoving me back in their magic tower, but I don’t know if that’s fer me really.\" </span> she gives the back of her pumpkin a quick scratch as she continues <span class='spooky'> \"What draws me tae witchcraft is the chaos, ah live tae see th’ utter madness that comes fae the spells ah cast ‘n’ th’ like, ‘n’ ah know you do tae, it’s why you’re ‘ere, aye? Ah kin conjure some utterly chaotic things, and ah love tae do it, just tae see what I’ll git! It’s why visiting here is so fun, ye wee lot scurrying about, getting me candies, hoping I’ll conjure up something utterly chaotic!\" </span> she throws her arms up in the arm with a laugh, spinning the pumpkin upon her head slightly. She carefully spins it back to face you, <span class='spooky'> \"But o’ course life ain’t that easy,  ye can’t just go around being a pure agent o’ chaos, ‘n’ ah feel like the reality o’ the world be trying tae dull me, to shove me in a boring dusty auld room where ah spend t’ rest o’ me days researching some boggin’ magic till ah die. Ah want tae bloody well change t’ world, ah want to do something that leaves an impact, but ah dunnae want t’ kill people doing it.\"</span> she gives out a soft sigh, \"Who knows, maybe I’ll bugger off ‘n’ make some pumkinmobiles or something daft like that.\" </span>")
					jacqrunes("Tae be honest, ah dunnae. Ah mean ah have a piece o’ paper that implies that a’m, ‘n’ a few folk who seem keen in shoving me back in their magic tower, but I don’t know if that’s fer me really." , C)
					sleep(10)
					jacqrunes("What draws me tae witchcraft is the chaos, ah live tae see th’ utter madness that comes fae the spells ah cast ‘n’ th’ like, ‘n’ ah know you do tae, it’s why you’re ‘ere, aye? Ah kin conjure some utterly chaotic things, and ah love tae do it, just tae see what I’ll git! It’s why visiting here is so fun, ye wee lot scurrying about, getting me candies, hoping I’ll conjure up something utterly chaotic!" , C)
					sleep(10)
					jacqrunes("But o’ course life ain’t that easy,  ye can’t just go around being a pure agent o’ chaos, ‘n’ ah feel like the reality o’ the world be trying tae dull me, to shove me in a boring dusty auld room where ah spend t’ rest o’ me days researching some boggin’ magic till ah die. Ah want tae bloody well change t’ world, ah want to do something that leaves an impact, but ah dunnae want t’ kill people doing it.", C)
					sleep(10)
					jacqrunes("Who knows, maybe I’ll bugger off ‘n’ make some pumkinmobiles or something daft like that.", C)
					sleep(25)
					visible_message("<b>[src]</b> says, <span class='spooky'>\"Thanks [C], Ah guess Ah didn't realise Ah needed someone tae talk tae but, I'm glad ye spent all your candies talking tae me. Funny how things seem much worse in yer head.\"</span>")
					jacqrunes("Thanks [C], Ah guess Ah didn't realise Ah needed someone tae talk tae but, I'm glad ye spent all your candies talking tae me. Funny how things seem much worse in yer head." , C)
					progression["[C.real_name]"] = progression["[C.real_name]"] | JACQ_EXPELL
					sleep(30)

					//Year 1 answer for anyone who is interested:
					/*"So you got ex-spell-ed?"
					Gives you a blank look at the pun, before continuing, <span class='spooky'>\"Not quite, Ah know Ah ken get back into the academy, it's only an explosion, they happen all the time, but, tae be fair it's my fault that things came tae their explosive climax. You don't know what it's like when you're after a witch doctorate, everyone else is doing well, everyone's making new spells and the like, and I'm just good at making explosions really, or fireworks. So, Ah did something Ah knew was dangerous, because Ah had tae do something tae stand oot, but Ah know this life ain't fer me, Ah don't want tae be locked up in dusty towers, grinding reagent after reagent together, trying tae find new reactions, some of the wizards in there haven't left fer years. Ah want tae live, Ah want tae fly around on a broom, turn people into cats fer a day and disappear cackling! That's what got me into witchcraft!\"</span> she throws her arms up in the arm, spinning the pumpkin upon her head slightly. She carefully spins it back to face you, giving oot a soft sigh, <span class='spooky'>\"Ah know my mother's obsession with this dumb thing on my head is just her trying tae fill the void of me and my sis moving oot, and it really shouldn't be on my head. And Ah know that I'm really here tae get help from my sis.. She's the sensible one, and she gives good hugs.
					*/

				if("Can I take you out on a date?")
					visible_message("<b>[src]</b> blushes, <span class='spooky'>\"...You want tae ask me oot on a date? Me? After all that nonsense Ah just said? It seems a waste of a candy honestly.\"</span>")
					jacqrunes("...You want tae ask me oot on a date? Me? After all that nonsense Ah just said? It seems a waste of a candy honestly." , C)
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
			jacqrunes("Hocus pocus, making friends is now your focus!", C)
			var/message = pick("make a tasty sandwich for", "compose a poem for", "aquire a nice outfit to give to", "strike up a conversation about pumpkins with", "write a letter and deliver it to", "give a nice hat to")
			var/mob/living/L2 = pick(GLOB.player_list)
			message += " [L2.name]."
			to_chat(C, "<span class='big warning'> You feel an overwhelming desire to [message]")
		if(2)
			visible_message("<b>[src]</b> waves their arms around, <span class='spooky'>\"If only you had a better upbringing, your ears are now full of my singing!\"</span>")
			jacqrunes("If only you had a better upbringing, your ears are now full of my singing!", C)
			C.client.tgui_panel?.play_music("https://katlin.dog/v/spooky.mp4")
		if(3)
			visible_message("<b>[src]</b> waves their arms around, <span class='spooky'>\"You're cute little bumpkin, On your head is a pumpkin!\"</span>")
			jacqrunes("You're cute little bumpkin, On your head is a pumpkin!", C)
			if(C.head)
				var/obj/item/W = C.head
				C.dropItemToGround(W, TRUE)
			var/jaqc_latern = new /obj/item/clothing/head/hardhat/pumpkinhead/jaqc
			C.equip_to_slot(jaqc_latern, ITEM_SLOT_HEAD, 1, 1)
		if(4)
			visible_message("<b>[src]</b> waves their arms around, <span class='spooky'>\"In your body there's something amiss, you'll find it's a chem made by my sis!\"</span>")
			jacqrunes("In your body there's something amiss, you'll find it's a chem made by my sis!", C)
			C.reagents.add_reagent(/datum/reagent/fermi/eigenstate, 30)
		if(5)
			visible_message("<b>[src]</b> waves their arms around, <span class='spooky'>\"A new familiar for me, and you'll see it's thee!\"</span>")
			jacqrunes("A new familiar for me, and you'll see it's thee!", C)
			C.reagents.add_reagent(/datum/reagent/fermi/secretcatchem, 30)
		if(6)
			visible_message("<b>[src]</b> waves their arms around, <span class='spooky'>\"While you may not be a ghost, for this sheet you'll always be it's host.\"</span>")
			jacqrunes("While you may not be a ghost, for this sheet you'll always be it's host.", C)
			var/mob/living/carbon/human/H = C
			if(H.wear_suit)
				var/obj/item/W = H.wear_suit
				H.dropItemToGround(W, TRUE)
			var/ghost = new /obj/item/clothing/suit/ghost_sheet/sticky
			H.equip_to_slot(ghost, ITEM_SLOT_OCLOTHING, 1, 1)
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
				canmove()
				return TRUE
			else
				candies =- C2
	visible_message("<b>[src]</b> looks to the side, <span class='spooky'>\"Look, Ah like ye but, Ah don't think Ah can right now. If ye can't tell, the stations covered in volatile candies, I've a few other laddies and lassies running after me treats, and tae top it all off, I've the gods breathing down me neck, watching every treat Ah make fer the lot of yous.\" she sighs, \"But that's not a no, right? That's.. just a nae right noo.\"</span>")
	jacqrunes("Look, Ah like ye but, Ah don't think Ah can right now. If ye can't tell, the stations covered in volatile candies, I've a few other laddies and lassies running after me treats, and tae top it all off, I've the gods breathing down me neck, watching every treat Ah make fer the lot of yous.", C)
	sleep(20)
	jacqrunes("But that's not a no, right? That's.. just a nae right noo.", C)
	visible_message("<b>[src]</b> takes off the pumpkin on her head, a rich blush on her cheeks. She leans over planting a kiss upon your forehead quickly befere popping the pumpkin back on her head.")
	sleep(20)
	visible_message("<b>[src]</b> waves their arms around, <span class='spooky'>\"There, that aught tae be worth a candy.\"</span>")
	jacqrunes("There, that aught tae be worth a candy.", C)
	sleep(20)
	poof()

/mob/living/simple_animal/jacq/proc/spawn_cars(mob/living/carbon/C)
	visible_message("<b>[src]</b> gives off a glowing smile, <span class='spooky'>\"What ken Ah offer ye? I can magic up a vectorcraft in manual or automatic fer ye.\"</span>")
	var/choices_reward = list("Manual", "Automatic", "How do Automatics work?", "Nothing, thanks")
	var/choice_reward = input(usr, "Trick or Treat?", "Trick or Treat?") in choices_reward

	switch(choice_reward)
		if("Manual")
			visible_message("<b>[src]</b> waves their arms around, <span class='spooky'>\"Great choice! 'Ere's yer car.\"</span>")
			jacqrunes("Great choice! 'Ere's yer car.", C)
			new /obj/vehicle/sealed/vectorcraft(loc)
		if("Automatic")
			visible_message("<b>[src]</b> waves their arms around, <span class='spooky'>\"'Ere's yer car. Not as fast as an automatic mind.\"</span>")
			jacqrunes("'Ere's yer car. Not as fast as an automatic mind.", C)
			new /obj/vehicle/sealed/vectorcraft/auto(loc)
		if("How do Automatics work?")
			visible_message("<b>[src]</b> smiles, <span class='spooky'>\"Hold wasd to gain speed in a direction, c to enable/disable the clutch, 1 2 3 4 to change gears (help is gear 1, disarm is gear 2, grab is gear 3 and harm is gear 4) while holding a direction (make sure the clutch is enabled when you change gears, you should hear a sound when you've successfully changed gears), r to toggle handbrake, hold alt for brake and press shift for boost (the machine will beep when the boost is recharged)! If you hear an ebbing sound like \"brbrbrbrbr\" you need to gear down, the whining sound means you need to gear up. Hearing a pleasant \"whumwhumwhum\" is optimal gearage! It can be a lil slow to start, so make sure you're in the 1st gear, andusing a boost to get you started is a good idea. If you've got a good speed you'll likely never need to dip down to gear 1 again, and make sure to hold the acceleration pedal down while changing gears (hold a direction). 1st gear is for slow movement, and it's a good idea to mvoe to 2nd gear as quick as you can, you can coldstart a car from gear one by slowly moving, then using the boost to jump you up to gear 2 speeds. The upper gears are for unlimiting your top speed.\"</span>")
			jacqrunes("They're a bit tricky, aye. Basically;", C)
		if("Nothing, thanks")
			visible_message("<b>[src]</b> shrugs, <span class='spooky'>\"Suit yerself.\"</span>")
			jacqrunes("Suit yerself.", C)

	visible_message("<b>[src]</b> shrugs, <span class='spooky'>\"Oh and look after the crafts, aye? They can get a wee bit... explosive if banged up a tad too much. They move slower damaged too like. Ye can repair 'em with the welders o'er there.\"</span>")
	jacqrunes("Oh and look after the crafts, aye? They can get a wee bit... explosive if banged up a tad too much. They move slower damaged too like. Ye can repair 'em with the welders o'er there. ", C)

/mob/living/simple_animal/jacq/update_mobility()
	. = ..()
	if(busy)
		. &= ~(MOBILITY_MOVE)
	else
		. |= MOBILITY_MOVE
	mobility_flags = .

//Christmas car spawner

/mob/living/simple_animal/jacq/car_spawner
	name = "Jacqueline cars terminal"
	icon_state = "jacq_cars_spawner"
	AIStatus = AI_OFF
	spawn_cars = TRUE
	active = FALSE

/mob/living/simple_animal/jacq/car_spawner/Destroy()
	visible_message("The <b>[src]</b> gives out an error sound, <span class='spooky'>\"Ey! Bugger off!\"</span>")
	fully_heal(FALSE)
	return ..()

/mob/living/simple_animal/jacq/car_spawner/death()
	visible_message("The <b>[src]</b> gives out an error sound, <span class='spooky'>\"Ey! Bugger off!\"</span>")
	fully_heal(FALSE)

/mob/living/simple_animal/jacq/car_spawner/poof()
	if(!active)//if disabled, don't poof
		return
	var/datum/reagents/R = new/datum/reagents(100)//Hey, just in case.
	var/datum/effect_system/smoke_spread/chem/s = new()
	R.add_reagent(/datum/reagent/fermi/secretcatchem, 10)
	s.set_up(R, 0, loc)
	s.start()
	stopmove()
	health = 25

/mob/living/simple_animal/jacq/car_spawner/spawn_cars(mob/living/carbon/C)
	visible_message("<b>[src]</b> boots up and displays jacq's glowing smile, <span class='spooky'>\"Hallo there user! Merry Christmas! What ken type o' craft ken Ah offer ye? I can magic up a vectorcraft in manual, automatic or customise it if yer feeling technical.\"</span>")
	jacqrunes("Hallo there user! What ken type o' craft ken Ah offer ye? I can magic up a vectorcraft in manual, automatic or customise it if yer feeling technical.", C)

	var/choices_reward = list("Manual", "Automatic", "Customise", "Are you a computer now Jacq?", "Nothing, thanks")
	var/choice_reward = input(usr, "Merry Trick_or_Treat.exe initiated!", "Merry Trick_or_Treat.exe initiated!") in choices_reward

	switch(choice_reward)
		if("Manual")
			visible_message("The <b>[src]</b> makes a magical booping sound, <span class='spooky'>\"Great choice! 'Ere's yer car.\"</span>")
			jacqrunes("Great choice! 'Ere's yer car.", C)
			new /obj/vehicle/sealed/vectorcraft(loc)
		if("Automatic")
			visible_message("<b>[src]</b> makes a magical booping sound, <span class='spooky'>\"'Ere's yer car. Not as fast as an automatic mind.\"</span>")
			jacqrunes("'Ere's yer car. Not as fast as an automatic mind.", C)
			new /obj/vehicle/sealed/vectorcraft/auto(loc)
		if("Are you a computer now Jacq?")
			visible_message("<b>[src]</b> makes a frustrated error sound, <span class='spooky'>\"Nae, are ye daft? Ah built these thingies tae magic up cars fer ye. Well, I got a speccy four eyes tae do it fer me, but me names on it like cause it was me idea.\"</span>")
			jacqrunes("Nae, are ye daft? Ah built these thingies tae magic up cars fer ye. Well, I got a speccy four eyes tae do it fer me, but me names on it like cause it was me idea.", C)
		if("Customise")
			visible_message("The <b>[src]</b> pings, <span class='spooky'>\"Arright, Manual or Automatic?\"</span>")
			var/choices_transm = list("Manual", "Automatic")
			var/choice_transm = input(usr, "Choose transmission", "Choose transmission") in choices_transm
			var/points = 0
			var/obj/vehicle/sealed/vectorcraft/VC
			switch(choice_transm)
				if("Manual")
					VC = new /obj/vehicle/sealed/vectorcraft(loc)
				if("Automatic")
					VC = new /obj/vehicle/sealed/vectorcraft/auto(loc)
					points += 500

			visible_message("The <b>[src]</b> pings, <span class='spooky'>\"Maximum acceleration? (default [VC.max_acceleration], max 10)\"</span>")
			var/max_accl = text2num(input(usr, "Maximum acceleration? (default [VC.max_acceleration], max 10)", "[VC.max_acceleration]"))
			max_accl = clamp(max_accl, 0, 10)
			VC.max_acceleration = max_accl
			VC.i_m_acell = max_accl
			points += max_accl*10

			/* This is internally used
			visible_message("The <b>[src]</b> pings, <span class='spooky'>\"Acceleration step? (default 0.3, max 1)\"</span>")
			var/max_accl_s = text2num(input(usr, "Acceleration step? (default 0.3, max 1)", "[VC.accel_step]"))
			max_accl_s = clamp(max_accl_s, 0, 1)
			VC.max_acceleration = max_accl_s
			points += max_accl_s*100
			*/

			visible_message("The <b>[src]</b> pings, <span class='spooky'>\"Acceleration? (default [VC.acceleration], max 2)\"</span>")
			var/accl = text2num(input(usr, "Acceleration? (default [VC.acceleration], max 2)", "[VC.acceleration]"))
			accl = clamp(accl, 0, 2)
			VC.acceleration = accl
			VC.i_acell = accl
			points += accl*100

			visible_message("The <b>[src]</b> pings, <span class='spooky'>\"Maximum deceleration? (default [VC.max_deceleration], max 15)\"</span>")
			var/deaccl = text2num(input(usr, "Max_deceleration? (default [VC.max_deceleration], max 15)", "[VC.max_deceleration]"))
			deaccl = clamp(deaccl, 0, 15)
			VC.max_deceleration = deaccl
			VC.i_m_decell = deaccl
			points += deaccl*10

			visible_message("The <b>[src]</b> pings, <span class='spooky'>\"Maximum velocity? (default [VC.max_velocity], max 200)\"</span>")
			var/m_velo = text2num(input(usr, "Maximum velocity? (default [VC.max_velocity], max 200)", "[VC.max_velocity]"))
			m_velo = clamp(m_velo, 0, 200)
			VC.max_velocity = m_velo
			points += m_velo

			visible_message("The <b>[src]</b> pings, <span class='spooky'>\"Boost power? (default [VC.boost_power], max 200)\"</span>")
			var/boost = text2num(input(usr, "Boost power? (default [VC.boost_power], max 200)", "[VC.boost_power]"))
			boost = clamp(boost, 0, 200)
			VC.boost_power = boost
			VC.i_boost = boost
			points += boost

			visible_message("The <b>[src]</b> pings, <span class='spooky'>\"Health points? (default [VC.max_integrity], max 1000)\"</span>")
			var/health = text2num(input(usr, "Health points? (default [VC.max_integrity], max 1000)", "[VC.max_integrity]"))
			health = clamp(health, 0, 500)
			VC.max_integrity = health
			points += health/2

			visible_message("The <b>[src]</b> pings, <span class='spooky'>\"Arright, 'ow do ye want it tae look?\"</span>")
			var/choices_icon = list("Racer", "Truck", "Cyber", "Ambulance", "Pod", "Clown")
			var/choice_icon = input(usr, "Choose body", "Choose body") in choices_icon
			switch(choice_icon)
				if("Truck")
					VC.icon_state = "truck"

				if("Cyber")
					VC.icon_state = "cyber"

				if("Ambulance")
					VC.icon_state = "ambutruck"

				if("Pod")
					VC.icon_state = "engineering_pod"

				if("Clown")
					VC.icon_state = "clowncar"

			visible_message("The <b>[src]</b> pings, <span class='spooky'>\"Finally; what name are ye gonna give it?\"</span>")
			var/choice_name = input(usr, "Pick a name!", "")
			choice_name += " (Points cost:[points])"
			VC.name = choice_name

			visible_message("The <b>[src]</b> gives a final boop, <span class='spooky'>\"There ye be, enjoy!\"</span>")

		if("How do Automatics work?")
			visible_message("The image of Jacq on the <b>[src]</b> smiles, <span class='spooky'>\"Hold wasd to gain speed in a direction, c to enable/disable the clutch, 1 2 3 4 to change gears (help is gear 1, disarm is gear 2, grab is gear 3 and harm is gear 4) while holding a direction (make sure the clutch is enabled when you change gears, you should hear a sound when you've successfully changed gears), r to toggle handbrake, hold alt for brake and press shift for boost (the machine will beep when the boost is recharged)! If you hear an ebbing sound like \"brbrbrbrbr\" you need to gear down, the whining sound means you need to gear up. Hearing a pleasant \"whumwhumwhum\" is optimal gearage! It can be a lil slow to start, so make sure you're in the 1st gear, andusing a boost to get you started is a good idea. If you've got a good speed you'll likely never need to dip down to gear 1 again, and make sure to hold the acceleration pedal down while changing gears (hold a direction). 1st gear is for slow movement, and it's a good idea to mvoe to 2nd gear as quick as you can, you can coldstart a car from gear one by slowly moving, then using the boost to jump you up to gear 2 speeds. The upper gears are for unlimiting your top speed.\"</span>")
			jacqrunes("They're a bit tricky, aye. Basically;", C)
		if("Nothing, thanks")
			visible_message("The image of Jacq on the <b>[src]</b> shrugs, <span class='spooky'>\"Suit yerself.\"</span>")
			jacqrunes("Suit yerself.", C)

	visible_message("The <b>[src]</b> beeps, <span class='spooky'>\"Oh and look after the crafts, aye? They can get a wee bit... explosive if banged up a tad too much. They move slower damaged too like. Ye can repair 'em with the welders o'er there.\"</span>")
	jacqrunes("Oh and look after the crafts, aye? They can get a wee bit... explosive if banged up a tad too much. They move slower damaged too like. Ye can repair 'em with the welders o'er there. ", C)

/obj/item/clothing/head/hardhat/pumpkinhead/jaqc
	name = "Jacq o' latern"
	desc = "A jacqueline o' lantern! You can't seem to get rid of it."
	icon_state = "hardhat0_pumpkin_j"
	item_state = "hardhat0_pumpkin_j"
	hat_type = "pumpkin_j"
	brightness_on = 4

/obj/item/clothing/head/hardhat/pumpkinhead/jaqc/Initialize(mapload)
	. = ..()
	ADD_TRAIT(src, TRAIT_NODROP, GLUED_ITEM_TRAIT)

/obj/item/clothing/suit/ghost_sheet/sticky

/obj/item/clothing/suit/ghost_sheet/sticky/Initialize(mapload)
	. = ..()
	ADD_TRAIT(src, TRAIT_NODROP, GLUED_ITEM_TRAIT)

/obj/item/clothing/suit/ghost_sheet/sticky/on_attack_hand(mob/user, act_intent = user.a_intent, unarmed_attack_flags)
	if(iscarbon(user))
		to_chat(user, "<span class='spooky'><i>Boooooo~!</i></span>")
		return
	else
		..()

/obj/item/clothing/suit/ghost_sheet/sticky/on_attack_hand(mob/user, act_intent = user.a_intent, unarmed_attack_flags)
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

/obj/item/reagent_containers/potion_container/Initialize(mapload)
	.=..()
	var/R = get_random_reagent_id()
	reagents.add_reagent(R, 30)
	name = "[R] Potion"

/obj/item/reagent_containers/potion_container/throw_impact(atom/hit_atom, datum/thrownthing/throwingdatum)
	..()
	delayed_release_smoke()

/obj/item/reagent_containers/potion_container/proc/delayed_release_smoke()
	set waitfor = FALSE
	sleep(20)
	var/datum/effect_system/smoke_spread/chem/s = new()
	s.set_up(src.reagents, 3, get_turf(src))
	s.start()
	qdel(src)

//Candies
/obj/item/reagent_containers/food/snacks/special_candy
	name = "Magic candy"
	icon = 'icons/obj/halloween_items.dmi'
	icon_state = "jacq_candy"
	desc = "A candy with strange magic within. Be careful, as the magic isn't always helpful."

/obj/item/reagent_containers/food/snacks/special_candy/Initialize(mapload)
	.=..()
	reagents.add_reagent(get_random_reagent_id(), 5)
