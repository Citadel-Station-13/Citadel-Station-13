//Cat
/mob/living/simple_animal/pet/cat
	name = "cat"
	desc = "Kitty!!"
	icon = 'icons/mob/pets.dmi'
	icon_state = "cat2"
	icon_living = "cat2"
	icon_dead = "cat2_dead"
	gender = MALE
	speak = list("Meow!", "Esp!", "Purr!", "HSSSSS")
	speak_emote = list("purrs", "meows")
	emote_hear = list("meows.", "mews.")
	emote_see = list("shakes its head.", "shivers.")
	speak_chance = 1
	turns_per_move = 5
	see_in_dark = 6
	ventcrawler = VENTCRAWLER_ALWAYS
	pass_flags = PASSTABLE
	mob_size = MOB_SIZE_SMALL
	mob_biotypes = list(MOB_ORGANIC, MOB_BEAST)
	minbodytemp = 200
	maxbodytemp = 400
	unsuitable_atmos_damage = 1
	animal_species = /mob/living/simple_animal/pet/cat
	childtype = list(/mob/living/simple_animal/pet/cat/kitten)
	butcher_results = list(/obj/item/reagent_containers/food/snacks/meat/slab = 2, /obj/item/organ/ears/cat = 1, /obj/item/organ/tail/cat = 1)
	response_help  = "pets"
	response_disarm = "gently pushes aside"
	response_harm   = "kicks"
	var/turns_since_scan = 0
	var/mob/living/simple_animal/mouse/movement_target
	gold_core_spawnable = FRIENDLY_SPAWN
	collar_type = "cat"

	do_footstep = TRUE

/mob/living/simple_animal/pet/cat/Initialize()
	. = ..()
	verbs += /mob/living/proc/lay_down

/mob/living/simple_animal/pet/cat/update_canmove()
	..()
	if(client && stat != DEAD)
		if (resting)
			icon_state = "[icon_living]_rest"
			collar_type = "[initial(collar_type)]_rest"
		else
			icon_state = "[icon_living]"
			collar_type = "[initial(collar_type)]"
	regenerate_icons()


/mob/living/simple_animal/pet/cat/space
	name = "space cat"
	desc = "It's a cat... in space!"
	icon_state = "spacecat"
	icon_living = "spacecat"
	icon_dead = "spacecat_dead"
	unsuitable_atmos_damage = 0
	minbodytemp = TCMB
	maxbodytemp = T0C + 40

/mob/living/simple_animal/pet/cat/original
	name = "Batsy"
	desc = "The product of alien DNA and bored geneticists."
	gender = FEMALE
	icon_state = "original"
	icon_living = "original"
	icon_dead = "original_dead"
	collar_type = null
	unique_pet = TRUE

/mob/living/simple_animal/pet/cat/kitten
	name = "kitten"
	desc = "D'aaawwww."
	icon_state = "kitten"
	icon_living = "kitten"
	icon_dead = "kitten_dead"
	density = FALSE
	pass_flags = PASSMOB
	mob_size = MOB_SIZE_SMALL
	collar_type = "kitten"

//RUNTIME IS ALIVE! SQUEEEEEEEE~
/mob/living/simple_animal/pet/cat/Runtime
	name = "Runtime"
	desc = "GCAT"
	icon_state = "cat"
	icon_living = "cat"
	icon_dead = "cat_dead"
	gender = FEMALE
	gold_core_spawnable = NO_SPAWN
	unique_pet = TRUE
	var/list/family = list()//var restored from savefile, has count of each child type
	var/list/children = list()//Actual mob instances of children
	var/cats_deployed = 0
	var/memory_saved = FALSE

/mob/living/simple_animal/pet/cat/Runtime/Initialize()
	if(prob(5))
		icon_state = "original"
		icon_living = "original"
		icon_dead = "original_dead"
	Read_Memory()
	. = ..()

/mob/living/simple_animal/pet/cat/Runtime/Life()
	if(!cats_deployed && SSticker.current_state >= GAME_STATE_SETTING_UP)
		Deploy_The_Cats()
	if(!stat && SSticker.current_state == GAME_STATE_FINISHED && !memory_saved)
		Write_Memory()
		memory_saved = TRUE
	..()

/mob/living/simple_animal/pet/cat/Runtime/make_babies()
	var/mob/baby = ..()
	if(baby)
		children += baby
		return baby

/mob/living/simple_animal/pet/cat/Runtime/death()
	if(!memory_saved)
		Write_Memory(TRUE)
	..()

/mob/living/simple_animal/pet/cat/Runtime/proc/Read_Memory()
	if(fexists("data/npc_saves/Runtime.sav")) //legacy compatability to convert old format to new
		var/savefile/S = new /savefile("data/npc_saves/Runtime.sav")
		S["family"] >> family
		fdel("data/npc_saves/Runtime.sav")
	else
		var/json_file = file("data/npc_saves/Runtime.json")
		if(!fexists(json_file))
			return
		var/list/json = json_decode(file2text(json_file))
		family = json["family"]
	if(isnull(family))
		family = list()

/mob/living/simple_animal/pet/cat/Runtime/proc/Write_Memory(dead)
	var/json_file = file("data/npc_saves/Runtime.json")
	var/list/file_data = list()
	family = list()
	if(!dead)
		for(var/mob/living/simple_animal/pet/cat/kitten/C in children)
			if(istype(C,type) || C.stat || !C.z || !C.butcher_results) //That last one is a work around for hologram cats
				continue
			if(C.type in family)
				family[C.type] += 1
			else
				family[C.type] = 1
	file_data["family"] = family
	fdel(json_file)
	WRITE_FILE(json_file, json_encode(file_data))

/mob/living/simple_animal/pet/cat/Runtime/proc/Deploy_The_Cats()
	cats_deployed = 1
	for(var/cat_type in family)
		if(family[cat_type] > 0)
			for(var/i in 1 to min(family[cat_type],100)) //Limits to about 500 cats, you wouldn't think this would be needed (BUT IT IS)
				new cat_type(loc)

/mob/living/simple_animal/pet/cat/Proc
	name = "Proc"
	gender = MALE
	gold_core_spawnable = NO_SPAWN
	unique_pet = TRUE

/mob/living/simple_animal/pet/cat/Life()
	if(!stat && !buckled && !client)
		if(prob(1))
			emote("me", 1, pick("stretches out for a belly rub.", "wags its tail.", "lies down."))
			icon_state = "[icon_living]_rest"
			collar_type = "[initial(collar_type)]_rest"
			resting = 1
			update_canmove()
		else if (prob(1))
			emote("me", 1, pick("sits down.", "crouches on its hind legs.", "looks alert."))
			icon_state = "[icon_living]_sit"
			collar_type = "[initial(collar_type)]_sit"
			resting = 1
			update_canmove()
		else if (prob(1))
			if (resting)
				emote("me", 1, pick("gets up and meows.", "walks around.", "stops resting."))
				icon_state = "[icon_living]"
				collar_type = "[initial(collar_type)]"
				resting = 0
				update_canmove()
			else
				emote("me", 1, pick("grooms its fur.", "twitches its whiskers.", "shakes out its coat."))

	//MICE!
	if((src.loc) && isturf(src.loc))
		if(!stat && !resting && !buckled)
			for(var/mob/living/simple_animal/mouse/M in view(1,src))
				if(!M.stat && Adjacent(M))
					emote("me", 1, "splats \the [M]!")
					M.splat()
					movement_target = null
					stop_automated_movement = 0
					break
			for(var/obj/item/toy/cattoy/T in view(1,src))
				if (T.cooldown < (world.time - 400))
					emote("me", 1, "bats \the [T] around with its paw!")
					T.cooldown = world.time

	..()

	make_babies()

	if(!stat && !resting && !buckled)
		turns_since_scan++
		if(turns_since_scan > 5)
			walk_to(src,0)
			turns_since_scan = 0
			if((movement_target) && !(isturf(movement_target.loc) || ishuman(movement_target.loc) ))
				movement_target = null
				stop_automated_movement = 0
			if( !movement_target || !(movement_target.loc in oview(src, 3)) )
				movement_target = null
				stop_automated_movement = 0
				for(var/mob/living/simple_animal/mouse/snack in oview(src,3))
					if(isturf(snack.loc) && !snack.stat)
						movement_target = snack
						break
			if(movement_target)
				stop_automated_movement = 1
				walk_to(src,movement_target,0,3)

/mob/living/simple_animal/pet/cat/attack_hand(mob/living/carbon/human/M)
	. = ..()
	switch(M.a_intent)
		if("help")
			wuv(1, M)
		if("harm")
			wuv(-1, M)

/mob/living/simple_animal/pet/cat/proc/wuv(change, mob/M)
	if(change)
		if(change > 0)
			if(M && stat != DEAD)
				new /obj/effect/temp_visual/heart(loc)
				emote("me", 1, "purrs!")
		else
			if(M && stat != DEAD)
				emote("me", 1, "hisses!")

/mob/living/simple_animal/pet/cat/cak //I told you I'd do it, Remie
	name = "Keeki"
	desc = "It's a cat made out of cake."
	icon_state = "cak"
	icon_living = "cak"
	icon_dead = "cak_dead"
	health = 50
	maxHealth = 50
	gender = FEMALE
	harm_intent_damage = 10
	butcher_results = list(/obj/item/organ/brain = 1, /obj/item/organ/heart = 1, /obj/item/reagent_containers/food/snacks/cakeslice/birthday = 3,  \
	/obj/item/reagent_containers/food/snacks/meat/slab = 2)
	response_harm = "takes a bite out of"
	attacked_sound = 'sound/items/eatfood.ogg'
	deathmessage = "loses its false life and collapses!"
	death_sound = "bodyfall"

/mob/living/simple_animal/pet/cat/cak/CheckParts(list/parts)
	..()
	var/obj/item/organ/brain/B = locate(/obj/item/organ/brain) in contents
	if(!B || !B.brainmob || !B.brainmob.mind)
		return
	B.brainmob.mind.transfer_to(src)
	to_chat(src, "<span class='big bold'>You are a cak!</span><b> You're a harmless cat/cake hybrid that everyone loves. People can take bites out of you if they're hungry, but you regenerate health \
	so quickly that it generally doesn't matter. You're remarkably resilient to any damage besides this and it's hard for you to really die at all. You should go around and bring happiness and \
	free cake to the station!</b>")
	var/new_name = stripped_input(src, "Enter your name, or press \"Cancel\" to stick with Keeki.", "Name Change")
	if(new_name)
		to_chat(src, "<span class='notice'>Your name is now <b>\"new_name\"</b>!</span>")
		name = new_name

/mob/living/simple_animal/pet/cat/cak/Life()
	..()
	if(stat)
		return
	if(health < maxHealth)
		adjustBruteLoss(-8) //Fast life regen
	for(var/obj/item/reagent_containers/food/snacks/donut/D in range(1, src)) //Frosts nearby donuts!
		if(D.icon_state != "donut2")
			D.name = "frosted donut"
			D.icon_state = "donut2"
			D.reagents.add_reagent("sprinkles", 2)
			D.bonus_reagents = list("sprinkles" = 2, "sugar" = 1)
			D.filling_color = "#FF69B4"

/mob/living/simple_animal/pet/cat/cak/attack_hand(mob/living/L)
	..()
	if(L.a_intent == INTENT_HARM && L.reagents && !stat)
		L.reagents.add_reagent("nutriment", 0.4)
		L.reagents.add_reagent("vitamin", 0.4)

//Cat made
/mob/living/simple_animal/pet/cat/custom_cat
	name = "White cat" //Incase it somehow gets spawned without an ID
	desc = "A cute white catto!"
	icon_state = "custom_cat"
	icon_living = "custom_cat"
	icon_dead = "custom_cat_dead"
	gender = FEMALE
	gold_core_spawnable = NO_SPAWN
	health = 50 //So people can't instakill it
	maxHealth = 50
	speak = list("Meowrowr!", "Mew!", "Miauen!")
	speak_emote = list("wigglepurrs", "mewls")
	emote_hear = list("meows.", "mews.")
	emote_see = list("looks at you eagerly for pets!", "wiggles enthusiastically.")
	gold_core_spawnable = NO_SPAWN

//secretcatchemcode, shh!! Of couse I hide it amongst cats. Also, yes, I expect you, Mr.Maintaner to read and review this, dispite it being hidden and not mentioned in the changelogs.
//I'm not trying to be sneaky, I'm trying to keep it a secret!
//I don't know how to do hidden chems like Aurora
//ChemReactionVars:
/datum/chemical_reaction/fermi/secretcatchem //DONE
	name = "secretcatchem"
	id = "secretcatchem"
	results = list("secretcatchem" = 0.5)
	required_reagents = list("stable_plasma" = 0.1, "sugar" = 0.1, "cream" = 0.1, "blood" = 0.1, "slimejelly" = 0.1)
	required_catalysts = list("felinidmutationtoxin" = 1)
	required_temp = 600
	mix_message = "the reaction gives off a meow!"
	mix_sound = "modular_citadel/sound/voice/merowr.ogg"
	//FermiChem vars:
	OptimalTempMin 		= 650
	OptimalpHMin 		= 0
	ReactpHLim 			= 2
	CurveSharpT 		= 0
	CurveSharppH 		= 0
	ThermicConstant		= 0
	HIonRelease 		= 0
	RateUpLim 			= 0.1
	FermiChem 			= TRUE
	FermiExplode 		= FALSE
	PurityMin 			= 0.2

/datum/chemical_reaction/fermi/secretcatchem/New()
	//rand doesn't seem to work with n^-e
	OptimalTempMin 		+= rand(-100, 100)
	OptimalTempMax 		= (OptimalTempMin+rand(0, 200))
	ExplodeTemp 		= (OptimalTempMax+rand(0, 200))
	OptimalpHMin 		+= rand(1, 10)
	OptimalpHMax 		= (OptimalpHMin + rand(1, 5))
	ReactpHLim 			+= rand(-2, 2)
	CurveSharpT 		+= (rand(1, 500)/100)
	CurveSharppH 		+= (rand(1, 500)/100)
	ThermicConstant		+= rand(-50, 50)
	HIonRelease 		+= (rand(-25, 25)/100)
	RateUpLim 			+= (rand(1, 1000)/100)
	PurityMin 			+= (rand(-1, 1)/10)
	var/additions = list("aluminium", "silver", "gold", "plasma", "silicon", "bluespace", "uranium", "milk")
	required_reagents[pick(additions)] = rand(1, 5)//weird

/datum/chemical_reaction/fermi/secretcatchem/FermiFinish(datum/reagents/holder, var/atom/my_atom)//Strange how this doesn't work but the other does.
	message_admins("Someone found the hidden reaction. Amazing!! Please tell Fermis!!")

//ReagentVars
//Turns you into a cute catto while it's in your system.
//If you manage to gamble perfectly, makes you a catgirl after you transform back. But really, you shouldn't end up with that with how random it is.
/datum/reagent/fermi/secretcatchem //Should I hide this from code divers? A secret cit chem?
	name = "secretcatchem" //an attempt at hiding it
	id = "secretcatchem"
	description = "An illegal and hidden chem that turns people into cats. It's said that it's so rare and unstable that having it means you've been blessed."
	taste_description = "hairballs and cream"
	color = "#ffc224"
	var/catshift = FALSE
	var/mob/living/simple_animal/pet/cat/custom_cat/catto = null

/datum/reagent/fermi/secretcatchem/New()
	name = "Catgirli[pick("a","u","e","y")]m [pick("apex", "prime", "meow")]"

/datum/reagent/fermi/secretcatchem/on_mob_add(mob/living/carbon/human/H)
	. = ..()
	var/current_species = H.dna.species.type
	var/datum/species/mutation = /datum/species/human/felinid
	if((mutation != current_species) && (purity >= 0.8))//ONLY if purity is high, and given the stuff is random. It's basically impossible to get this to 1. It already requires felind too, so no new functionality there.
		H.set_species(mutation)
		H.gender = FEMALE
		//exception(al) handler:
		H.dna.features["mam_tail"] = "Cat"
		H.dna.features["tail_human"] = "Cat"
		H.dna.features["ears"]  = "Cat"
		H.dna.features["mam_ears"] = "Cat"
		H.dna.features["tail_lizard"] = "Cat"
		H.dna.features["mam_tail"] = "Cat"
		H.dna.features["mam_tail_animated"] = "Cat"
		H.facial_hair_style = "Shaved"
		H.verb_say = "mewls"
		catshift = TRUE
		playsound(get_turf(H), 'modular_citadel/sound/voice/merowr.ogg', 50, 1, -1)
	to_chat(H, "<span class='notice'>You suddenly turn into a cat!</span>")
	catto = new(get_turf(H.loc))
	H.mind.transfer_to(catto)
	catto.name = H.name
	catto.desc = "A cute catto! They remind you of [H] somehow."
	catto.color = "#[H.dna.features["mcolor"]]"
	H.forceMove(locate(10,6,1))//To the zelda room.

/datum/reagent/fermi/secretcatchem/on_mob_life(mob/living/carbon/H)
	if(prob(5))
		playsound(get_turf(catto), 'modular_citadel/sound/voice/merowr.ogg', 50, 1, -1)
		catto.say("lets out a meowrowr!*")
	..()

/datum/reagent/fermi/secretcatchem/on_mob_delete(mob/living/carbon/H)
	var/words = "Your body shifts back to normal."
	do_teleport(H, catto.loc)
	catto.mind.transfer_to(H)
	if(catshift == TRUE)
		words += " ...But wait, are those ears and a tail?"
		H.say("*wag")//force update sprites.
	to_chat(H, "<span class='notice'>[words]</span>")
	qdel(catto)

/datum/chemical_reaction/fermi/secretcatchem/FermiExplode(datum/reagents, var/atom/my_atom, volume, temp, pH)
	var/mob/living/simple_animal/pet/cat/custom_cat/catto = new(get_turf(my_atom))
	var/list/seen = viewers(8, get_turf(my_atom))
	for(var/mob/M in seen)
		to_chat(M, "<span class='warning'>The reaction suddenly gives out a meow, condensing into a chemcat!</b></span>")//meow!
	playsound(get_turf(my_atom), 'modular_citadel/sound/voice/merowr.ogg', 50, 1, -1)
	catto.name = "FermiCat"
	catto.desc = "A cute Fermichem cat, created by a lot of compicated and confusing chemistry!"
	catto.color = "#770000"
	my_atom.reagents.remove_any(10)
