/* Emags
 * Contains:
 * EMAGS AND DOORMAGS
 */


/*
 * EMAG AND SUBTYPES
 */
 
 // Standard variant
/obj/item/card/emag
	desc = "It's a card with a magnetic strip attached to some circuitry."
	name = "cryptographic sequencer"
	icon_state = "emag"
	item_state = "card-id"
	lefthand_file = 'icons/mob/inhands/equipment/idcards_lefthand.dmi'
	righthand_file = 'icons/mob/inhands/equipment/idcards_righthand.dmi'
	item_flags = NO_MAT_REDEMPTION | NOBLUDGEON

	// If the item requires you to be in range
	var/prox_check = TRUE 

	//List of types that require a specialized variant
	var/type_blacklist

/obj/item/card/emag/attack_self(mob/user)
	// Display chat message to nearby users
	if(Adjacent(user))
		user.visible_message("<span class='notice'>[user] shows you: [icon2html(src, viewers(user))] [src.name].</span>", "<span class='notice'>You show \the [src.name].</span>")

	// Add the user's fingerprint
	add_fingerprint(user)

// Bluespace variant: Works at range
/obj/item/card/emag/bluespace
	name = "bluespace cryptographic sequencer"
	desc = "It's a blue card with a magnetic strip attached to some circuitry. It appears to have some sort of transmitter attached to it."
	icon_state = "emag_bs"
	
	// Allow using this variant at range
	prox_check = FALSE

// Halloween variant: Spooky?
/obj/item/card/emag/halloween
	name = "hack-o'-lantern"
	desc = "It's a pumpkin with a cryptographic sequencer sticking out."
	icon_state = "hack_o_lantern"

// Toy variant: Joke item
/obj/item/card/emagfake
	desc = "It's a card with a magnetic strip attached to some circuitry. Closer inspection shows that this card is a poorly made replica, with a \"Donk Co.\" logo stamped on the back."
	name = "cryptographic sequencer"
	icon_state = "emag"
	item_state = "card-id"
	lefthand_file = 'icons/mob/inhands/equipment/idcards_lefthand.dmi'
	righthand_file = 'icons/mob/inhands/equipment/idcards_righthand.dmi'

/obj/item/card/emagfake/attack_self(mob/user)
	// Display chat message to nearby users
	if(Adjacent(user))
		user.visible_message("<span class='notice'>[user] shows you: [icon2html(src, viewers(user))] [src.name].</span>", "<span class='notice'>You show \the [src.name].</span>")
	
	// Add the user's fingerprint
	add_fingerprint(user)

/obj/item/card/emagfake/afterattack(atom/target, mob/user, proximity_flag, click_parameters)
	. = ..()
	// Check for proximity
	if (!proximity_flag)
		return

	// Play a honk sound at the target
	playsound(src, 'sound/items/bikehorn.ogg', 50, TRUE)

/obj/item/card/emag/Initialize(mapload)
	. = ..()
	// list of all typepaths that require a specialized variant to hack
	type_blacklist = list(
		typesof(/obj/machinery/door/airlock),
		typesof(/obj/machinery/door/window/),
		typesof(/obj/machinery/door/firedoor)
	)

/obj/item/card/emag/attack()
	return

/obj/item/card/emag/afterattack(atom/target, mob/user, proximity)
	. = ..()
	// Define the target
	var/atom/atom_target = target

	// Check for proximity or bluespace
	if(!proximity && prox_check)
		return

	// Check for valid type
	if(!can_emag(target, user))
		return

	// Log the action
	log_combat(user, atom_target, "attempted to emag")

	// Set the target to emagged
	atom_target.emag_act(user, src)

/obj/item/card/emag/proc/can_emag(atom/target, mob/user)
	// Iterate over blacklist
	for (var/subtypelist in type_blacklist)
		// Check for blacklisted subtype
		if (target.type in subtypelist)
			// Warn user in chat
			to_chat(user, span_warning("The [target] cannot be affected by the [src]! A more specialized hacking device is required."))

			// Disallow usage
			return FALSE

	// Allow usage
	return TRUE

/*
 * DOORMAG
 */
 
// Door variant: Just opens doors
/obj/item/card/emag/doorjack
	desc = "Commonly known as a \"doorjack\", this device is a specialized cryptographic sequencer specifically designed to override station airlock access codes. Uses self-refilling charges to hack airlocks."
	name = "airlock authentication override card"
	icon_state = "doorjack"
	item_state = "doorjack"

	// List of valid types
	var/type_whitelist

	// Number of uses before recharging
	var/charges = 3

	// Total possible number of charges
	var/max_charges = 3

	// Recharge timers
	var/list/charge_timers = list()

	// Time taken per recharge
	var/charge_time = 1800 // Three minutes

/obj/item/card/emag/doorjack/Initialize(mapload)
	. = ..()
	// List of all acceptable typepaths that this device can affect
	type_whitelist = list(
		typesof(/obj/machinery/door/airlock),
		typesof(/obj/machinery/door/window/),
		typesof(/obj/machinery/door/firedoor)
	) 

/obj/item/card/emag/doorjack/proc/use_charge(mob/user)
	// Remove a charge
	charges --

	// Alert user that a charge was used, and remaining count
	to_chat(user, span_notice("You use [src]. It now has [charges] charge[charges == 1 ? "" : "s"] remaining."))

	// Add a recharge timer
	charge_timers.Add(addtimer(CALLBACK(src, .proc/recharge), charge_time, TIMER_STOPPABLE))

/obj/item/card/emag/doorjack/proc/recharge(mob/user)
	// Add a charge, up to the limit
	charges = min(charges+1, max_charges)

	// Play a sound to indicate that a charge has been added
	playsound(src,'sound/machines/twobeep.ogg',10,TRUE, extrarange = SILENCED_SOUND_EXTRARANGE, falloff_distance = 0)

	// Remove a recharge timer
	charge_timers.Remove(charge_timers[1])

/obj/item/card/emag/doorjack/examine(mob/user)
	. = ..()

	// List the number of charges
	. += span_notice("It has [charges] charges remaining.")

	// Display charge progress bars
	if (length(charge_timers))
		. += "[span_notice("<b>A small display on the back reads:")]</b>"
	for (var/i in 1 to length(charge_timers))
		var/timeleft = timeleft(charge_timers[i])
		var/loadingbar = num2loadingbar(timeleft/charge_time)
		. += span_notice("<b>CHARGE #[i]: [loadingbar] ([DisplayTimeText(timeleft)])</b>")

/obj/item/card/emag/doorjack/can_emag(atom/target, mob/user)
	// Check for remaining charges
	if (charges <= 0)
		// Warn user in chat that no usages remain
		to_chat(user, span_warning("[src] is recharging!"))
		
		// Disallow usage
		return FALSE

	// Check for valid target
	for (var/list/subtypelist in type_whitelist)
		if (target.type in subtypelist)
			// Allow usage
			return TRUE

	// Warn user of invalid target
	to_chat(user, span_warning("[src] is unable to interface with this. It only seems to fit into airlock electronics."))
	
	// Disallow usage
	return FALSE
