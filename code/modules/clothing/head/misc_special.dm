/*
 * Contents:
 *		Welding mask
 *		Cakehat
 *		Ushanka
 *		Pumpkin head
 *		Kitty ears
 *		Cardborg disguise
 *		Wig
 *		Bronze hat
 */

/*
 * Welding mask
 */
/obj/item/clothing/head/welding
	name = "welding helmet"
	desc = "A head-mounted face cover designed to protect the wearer completely from space-arc eye."
	icon_state = "welding"
	flags_cover = HEADCOVERSEYES | HEADCOVERSMOUTH
	item_state = "welding"
	custom_materials = list(/datum/material/iron=1750, /datum/material/glass=400)
	flash_protect = 2
	tint = 2
	armor = list("melee" = 10, "bullet" = 0, "laser" = 0,"energy" = 0, "bomb" = 0, "bio" = 0, "rad" = 0, "fire" = 100, "acid" = 60)
	flags_inv = HIDEMASK|HIDEEARS|HIDEEYES|HIDEFACE
	actions_types = list(/datum/action/item_action/toggle)
	visor_flags_inv = HIDEMASK|HIDEEARS|HIDEEYES|HIDEFACE
	visor_flags_cover = HEADCOVERSEYES | HEADCOVERSMOUTH
	resistance_flags = FIRE_PROOF
	mutantrace_variation = STYLE_MUZZLE

/obj/item/clothing/head/welding/attack_self(mob/user)
	weldingvisortoggle(user)


/*
 * Cakehat
 */
/obj/item/clothing/head/hardhat/cakehat
	name = "cakehat"
	desc = "You put the cake on your head. Brilliant."
	icon_state = "hardhat0_cakehat"
	item_state = "hardhat0_cakehat"
	hat_type = "cakehat"
	hitsound = 'sound/weapons/tap.ogg'
	flags_inv = HIDEEARS|HIDEHAIR
	armor = list("melee" = 0, "bullet" = 0, "laser" = 0,"energy" = 0, "bomb" = 0, "bio" = 0, "rad" = 0, "fire" = 0, "acid" = 0)
	brightness_on = 2 //luminosity when on
	flags_cover = HEADCOVERSEYES
	heat = 1000

	beepsky_fashion = /datum/beepsky_fashion/cake

/obj/item/clothing/head/hardhat/cakehat/process()
	var/turf/location = src.loc
	if(ishuman(location))
		var/mob/living/carbon/human/M = location
		if(M.is_holding(src) || M.head == src)
			location = M.loc

	if(isturf(location))
		location.hotspot_expose(700, 1)

/obj/item/clothing/head/hardhat/cakehat/turn_on()
	..()
	force = 15
	throwforce = 15
	damtype = BURN
	hitsound = 'sound/items/welder.ogg'
	START_PROCESSING(SSobj, src)

/obj/item/clothing/head/hardhat/cakehat/turn_off()
	..()
	force = 0
	throwforce = 0
	damtype = BRUTE
	hitsound = 'sound/weapons/tap.ogg'
	STOP_PROCESSING(SSobj, src)

/obj/item/clothing/head/hardhat/cakehat/get_temperature()
	return on * heat
/*
 * Ushanka
 */
/obj/item/clothing/head/ushanka
	name = "ushanka"
	desc = "Perfect for winter in Siberia, da?"
	icon_state = "ushankadown"
	item_state = "ushankadown"
	alternate_screams = list('sound/voice/human/cyka1.ogg', 'sound/voice/human/cheekibreeki.ogg')
	flags_inv = HIDEEARS|HIDEHAIR
	var/earflaps = 1
	cold_protection = HEAD
	min_cold_protection_temperature = FIRE_HELM_MIN_TEMP_PROTECT

	dog_fashion = /datum/dog_fashion/head/ushanka

/obj/item/clothing/head/ushanka/attack_self(mob/user)
	if(earflaps)
		src.icon_state = "ushankaup"
		src.item_state = "ushankaup"
		earflaps = 0
		to_chat(user, "<span class='notice'>You raise the ear flaps on the ushanka.</span>")
	else
		src.icon_state = "ushankadown"
		src.item_state = "ushankadown"
		earflaps = 1
		to_chat(user, "<span class='notice'>You lower the ear flaps on the ushanka.</span>")

/*
 * Pumpkin head
 */
/obj/item/clothing/head/hardhat/pumpkinhead
	name = "carved pumpkin"
	desc = "A jack o' lantern! Believed to ward off evil spirits."
	icon_state = "hardhat0_pumpkin"
	item_state = "hardhat0_pumpkin"
	hat_type = "pumpkin"
	flags_inv = HIDEMASK|HIDEEARS|HIDEEYES|HIDEFACE|HIDEHAIR|HIDEFACIALHAIR|HIDESNOUT
	armor = list("melee" = 0, "bullet" = 0, "laser" = 0,"energy" = 0, "bomb" = 0, "bio" = 0, "rad" = 0, "fire" = 0, "acid" = 0)
	brightness_on = 2 //luminosity when on
	flags_cover = HEADCOVERSEYES

/*
 * Kitty ears
 */
/obj/item/clothing/head/kitty
	name = "kitty ears"
	desc = "A pair of kitty ears. Meow!"
	icon_state = "kitty"
	color = "#999999"
	dynamic_hair_suffix = ""

	dog_fashion = /datum/dog_fashion/head/kitty
	beepsky_fashion = /datum/beepsky_fashion/cat

/obj/item/clothing/head/kitty/equipped(mob/living/carbon/human/user, slot)
	if(ishuman(user) && slot == SLOT_HEAD)
		update_icon(user)
		user.update_inv_head() //Color might have been changed by update_icon.
	..()

/obj/item/clothing/head/kitty/update_icon(mob/living/carbon/human/user)
	if(ishuman(user))
		add_atom_colour("#[user.hair_color]", FIXED_COLOUR_PRIORITY)

/obj/item/clothing/head/kitty/genuine
	desc = "A pair of kitty ears. A tag on the inside says \"Hand made from real cats.\""


/obj/item/clothing/head/hardhat/reindeer
	name = "novelty reindeer hat"
	desc = "Some fake antlers and a very fake red nose."
	icon_state = "hardhat0_reindeer"
	item_state = "hardhat0_reindeer"
	hat_type = "reindeer"
	flags_inv = 0
	armor = list("melee" = 0, "bullet" = 0, "laser" = 0,"energy" = 0, "bomb" = 0, "bio" = 0, "rad" = 0, "fire" = 0, "acid" = 0)
	brightness_on = 1 //luminosity when on
	dynamic_hair_suffix = ""

	dog_fashion = /datum/dog_fashion/head/reindeer

/obj/item/clothing/head/cardborg
	name = "cardborg helmet"
	desc = "A helmet made out of a box."
	icon_state = "cardborg_h"
	item_state = "cardborg_h"
	flags_cover = HEADCOVERSEYES
	alternate_screams = list('modular_citadel/sound/voice/scream_silicon.ogg')
	flags_inv = HIDEMASK|HIDEEARS|HIDEEYES|HIDEFACE|HIDEHAIR|HIDEFACIALHAIR|HIDESNOUT

	dog_fashion = /datum/dog_fashion/head/cardborg

/obj/item/clothing/head/cardborg/equipped(mob/living/user, slot)
	..()
	if(ishuman(user) && slot == SLOT_HEAD)
		var/mob/living/carbon/human/H = user
		if(istype(H.wear_suit, /obj/item/clothing/suit/cardborg))
			var/obj/item/clothing/suit/cardborg/CB = H.wear_suit
			CB.disguise(user, src)

/obj/item/clothing/head/cardborg/dropped(mob/living/user)
	..()
	user.remove_alt_appearance("standard_borg_disguise")



/obj/item/clothing/head/wig
	name = "wig"
	desc = "A bunch of hair without a head attached."
	icon = 'icons/mob/hair.dmi'	  // default icon for all hairs
	icon_state = "hair_vlong"
	flags_inv = HIDEHAIR
	color = "#000"
	var/hair_style = "Very Long Hair"

/obj/item/clothing/head/wig/Initialize(mapload)
	. = ..()
	icon_state = "" //Shitty hack that i dont know if it is even neccesary to deal with the vendor stack exception
	update_icon()

/obj/item/clothing/head/wig/update_icon_state()
	var/datum/sprite_accessory/S = GLOB.hair_styles_list[hair_style]
	if(!S)
		icon = 'icons/obj/clothing/hats.dmi'
		icon_state = "pwig"
	else
		icon = S.icon
		icon_state = S.icon_state

/obj/item/clothing/head/wig/worn_overlays(isinhands = FALSE, icon_file, used_state, style_flags = NONE)
	. = ..()
	if(!isinhands)
		var/datum/sprite_accessory/S = GLOB.hair_styles_list[hair_style]
		if(!S)
			return
		var/mutable_appearance/M = mutable_appearance(S.icon, S.icon_state,layer = -HAIR_LAYER)
		M.appearance_flags |= RESET_COLOR
		M.color = color
		. += M

/obj/item/clothing/head/wig/random/Initialize(mapload)
	hair_style = pick(GLOB.hair_styles_list - "Bald") //Don't want invisible wig
	color = "#[random_short_color()]"
	. = ..()

/obj/item/clothing/head/bronze
	name = "bronze hat"
	desc = "A crude helmet made out of bronze plates. It offers very little in the way of protection."
	icon = 'icons/obj/clothing/clockwork_garb.dmi'
	icon_state = "clockwork_helmet_old"
	flags_inv = HIDEEARS|HIDEHAIR
	armor = list("melee" = 5, "bullet" = 0, "laser" = -5, "energy" = 0, "bomb" = 10, "bio" = 0, "rad" = 0, "fire" = 20, "acid" = 20)

/obj/item/clothing/head/foilhat
	name = "tinfoil hat"
	desc = "Thought control rays, psychotronic scanning. Don't mind that, I'm protected cause I made this hat."
	icon_state = "foilhat"
	item_state = "foilhat"
	armor = list("melee" = 0, "bullet" = 0, "laser" = -5,"energy" = 0, "bomb" = 0, "bio" = 0, "rad" = -5, "fire" = 0, "acid" = 0)
	equip_delay_other = 140
	var/datum/brain_trauma/mild/phobia/conspiracies/paranoia
	var/warped = FALSE
	clothing_flags = IGNORE_HAT_TOSS

/obj/item/clothing/head/foilhat/Initialize(mapload)
	. = ..()
	if(!warped)
		AddComponent(/datum/component/anti_magic, FALSE, FALSE, TRUE, ITEM_SLOT_HEAD, 6, TRUE, null, CALLBACK(src, .proc/warp_up))
	else
		warp_up()

/obj/item/clothing/head/foilhat/equipped(mob/living/carbon/human/user, slot)
	. = ..()
	if(slot != SLOT_HEAD || warped)
		return
	if(paranoia)
		QDEL_NULL(paranoia)
	paranoia = new()
	paranoia.clonable = FALSE
	user.gain_trauma(paranoia, TRAUMA_RESILIENCE_MAGIC)
	to_chat(user, "<span class='warning'>As you don the foiled hat, an entire world of conspiracy theories and seemingly insane ideas suddenly rush into your mind. What you once thought unbelievable suddenly seems.. undeniable. Everything is connected and nothing happens just by accident. You know too much and now they're out to get you. </span>")

/obj/item/clothing/head/foilhat/MouseDrop(atom/over_object)
	//God Im sorry
	if(!warped && iscarbon(usr))
		var/mob/living/carbon/C = usr
		if(src == C.head)
			to_chat(C, "<span class='userdanger'>Why would you want to take this off? Do you want them to get into your mind?!</span>")
			return
	return ..()

/obj/item/clothing/head/foilhat/dropped(mob/user)
	. = ..()
	if(paranoia)
		QDEL_NULL(paranoia)

/obj/item/clothing/head/foilhat/proc/warp_up()
	name = "scorched tinfoil hat"
	desc = "A badly warped up hat. Quite unprobable this will still work against any of fictional and contemporary dangers it used to."
	warped = TRUE
	if(!isliving(loc) || !paranoia)
		return
	var/mob/living/target = loc
	if(target.get_item_by_slot(SLOT_HEAD) != src)
		return
	QDEL_NULL(paranoia)
	if(!target.IsUnconscious())
		to_chat(target, "<span class='warning'>Your zealous conspirationism rapidly dissipates as the donned hat warps up into a ruined mess. All those theories starting to sound like nothing but a ridicolous fanfare.</span>")

/obj/item/clothing/head/foilhat/on_attack_hand(mob/user, act_intent = user.a_intent, unarmed_attack_flags)
	if(!warped && iscarbon(user))
		var/mob/living/carbon/C = user
		if(src == C.head)
			to_chat(user, "<span class='userdanger'>Why would you want to take this off? Do you want them to get into your mind?!</span>")
			return
	return ..()

/obj/item/clothing/head/foilhat/microwave_act(obj/machinery/microwave/M)
	. = ..()
	if(!warped)
		warp_up()

/obj/item/clothing/head/flakhelm	//Actually the M1 Helmet
	name = "flak helmet"
	icon_state = "m1helm"
	item_state = "helmet"
	armor = list("melee" = 0, "bullet" = 0, "laser" = 0, "energy" = 0, "bomb" = 0.1, "bio" = 0, "rad" = 0, "fire" = -10, "acid" = -15)
	desc = "A dilapidated helmet used in ancient wars. This one is brittle and essentially useless. An ace of spades is tucked into the band around the outer shell."
	pocket_storage_component_path = /datum/component/storage/concrete/pockets/tiny/spacenam	//So you can stuff other things in the elastic band instead of it simply being a fluff thing.

//The "pocket" for the M1 helmet so you can tuck things into the elastic band

/datum/component/storage/concrete/pockets/tiny/spacenam
	attack_hand_interact = TRUE		//So you can actually see what you stuff in there
