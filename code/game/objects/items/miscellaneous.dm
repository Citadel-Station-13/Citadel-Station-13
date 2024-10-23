/obj/item/choice_beacon
	name = "choice beacon"
	desc = "Hey, why are you viewing this?!! Please let Centcom know about this odd occurance."
	icon = 'icons/obj/device.dmi'
	icon_state = "gangtool-blue"
	item_state = "radio"
	var/list/stored_options
	var/force_refresh = FALSE //if set to true, the beacon will recalculate its display options whenever opened

/obj/item/choice_beacon/attack_self(mob/user)
	if(canUseBeacon(user))
		generate_options(user)

/obj/item/choice_beacon/proc/generate_display_names() // return the list that will be used in the choice selection. entries should be in (type.name = type) fashion. see choice_beacon/hero for how this is done.
	return list()

/obj/item/choice_beacon/proc/canUseBeacon(mob/living/user)
	if(user.canUseTopic(src, BE_CLOSE, FALSE, NO_TK))
		return TRUE
	else
		playsound(src, 'sound/machines/buzz-sigh.ogg', 40, 1)
		return FALSE

/obj/item/choice_beacon/proc/generate_options(mob/living/M)
	if(!stored_options || force_refresh)
		stored_options = generate_display_names()
	if(!stored_options.len)
		return
	var/choice = input(M,"Which item would you like to order?","Select an Item") as null|anything in stored_options
	if(!choice || !M.canUseTopic(src, BE_CLOSE, FALSE, NO_TK))
		return

	spawn_option(stored_options[choice],M)
	qdel(src)

/obj/item/choice_beacon/proc/create_choice_atom(atom/choice, mob/owner)
	return new choice()

/obj/item/choice_beacon/proc/spawn_option(atom/choice,mob/living/M)
	var/obj/new_item = create_choice_atom(choice, M)
	var/area/pod_storage_area = locate(/area/centcom/supplypod/podStorage) in GLOB.sortedAreas
	var/obj/structure/closet/supplypod/bluespacepod/pod = new(pick(get_area_turfs(pod_storage_area))) //Lets just have it in the pod storage zone for a really short time because we don't want it in nullspace
	pod.explosionSize = list(0,0,0,0)
	new_item.forceMove(pod)
	var/msg = "<span class='danger'>After making your selection, you notice a strange target on the ground. It might be best to step back!</span>"
	if(ishuman(M))
		var/mob/living/carbon/human/H = M
		if(istype(H.ears, /obj/item/radio/headset))
			msg = "You hear something crackle in your ears for a moment before a voice speaks.  \"Please stand by for a message from Central Command.  Message as follows: <span class='bold'>Item request received. Your package is inbound, please stand back from the landing site.</span> Message ends.\""
	to_chat(M, msg)

	new /obj/effect/pod_landingzone(get_turf(src), pod)

/obj/item/choice_beacon/ingredients
	name = "ingredient box delivery beacon"
	desc = "Summon a box of ingredients from a wide selection!"
	icon_state = "gangtool-red"

/obj/item/choice_beacon/ingredients/generate_display_names()
	var/static/list/ingredientboxes
	if(!ingredientboxes)
		ingredientboxes = list()
		var/list/templist = typesof(/obj/item/storage/box/ingredients)
		for(var/V in templist)
			var/obj/item/storage/box/ingredients/A = V
			ingredientboxes[initial(A.theme_name)] = A
	return ingredientboxes

/obj/item/choice_beacon/hero
	name = "heroic beacon"
	desc = "To summon heroes from the past to protect the future."

/obj/item/choice_beacon/hero/generate_display_names()
	var/static/list/hero_item_list
	if(!hero_item_list)
		hero_item_list = list()
		var/list/templist = typesof(/obj/item/storage/box/hero) //we have to convert type = name to name = type, how lovely!
		for(var/V in templist)
			var/atom/A = V
			hero_item_list[initial(A.name)] = A
	return hero_item_list

/obj/item/storage/box/hero
	name = "Courageous Tomb Raider - 1940's."

/obj/item/storage/box/hero/PopulateContents()
	new /obj/item/clothing/head/fedora/curator(src)
	new /obj/item/clothing/suit/curator(src)
	new /obj/item/clothing/under/rank/civilian/curator/treasure_hunter(src)
	new /obj/item/clothing/shoes/workboots/mining(src)
	new /obj/item/melee/curator_whip(src)

/obj/item/storage/box/hero/astronaut
	name = "First Man on the Moon - 1960's."

/obj/item/storage/box/hero/astronaut/PopulateContents()
	new /obj/item/clothing/suit/space/nasavoid(src)
	new /obj/item/clothing/head/helmet/space/nasavoid(src)
	new /obj/item/tank/internals/emergency_oxygen/double(src)
	new /obj/item/gps(src)

/obj/item/storage/box/hero/scottish
	name = "Braveheart, the Scottish rebel - 1300's."

/obj/item/storage/box/hero/scottish/PopulateContents()
	new /obj/item/clothing/under/costume/kilt(src)
	new /obj/item/claymore/weak/ceremonial(src)
	new /obj/item/toy/crayon/spraycan(src)
	new /obj/item/clothing/shoes/sandal(src)

/obj/item/choice_beacon/hosgun
	name = "personal weapon beacon"
	desc = "Use this to summon your personal Head of Security issued firearm!"

/obj/item/choice_beacon/hosgun/generate_display_names()
	var/static/list/hos_gun_list
	if(!hos_gun_list)
		hos_gun_list = list()
		var/list/templist = subtypesof(/obj/item/storage/secure/briefcase/hos/) //we have to convert type = name to name = type, how lovely!
		for(var/V in templist)
			var/atom/A = V
			hos_gun_list[initial(A.name)] = A
	return hos_gun_list

/obj/item/choice_beacon/augments
	name = "augment beacon"
	desc = "Summons augmentations."

/obj/item/choice_beacon/augments/generate_display_names()
	var/static/list/augment_list
	if(!augment_list)
		augment_list = list()
		var/list/templist = list(
		/obj/item/organ/cyberimp/brain/anti_drop,
		/obj/item/organ/cyberimp/arm/toolset,
		/obj/item/organ/cyberimp/arm/surgery,
		/obj/item/organ/cyberimp/chest/thrusters,
		/obj/item/organ/lungs/cybernetic/tier3,
		/obj/item/organ/liver/cybernetic/tier3) //cyberimplants range from a nice bonus to fucking broken bullshit so no subtypesof
		for(var/V in templist)
			var/atom/A = V
			augment_list[initial(A.name)] = A
	return augment_list

/obj/item/choice_beacon/augments/spawn_option(atom/choice,mob/living/M)
	new choice(get_turf(M))
	to_chat(M, "<span class='hear'>You hear something crackle from the beacon for a moment before a voice speaks. \"Please stand by for a message from S.E.L.F. Message as follows: <b>Item request received. Your package has been transported, use the autosurgeon supplied to apply the upgrade.</b> Message ends.\"</span>")

/obj/item/choice_beacon/pet //donator beacon that summons a small friendly animal
	name = "pet beacon"
	desc = "Straight from the outerspace pet shop to your feet."
	var/static/list/pets = list("Crab" = /mob/living/simple_animal/crab,
		"Cat" = /mob/living/simple_animal/pet/cat,
		"Space cat" = /mob/living/simple_animal/pet/cat/space,
		"Kitten" = /mob/living/simple_animal/pet/cat/kitten,
		"Dog" = /mob/living/simple_animal/pet/dog,
		"Corgi" = /mob/living/simple_animal/pet/dog/corgi,
		"Pug" = /mob/living/simple_animal/pet/dog/pug,
		"Exotic Corgi" = /mob/living/simple_animal/pet/dog/corgi/exoticcorgi,
		"Fox" = /mob/living/simple_animal/pet/fox,
		"Red Panda" = /mob/living/simple_animal/pet/redpanda,
		"Possum" = /mob/living/simple_animal/opossum)
	var/pet_name

/obj/item/choice_beacon/pet/generate_display_names()
	return pets

/obj/item/choice_beacon/pet/create_choice_atom(atom/choice, mob/owner)
	var/mob/living/simple_animal/new_choice = new choice()
	new_choice.butcher_results = null //please don't eat your pet, chef
	var/obj/item/pet_carrier/donator/carrier = new() //a donator pet carrier is just a carrier that can't be shoved in an autolathe for metal
	carrier.add_occupant(new_choice)
	new_choice.mob_size = MOB_SIZE_TINY //yeah we're not letting you use this roundstart pet to hurt people / knock them down
	new_choice.pass_flags = PASSTABLE | PASSMOB //your pet is not a bullet/person shield
	new_choice.density = FALSE
	new_choice.blood_volume = 0 //your pet cannot be used to drain blood from for a bloodsucker
	new_choice.desc = "A pet [initial(choice.name)], owned by [owner]!"
	new_choice.can_have_ai = FALSE //no it cant be sentient damnit
	if(pet_name)
		new_choice.name = pet_name
		new_choice.unique_name = TRUE
	return carrier

/obj/item/choice_beacon/pet/spawn_option(atom/choice,mob/living/M)
	pet_name = input(M, "What would you like to name the pet? (leave blank for default name)", "Pet Name")
	..()

//choice boxes (they just open in your hand instead of making a pod)
/obj/item/choice_beacon/box
	name = "choice box (default)"
	desc = "Think really hard about what you want, and then rip it open!"
	icon = 'icons/obj/storage.dmi'
	icon_state = "deliverypackage3"
	item_state = "deliverypackage3"

/obj/item/choice_beacon/box/spawn_option(atom/choice,mob/living/M)
	var/choice_text = choice
	if(ispath(choice_text))
		choice_text = initial(choice.name)
	to_chat(M, "<span class='hear'>The box opens, revealing the [choice_text]!</span>")
	playsound(src.loc, 'sound/items/poster_ripped.ogg', 50, 1)
	M.temporarilyRemoveItemFromInventory(src, TRUE)
	M.put_in_hands(new choice)
	qdel(src)

/obj/item/choice_beacon/box/plushie/spawn_option(choice,mob/living/M)
	if(ispath(choice, /obj/item/toy/plush))
		..() //regular plush, spawn it naturally
	else
		//snowflake plush
		var/obj/item/toy/plush/snowflake_plushie = new(get_turf(M))
		snowflake_plushie.set_snowflake_from_config(choice)
		M.temporarilyRemoveItemFromInventory(src, TRUE)
		M.put_in_hands(new choice)
		qdel(src)

/obj/item/choice_beacon/box/carpet //donator carpet beacon
	name = "choice box (carpet)"
	desc = "Contains 50 of a selected carpet inside!"
	var/static/list/carpet_list = list(/obj/item/stack/tile/carpet/black/fifty = "Black Carpet",
		"Black & Red Carpet" = /obj/item/stack/tile/carpet/blackred/fifty,
		"Monochrome Carpet" = /obj/item/stack/tile/carpet/monochrome/fifty,
		"Blue Carpet" = /obj/item/stack/tile/carpet/blue/fifty,
		"Cyan Carpet" = /obj/item/stack/tile/carpet/cyan/fifty,
		"Green Carpet" = /obj/item/stack/tile/carpet/green/fifty,
		"Orange Carpet" = /obj/item/stack/tile/carpet/orange/fifty,
		"Purple Carpet" = /obj/item/stack/tile/carpet/purple/fifty,
		"Red Carpet" = /obj/item/stack/tile/carpet/red/fifty,
		"Royal Black Carpet" = /obj/item/stack/tile/carpet/royalblack/fifty,
		"Royal Blue Carpet" = /obj/item/stack/tile/carpet/royalblue/fifty)

/obj/item/choice_beacon/box/carpet/generate_display_names()
	return carpet_list

/obj/item/choice_beacon/box/plushie
	name = "choice box (plushie)"
	desc = "Using the power of quantum entanglement, this box contains every plush, until the moment it is opened!"
	icon = 'icons/obj/plushes.dmi'
	icon_state = "box"
	item_state = "box"

/obj/item/choice_beacon/box/plushie/generate_display_names()
	var/static/list/plushie_list = list()
	if(!length(plushie_list))
		//plushie set 1: just subtypes of /obj/item/toy/plush
		var/list/plushies_set_one = subtypesof(/obj/item/toy/plush)
		plushies_set_one = remove_bad_plushies(plushies_set_one)
		for(var/V in plushies_set_one)
			var/atom/A = V
			plushie_list[initial(A.name)] = A
		//plushie set 2: snowflake plushies
		var/list/plushies_set_two = CONFIG_GET(keyed_list/snowflake_plushies)
		for(var/V in plushies_set_two)
			plushie_list[V] = V //easiest way to do this which works with how selecting options works, despite being snowflakey to have the key equal the value
	return plushie_list

/// Don't allow these special ones (you can still get narplush/hugbox)
/obj/item/choice_beacon/box/plushie/proc/remove_bad_plushies(list/plushies)
	plushies -= list(
		/obj/item/toy/plush/narplush,
		/obj/item/toy/plush/awakenedplushie,
		/obj/item/toy/plush/random_snowflake,
		/obj/item/toy/plush/plushling,
		/obj/item/toy/plush/random
		)
	return plushies

/obj/item/skub
	desc = "It's skub."
	name = "skub"
	icon = 'icons/obj/items_and_weapons.dmi'
	icon_state = "skub"
	w_class = WEIGHT_CLASS_BULKY
	attack_verb = list("skubbed")
