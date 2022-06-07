
/obj/machinery/vending/monkey
	name = "\improper Monkey Vendor"
	desc = "A monkey vendor. Strange noises can be heard from inside."
	icon_state = "valuechimp"
	products = list(/obj/item/vended_monkey = 6)
	refill_canister = /obj/item/vending_refill/monkey
	payment_department = ACCOUNT_MED

// temporary monkey item that is dispensed onto the floor and then deletes itself, spawning a monkey
/obj/item/vended_monkey
	name = "vended monkey"
	desc = "If you're seeing this, the coders made a mistake!"
	item_flags = ABSTRACT // this stops it being placed into the user's hand by failing a can_put_in_hand check
	icon = 'icons/obj/items_and_weapons.dmi'
	icon_state = "valuechimp"

/obj/item/vended_monkey/Initialize()
	. = ..()
	new /mob/living/carbon/monkey(get_turf(src))
	qdel(src)

/obj/item/vending_refill/monkey
	machine_name = "Monkey Vendor"
	icon_state = "refill_monkey"

/obj/machinery/vending/monkey/advertise()
	// shake
	do_jiggle()
	// make monkey noises
	playsound(loc, 'modular_citadel/sound/voice/scream_monkey.ogg', 30, 1, 3, 1.2) // slightly quieter than a normal scream
	// chat effect
	visible_message("<span class='danger'>[src] shakes violently!</span>")
