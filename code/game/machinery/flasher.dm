// It is a gizmo that flashes a small area

/obj/machinery/flasher
	name = "mounted flash"
	desc = "A wall-mounted flashbulb device."
	icon = 'icons/obj/stationobjs.dmi'
	icon_state = "mflash1"
	var/obj/item/device/assembly/flash/handheld/bulb = null
	var/id = null
	var/range = 2 //this is roughly the size of brig cell
	var/last_flash = 0 //Don't want it getting spammed like regular flashes
	var/strength = 5 //How weakened targets are when flashed.
	var/base_state = "mflash"
	anchored = 1

/obj/machinery/flasher/portable //Portable version of the flasher. Only flashes when anchored
	name = "portable flasher"
	desc = "A portable flashing device. Wrench to activate and deactivate. Cannot detect slow movements."
	icon_state = "pflash1-p"
	strength = 4
	anchored = 0
	base_state = "pflash"
	density = 1

/obj/machinery/flasher/New(loc, ndir = 0, built = 0)
	..() // ..() is EXTREMELY IMPORTANT, never forget to add it
	if(built)
		setDir(ndir)
		pixel_x = (dir & 3)? 0 : (dir == 4 ? -28 : 28)
		pixel_y = (dir & 3)? (dir ==1 ? -28 : 28) : 0
	else
		bulb = new /obj/item/device/assembly/flash/handheld(src)

/obj/machinery/flasher/Move()
	remove_from_proximity_list(src, range)
	..()

/obj/machinery/flasher/power_change()
	if (powered() && anchored && bulb)
		stat &= ~NOPOWER
		if(bulb.crit_fail)
			icon_state = "[base_state]1-p"
		else
			icon_state = "[base_state]1"
	else
		stat |= ~NOPOWER
		icon_state = "[base_state]1-p"

//Don't want to render prison breaks impossible
/obj/machinery/flasher/attackby(obj/item/weapon/W, mob/user, params)
	add_fingerprint(user)
	if (istype(W, /obj/item/weapon/wirecutters))
		if (bulb)
			user.visible_message("[user] begins to disconnect [src]'s flashbulb.", "<span class='notice'>You begin to disconnect [src]'s flashbulb...</span>")
			playsound(src.loc, 'sound/items/Wirecutter.ogg', 100, 1)
			if(do_after(user, 30/W.toolspeed, target = src) && bulb)
				user.visible_message("[user] has disconnected [src]'s flashbulb!", "<span class='notice'>You disconnect [src]'s flashbulb.</span>")
				bulb.loc = src.loc
				bulb = null
				power_change()

	else if (istype(W, /obj/item/device/assembly/flash/handheld))
		if (!bulb)
			if(!user.drop_item())
				return
			user.visible_message("[user] installs [W] into [src].", "<span class='notice'>You install [W] into [src].</span>")
			W.loc = src
			bulb = W
			power_change()
		else
			user << "<span class='warning'>A flashbulb is already installed in [src]!</span>"

	else if (istype(W, /obj/item/weapon/wrench))
		if(!bulb)
			user << "<span class='notice'>You start unsecuring the flasher frame...</span>"
			playsound(loc, 'sound/items/Ratchet.ogg', 50, 1)
			if(do_after(user, 40/W.toolspeed, target = src))
				user << "<span class='notice'>You unsecure the flasher frame.</span>"
				var/obj/item/wallframe/flasher/F = new(get_turf(src))
				transfer_fingerprints_to(F)
				F.id = id
				playsound(loc, 'sound/items/Deconstruct.ogg', 50, 1)
				qdel(src)
		else
			user << "<span class='warning'>Remove a flashbulb from [src] first!</span>"
	else
		return ..()

//Let the AI trigger them directly.
/obj/machinery/flasher/attack_ai()
	if (anchored)
		return flash()
	else
		return

/obj/machinery/flasher/proc/flash()
	if (!powered() || !bulb)
		return

	if (bulb.crit_fail || (last_flash && world.time < src.last_flash + 150))
		return

	if(!bulb.flash_recharge(30)) //Bulb can burn out if it's used too often too fast
		power_change()
		return
	bulb.times_used ++

	playsound(src.loc, 'sound/weapons/flash.ogg', 100, 1)
	flick("[base_state]_flash", src)
	last_flash = world.time
	use_power(1000)

	for (var/mob/living/L in viewers(src, null))
		if (get_dist(src, L) > range)
			continue

		if(L.flash_eyes(affect_silicon = 1))
			L.Weaken(strength)
			if(L.weakeyes)
				L.Weaken(strength * 1.5)
				L.visible_message("<span class='disarm'><b>[L]</b> gasps and shields their eyes!</span>")

	return 1


/obj/machinery/flasher/emp_act(severity)
	if(stat & (BROKEN|NOPOWER))
		..(severity)
		return
	if(bulb && prob(75/severity))
		flash()
		bulb.burn_out()
		power_change()
	..(severity)

/obj/machinery/flasher/portable/HasProximity(atom/movable/AM)
	if (last_flash && world.time < last_flash + 150)
		return

	if(istype(AM, /mob/living/carbon))
		var/mob/living/carbon/M = AM
		if (M.m_intent != "walk" && anchored)
			flash()

/obj/machinery/flasher/portable/attackby(obj/item/weapon/W, mob/user, params)
	if (istype(W, /obj/item/weapon/wrench))
		playsound(src.loc, 'sound/items/Ratchet.ogg', 100, 1)

		if (!anchored && !isinspace())
			user << "<span class='notice'>[src] is now secured.</span>"
			add_overlay("[base_state]-s")
			anchored = 1
			power_change()
			add_to_proximity_list(src, range)
		else
			user << "<span class='notice'>[src] can now be moved.</span>"
			cut_overlays()
			anchored = 0
			power_change()
			remove_from_proximity_list(src, range)

	else
		return ..()


/obj/item/wallframe/flasher
	name = "mounted flash frame"
	desc = "Used for building wall-mounted flashers."
	icon = 'icons/obj/stationobjs.dmi'
	icon_state = "mflash_frame"
	result_path = /obj/machinery/flasher
	var/id = null

/obj/item/wallframe/flasher/examine(mob/user)
	..()
	user << "<span class='notice'>Its channel ID is '[id]'.</span>"

/obj/item/wallframe/flasher/after_attach(var/obj/O)
	..()
	var/obj/machinery/flasher/F = O
	F.id = id