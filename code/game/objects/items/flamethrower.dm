/obj/item/flamethrower
	name = "flamethrower"
	desc = "You are a firestarter!"
	icon = 'icons/obj/flamethrower.dmi'
	icon_state = "flamethrowerbase"
	item_state = "flamethrower_0"
	lefthand_file = 'icons/mob/inhands/weapons/flamethrower_lefthand.dmi'
	righthand_file = 'icons/mob/inhands/weapons/flamethrower_righthand.dmi'
	flags_1 = CONDUCT_1
	force = 3
	throwforce = 10
	throw_speed = 1
	throw_range = 5
	w_class = WEIGHT_CLASS_NORMAL
	custom_materials = list(/datum/material/iron=500)
	resistance_flags = FIRE_PROOF
	var/status = FALSE
	var/lit = FALSE	//on or off
	var/operating = FALSE//cooldown
	var/obj/item/weldingtool/weldtool = null
	var/obj/item/assembly/igniter/igniter = null
	var/obj/item/tank/internals/plasma/ptank = null
	var/warned_admins = FALSE //for the message_admins() when lit
	//variables for prebuilt flamethrowers
	var/create_full = FALSE
	var/create_with_tank = FALSE
	var/igniter_type = /obj/item/assembly/igniter
	trigger_guard = TRIGGER_GUARD_NORMAL

/obj/item/flamethrower/ComponentInitialize()
	. = ..()
	AddElement(/datum/element/update_icon_updates_onmob)

/obj/item/flamethrower/Destroy()
	if(weldtool)
		qdel(weldtool)
	if(igniter)
		qdel(igniter)
	if(ptank)
		qdel(ptank)
	return ..()

/obj/item/flamethrower/process()
	if(!lit || !igniter)
		STOP_PROCESSING(SSobj, src)
		return null
	var/turf/location = loc
	if(istype(location, /mob/))
		var/mob/M = location
		if(M.is_holding(src))
			location = M.loc
	if(isturf(location)) //start a fire if possible
		igniter.flamethrower_process(location)

/obj/item/flamethrower/update_icon_state()
	item_state = "flamethrower_[lit]"

/obj/item/flamethrower/update_overlays()
	. = ..()
	if(igniter)
		. += "+igniter[status]"
	if(ptank)
		. += "+ptank"
	if(lit)
		. += "+lit"

/obj/item/flamethrower/afterattack(atom/target, mob/user, flag)
	. = ..()
	if(flag)
		return // too close
	if(ishuman(user))
		if(!can_trigger_gun(user))
			return
	if(user && user.get_active_held_item() == src) // Make sure our user is still holding us
		var/turf/target_turf = get_turf(target)
		if(target_turf)
			var/turflist = getline(user, target_turf)
			log_combat(user, target, "flamethrowered", src)
			flame_turf(turflist)

/obj/item/flamethrower/attackby(obj/item/W, mob/user, params)
	if(istype(W, /obj/item/wrench) && !status)//Taking this apart
		var/turf/T = get_turf(src)
		if(weldtool)
			weldtool.forceMove(T)
			weldtool = null
		if(igniter)
			igniter.forceMove(T)
			igniter = null
		if(ptank)
			ptank.forceMove(T)
			ptank = null
		new /obj/item/stack/rods(T)
		qdel(src)
		return

	else if(istype(W, /obj/item/screwdriver) && igniter && !lit)
		status = !status
		to_chat(user, "<span class='notice'>[igniter] is now [status ? "secured" : "unsecured"]!</span>")
		update_icon()
		return

	else if(isigniter(W))
		var/obj/item/assembly/igniter/I = W
		if(I.secured)
			return
		if(igniter)
			return
		if(!user.transferItemToLoc(W, src))
			return
		igniter = I
		update_icon()
		return

	else if(istype(W, /obj/item/tank/internals/plasma))
		if(ptank)
			if(user.transferItemToLoc(W,src))
				ptank.forceMove(get_turf(src))
				ptank = W
				to_chat(user, "<span class='notice'>You swap the plasma tank in [src]!</span>")
			return
		if(!user.transferItemToLoc(W, src))
			return
		ptank = W
		update_icon()
		return

	else
		return ..()

/obj/item/flamethrower/analyzer_act(mob/living/user, obj/item/I)
	if(ptank)
		ptank.analyzer_act(user, I)
	return TRUE


/obj/item/flamethrower/attack_self(mob/user)
	toggle_igniter(user)

/obj/item/flamethrower/AltClick(mob/user)
	. = ..()
	if(ptank && isliving(user) && user.canUseTopic(src, BE_CLOSE, ismonkey(user)))
		user.put_in_hands(ptank)
		ptank = null
		to_chat(user, "<span class='notice'>You remove the plasma tank from [src]!</span>")
		update_icon()
		return TRUE

/obj/item/flamethrower/examine(mob/user)
	. = ..()
	if(ptank)
		. += "<span class='notice'>\The [src] has \a [ptank] attached. Alt-click to remove it.</span>"

/obj/item/flamethrower/proc/toggle_igniter(mob/user)
	if(!ptank)
		to_chat(user, "<span class='notice'>Attach a plasma tank first!</span>")
		return
	if(!status)
		to_chat(user, "<span class='notice'>Secure the igniter first!</span>")
		return
	to_chat(user, "<span class='notice'>You [lit ? "extinguish" : "ignite"] [src]!</span>")
	lit = !lit
	if(lit)
		START_PROCESSING(SSobj, src)
		if(!warned_admins)
			message_admins("[ADMIN_LOOKUPFLW(user)] has lit a flamethrower.")
			warned_admins = TRUE
	else
		STOP_PROCESSING(SSobj,src)
	update_icon()

/obj/item/flamethrower/CheckParts(list/parts_list)
	..()
	weldtool = locate(/obj/item/weldingtool) in contents
	igniter = locate(/obj/item/assembly/igniter) in contents
	weldtool.status = FALSE
	igniter.secured = FALSE
	status = TRUE
	update_icon()

//Called from turf.dm turf/dblclick
/obj/item/flamethrower/proc/flame_turf(turflist)
	if(!lit || operating)
		return
	operating = TRUE
	var/turf/previousturf = get_turf(src)
	for(var/turf/T in turflist)
		if(T == previousturf)
			continue	//so we don't burn the tile we be standin on
		var/list/turfs_sharing_with_prev = previousturf.GetAtmosAdjacentTurfs(alldir=1)
		if(!(T in turfs_sharing_with_prev))
			break
		if(igniter)
			igniter.ignite_turf(src,T)
		else
			default_ignite(T)
		sleep(1)
		previousturf = T
	operating = FALSE
	if(usr.machine == src)
		attack_self(usr)


/obj/item/flamethrower/proc/default_ignite(turf/target, release_amount = 0.05)
	//TODO: DEFERRED Consider checking to make sure tank pressure is high enough before doing this...
	//Transfer 5% of current tank air contents to turf
	var/datum/gas_mixture/air_transfer = ptank.air_contents.remove_ratio(release_amount)
	air_transfer.set_moles(/datum/gas/plasma, air_transfer.get_moles(/datum/gas/plasma) * 5)
	target.assume_air(air_transfer)
	//Burn it based on transfered gas
	target.hotspot_expose((ptank.air_contents.return_temperature()*2) + 380,500)
	//location.hotspot_expose(1000,500,1)
	SSair.add_to_active(target, 0)


/obj/item/flamethrower/Initialize(mapload)
	. = ..()
	if(create_full)
		if(!weldtool)
			weldtool = new /obj/item/weldingtool(src)
		weldtool.status = FALSE
		if(!igniter)
			igniter = new igniter_type(src)
		igniter.secured = FALSE
		status = TRUE
		if(create_with_tank)
			ptank = new /obj/item/tank/internals/plasma/full(src)
		update_icon()

/obj/item/flamethrower/full
	create_full = TRUE

/obj/item/flamethrower/full/tank
	create_with_tank = TRUE

/obj/item/flamethrower/run_block(mob/living/owner, atom/object, damage, attack_text, attack_type, armour_penetration, mob/attacker, def_zone, final_block_chance, list/block_return)
	if(attack_type & ATTACK_TYPE_PROJECTILE)
		var/obj/item/projectile/P = object
		if(istype(P) && (P.damage_type != STAMINA) && damage && !P.nodamage && prob(15))
			owner.visible_message("<span class='danger'>\The [attack_text] hits the fueltank on [owner]'s [name], rupturing it! What a shot!</span>")
			var/target_turf = get_turf(owner)
			igniter.ignite_turf(src,target_turf, release_amount = 100)
			qdel(ptank)
			return BLOCK_SUCCESS | BLOCK_PHYSICAL_EXTERNAL
	return ..()

/obj/item/assembly/igniter/proc/flamethrower_process(turf/open/location)
	location.hotspot_expose(700,2)

/obj/item/assembly/igniter/cold/flamethrower_process(turf/open/location)
	return

/obj/item/assembly/igniter/proc/ignite_turf(obj/item/flamethrower/F,turf/open/location,release_amount = 0.05)
	F.default_ignite(location,release_amount)
