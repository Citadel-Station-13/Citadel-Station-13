/datum/round_event_control/travelling_trader
	name = "Travelling Trader"
	typepath = /datum/round_event/travelling_trader
	weight = 8
	max_occurrences = 2
	earliest_start = 0 MINUTES

/datum/round_event/travelling_trader
	startWhen = 0
	endWhen = 900 //you effectively have 15 minutes to complete the traders request, before they disappear
	var/mob/living/carbon/human/dummy/travelling_trader/trader
	var/atom/spawn_location //where the trader appears

/datum/round_event/travelling_trader/setup()
	if(GLOB.generic_event_spawns)
		spawn_location = pick(GLOB.generic_event_spawns)
	else
		message_admins("No event spawn landmarks exist on the map while placing a travelling trader, resorting to random station turf. (go yell at a mapper)")
		spawn_location = get_random_station_turf()

/datum/round_event/travelling_trader/start()
	//spawn a type of trader
	var/trader_type = pick(subtypesof(/mob/living/carbon/human/dummy/travelling_trader))
	trader = new trader_type(get_turf(spawn_location))
	var/datum/effect_system/smoke_spread/smoke = new
	smoke.set_up(1, spawn_location)
	smoke.start()
	trader.visible_message("<b>[trader]</b> suddenly appears in a puff of smoke!")

/datum/round_event/travelling_trader/announce(fake)
	priority_announce("A mysterious figure has been detected on sensors at [get_area(spawn_location)]", "Mysterious Figure")

/datum/round_event/travelling_trader/end()
	if(trader) // the /datum/round_event/travelling_trader has given up on waiting!
		trader.visible_message("The <b>[trader]</b> has given up on waiting!")
		qdel(trader)

//the actual trader mob
/mob/living/carbon/human/dummy/travelling_trader //similar to a dummy because we want to be resource-efficient
	var/trader_name = "Debug Travelling Trader"
	status_flags = GODMODE //avoid scenarios of people trying to kill the trader
	move_resist = MOVE_FORCE_VERY_STRONG //you can't bluespace bodybag them!
	var/datum/outfit/trader_outfit
	var/list/possible_wanted_items //weighted list of possible things to request
	var/list/possible_rewards //weighted list of possible things to give in return for the requested item
	var/atom/requested_item //the thing they chose from possible_wanted_items
	var/last_speech //last time someone tried interacting with them using their hand
	var/last_refusal //last time they vocally refused an item given to them
	var/initial_speech = "It looks like the coders did a mishap!" //first thing they say when interacted with, like a description
	var/speech_verb = "says"
	var/request_speech = "Please bring me a requested_item you shall be greatly rewarded!" //second thing they say when interacted with
	var/acceptance_speech = "This is exactly what I wanted! I shall be on my way now, thank you.!"
	var/refusal_speech = "A given_item? I wanted a requested_item!" //what they say when refusing an item
	var/active = TRUE
	var/examine_text = list("<span class='warning'>You attempt to look directly at the being's face, but it's just a blur!")
	move_resist = MOVE_FORCE_VERY_STRONG
	mob_size = MOB_SIZE_LARGE
	alpha = 200

/mob/living/carbon/human/dummy/travelling_trader/examine(mob/user)
	SEND_SIGNAL(src, COMSIG_PARENT_EXAMINE, user, examine_text)
	return examine_text

/mob/living/carbon/human/dummy/travelling_trader/proc/setup_speech(var/input_speech, var/obj/item/given_item)
	if(requested_item)
		input_speech = replacetext(input_speech, "requested_item", initial(requested_item.name))
	if(given_item)
		input_speech = replacetext(input_speech, "given_item", given_item.name)
	return input_speech

/mob/living/carbon/human/dummy/travelling_trader/on_attack_hand(mob/living/carbon/human/H)
	if(active && last_speech + 3 < world.realtime) //can only talk once per 3 seconds, to avoid spam
		last_speech = world.realtime
		if(initial_speech)
			visible_message("<b>[src]</b> [speech_verb] \"[setup_speech(initial_speech)]\"")
			sleep(15)
		if(active && request_speech) //they might not be active anymore because of the prior sleep!
			visible_message("<b>[src]</b> [speech_verb] \"[setup_speech(request_speech)]\"")

/mob/living/carbon/human/dummy/travelling_trader/attackby(obj/item/I, mob/user)
	if(active)
		if(check_item(I))
			active = FALSE
			visible_message("<b>[src]</b> [speech_verb] \"[setup_speech(acceptance_speech, I)]\"")
			qdel(I)
			sleep(15)
			give_reward(user)
			qdel(src)
		else
			if(last_refusal + 3 < world.realtime)
				last_refusal = world.realtime
				visible_message("<b>[src]</b> [speech_verb] \"[setup_speech(refusal_speech, I)]\"")

/mob/living/carbon/human/dummy/travelling_trader/proc/check_item(var/obj/item/supplied_item) //sometimes we might want to care about the properties of the item, etc
	return istype(supplied_item, requested_item)

/mob/living/carbon/human/dummy/travelling_trader/proc/give_reward()
	var/reward = pickweight(possible_rewards)
	new reward(get_turf(src))

/mob/living/carbon/human/dummy/travelling_trader/Initialize()
	. = ..() // return a hint you fuck
	add_atom_colour("#570d6b", FIXED_COLOUR_PRIORITY) //make them purple (otherworldly!)
	set_light(1, -0.7, "#AAD84B")
	ADD_TRAIT(src,TRAIT_PIERCEIMMUNE, "trader_pierce_immune") //don't let people take their blood
	equipOutfit(trader_outfit, TRUE)
	for(var/obj/item/item in src.get_equipped_items())
		ADD_TRAIT(item, TRAIT_NODROP, "trader_no_drop") //don't let people steal the travellers clothes!
		item.resistance_flags |= INDESTRUCTIBLE //don't let people burn their clothes off, either.
	if(!requested_item) //sometimes we already picked one
		requested_item = pickweight(possible_wanted_items)
	name = trader_name //gets changed in humans initialisation so we set it here

/mob/living/carbon/human/dummy/travelling_trader/Destroy()
	var/datum/effect_system/smoke_spread/smoke = new
	smoke.set_up(1, loc)
	smoke.start()
	visible_message("<b>[src]</b> disappears in a puff of smoke, leaving something on the ground!")
	..()

//travelling trader subtypes (the types that can actually spawn)
//so far there's: cook / botanist / bartender / animal hunter / artifact dealer / surgeon (6 types!)

//cook
/mob/living/carbon/human/dummy/travelling_trader/cook
	trader_name = "Otherworldly Chef"
	trader_outfit = /datum/outfit/job/cook
	initial_speech = "Mama-mia! I have came to this plane of existence, searching the greatest of foods!"
	request_speech = "Can you fetch me the delicacy known as requested_item? I would pay you for your service!"
	acceptance_speech = "Grazie! You have done me a service, my friend."
	refusal_speech = "A given_item? Surely you must be joking!"
	possible_rewards = list(/obj/item/paper/secretrecipe = 1,
		/obj/item/pizzabox/infinite = 1,
		/obj/item/kitchen/fork/throwing = 1,
		/mob/living/simple_animal/cow/random = 1)

/mob/living/carbon/human/dummy/travelling_trader/cook/Initialize()
	//pick a random crafted food item as the requested item
	var/datum/crafting_recipe/food_recipe = pick(subtypesof(/datum/crafting_recipe/food))
	var/result = initial(food_recipe.result)
	if(ispath(result, /obj/item/reagent_containers/food)) //not all food recipes make food objects (like cak/butterbear)
		requested_item = result
	else
		requested_item = /obj/item/reagent_containers/food/snacks/copypasta
	..()

//botanist
/mob/living/carbon/human/dummy/travelling_trader/gardener
	trader_name = "Otherworldly Gardener"
	trader_outfit = /datum/outfit/job/botanist
	initial_speech = "I have come across this realm in search of rare plants and believe this station may be able to help me.."
	request_speech = "Are you able to bring me the plant known to you as: 'requested_item'? I could see that you get some reward for this task."
	acceptance_speech = "Amazing! Ill finally be able to make that salad. Goodbye for now!"
	refusal_speech = "A given_item? Did nobody ever teach you the basics of gardening?"
	possible_rewards = list(/obj/item/seeds/cherry/bomb = 1,
		/obj/item/storage/box/strange_seeds_5pack = 6,
		/obj/item/clothing/suit/hooded/bee_costume = 2,
		/obj/item/seeds/gatfruit = 1) //overall you have less chance of seeing them than a lifebringer just bringing the seeds to you directly


/mob/living/carbon/human/dummy/travelling_trader/gardener/Initialize()
	requested_item = pick(subtypesof(/obj/item/reagent_containers/food/snacks/grown) - list(/obj/item/reagent_containers/food/snacks/grown/shell,
		/obj/item/reagent_containers/food/snacks/grown/shell/gatfruit,
		/obj/item/reagent_containers/food/snacks/grown/cherry_bomb))
	..()

//animal hunter
/mob/living/carbon/human/dummy/travelling_trader/animal_hunter
	trader_name = "Otherworldly Animal Specialist"
	trader_outfit = /datum/outfit/job/doctor
	initial_speech = "Greetings, lifeform. I am here to locate a special creature aboard your station."
	request_speech = "Find me the creature known as 'requested_item' and hand it to me, preferably in a suitable container."
	refusal_speech = "Do you think me to be a fool, lifeform? I know a requested_item when I see one."
	possible_wanted_items = list(/mob/living/simple_animal/pet/dog/corgi = 4,
	/mob/living/carbon/monkey = 1,
	/mob/living/simple_animal/mouse = 2)
	possible_rewards = list(/mob/living/simple_animal/pet/dog/corgi/exoticcorgi = 1, //rewards are animals, friendly to only the person who handed the reward in!
		/mob/living/simple_animal/cockroach = 1,
		/mob/living/simple_animal/hostile/skeleton = 1,
		/mob/living/simple_animal/hostile/stickman = 1,
		/mob/living/simple_animal/hostile/stickman/dog = 1,
		/mob/living/simple_animal/hostile/asteroid/fugu = 1,
		/mob/living/simple_animal/hostile/bear = 1,
		/mob/living/simple_animal/hostile/retaliate/clown/fleshclown = 1,
		/mob/living/simple_animal/hostile/tree = 1,
		/mob/living/simple_animal/hostile/mimic = 1,
		/mob/living/simple_animal/hostile/shark = 1,
		/mob/living/simple_animal/hostile/netherworld/blankbody = 1,
		/mob/living/simple_animal/hostile/retaliate/goose = 1)

/mob/living/carbon/human/dummy/travelling_trader/animal_hunter/Initialize()
	. = ..()
	acceptance_speech = pick(list("This lifeform shall make for a great stew, thank you.", "This lifeform shall be of a true use to our cause, thank you.", "The lifeform is adequate. Goodbye.", "This lifeform shall make a great addition to my collection."))

/mob/living/carbon/human/dummy/travelling_trader/animal_hunter/check_item(obj/item/supplied_item) //item is likely to be in contents of whats supplied
	for(var/atom/something in supplied_item.contents)
		if(istype(something, requested_item))
			qdel(something) //typically things holding mobs release the mob when the container is deleted, so delete the mob first here
			return TRUE
	return FALSE

/mob/living/carbon/human/dummy/travelling_trader/animal_hunter/give_reward(mob/giver) //the reward is actually given in a jar, because releasing it onto the station might be a bad idea
	var/obj/item/pet_carrier/bluespace/single_use/jar = new(get_turf(src))
	var/chosen_animal = pickweight(possible_rewards)
	var/mob/living/new_animal = new chosen_animal(jar)
	if(giver && giver.tag)
		new_animal.faction += "\[[giver.tag]\]"
	jar.add_occupant(new_animal)
	jar.name = "WARNING: [new_animal]"

//bartender
/mob/living/carbon/human/dummy/travelling_trader/bartender
	trader_name = "Otherworldly Bartender"
	trader_outfit = /datum/outfit/job/bartender
	initial_speech = "Greetings, station inhabitor. I came to this dimension in the pursuit of a particular drink."
	request_speech = "Bring me thirty units of the beverage known as 'requested_item'."
	acceptance_speech = "This is truly the drink I have been seeking. Thank you."
	refusal_speech = "Do not mess with me, simpleton, I do not wish for that which you are trying to give me."
	possible_rewards = list(/obj/structure/reagent_dispensers/keg/neurotoxin = 1, //all kegs have 250u aside from neurotoxin/hearty punch which have 100u
		/obj/structure/reagent_dispensers/keg/hearty_punch = 3,
		/obj/structure/reagent_dispensers/keg/red_queen = 3,
		/obj/structure/reagent_dispensers/keg/narsour = 3,
		/obj/structure/reagent_dispensers/keg/quintuple_sec = 3)

/mob/living/carbon/human/dummy/travelling_trader/bartender/Initialize() //pick a subtype of ethanol that isn't found in the default set of the booze dispensers reagents
	. = ..() // RETURN A HINT.
	requested_item = pick(subtypesof(/datum/reagent/consumable/ethanol) - list(/datum/reagent/consumable/ethanol/beer,
		/datum/reagent/consumable/ethanol/kahlua,
		/datum/reagent/consumable/ethanol/whiskey,
		/datum/reagent/consumable/ethanol/wine,
		/datum/reagent/consumable/ethanol/vodka,
		/datum/reagent/consumable/ethanol/gin,
		/datum/reagent/consumable/ethanol/rum,
		/datum/reagent/consumable/ethanol/tequila,
		/datum/reagent/consumable/ethanol/vermouth,
		/datum/reagent/consumable/ethanol/cognac,
		/datum/reagent/consumable/ethanol/ale,
		/datum/reagent/consumable/ethanol/absinthe,
		/datum/reagent/consumable/ethanol/hcider,
		/datum/reagent/consumable/ethanol/creme_de_menthe,
		/datum/reagent/consumable/ethanol/creme_de_cacao,
		/datum/reagent/consumable/ethanol/creme_de_coconut,
		/datum/reagent/consumable/ethanol/triple_sec,
		/datum/reagent/consumable/ethanol/sake,
		/datum/reagent/consumable/ethanol/applejack))

/mob/living/carbon/human/dummy/travelling_trader/bartender/check_item(var/obj/item/supplied_item) //you need to check its reagents
	if(istype(supplied_item, /obj/item/reagent_containers))
		var/obj/item/reagent_containers/supplied_container = supplied_item
		if(supplied_container.reagents.has_reagent(requested_item, 30))
			return TRUE
	return FALSE

//artifact dealer
/mob/living/carbon/human/dummy/travelling_trader/artifact_dealer
	trader_name = "Otherworldly Artifact Dealer"
	trader_outfit = /datum/outfit/artifact_dealer //he's cool enough to get his own outfit
	initial_speech = "I have come here due to sensing the existence of an object of great power and importance."
	request_speech = "Give to me the great object known as: requested_item and I shall make it worth your while, traveller."
	acceptance_speech = "This is truly an artifact worthy of my collection, thank you."
	refusal_speech = "A given_item? Hah! Worthless."
	possible_wanted_items = list(/obj/item/pen/fountain/captain = 1, //various rare things and high risk but not useful things (i.e. champion belt, bedsheet, pen)
		 /obj/item/storage/belt/champion = 1,
		 /obj/item/clothing/shoes/wheelys = 1,
		 /obj/item/relic = 1,
		 /obj/item/flashlight/lamp/bananalamp = 1,
		 /obj/item/storage/box/hug = 1,
		 /obj/item/clothing/gloves/color/yellow = 1,
		 /obj/item/instrument/saxophone = 1,
		 /obj/item/bedsheet/captain = 1,
		 /obj/item/slime_extract/green = 1,
		 /obj/item/chainsaw = 1,
		 /obj/item/clothing/head/crown = 1)
	possible_rewards = list(/obj/item/storage/bag/money/c5000 = 5,
		/obj/item/circuitboard/computer/arcade/amputation = 2,
		/obj/item/stack/sticky_tape/infinite = 2,
		/obj/item/clothing/suit/hooded/wintercoat/cosmic = 2)

/mob/living/carbon/human/dummy/travelling_trader/artifact_dealer/Initialize()
	possible_rewards += list(pick(subtypesof(/obj/item/clothing/head/collectable)) = 1) //this is slightly lower because it's absolutely useless
	..()

/datum/outfit/artifact_dealer
	name = "Artifact Dealer"
	uniform = /obj/item/clothing/under/suit/black_really
	shoes = /obj/item/clothing/shoes/combat
	head = /obj/item/clothing/head/that
	glasses = /obj/item/clothing/glasses/monocle

//surgeon
/mob/living/carbon/human/dummy/travelling_trader/surgeon
	trader_name = "Otherworldly Surgeon"
	trader_outfit = /datum/outfit/otherworldly_surgeon
	initial_speech = "Hello there, meatbag. You can provide me with something I want."
	request_speech = "Find me the appendage you call 'requested_item'. I shall make sure it's worth your efforts."
	acceptance_speech = "This shall do. Goodbye, meatbag."
	refusal_speech = "That is not what I wish for. Give me a requested_item, or I shall take one by force."
	possible_wanted_items = list(/obj/item/bodypart/l_arm = 4,
		/obj/item/bodypart/r_arm = 4,
		/obj/item/bodypart/l_leg = 4,
		/obj/item/bodypart/r_leg = 4,
		/obj/item/organ/tongue = 2,
		/obj/item/organ/liver = 2,
		/obj/item/organ/lungs = 2,
		/obj/item/organ/heart = 2,
		/obj/item/organ/eyes = 1,
		/obj/item/organ/brain = 1,
		/obj/item/bodypart/head = 1)
	possible_rewards = list(/obj/item/organ/cyberimp/mouth/breathing_tube = 1,
		/obj/item/organ/eyes/robotic/thermals = 1,
		/obj/item/organ/cyberimp/arm/toolset = 1,
		/obj/item/organ/cyberimp/arm/surgery = 1,
		/obj/item/organ/cyberimp/arm/janitor = 1,
		/obj/item/organ/cyberimp/arm/flash = 1,
		/obj/item/organ/cyberimp/arm/shield = 1,
		/obj/item/organ/cyberimp/eyes/hud/medical = 1,
		/obj/item/organ/cyberimp/arm/baton = 1)

/mob/living/carbon/human/dummy/travelling_trader/surgeon/give_reward()
	var/chosen_implant = pickweight(possible_rewards)
	var/new_implant = new chosen_implant
	var/obj/item/autosurgeon/reward = new(get_turf(src))
	reward.insert_organ(new_implant)
	reward.uses = 1

/datum/outfit/otherworldly_surgeon
	name = "Otherworldly Surgeon"
	uniform = /obj/item/clothing/under/pants/white
	shoes = /obj/item/clothing/shoes/sneakers/white
	gloves = /obj/item/clothing/gloves/color/latex
	mask = /obj/item/clothing/mask/surgical
	suit = /obj/item/clothing/suit/apron/surgical
