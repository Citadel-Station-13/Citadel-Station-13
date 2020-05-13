
GLOBAL_LIST_INIT(dwarf_first, world.file2list("strings/names/dwarf_first.txt")) //Textfiles with first
GLOBAL_LIST_INIT(dwarf_last, world.file2list("strings/names/dwarf_last.txt")) //textfiles with last

/datum/species/dwarf //not to be confused with the genetic manlets
	name = "Dwarf"
	id = "dwarf" //Also called Homo sapiens pumilionis
	default_color = "FFFFFF"
	species_traits = list(EYECOLOR,HAIR,FACEHAIR,LIPS,NO_UNDERWEAR,TRAIT_DWARF)
	inherent_traits = list()
	limbs_id = "human"
	use_skintones = USE_SKINTONES_GRAYSCALE_CUSTOM
	say_mod = "bellows" //high energy, EXTRA BIOLOGICAL FUEL
	damage_overlay_type = "human"
	skinned_type = /obj/item/stack/sheet/animalhide/human
	liked_food = ALCOHOL | MEAT | DAIRY //Dwarves like alcohol, meat, and dairy products.
	disliked_food = JUNKFOOD | FRIED //Dwarves hate foods that have no nutrition other than alcohol.
	mutant_organs = list(/obj/item/organ/dwarfgland) //Dwarven alcohol gland, literal gland warrior
	mutantliver = /obj/item/organ/liver/dwarf //Dwarven super liver (Otherwise they r doomed)
	species_language_holder = /datum/language_holder/dwarf

/mob/living/carbon/human/species/dwarf //species admin spawn path
	race = /datum/species/dwarf //and the race the path is set to.

/datum/species/dwarf/check_roundstart_eligible()
	if(SSevents.holidays && SSevents.holidays[HALLOWEEN])
		return TRUE
	return ..()

/datum/species/dwarf/on_species_gain(mob/living/carbon/C, datum/species/old_species)
	. = ..()
	var/dwarf_hair = pick("Beard (Dwarf)", "Beard (Very Long)", "Beard (Long)") //beard roullette
	var/mob/living/carbon/human/H = C
	H.facial_hair_style = dwarf_hair
	H.update_hair()
	H.transform = H.transform.Scale(1, 0.8) //We use scale, and yeah. Dwarves can become gnomes with DWARFISM.
	RegisterSignal(C, COMSIG_MOB_SAY, .proc/handle_speech) //We register handle_speech is being used.

/datum/species/dwarf/on_species_loss(mob/living/carbon/H, datum/species/new_species)
	. = ..()
	H.transform = H.transform.Scale(1, 1.25) //And we undo it.
	UnregisterSignal(H, COMSIG_MOB_SAY) //We register handle_speech is not being used.

//Dwarf Name stuff
/proc/dwarf_name() //hello caller: my name is urist mcuristurister
	return "[pick(GLOB.dwarf_first)] [pick(GLOB.dwarf_last)]"

/datum/species/dwarf/random_name(gender,unique,lastname)
	return dwarf_name() //hello, ill return the value from dwarf_name proc to you when called.

//Dwarf Speech handling - Basically a filter/forces them to say things. The IC helper
/datum/species/dwarf/proc/handle_speech(datum/source, list/speech_args)
	var/message = speech_args[SPEECH_MESSAGE]
	if(speech_args[SPEECH_LANGUAGE] != /datum/language/dwarf) // No accent if they speak their language
		if(message[1] != "*")
			message = " [message]" //Credits to goonstation for the strings list.
			var/list/dwarf_words = strings("dwarf_replacement.json", "dwarf") //thanks to regex too.
			for(var/key in dwarf_words) //Theres like 1459 words or something man.
				var/value = dwarf_words[key] //Thus they will always be in character.
				if(islist(value)) //Whether they like it or not.
					value = pick(value) //This could be drastically reduced if needed though.
				message = replacetextEx(message, " [uppertext(key)]", " [uppertext(value)]")
				message = replacetextEx(message, " [capitalize(key)]", " [capitalize(value)]")
				message = replacetextEx(message, " [key]", " [value]") //Also its scottish.

	if(prob(3))
		message += " By Armok!"
	speech_args[SPEECH_MESSAGE] = trim(message)

//This mostly exists because my testdwarf's liver died while trying to also not die due to no alcohol.
/obj/item/organ/liver/dwarf
	name = "dwarf liver"
	icon_state = "liver"
	desc = "A dwarven liver, theres something magical about seeing one of these up close."
	alcohol_tolerance = 0 //dwarves really shouldn't be dying to alcohol.
	toxTolerance = 5 //Shrugs off 5 units of toxins damage.
	maxHealth = 150 //More health than the average liver, as you aren't going to be replacing this.
	//If it does need replaced with a standard human liver, prepare for hell.

//alcohol gland
/obj/item/organ/dwarfgland
	name = "dwarf alcohol gland"
	icon_state = "plasma" //Yes this is a actual icon in icons/obj/surgery.dmi
	desc = "A genetically engineered gland which is hopefully a step forward for humanity."
	w_class = WEIGHT_CLASS_NORMAL
	var/stored_alcohol = 250 //They start with 250 units, that ticks down and eventaully bad effects occur
	var/max_alcohol = 500 //Max they can attain, easier than you think to OD on alcohol.
	var/heal_rate = 0.5 //The rate they heal damages over 400 alcohol stored. Default is 0.5 so we times 3 since 3 seconds.
	var/alcohol_rate = 0.25 //The rate the alcohol ticks down per each iteration of dwarf_eth_ticker completing.
	//These count in on_life ticks which should be 2 seconds per every increment of 1 in a perfect world.
	var/dwarf_filth_ticker = 0 //Currently set =< 4, that means this will fire the proc around every 4-8 seconds.
	var/dwarf_eth_ticker = 0 //Currently set =< 1, that means this will fire the proc around every 2 seconds
	var/last_filth_spam
	var/last_alcohol_spam

/obj/item/organ/dwarfgland/prepare_eat()
	var/obj/S = ..()
	S.reagents.add_reagent(/datum/reagent/consumable/ethanol, stored_alcohol/10)
	return S

/obj/item/organ/dwarfgland/on_life() //Primary loop to hook into to start delayed loops for other loops..
	. = ..()
	if(owner && owner.stat != DEAD)
		dwarf_cycle_ticker()

//Handles the delayed tick cycle by just adding on increments per each on_life() tick
/obj/item/organ/dwarfgland/proc/dwarf_cycle_ticker()
	dwarf_eth_ticker++
	dwarf_filth_ticker++

	if(dwarf_filth_ticker >= 4) //Should be around 4-8 seconds since a tick is around 2 seconds.
		dwarf_filth_cycle()		//On_life will adjust regarding other factors, so we are along for the ride.
		dwarf_filth_ticker = 0 //We set the ticker back to 0 to go again.
	if(dwarf_eth_ticker >= 1) //Alcohol reagent check should be around 2 seconds, since a tick is around 2 seconds.
		dwarf_eth_cycle()
		dwarf_eth_ticker = 0

//If this still friggin uses too much CPU, I'll make a for view subsystem If I have to.
/obj/item/organ/dwarfgland/proc/dwarf_filth_cycle()
	if(!owner?.client || !owner?.mind)
		return
	//Filth Reactions - Since miasma now exists
	var/filth_counter = 0 //Holder for the filth check cycle, basically contains how much filth dwarf sees numerically.
	for(var/fuck in view(owner,7)) //hello byond for view loop.
		if(istype(fuck, /mob/living/carbon/human))
			var/mob/living/carbon/human/H = fuck
			if(H.stat == DEAD || (HAS_TRAIT(H, TRAIT_FAKEDEATH)))
				filth_counter += 10
		if(istype(fuck, /obj/effect/decal/cleanable/blood))
			if(istype(fuck, /obj/effect/decal/cleanable/blood/gibs))
				filth_counter += 1
			else
				filth_counter += 0.1
		if(istype(fuck,/obj/effect/decal/cleanable/vomit)) //They are disgusted by their own vomit too.
			filth_counter += 10 //Dwarves could technically chainstun each other in a vomit tantrum spiral.
	switch(filth_counter)
		if(11 to 25)
			if(last_filth_spam + 40 SECONDS < world.time)
				to_chat(owner, "<span class = 'warning'>Someone should really clean up in here!</span>")
				last_filth_spam = world.time
		if(26 to 50)
			if(prob(6)) //And then the probability they vomit along with it.
				to_chat(owner, "<span class = 'danger'>The stench makes you queasy.</span>")
				owner.vomit(10) //I think vomit should stay over a disgust adjustment.
		if(51 to 75)
			if(prob(9))
				to_chat(owner, "<span class = 'danger'>By Armok! You won't be able to keep alcohol down at all!</span>")
				owner.vomit(20) //Its more funny
		if(76 to 100)
			if(prob(11))
				to_chat(owner, "<span class = 'userdanger'>You can't live in such FILTH!</span>")
				owner.adjustToxLoss(10) //Now they start dying.
				owner.vomit(20)
		if(101 to INFINITY) //Now they will really start dying
			if(last_filth_spam + 12 SECONDS < world.time)
				to_chat(owner, "<span class = 'userdanger'> THERES TOO MUCH FILTH, OH GODS THE FILTH!</span>")
				last_filth_spam = world.time
			if(prob(40))
				owner.adjustToxLoss(15)
				owner.vomit(30)
	CHECK_TICK //Check_tick right here, its motherfuckin magic. (To me at least)

//Handles the dwarf alcohol cycle tied to on_life, it ticks in dwarf_cycle_ticker.
/obj/item/organ/dwarfgland/proc/dwarf_eth_cycle()
	//BOOZE POWER
	var/init_stored_alcohol = stored_alcohol
	for(var/datum/reagent/R in owner.reagents.reagent_list)
		if(istype(R, /datum/reagent/consumable/ethanol))
			var/datum/reagent/consumable/ethanol/E = R
			stored_alcohol = clamp(stored_alcohol + E.boozepwr / 50, 0, max_alcohol)
	var/heal_amt = heal_rate
	stored_alcohol -= alcohol_rate //Subtracts alcohol_Rate from stored alcohol so EX: 250 - 0.25 per each loop that occurs.
	if(stored_alcohol > 400) //If they are over 400 they start regenerating
		owner.adjustBruteLoss(-heal_amt) //But its alcohol, there will be other issues here.
		owner.adjustFireLoss(-heal_amt) //Unless they drink casually all the time.
		owner.adjustOxyLoss(-heal_amt)
		owner.adjustCloneLoss(-heal_amt) //Also they will probably get brain damage if thats a thing here.
	if(init_stored_alcohol + 0.5 < stored_alcohol) //recovering stored alcohol at a steady rate of +0.75, no spam.
		return
	switch(stored_alcohol)
		if(0 to 24)
			if(last_alcohol_spam + 8 SECONDS < world.time)
				to_chat(owner, "<span class='userdanger'>DAMNATION INCARNATE, WHY AM I CURSED WITH THIS DRY-SPELL? I MUST DRINK.</span>")
				last_alcohol_spam = world.time
			owner.adjustToxLoss(10)
		if(25 to 50)
			if(last_alcohol_spam + 20 SECONDS < world.time)
				to_chat(owner, "<span class='danger'>Oh DAMN, I need some brew!</span>")
				last_alcohol_spam = world.time
		if(51 to 75)
			if(last_alcohol_spam + 35 SECONDS < world.time)
				to_chat(owner, "<span class='warning'>Your body aches, you need to get ahold of some booze...</span>")
				last_alcohol_spam = world.time
		if(76 to 100)
			if(last_alcohol_spam + 40 SECONDS < world.time)
				to_chat(owner, "<span class='notice'>A pint of anything would really hit the spot right now.</span>")
				last_alcohol_spam = world.time
		if(101 to 150)
			if(last_alcohol_spam + 50 SECONDS < world.time)
				to_chat(owner, "<span class='notice'>You feel like you could use a good brew.</span>")
				last_alcohol_spam = world.time
