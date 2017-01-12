//This file was auto-corrected by findeclaration.exe on 25.5.2012 20:42:33

/obj/machinery/power/emitter
	name = "Emitter"
	desc = "A heavy duty industrial laser.\n<span class='notice'>Alt-click to rotate it clockwise.</span>"
	icon = 'icons/obj/singularity.dmi'
	icon_state = "emitter"
	var/icon_state_on = "emitter_+a"
	anchored = 0
	density = 1
	req_access = list(access_engine_equip)

	use_power = 0
	idle_power_usage = 10
	active_power_usage = 300

	var/active = 0
	var/powered = 0
	var/fire_delay = 100
	var/maximum_fire_delay = 100
	var/minimum_fire_delay = 20
	var/last_shot = 0
	var/shot_number = 0
	var/state = 0
	var/locked = 0

	var/projectile_type = /obj/item/projectile/beam/emitter

	var/projectile_sound = 'sound/weapons/emitter.ogg'

/obj/machinery/power/emitter/New()
	..()
	var/obj/item/weapon/circuitboard/machine/B = new /obj/item/weapon/circuitboard/machine/emitter(null)
	B.apply_default_parts(src)
	RefreshParts()

/obj/item/weapon/circuitboard/machine/emitter
	name = "circuit board (Emitter)"
	build_path = /obj/machinery/power/emitter
	origin_tech = "programming=3;powerstorage=4;engineering=4"
	req_components = list(
							/obj/item/weapon/stock_parts/micro_laser = 1,
							/obj/item/weapon/stock_parts/manipulator = 1)

/obj/machinery/power/emitter/RefreshParts()
	var/max_firedelay = 120
	var/firedelay = 120
	var/min_firedelay = 24
	var/power_usage = 350
	for(var/obj/item/weapon/stock_parts/micro_laser/L in component_parts)
		max_firedelay -= 20 * L.rating
		min_firedelay -= 4 * L.rating
		firedelay -= 20 * L.rating
	maximum_fire_delay = max_firedelay
	minimum_fire_delay = min_firedelay
	fire_delay = firedelay
	for(var/obj/item/weapon/stock_parts/manipulator/M in component_parts)
		power_usage -= 50 * M.rating
	active_power_usage = power_usage

/obj/machinery/power/emitter/verb/rotate()
	set name = "Rotate"
	set category = "Object"
	set src in oview(1)

	if(usr.stat || !usr.canmove || usr.restrained())
		return
	if (src.anchored)
		usr << "<span class='warning'>It is fastened to the floor!</span>"
		return 0
	src.setDir(turn(src.dir, 270))
	return 1

/obj/machinery/power/emitter/AltClick(mob/user)
	..()
	if(user.incapacitated())
		user << "<span class='warning'>You can't do that right now!</span>"
		return
	if(!in_range(src, user))
		return
	else
		rotate()

/obj/machinery/power/emitter/initialize()
	..()
	if(state == 2 && anchored)
		connect_to_network()

/obj/machinery/power/emitter/Destroy()
	if(ticker && ticker.current_state == GAME_STATE_PLAYING)
		message_admins("Emitter deleted at ([x],[y],[z] - <A HREF='?_src_=holder;adminplayerobservecoodjump=1;X=[x];Y=[y];Z=[z]'>JMP</a>)",0,1)
		log_game("Emitter deleted at ([x],[y],[z])")
		investigate_log("<font color='red'>deleted</font> at ([x],[y],[z])","singulo")
	return ..()

/obj/machinery/power/emitter/update_icon()
	if (active && powernet && avail(active_power_usage))
		icon_state = icon_state_on
	else
		icon_state = initial(icon_state)


/obj/machinery/power/emitter/attack_hand(mob/user)
	src.add_fingerprint(user)
	if(state == 2)
		if(!powernet)
			user << "<span class='warning'>The emitter isn't connected to a wire!</span>"
			return 1
		if(!src.locked)
			if(src.active==1)
				src.active = 0
				user << "<span class='notice'>You turn off \the [src].</span>"
				message_admins("Emitter turned off by [key_name_admin(user)](<A HREF='?_src_=holder;adminmoreinfo=\ref[user]'>?</A>) (<A HREF='?_src_=holder;adminplayerobservefollow=\ref[user]'>FLW</A>) in ([x],[y],[z] - <A HREF='?_src_=holder;adminplayerobservecoodjump=1;X=[x];Y=[y];Z=[z]'>JMP</a>)",0,1)
				log_game("Emitter turned off by [key_name(user)] in ([x],[y],[z])")
				investigate_log("turned <font color='red'>off</font> by [key_name(user)]","singulo")
			else
				src.active = 1
				user << "<span class='notice'>You turn on \the [src].</span>"
				src.shot_number = 0
				src.fire_delay = maximum_fire_delay
				investigate_log("turned <font color='green'>on</font> by [key_name(user)]","singulo")
			update_icon()
		else
			user << "<span class='warning'>The controls are locked!</span>"
	else
		user << "<span class='warning'>The [src] needs to be firmly secured to the floor first!</span>"
		return 1


/obj/machinery/power/emitter/emp_act(severity)//Emitters are hardened but still might have issues
//	add_load(1000)
/*	if((severity == 1)&&prob(1)&&prob(1))
		if(src.active)
			src.active = 0
			src.use_power = 1	*/
	return 1


/obj/machinery/power/emitter/process()
	if(stat & (BROKEN))
		return
	if(src.state != 2 || (!powernet && active_power_usage))
		src.active = 0
		update_icon()
		return
	if(((src.last_shot + src.fire_delay) <= world.time) && (src.active == 1))

		if(!active_power_usage || avail(active_power_usage))
			add_load(active_power_usage)
			if(!powered)
				powered = 1
				update_icon()
				investigate_log("regained power and turned <font color='green'>on</font>","singulo")
		else
			if(powered)
				powered = 0
				update_icon()
				investigate_log("lost power and turned <font color='red'>off</font>","singulo")
				log_game("Emitter lost power in ([x],[y],[z])")
				message_admins("Emitter lost power in ([x],[y],[z] - <a href='?_src_=holder;adminplayerobservecoodjump=1;X=[x];Y=[y];Z=[z]'>JMP</a>)",0,1)
			return

		src.last_shot = world.time
		if(src.shot_number < 3)
			src.fire_delay = 2
			src.shot_number ++
		else
			src.fire_delay = rand(minimum_fire_delay,maximum_fire_delay)
			src.shot_number = 0

		var/obj/item/projectile/A = PoolOrNew(projectile_type,src.loc)

		A.setDir(src.dir)
		playsound(src.loc, projectile_sound, 25, 1)

		if(prob(35))
			var/datum/effect_system/spark_spread/s = new /datum/effect_system/spark_spread
			s.set_up(5, 1, src)
			s.start()

		switch(dir)
			if(NORTH)
				A.yo = 20
				A.xo = 0
			if(EAST)
				A.yo = 0
				A.xo = 20
			if(WEST)
				A.yo = 0
				A.xo = -20
			else // Any other
				A.yo = -20
				A.xo = 0
		A.starting = loc
		A.fire()


/obj/machinery/power/emitter/attackby(obj/item/W, mob/user, params)

	if(istype(W, /obj/item/weapon/wrench))
		if(active)
			user << "<span class='warning'>Turn off \the [src] first!</span>"
			return
		switch(state)
			if(0)
				if(isinspace()) return
				state = 1
				playsound(src.loc, 'sound/items/Ratchet.ogg', 75, 1)
				user.visible_message("[user.name] secures [src.name] to the floor.", \
					"<span class='notice'>You secure the external reinforcing bolts to the floor.</span>", \
					"<span class='italics'>You hear a ratchet</span>")
				src.anchored = 1
			if(1)
				state = 0
				playsound(src.loc, 'sound/items/Ratchet.ogg', 75, 1)
				user.visible_message("[user.name] unsecures [src.name] reinforcing bolts from the floor.", \
					"<span class='notice'>You undo the external reinforcing bolts.</span>", \
					"<span class='italics'>You hear a ratchet.</span>")
				src.anchored = 0
			if(2)
				user << "<span class='warning'>The [src.name] needs to be unwelded from the floor!</span>"
		return

	if(istype(W, /obj/item/weapon/weldingtool))
		var/obj/item/weapon/weldingtool/WT = W
		if(active)
			user << "Turn off \the [src] first."
			return
		switch(state)
			if(0)
				user << "<span class='warning'>The [src.name] needs to be wrenched to the floor!</span>"
			if(1)
				if (WT.remove_fuel(0,user))
					playsound(src.loc, 'sound/items/Welder2.ogg', 50, 1)
					user.visible_message("[user.name] starts to weld the [src.name] to the floor.", \
						"<span class='notice'>You start to weld \the [src] to the floor...</span>", \
						"<span class='italics'>You hear welding.</span>")
					if (do_after(user,20/W.toolspeed, target = src))
						if(!src || !WT.isOn()) return
						state = 2
						user << "<span class='notice'>You weld \the [src] to the floor.</span>"
						connect_to_network()
			if(2)
				if (WT.remove_fuel(0,user))
					playsound(src.loc, 'sound/items/Welder2.ogg', 50, 1)
					user.visible_message("[user.name] starts to cut the [src.name] free from the floor.", \
						"<span class='notice'>You start to cut \the [src] free from the floor...</span>", \
						"<span class='italics'>You hear welding.</span>")
					if (do_after(user,20/W.toolspeed, target = src))
						if(!src || !WT.isOn()) return
						state = 1
						user << "<span class='notice'>You cut \the [src] free from the floor.</span>"
						disconnect_from_network()
		return

	if(W.GetID())
		if(emagged)
			user << "<span class='warning'>The lock seems to be broken!</span>"
			return
		if(allowed(user))
			if(active)
				locked = !locked
				user << "<span class='notice'>You [src.locked ? "lock" : "unlock"] the controls.</span>"
			else
				user << "<span class='warning'>The controls can only be locked when \the [src] is online!</span>"
		else
			user << "<span class='danger'>Access denied.</span>"
		return

	if(default_deconstruction_screwdriver(user, "emitter_open", "emitter", W))
		return

	if(exchange_parts(user, W))
		return

	if(default_pry_open(W))
		return

	if(default_deconstruction_crowbar(W))
		return

	return ..()

/obj/machinery/power/emitter/emag_act(mob/user)
	if(!emagged)
		locked = 0
		emagged = 1
		if(user)
			user.visible_message("[user.name] emags the [src.name].","<span class='notice'>You short out the lock.</span>")
