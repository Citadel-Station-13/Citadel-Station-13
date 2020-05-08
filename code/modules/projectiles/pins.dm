/obj/item/firing_pin
	name = "electronic firing pin"
	desc = "A small authentication device, to be inserted into a firearm receiver to allow operation. NT safety regulations require all new designs to incorporate one."
	icon = 'icons/obj/device.dmi'
	icon_state = "firing_pin"
	item_state = "pen"
	flags_1 = CONDUCT_1
	w_class = WEIGHT_CLASS_TINY
	attack_verb = list("poked")
	var/fail_message = "<span class='warning'>INVALID USER.</span>"
	var/selfdestruct = 0 // Explode when user check is failed.
	var/force_replace = 0 // Can forcefully replace other pins.
	var/pin_removeable = 0 // Can be replaced by any pin.
	var/obj/item/gun/gun

/obj/item/firing_pin/New(newloc)
	..()
	if(istype(newloc, /obj/item/gun))
		gun = newloc

/obj/item/firing_pin/afterattack(atom/target, mob/user, proximity_flag)
	. = ..()
	if(proximity_flag)
		if(istype(target, /obj/item/gun))
			var/obj/item/gun/G = target
			if(G.no_pin_required)
				return
			if(G.pin && (force_replace || G.pin.pin_removeable))
				G.pin.forceMove(get_turf(G))
				G.pin.gun_remove(user)
				to_chat(user, "<span class ='notice'>You remove [G]'s old pin.</span>")

			if(!G.pin)
				if(!user.temporarilyRemoveItemFromInventory(src))
					return
				gun_insert(user, G)
				to_chat(user, "<span class ='notice'>You insert [src] into [G].</span>")
			else
				to_chat(user, "<span class ='notice'>This firearm already has a firing pin installed.</span>")

/obj/item/firing_pin/emag_act(mob/user)
	. = ..()
	if(obj_flags & EMAGGED)
		return
	obj_flags |= EMAGGED
	to_chat(user, "<span class='notice'>You override the authentication mechanism.</span>")
	return TRUE

/obj/item/firing_pin/proc/gun_insert(mob/living/user, obj/item/gun/G)
	gun = G
	forceMove(gun)
	gun.pin = src
	return

/obj/item/firing_pin/proc/gun_remove(mob/living/user)
	gun.pin = null
	gun = null
	return

/obj/item/firing_pin/proc/pin_auth(mob/living/user)
	return TRUE

/obj/item/firing_pin/proc/auth_fail(mob/living/user)
	if(user)
		user.show_message(fail_message, MSG_VISUAL)
	if(selfdestruct)
		if(user)
			user.show_message("<span class='danger'>SELF-DESTRUCTING...</span><br>", MSG_VISUAL)
			to_chat(user, "<span class='userdanger'>[gun] explodes!</span>")
		explosion(get_turf(gun), -1, 0, 2, 3)
		if(gun)
			qdel(gun)

/obj/item/firing_pin/magic
	name = "magic crystal shard"
	desc = "A small enchanted shard which allows magical weapons to fire."

// Test pin, works only near firing range.
/obj/item/firing_pin/test_range
	name = "test-range firing pin"
	desc = "This safety firing pin allows weapons to be fired within proximity to a firing range."
	fail_message = "<span class='warning'>TEST RANGE CHECK FAILED.</span>"
	pin_removeable = TRUE

/obj/item/firing_pin/test_range/pin_auth(mob/living/user)
	if(!istype(user))
		return FALSE
	for(var/obj/machinery/magnetic_controller/M in range(user, 3))
		return TRUE
	return FALSE


// Implant pin, checks for implant
/obj/item/firing_pin/implant
	name = "implant-keyed firing pin"
	desc = "This is a security firing pin which only authorizes users who are implanted with a certain device."
	fail_message = "<span class='warning'>IMPLANT CHECK FAILED.</span>"
	var/obj/item/implant/req_implant = null

/obj/item/firing_pin/implant/pin_auth(mob/living/user)
	if(user)
		for(var/obj/item/implant/I in user.implants)
			if(req_implant && I.type == req_implant)
				return TRUE
	return FALSE

/obj/item/firing_pin/implant/mindshield
	name = "mindshield firing pin"
	desc = "This Security firing pin authorizes the weapon for only mindshield-implanted users."
	icon_state = "firing_pin_loyalty"
	req_implant = /obj/item/implant/mindshield

/obj/item/firing_pin/implant/pindicate
	name = "syndicate firing pin"
	icon_state = "firing_pin_pindi"
	req_implant = /obj/item/implant/weapons_auth



// Honk pin, clown's joke item.
// Can replace other pins. Replace a pin in cap's laser for extra fun!
/obj/item/firing_pin/clown
	name = "hilarious firing pin"
	desc = "Advanced clowntech that can convert any firearm into a far more useful object."
	color = "#FFFF00"
	fail_message = "<span class='warning'>HONK!</span>"
	force_replace = TRUE

/obj/item/firing_pin/clown/pin_auth(mob/living/user)
	playsound(src, 'sound/items/bikehorn.ogg', 50, 1)
	return FALSE

// Ultra-honk pin, clown's deadly joke item.
// A gun with ultra-honk pin is useful for clown and useless for everyone else.
/obj/item/firing_pin/clown/ultra/pin_auth(mob/living/user)
	playsound(src.loc, 'sound/items/bikehorn.ogg', 50, 1)
	if(user && (!(HAS_TRAIT(user, TRAIT_CLUMSY)) && !(user.mind && HAS_TRAIT(user.mind, TRAIT_CLOWN_MENTALITY))))
		return FALSE
	return TRUE

/obj/item/firing_pin/clown/ultra/gun_insert(mob/living/user, obj/item/gun/G)
	..()
	G.clumsy_check = FALSE

/obj/item/firing_pin/clown/ultra/gun_remove(mob/living/user)
	gun.clumsy_check = initial(gun.clumsy_check)
	..()

// Now two times deadlier!
/obj/item/firing_pin/clown/ultra/selfdestruct
	desc = "Advanced clowntech that can convert any firearm into a far more useful object. It has a small nitrobananium charge on it."
	selfdestruct = TRUE


// DNA-keyed pin.
// When you want to keep your toys for yourself.
/obj/item/firing_pin/dna
	name = "DNA-keyed firing pin"
	desc = "This is a DNA-locked firing pin which only authorizes one user. Attempt to fire once to DNA-link."
	icon_state = "firing_pin_dna"
	fail_message = "<span class='warning'>DNA CHECK FAILED.</span>"
	var/unique_enzymes = null

/obj/item/firing_pin/dna/afterattack(atom/target, mob/user, proximity_flag)
	. = ..()
	if(proximity_flag && iscarbon(target))
		var/mob/living/carbon/M = target
		if(M.dna && M.dna.unique_enzymes)
			unique_enzymes = M.dna.unique_enzymes
			to_chat(user, "<span class='notice'>DNA-LOCK SET.</span>")

/obj/item/firing_pin/dna/pin_auth(mob/living/carbon/user)
	if(user && user.dna && user.dna.unique_enzymes)
		if(user.dna.unique_enzymes == unique_enzymes)
			return TRUE
	return FALSE

/obj/item/firing_pin/dna/auth_fail(mob/living/carbon/user)
	if(!unique_enzymes)
		if(user && user.dna && user.dna.unique_enzymes)
			unique_enzymes = user.dna.unique_enzymes
			to_chat(user, "<span class='notice'>DNA-LOCK SET.</span>")
	else
		..()

/obj/item/firing_pin/dna/dredd
	desc = "This is a DNA-locked firing pin which only authorizes one user. Attempt to fire once to DNA-link. It has a small explosive charge on it."
	selfdestruct = TRUE

/obj/item/firing_pin/holy
	name = "blessed pin"
	desc = "A firing pin that only responds to those who are holier than thou."

/obj/item/firing_pin/holy/pin_auth(mob/living/user)
	if(user.mind.isholy)
		return TRUE
	return FALSE

// Laser tag pins
/obj/item/firing_pin/tag
	name = "laser tag firing pin"
	desc = "A recreational firing pin, used in laser tag units to ensure users have their vests on."
	fail_message = "<span class='warning'>SUIT CHECK FAILED.</span>"
	var/obj/item/clothing/suit/suit_requirement = null
	var/tagcolor = ""

/obj/item/firing_pin/tag/pin_auth(mob/living/user)
	if(ishuman(user))
		var/mob/living/carbon/human/M = user
		if(istype(M.wear_suit, suit_requirement))
			return TRUE
	to_chat(user, "<span class='warning'>You need to be wearing [tagcolor] laser tag armor!</span>")
	return FALSE

/obj/item/firing_pin/tag/red
	name = "red laser tag firing pin"
	icon_state = "firing_pin_red"
	suit_requirement = /obj/item/clothing/suit/redtag
	tagcolor = "red"

/obj/item/firing_pin/tag/blue
	name = "blue laser tag firing pin"
	icon_state = "firing_pin_blue"
	suit_requirement = /obj/item/clothing/suit/bluetag
	tagcolor = "blue"

/obj/item/firing_pin/Destroy()
	if(gun)
		gun.pin = null
	return ..()

//Station Locked

/obj/item/firing_pin/away
	name = "station locked pin"
	desc = "A firing pin that only will fire when off the station."

/obj/item/firing_pin/away/pin_auth(mob/living/user)
	var/area/station_area = get_area(src)
	if(!station_area || is_station_level(station_area.z))
		to_chat(user, "<span class='warning'>The pin beeps, refusing to fire.</span>")
		return FALSE
	return TRUE

/obj/item/firing_pin/security_level
	name = "security level firing pin"
	desc = "A sophisticated firing pin that authorizes operation based on its settings and current security level."
	icon_state = "firing_pin_sec_level"
	var/min_sec_level = SEC_LEVEL_GREEN
	var/max_sec_level = SEC_LEVEL_DELTA
	var/only_lethals = FALSE
	var/can_toggle = TRUE

/obj/item/firing_pin/security_level/Initialize()
	. = ..()
	fail_message = "<span class='warning'>INVALID SECURITY LEVEL. CURRENT: [uppertext(NUM2SECLEVEL(GLOB.security_level))]. \
					MIN: [uppertext(NUM2SECLEVEL(min_sec_level))]. MAX: [uppertext(NUM2SECLEVEL(max_sec_level))]. \
					ONLY LETHALS: [only_lethals ? "YES" : "NO"].</span>"
	update_icon()

/obj/item/firing_pin/security_level/examine(mob/user)
	. = ..()
	var/lethal = only_lethals ? "only lethal " : ""
	if(min_sec_level != max_sec_level)
		. += "<span class='notice'>It's currently set to disallow [lethal]operation when the security level isn't between <b>[NUM2SECLEVEL(min_sec_level)]</b> and <b>[NUM2SECLEVEL(max_sec_level)]</b>.</span>"
	else
		. += "<span class='notice'>It's currently set to disallow [lethal]operation when the security level isn't <b>[NUM2SECLEVEL(min_sec_level)]</b>.</span>"
	if(can_toggle)
		. += "<span class='notice'>You can use a <b>multitool</b> to modify its settings.</span>"

/obj/item/firing_pin/security_level/multitool_act(mob/living/user, obj/item/I)
	. = TRUE
	if(!can_toggle || !user.canUseTopic(src, BE_CLOSE))
		return
	var/selection = alert(user, "Which setting would you want to modify?", "Firing Pin Settings", "Minimum Level Setting", "Maximum Level Setting", "Lethals Only Toggle")
	if(QDELETED(src) || QDELETED(user) || !user.canUseTopic(src, BE_CLOSE))
		return
	var/static/list/till_designs_pr_isnt_merged = list("green", "blue", "amber", "red", "delta")
	switch(selection)
		if("Minimum Level Setting")
			var/input = input(user, "Input the new minimum level setting.", "Firing Pin Settings", NUM2SECLEVEL(min_sec_level)) as null|anything in till_designs_pr_isnt_merged
			if(!input)
				return
			min_sec_level = till_designs_pr_isnt_merged.Find(input) - 1
			if(min_sec_level > max_sec_level)
				max_sec_level = SEC_LEVEL_DELTA
		if("Maximum Level Setting")
			var/input = input(user, "Input the new maximum level setting.", "Firing Pin Settings", NUM2SECLEVEL(max_sec_level)) as null|anything in till_designs_pr_isnt_merged
			if(!input)
				return
			max_sec_level = till_designs_pr_isnt_merged.Find(input) - 1
			if(max_sec_level < max_sec_level)
				min_sec_level = SEC_LEVEL_GREEN
		if("Lethals Only Toggle")
			only_lethals = !only_lethals

	fail_message = "<span class='warning'>INVALID SECURITY LEVEL. CURRENT: [uppertext(NUM2SECLEVEL(GLOB.security_level))]. \
					MIN: [uppertext(NUM2SECLEVEL(min_sec_level))]. MAX: [uppertext(NUM2SECLEVEL(max_sec_level))]. \
					ONLY LETHALS: [only_lethals ? "YES" : "NO"].</span>"
	update_icon()

/obj/item/firing_pin/security_level/update_overlays()
	. = ..()
	var/offset = 0
	for(var/level in list(min_sec_level, max_sec_level))
		var/mutable_appearance/overlay = mutable_appearance(icon, "pin_sec_level_overlay")
		overlay.pixel_x += offset
		offset += 4
		switch(level)
			if(SEC_LEVEL_GREEN)
				overlay.color = "#b2ff59" //light green
			if(SEC_LEVEL_BLUE)
				overlay.color = "#99ccff" //light blue
			if(SEC_LEVEL_AMBER)
				overlay.color = "#ffae42" //light yellow/orange
			if(SEC_LEVEL_RED)
				overlay.color = "#ff3f34" //light red
			else
				overlay.color = "#fe59c2" //neon fuchsia
		. += overlay
	var/mutable_appearance/overlay = mutable_appearance(icon, "pin_sec_level_overlay")
	overlay.pixel_x += offset
	overlay.color = only_lethals ? "#b2ff59" : "#ff3f34"
	. += overlay

/obj/item/firing_pin/security_level/pin_auth(mob/living/user)
	return (only_lethals && !(gun.chambered?.harmful)) || ISINRANGE(GLOB.security_level, min_sec_level, max_sec_level)
