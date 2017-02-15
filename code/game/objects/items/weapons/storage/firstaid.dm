/* First aid storage
 * Contains:
 *		First Aid Kits
 * 		Pill Bottles
 *		Dice Pack (in a pill bottle)
 */

/*
 * First Aid Kits
 */
/obj/item/weapon/storage/firstaid
	name = "first-aid kit"
	desc = "It's an emergency medical kit for those serious boo-boos."
	icon_state = "firstaid"
	throw_speed = 3
	throw_range = 7
	var/empty = 0

/obj/item/weapon/storage/firstaid/regular
	icon_state = "firstaid"
	desc = "A first aid kit with the ability to heal common types of injuries."

/obj/item/weapon/storage/firstaid/regular/New()
	..()
	if(empty) return
	new /obj/item/stack/medical/gauze(src)
	new /obj/item/stack/medical/bruise_pack(src)
	new /obj/item/stack/medical/bruise_pack(src)
	new /obj/item/stack/medical/ointment(src)
	new /obj/item/stack/medical/ointment(src)
	new /obj/item/weapon/reagent_containers/hypospray/medipen(src)
	new /obj/item/device/healthanalyzer(src)
	return

/obj/item/weapon/storage/firstaid/fire
	name = "burn treatment kit"
	desc = "A specialized medical kit for when the toxins lab <i>-spontaneously-</i> burns down."
	icon_state = "ointment"
	item_state = "firstaid-ointment"

/obj/item/weapon/storage/firstaid/fire/New()
	..()
	if(empty) return
	icon_state = pick("ointment","firefirstaid")
	for(var/i in 1 to 3)
		new /obj/item/weapon/reagent_containers/pill/patch/silver_sulf(src)
	new /obj/item/weapon/reagent_containers/pill/oxandrolone(src)
	new /obj/item/weapon/reagent_containers/pill/oxandrolone(src)
	new /obj/item/weapon/reagent_containers/hypospray/medipen(src)
	new /obj/item/device/healthanalyzer(src)
	return

/obj/item/weapon/storage/firstaid/toxin
	name = "toxin treatment kit"
	desc = "Used to treat toxic blood content and radiation poisoning."
	icon_state = "antitoxin"
	item_state = "firstaid-toxin"

/obj/item/weapon/storage/firstaid/toxin/New()
	..()
	if(empty) return
	icon_state = pick("antitoxin","antitoxfirstaid","antitoxfirstaid2","antitoxfirstaid3")
	for(var/i in 1 to 4)
		new /obj/item/weapon/reagent_containers/syringe/charcoal(src)
	for(var/i in 1 to 2)
		new /obj/item/weapon/storage/pill_bottle/charcoal(src)
	new /obj/item/device/healthanalyzer(src)
	return

/obj/item/weapon/storage/firstaid/o2
	name = "oxygen deprivation treatment kit"
	desc = "A box full of oxygen goodies."
	icon_state = "o2"
	item_state = "firstaid-o2"

/obj/item/weapon/storage/firstaid/o2/New()
	..()
	if(empty) return
	for(var/i in 1 to 4)
		new /obj/item/weapon/reagent_containers/pill/salbutamol(src)
	new /obj/item/weapon/reagent_containers/hypospray/medipen(src)
	new /obj/item/weapon/reagent_containers/hypospray/medipen(src)
	new /obj/item/device/healthanalyzer(src)
	return

/obj/item/weapon/storage/firstaid/brute
	name = "brute trauma treatment kit"
	desc = "A first aid kit for when you get toolboxed."
	icon_state = "brute"
	item_state = "firstaid-brute"

/obj/item/weapon/storage/firstaid/brute/New()
	..()
	if(empty) return
	for(var/i in 1 to 4)
		new /obj/item/weapon/reagent_containers/pill/patch/styptic(src)
	new /obj/item/stack/medical/gauze(src)
	new /obj/item/stack/medical/gauze(src)
	new /obj/item/device/healthanalyzer(src)
	return

/obj/item/weapon/storage/firstaid/tactical
	name = "combat medical kit"
	desc = "I hope you've got insurance."
	icon_state = "bezerk"
	max_w_class = WEIGHT_CLASS_NORMAL

/obj/item/weapon/storage/firstaid/tactical/New()
	..()
	if(empty) return
	new /obj/item/stack/medical/gauze(src)
	new /obj/item/weapon/defibrillator/compact/combat/loaded(src)
	new /obj/item/weapon/reagent_containers/hypospray/combat(src)
	new /obj/item/weapon/reagent_containers/pill/patch/styptic(src)
	new /obj/item/weapon/reagent_containers/pill/patch/silver_sulf(src)
	new /obj/item/weapon/reagent_containers/syringe/lethal/choral(src)
	new /obj/item/clothing/glasses/hud/health/night(src)
	return


/*
 * Pill Bottles
 */
/obj/item/weapon/storage/pill_bottle
	name = "pill bottle"
	desc = "It's an airtight container for storing medication."
	icon_state = "pill_canister"
	icon = 'icons/obj/chemical.dmi'
	item_state = "contsolid"
	w_class = WEIGHT_CLASS_SMALL
	can_hold = list(/obj/item/weapon/reagent_containers/pill,/obj/item/weapon/dice)
	allow_quick_gather = 1
	use_to_pickup = 1

/obj/item/weapon/storage/pill_bottle/MouseDrop(obj/over_object) //Quick pillbottle fix. -Agouri

	if(ishuman(usr) || ismonkey(usr)) //Can monkeys even place items in the pocket slots? Leaving this in just in case~
		var/mob/M = usr
		if(!istype(over_object, /obj/screen) || !Adjacent(M))
			return ..()
		if(!M.incapacitated() && istype(over_object, /obj/screen/inventory/hand))
			var/obj/screen/inventory/hand/H = over_object
			if(M.putItemFromInventoryInHandIfPossible(src, H.held_index))
				add_fingerprint(usr)
		if(over_object == usr && in_range(src, usr) || usr.contents.Find(src))
			if(usr.s_active)
				usr.s_active.close(usr)
			src.show_to(usr)

/obj/item/weapon/storage/box/silver_sulf
	name = "box of silver sulfadiazine patches"
	desc = "Contains patches used to treat burns."

/obj/item/weapon/storage/box/silver_sulf/New()
	..()
	for(var/i in 1 to 7)
		new /obj/item/weapon/reagent_containers/pill/patch/silver_sulf(src)

/obj/item/weapon/storage/pill_bottle/charcoal
	name = "bottle of charcoal pills"
	desc = "Contains pills used to counter toxins."

/obj/item/weapon/storage/pill_bottle/charcoal/New()
	..()
	for(var/i in 1 to 7)
		new /obj/item/weapon/reagent_containers/pill/charcoal(src)

/obj/item/weapon/storage/pill_bottle/epinephrine
	name = "bottle of epinephrine pills"
	desc = "Contains pills used to stabilize patients."

/obj/item/weapon/storage/pill_bottle/epinephrine/New()
	..()
	for(var/i in 1 to 7)
		new /obj/item/weapon/reagent_containers/pill/epinephrine(src)

/obj/item/weapon/storage/pill_bottle/mutadone
	name = "bottle of mutadone pills"
	desc = "Contains pills used to treat genetic abnormalities."

/obj/item/weapon/storage/pill_bottle/mutadone/New()
	..()
	for(var/i in 1 to 7)
		new /obj/item/weapon/reagent_containers/pill/mutadone(src)

/obj/item/weapon/storage/pill_bottle/mannitol
	name = "bottle of mannitol pills"
	desc = "Contains pills used to treat brain damage."

/obj/item/weapon/storage/pill_bottle/mannitol/New()
	..()
	for(var/i in 1 to 7)
		new /obj/item/weapon/reagent_containers/pill/mannitol(src)

/obj/item/weapon/storage/pill_bottle/stimulant
	name = "bottle of stimulant pills"
	desc = "Guaranteed to give you that extra burst of energy during a long shift!"

/obj/item/weapon/storage/pill_bottle/stimulant/New()
	..()
	for(var/i in 1 to 5)
		new /obj/item/weapon/reagent_containers/pill/stimulant(src)

/obj/item/weapon/storage/pill_bottle/mining
	name = "box of patches"
	desc = "Contains patches used to treat brute and burn damage."

/obj/item/weapon/storage/pill_bottle/mining/New()
	..()
	new /obj/item/weapon/reagent_containers/pill/patch/silver_sulf(src)
	for(var/i in 1 to 3)
		new /obj/item/weapon/reagent_containers/pill/patch/styptic(src)