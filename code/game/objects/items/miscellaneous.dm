/obj/item/caution
	desc = "Caution! Wet Floor!"
	name = "wet floor sign"
	icon = 'icons/obj/janitor.dmi'
	icon_state = "caution"
	lefthand_file = 'icons/mob/inhands/equipment/custodial_lefthand.dmi'
	righthand_file = 'icons/mob/inhands/equipment/custodial_righthand.dmi'
	force = 1
	throwforce = 3
	throw_speed = 2
	throw_range = 5
	w_class = WEIGHT_CLASS_SMALL
	attack_verb = list("warned", "cautioned", "smashed")

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

/obj/item/choice_beacon/proc/spawn_option(obj/choice,mob/living/M)
	var/obj/new_item = new choice()
	var/obj/structure/closet/supplypod/bluespacepod/pod = new()
	pod.explosionSize = list(0,0,0,0)
	new_item.forceMove(pod)
	var/msg = "<span class='danger'>After making your selection, you notice a strange target on the ground. It might be best to step back!</span>"
	if(ishuman(M))
		var/mob/living/carbon/human/H = M
		if(istype(H.ears, /obj/item/radio/headset))
			msg = "You hear something crackle in your ears for a moment before a voice speaks.  \"Please stand by for a message from Central Command.  Message as follows: <span class='bold'>Item request received. Your package is inbound, please stand back from the landing site.</span> Message ends.\""
	to_chat(M, msg)

	new /obj/effect/abstract/DPtarget(get_turf(src), pod)

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
		/obj/item/organ/lungs/cybernetic,
		/obj/item/organ/liver/cybernetic) //cyberimplants range from a nice bonus to fucking broken bullshit so no subtypesof
		for(var/V in templist)
			var/atom/A = V
			augment_list[initial(A.name)] = A
	return augment_list

/obj/item/choice_beacon/augments/spawn_option(obj/choice,mob/living/M)
	new choice(get_turf(M))
	to_chat(M, "<span class='hear'>You hear something crackle from the beacon for a moment before a voice speaks. \"Please stand by for a message from S.E.L.F. Message as follows: <b>Item request received. Your package has been transported, use the autosurgeon supplied to apply the upgrade.</b> Message ends.\"</span>")

/obj/item/choice_beacon/box
	name = "choice box (default)"
	desc = "Think really hard about what you want, and then rip it open!"
	icon = 'icons/obj/storage.dmi'
	icon_state = "deliverypackage3"
	item_state = "deliverypackage3"

/obj/item/choice_beacon/box/spawn_option(obj/choice,mob/living/M)
	to_chat(M, "<span class='hear'>The box opens, revealing the [choice]!</span>")
	playsound(src.loc, 'sound/items/poster_ripped.ogg', 50, 1)
	M.temporarilyRemoveItemFromInventory(src, TRUE)
	M.put_in_hands(new choice)
	qdel(src)

/obj/item/choice_beacon/box/plushie
	name = "choice box (plushie)"
	desc = "Using the power of quantum entanglement, this box contains every plush, until the moment it is opened!"
	icon = 'icons/obj/plushes.dmi'
	icon_state = "box"
	item_state = "box"

/obj/item/choice_beacon/box/spawn_option(choice,mob/living/M)
	if(ispath(choice, /obj/item/toy/plush))
		..() //regular plush, spawn it naturally
	else
		//snowflake plush
		var/obj/item/toy/plush/snowflake_plushie = new(get_turf(M))
		snowflake_plushie.set_snowflake_from_config(choice)
		M.temporarilyRemoveItemFromInventory(src, TRUE)
		M.put_in_hands(new choice)
		qdel(src)

/obj/item/choice_beacon/box/plushie/generate_display_names()
	var/list/plushie_list = list()
	//plushie set 1: just subtypes of /obj/item/toy/plush
	var/list/plushies_set_one = subtypesof(/obj/item/toy/plush) - list(/obj/item/toy/plush/narplush, /obj/item/toy/plush/awakenedplushie, /obj/item/toy/plush/random_snowflake, /obj/item/toy/plush/random) //don't allow these special ones (you can still get narplush/hugbox)
	for(var/V in plushies_set_one)
		var/atom/A = V
		plushie_list[initial(A.name)] = A
	//plushie set 2: snowflake plushies
	var/list/plushies_set_two = CONFIG_GET(keyed_list/snowflake_plushies)
	for(var/V in plushies_set_two)
		plushie_list[V] = V //easiest way to do this which works with how selecting options works, despite being snowflakey to have the key equal the value
	return plushie_list

/obj/item/skub
	desc = "It's skub."
	name = "skub"
	icon = 'icons/obj/items_and_weapons.dmi'
	icon_state = "skub"
	w_class = WEIGHT_CLASS_BULKY
	attack_verb = list("skubbed")

