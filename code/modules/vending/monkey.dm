
/obj/machinery/vending/monkey
	name = "\improper Monkey Vendor"
	desc = "A monkey vendor. Strange noises can be heard from inside."
	icon_state = "valuechimp"
	products = list(/obj/item/vended_monkey = 6)
	refill_canister = /obj/item/vending_refill/monkey

// temporary monkey item that is dispensed onto the floor and then deletes itself, spawning a monkey
/obj/item/vended_monkey
	name = "vended monkey"
	desc = "If you're seeing this, the coders made a mistake!"
	item_flags = ABSTRACT // this stops it being placed into the user's hand by failing a can_put_in_hand check

/obj/item/vended_monkey/Initialize()
	. = ..()
	new /mob/living/carbon/monkey(get_turf(src))
	qdel(src)

/obj/item/vending_refill/monkey
	machine_name = "Monkey Vendor"
	icon_state = "refill_cola????????" // um????? we dont have a sprite????

/obj/machinery/vending/monkey/advertise()
	// shake and make monkey noises instead
