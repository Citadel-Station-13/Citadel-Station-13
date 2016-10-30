/obj/structure/window
	name = "window"
	desc = "A window."
	icon_state = "window"
	density = 1
	layer = ABOVE_OBJ_LAYER //Just above doors
	pressure_resistance = 4*ONE_ATMOSPHERE
	anchored = 1 //initially is 0 for tile smoothing
	flags = ON_BORDER
	var/maxhealth = 25
	var/health = 0
	var/ini_dir = null
	var/state = 0
	var/reinf = 0
	var/wtype = "glass"
	var/fulltile = 0
//	var/silicate = 0 // number of units of silicate
//	var/icon/silicateIcon = null // the silicated icon
	var/image/crack_overlay
	var/list/debris = list()
	can_be_unanchored = 1

/obj/structure/window/examine(mob/user)
	..()
	user << "<span class='notice'>Alt-click to rotate it clockwise.</span>"

/obj/structure/window/New(Loc,re=0)
	..()
	health = maxhealth
	if(re)
		reinf = re
	if(reinf)
		state = 2*anchored

	ini_dir = dir
	air_update_turf(1)

	// Precreate our own debris

	var/shards = 1
	if(fulltile)
		shards++
	var/rods = 0
	if(reinf)
		rods++
		if(fulltile)
			rods++

	for(var/i in 1 to shards)
		debris += new /obj/item/weapon/shard(src)
	if(rods)
		debris += new /obj/item/stack/rods(src, rods)


/obj/structure/window/bullet_act(obj/item/projectile/P)
	. = ..()
	take_damage(P.damage, P.damage_type, 0)

/obj/structure/window/ex_act(severity, target)
	switch(severity)
		if(1)
			qdel(src)
		if(2)
			shatter()
		if(3)
			take_damage(rand(25,75), BRUTE, 0)

/obj/structure/window/blob_act(obj/effect/blob/B)
	shatter()

/obj/structure/window/narsie_act()
	color = NARSIE_WINDOW_COLOUR
	for(var/obj/item/weapon/shard/shard in debris)
		shard.color = NARSIE_WINDOW_COLOUR

/obj/structure/window/ratvar_act()
	if(prob(20))
		if(!fulltile)
			new/obj/structure/window/reinforced/clockwork(get_turf(src), dir)
		else
			new/obj/structure/window/reinforced/clockwork/fulltile(get_turf(src))
		qdel(src)

/obj/structure/window/singularity_pull(S, current_size)
	if(current_size >= STAGE_FIVE)
		shatter()

/obj/structure/window/CanPass(atom/movable/mover, turf/target, height=0)
	if(istype(mover) && mover.checkpass(PASSGLASS))
		return 1
	if(dir == SOUTHWEST || dir == SOUTHEAST || dir == NORTHWEST || dir == NORTHEAST)
		return 0	//full tile window, you can't move into it!
	if(get_dir(loc, target) == dir)
		return !density
	else
		return 1


/obj/structure/window/CheckExit(atom/movable/O as mob|obj, target)
	if(istype(O) && O.checkpass(PASSGLASS))
		return 1
	if(get_dir(O.loc, target) == dir)
		return 0
	return 1


/obj/structure/window/hitby(AM as mob|obj)
	..()
	var/tforce = 0
	if(ismob(AM))
		tforce = 40

	else if(isobj(AM))
		var/obj/item/I = AM
		tforce = I.throwforce
	if(reinf)
		tforce *= 0.25
	take_damage(tforce)

/obj/structure/window/attack_tk(mob/user)
	user.changeNext_move(CLICK_CD_MELEE)
	user.visible_message("<span class='notice'>Something knocks on [src].</span>")
	add_fingerprint(user)
	playsound(loc, 'sound/effects/Glassknock.ogg', 50, 1)

/obj/structure/window/attack_hulk(mob/living/carbon/human/user)
	if(!can_be_reached(user))
		return
	..(user, 1)
	user.say(pick(";RAAAAAAAARGH!", ";HNNNNNNNNNGGGGGGH!", ";GWAAAAAAAARRRHHH!", "NNNNNNNNGGGGGGGGHH!", ";AAAAAAARRRGH!"))
	user.visible_message("<span class='danger'>[user] smashes through [src]!</span>")
	add_fingerprint(user)
	take_damage(50)
	return 1

/obj/structure/window/attack_hand(mob/user)
	if(!can_be_reached(user))
		return
	user.changeNext_move(CLICK_CD_MELEE)
	user.visible_message("[user] knocks on [src].")
	add_fingerprint(user)
	playsound(loc, 'sound/effects/Glassknock.ogg', 50, 1)

/obj/structure/window/attack_paw(mob/user)
	return attack_hand(user)


/obj/structure/window/proc/attack_generic(mob/user, damage = 0, damage_type = BRUTE)	//used by attack_alien, attack_animal, and attack_slime
	if(!can_be_reached(user))
		return
	user.do_attack_animation(src)
	user.changeNext_move(CLICK_CD_MELEE)
	user.visible_message("<span class='danger'>[user] smashes into [src]!</span>")
	take_damage(damage, damage_type)

/obj/structure/window/attack_alien(mob/living/user)
	attack_generic(user, 15)

/obj/structure/window/attack_animal(mob/living/simple_animal/M)
	if(!M.melee_damage_upper)
		return
	attack_generic(M, M.melee_damage_upper, M.melee_damage_type)


/obj/structure/window/attack_slime(mob/living/simple_animal/slime/user)
	if(!user.is_adult)
		return
	attack_generic(user, rand(10, 15))


/obj/structure/window/attackby(obj/item/I, mob/living/user, params)
	if(!can_be_reached(user))
		return 1 //skip the afterattack

	add_fingerprint(user)
	if(istype(I, /obj/item/weapon/weldingtool) && user.a_intent == "help")
		var/obj/item/weapon/weldingtool/WT = I
		if(health < maxhealth)
			if(WT.remove_fuel(0,user))
				user << "<span class='notice'>You begin repairing [src]...</span>"
				playsound(loc, 'sound/items/Welder.ogg', 40, 1)
				if(do_after(user, 40/I.toolspeed, target = src))
					health = maxhealth
					playsound(loc, 'sound/items/Welder2.ogg', 50, 1)
					update_nearby_icons()
					user << "<span class='notice'>You repair [src].</span>"
		else
			user << "<span class='warning'>[src] is already in good condition!</span>"
		return


	if(!(flags&NODECONSTRUCT))
		if(istype(I, /obj/item/weapon/screwdriver))
			playsound(loc, I.usesound, 75, 1)
			if(reinf && (state == 2 || state == 1))
				user << (state == 2 ? "<span class='notice'>You begin to unscrew the window from the frame...</span>" : "<span class='notice'>You begin to screw the window to the frame...</span>")
			else if(reinf && state == 0)
				user << (anchored ? "<span class='notice'>You begin to unscrew the frame from the floor...</span>" : "<span class='notice'>You begin to screw the frame to the floor...</span>")
			else if(!reinf)
				user << (anchored ? "<span class='notice'>You begin to unscrew the window from the floor...</span>" : "<span class='notice'>You begin to screw the window to the floor...</span>")

			if(do_after(user, 30/I.toolspeed, target = src))
				if(reinf && (state == 1 || state == 2))
					//If state was unfastened, fasten it, else do the reverse
					state = (state == 1 ? 2 : 1)
					user << (state == 1 ? "<span class='notice'>You unfasten the window from the frame.</span>" : "<span class='notice'>You fasten the window to the frame.</span>")
				else if(reinf && state == 0)
					anchored = !anchored
					update_nearby_icons()
					user << (anchored ? "<span class='notice'>You fasten the frame to the floor.</span>" : "<span class='notice'>You unfasten the frame from the floor.</span>")
				else if(!reinf)
					anchored = !anchored
					update_nearby_icons()
					user << (anchored ? "<span class='notice'>You fasten the window to the floor.</span>" : "<span class='notice'>You unfasten the window.</span>")
			return

		else if (istype(I, /obj/item/weapon/crowbar) && reinf && (state == 0 || state == 1))
			user << (state == 0 ? "<span class='notice'>You begin to lever the window into the frame...</span>" : "<span class='notice'>You begin to lever the window out of the frame...</span>")
			playsound(loc, I.usesound, 75, 1)
			if(do_after(user, 40/I.toolspeed, target = src))
				//If state was out of frame, put into frame, else do the reverse
				state = (state == 0 ? 1 : 0)
				user << (state == 1 ? "<span class='notice'>You pry the window into the frame.</span>" : "<span class='notice'>You pry the window out of the frame.</span>")
			return

		else if(istype(I, /obj/item/weapon/wrench) && !anchored)
			playsound(loc, I.usesound, 75, 1)
			user << "<span class='notice'> You begin to disassemble [src]...</span>"
			if(do_after(user, 40/I.toolspeed, target = src))
				if(qdeleted(src))
					return

				if(reinf)
					var/obj/item/stack/sheet/rglass/RG = new (user.loc)
					RG.add_fingerprint(user)
					if(fulltile) //fulltiles drop two panes
						RG = new (user.loc)
						RG.add_fingerprint(user)

				else
					var/obj/item/stack/sheet/glass/G = new (user.loc)
					G.add_fingerprint(user)
					if(fulltile)
						G = new (user.loc)
						G.add_fingerprint(user)

				playsound(src.loc, 'sound/items/Deconstruct.ogg', 50, 1)
				user << "<span class='notice'>You successfully disassemble [src].</span>"
				qdel(src)
			return
	return ..()


/obj/structure/window/attacked_by(obj/item/I, mob/living/user)
	..()
	take_damage(I.force, I.damtype)

/obj/structure/window/mech_melee_attack(obj/mecha/M)
	if(..())
		take_damage(M.force, M.damtype)


/obj/structure/window/proc/can_be_reached(mob/user)
	if(!fulltile)
		if(get_dir(user,src) & dir)
			for(var/obj/O in loc)
				if(!O.CanPass(user, user.loc, 1))
					return 0
	return 1

/obj/structure/window/proc/take_damage(damage, damage_type = BRUTE, sound_effect = 1)
	if(reinf)
		damage *= 0.5
	switch(damage_type)
		if(BRUTE)
			if(sound_effect)
				playsound(loc, 'sound/effects/Glasshit.ogg', 90, 1)
		if(BURN)
			if(sound_effect)
				playsound(src.loc, 'sound/items/Welder.ogg', 100, 1)
		else
			return
	health -= damage
	update_nearby_icons()
	if(health <= 0)
		shatter()

/obj/structure/window/proc/shatter()
	if(qdeleted(src))
		return
	playsound(src, "shatter", 70, 1)
	var/turf/T = loc

	if(!(flags & NODECONSTRUCT))
		for(var/i in debris)
			var/obj/item/I = i

			I.loc = T
			transfer_fingerprints_to(I)
	qdel(src)
	update_nearby_icons()

/obj/structure/window/verb/rotate()
	set name = "Rotate Window Counter-Clockwise"
	set category = "Object"
	set src in oview(1)

	if(usr.stat || !usr.canmove || usr.restrained())
		return

	if(anchored)
		usr << "<span class='warning'>[src] cannot be rotated while it is fastened to the floor!</span>"
		return 0

	setDir(turn(dir, 90))
//	updateSilicate()
	air_update_turf(1)
	ini_dir = dir
	add_fingerprint(usr)
	return


/obj/structure/window/verb/revrotate()
	set name = "Rotate Window Clockwise"
	set category = "Object"
	set src in oview(1)

	if(usr.stat || !usr.canmove || usr.restrained())
		return

	if(anchored)
		usr << "<span class='warning'>[src] cannot be rotated while it is fastened to the floor!</span>"
		return 0

	setDir(turn(dir, 270))
//	updateSilicate()
	air_update_turf(1)
	ini_dir = dir
	add_fingerprint(usr)
	return

/obj/structure/window/AltClick(mob/user)
	..()
	if(user.incapacitated())
		user << "<span class='warning'>You can't do that right now!</span>"
		return
	if(!in_range(src, user))
		return
	else
		revrotate()

/*
/obj/structure/window/proc/updateSilicate() what do you call a syndicate silicon?
	if(silicateIcon && silicate)
		icon = initial(icon)

		var/icon/I = icon(icon,icon_state,dir)

		var/r = (silicate / 100) + 1
		var/g = (silicate / 70) + 1
		var/b = (silicate / 50) + 1
		I.SetIntensity(r,g,b)
		icon = I
		silicateIcon = I
*/

/obj/structure/window/Destroy()
	density = 0
	air_update_turf(1)
	update_nearby_icons()
	return ..()


/obj/structure/window/Move()
	var/turf/T = loc
	..()
	setDir(ini_dir)
	move_update_air(T)

/obj/structure/window/CanAtmosPass(turf/T)
	if(get_dir(loc, T) == dir)
		return !density
	if(dir == SOUTHWEST || dir == SOUTHEAST || dir == NORTHWEST || dir == NORTHEAST)
		return !density
	return 1

//This proc is used to update the icons of nearby windows.
/obj/structure/window/proc/update_nearby_icons()
	update_icon()
	if(smooth)
		queue_smooth_neighbors(src)

//merges adjacent full-tile windows into one
/obj/structure/window/update_icon()
	if(!qdeleted(src))
		if(!fulltile)
			return

		var/ratio = health / maxhealth
		ratio = Ceiling(ratio*4) * 25

		if(smooth)
			queue_smooth(src)

		overlays -= crack_overlay
		if(ratio > 75)
			return
		crack_overlay = image('icons/obj/structures.dmi',"damage[ratio]",-(layer+0.1))
		add_overlay(crack_overlay)

/obj/structure/window/temperature_expose(datum/gas_mixture/air, exposed_temperature, exposed_volume)
	if(exposed_temperature > T0C + (reinf ? 1600 : 800))
		take_damage(round(exposed_volume / 100), BURN, 0)
	..()

/obj/structure/window/storage_contents_dump_act(obj/item/weapon/storage/src_object, mob/user)
	return 0

/obj/structure/window/CanAStarPass(ID, to_dir)
	if(!density)
		return 1
	if((dir == SOUTHWEST) || (dir == to_dir))
		return 0

	return 1

/obj/structure/window/reinforced
	name = "reinforced window"
	icon_state = "rwindow"
	reinf = 1
	maxhealth = 50
	explosion_block = 1

/obj/structure/window/reinforced/tinted
	name = "tinted window"
	icon_state = "twindow"
	opacity = 1

/obj/structure/window/reinforced/tinted/frosted
	name = "frosted window"
	icon_state = "fwindow"


/* Full Tile Windows (more health) */

/obj/structure/window/fulltile
	icon = 'icons/obj/smooth_structures/window.dmi'
	icon_state = "window"
	dir = NORTHEAST
	maxhealth = 50
	fulltile = 1
	smooth = SMOOTH_TRUE
	canSmoothWith = list(/obj/structure/window/fulltile, /obj/structure/window/reinforced/fulltile, /obj/structure/window/reinforced/tinted/fulltile)

/obj/structure/window/reinforced/fulltile
	icon = 'icons/obj/smooth_structures/reinforced_window.dmi'
	icon_state = "r_window"
	dir = NORTHEAST
	maxhealth = 100
	fulltile = 1
	smooth = SMOOTH_TRUE
	canSmoothWith = list(/obj/structure/window/fulltile, /obj/structure/window/reinforced/fulltile, /obj/structure/window/reinforced/tinted/fulltile)
	level = 3

/obj/structure/window/reinforced/tinted/fulltile
	icon = 'icons/obj/smooth_structures/tinted_window.dmi'
	icon_state = "tinted_window"
	dir = NORTHEAST
	fulltile = 1
	smooth = SMOOTH_TRUE
	canSmoothWith = list(/obj/structure/window/fulltile, /obj/structure/window/reinforced/fulltile, /obj/structure/window/reinforced/tinted/fulltile/)
	level = 3

/obj/structure/window/reinforced/fulltile/ice
	icon = 'icons/obj/smooth_structures/rice_window.dmi'
	icon_state = "ice_window"
	maxhealth = 150
	canSmoothWith = list(/obj/structure/window/fulltile, /obj/structure/window/reinforced/fulltile, /obj/structure/window/reinforced/tinted/fulltile, /obj/structure/window/reinforced/fulltile/ice)
	level = 3

/obj/structure/window/shuttle
	name = "shuttle window"
	desc = "A reinforced, air-locked pod window."
	icon = 'icons/obj/smooth_structures/shuttle_window.dmi'
	icon_state = "shuttle_window"
	dir = NORTHEAST
	maxhealth = 100
	wtype = "shuttle"
	fulltile = 1
	reinf = 1
	smooth = SMOOTH_TRUE
	canSmoothWith = null
	explosion_block = 1
	level = 3

/obj/structure/window/shuttle/narsie_act()
	color = "#3C3434"

/obj/structure/window/shuttle/tinted
	opacity = TRUE

/obj/structure/window/reinforced/clockwork
	name = "brass window"
	desc = "A paper-thin pane of translucent yet reinforced brass."
	icon = 'icons/obj/smooth_structures/clockwork_window.dmi'
	icon_state = "clockwork_window_single"
	maxhealth = 100
	explosion_block = 2 //fancy AND hard to destroy. the most useful combination.

/obj/structure/window/reinforced/clockwork/New(loc, direct)
	..()
	if(!fulltile)
		var/obj/effect/E = PoolOrNew(/obj/effect/overlay/temp/ratvar/window/single, get_turf(src))
		if(direct)
			setDir(direct)
			E.setDir(direct)
	else
		PoolOrNew(/obj/effect/overlay/temp/ratvar/window, get_turf(src))
	for(var/obj/item/I in debris)
		debris -= I
		qdel(I)
	debris += new/obj/item/clockwork/component/vanguard_cogwheel(src)

/obj/structure/window/reinforced/clockwork/ratvar_act()
	health = maxhealth
	update_icon()
	return 0

/obj/structure/window/reinforced/clockwork/narsie_act()
	take_damage(rand(25, 75), BRUTE)
	if(src)
		var/previouscolor = color
		color = "#960000"
		animate(src, color = previouscolor, time = 8)

/obj/structure/window/reinforced/clockwork/fulltile
	icon_state = "clockwork_window"
	smooth = SMOOTH_TRUE
	canSmoothWith = null
	fulltile = 1
	dir = NORTHEAST
	maxhealth = 150
