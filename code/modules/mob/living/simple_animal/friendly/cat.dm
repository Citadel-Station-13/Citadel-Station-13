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

//secretcatchemcode, shh!! Of couse I hide it amongst cats. Also, yes, I expect you, Mr.Maintaner to read and review this, dispite it being hidden and not mentioned in the changelogs.
//ChemReactionVars:
/datum/chemical_reaction/fermi/secretcatchem //DONE
	name = "secretcatchem"
	id = "secretcatchem"
	results = list("secretcatchem" = 2)
	required_reagents = list("stable_plasma" = 0.5, "sugar" = 0.5, "cream" = 0.5, "blood" = 0.5)
	required_catalysts = list("felinidmutationtoxin" = 5)
	mix_message = "the reaction gives off a meow!"
	//FermiChem vars:
	OptimalTempMin 		= 700 		// Lower area of bell curve for determining heat based rate reactions
	OptimalTempMax 		= 800 		// Upper end for above
	ExplodeTemp 		= 900		// Temperature at which reaction explodes
	OptimalpHMin 		= 6 		// Lowest value of pH determining pH a 1 value for pH based rate reactions (Plateu phase)
	OptimalpHMax 		= 8 		// Higest value for above
	ReactpHLim 			= 2 		// How far out pH wil react, giving impurity place (Exponential phase)
	CatalystFact 		= 0 		// How much the catalyst affects the reaction (0 = no catalyst)
	CurveSharpT 		= 0 		// How sharp the temperature exponential curve is (to the power of value)
	CurveSharppH 		= 0 		// How sharp the pH exponential curve is (to the power of value)
	ThermicConstant		= 0 		// Temperature change per 1u produced
	HIonRelease 		= 0 		// pH change per 1u reaction (inverse for some reason)
	RateUpLim 			= 0.1 		// Optimal/max rate possible if all conditions are perfect
	FermiChem 			= TRUE		// If the chemical uses the Fermichem reaction mechanics
	FermiExplode 		= FALSE		// If the chemical explodes in a special way
	PurityMin 			= 0.2

/datum/chemical_reaction/fermi/secretcatchem/Initialize()
	message_admins("randomizing reaction")
	OptimalTempMin 		+= rand(-100, 100)
	OptimalTempMax 		+= rand(-100, 100)
	ExplodeTemp 		+= rand(-100, 100)
	OptimalpHMin 		+= rand(-1, 1)
	OptimalpHMax 		+= rand(-1, 1)
	ReactpHLim 			+= rand(-2, 2)
	CurveSharpT 		+= rand(0.01, 5)
	CurveSharppH 		+= rand(0.01, 5)
	ThermicConstant		+= rand(-50, 50)
	HIonRelease 		+= rand(-0.25, 0.25)
	RateUpLim 			+= rand(0, 100)
	PurityMin 			+= rand(-0.1, 0.1)
	var/additions = list("aluminum", "silver", "gold", "plasma", "silicon", "bluespace")
	var/chosenA = pick(additions)
	required_reagents[chosenA] = rand(0.1, 1)

/datum/chemical_reaction/fermi/secretcatchem/FermiFinish(datum/reagents/holder, var/atom/my_atom)//Strange how this doesn't work but the other does.
	message_admins("Someone found the hidden reaction. Amazing!! Please tell Fermi!!")

//ReagentVars
//Turns you into a cute catto while it's in your system.
//If you manage to gamble perfectly, makes you a catgirl after you transform back. But really, you shouldn't end up with that with how random it is.
/datum/reagent/fermi/secretcatchem //Should I hide this from code divers? A secret cit chem?
	name = "secretcatchem" //an attempt at hiding it
	id = "secretcatchem"
	description = "An illegal and hidden chem that turns people into cats/catgirls. It's said that it's so rare and unstable that having it means you've been blessed."
	taste_description = "hairballs and cream"
	color = "#ffc224"
	var/catshift = FALSE
	var/mob/living/simple_animal/pet/cat/custom_cat/catto
	//var/mob/living/carbon/human/origin maybe unneeded

/datum/reagent/fermi/secretcatchem/New()
	name = "Catgirli[pick("a","u","e","y")]m [pick("apex", "prime", "meow")]"

/datum/reagent/fermi/secretcatchem/on_mob_add(mob/living/carbon/human/H)
	. = ..()
	//origin = H
	var/current_species = H.dna.species.type
	var/datum/species/mutation = /datum/species/human/felinid
	if((mutation && mutation != current_species) && (purity > 0.9))//ONLY if purity is 1, and given the stuff is random. It's basically impossible to get this to 1.
		H.set_species(mutation)
		H.gender = FEMALE
		catshift = TRUE
	catto = new(get_turf(H.loc))
	H.mind.transfer_to(catto)
	H.moveToNullspace()
	catto.name = M.name
	catto.desc = "A cute catto! They remind you of [M] somehow."
	catto.color = "#[dna.features["mcolor"]]"

/datum/reagent/fermi/secretcatchem/on_mob_life(mob/living/carbon/human/H)
	if(prob(5))
		playsound(get_turf(catto), 'modular_citadel/sound/voice/merowr.ogg', 50, 1, -1)
		catto.emote("me","lets out a meowrowr!")
	..()

/datum/reagent/fermi/secretcatchem/on_mob_add(mob/living/carbon/human/H)
	var/words = "<span class='notice'>Your body shifts back to normal."
	if(catshift == TRUE)
		words += " ...But wait, are those ears and a tail?")
	to_chat(H, "[words]</span>")
	H.doMove(catto)
	catto.mind.transfer_to(M)
	qdel(catto)
