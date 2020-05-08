// -------------- HoS Modular Weapon System -------------
// ---------- Code originally from VoreStation ----------
/obj/item/gun/ballistic/revolver/mws
	name = "MWS-01 'Big Iron'"
	desc = "Modular Weapons System"

	icon = 'icons/obj/guns/projectile.dmi'
	icon_state = "mws"

	fire_sound = 'sound/weapons/Taser.ogg'

	mag_type = /obj/item/ammo_box/magazine/mws_mag
	spawnwithmagazine = FALSE

	recoil = 0

	var/charge_sections = 6

/obj/item/gun/ballistic/revolver/mws/afterattack(atom/target, mob/living/user, flag, params)
	if(chambered && !chambered.BB) //if BB is null, i.e the shot has been fired...
		var/obj/item/ammo_casing/mws_batt/shot = chambered
		if(shot.shots_left >= 1)
			shot.newshot() //Create a new shot
			update_charge()
	.=..()

/obj/item/gun/ballistic/revolver/mws/process_chamber()
	if(chambered && !chambered.BB) //if BB is null, i.e the shot has been fired...
		var/obj/item/ammo_casing/mws_batt/shot = chambered
		if(shot.shots_left >= 1)
			shot.newshot() //Create a new shot
			update_charge()
		else
			for(var/B in magazine.stored_ammo)
				var/obj/item/ammo_casing/mws_batt/other_batt = B
				if(istype(other_batt,shot) && other_batt.shots_left >= 1)
					switch_to(other_batt)
	else
		return

/obj/item/gun/ballistic/revolver/mws/proc/update_charge()

	if(!chambered)
		return

	var/obj/item/ammo_casing/mws_batt/batt = chambered
	if(batt.cell.charge >= batt.e_cost)
		batt.cell.use(batt.e_cost)

	if(batt.cell.charge > 0)
		batt.shots_left = (batt.cell.charge / batt.cell.maxcharge) * 7
	else
		batt.shots_left = 0
	update_icon()

/obj/item/gun/ballistic/revolver/mws/proc/switch_to(obj/item/ammo_casing/mws_batt/new_batt)
	if(ishuman(loc))
		if(chambered && new_batt.type == chambered.type)
			to_chat(loc,"<span class='warning'>\The [src] is now using the next [new_batt.type_name] power cell.</span>")
		else
			to_chat(loc,"<span class='warning'>\The [src] is now firing [new_batt.type_name].</span>")

	chambered = new_batt
	update_icon()

/obj/item/gun/ballistic/revolver/mws/attack_self(mob/living/user)
	if(!chambered)
		return

	var/list/stored_ammo = magazine.stored_ammo

	if(stored_ammo.len == 1)
		return //silly you.

	//Find an ammotype that ISN'T the same, or exhaust the list and don't change.
	var/our_slot = stored_ammo.Find(chambered)

	for(var/index in 1 to stored_ammo.len)
		var/true_index = ((our_slot + index - 1) % stored_ammo.len) + 1 // Stupid ONE BASED lists!
		var/obj/item/ammo_casing/mws_batt/next_batt = stored_ammo[true_index]
		if(chambered != next_batt && !istype(next_batt, chambered.type) && next_batt.shots_left >= 1)
			switch_to(next_batt)
			break

/obj/item/gun/ballistic/revolver/mws/AltClick(mob/living/user)
	if(magazine)
		magazine.forceMove(drop_location())
		user.put_in_hands(magazine)
		magazine.update_icon()
		if(magazine.ammo_count())
			playsound(src, 'sound/weapons/gun_magazine_remove_full.ogg', 70, 1)
		else
			playsound(src, "gun_remove_empty_magazine", 70, 1)
		magazine = null
		to_chat(user, "<span class='notice'>You pull the magazine out of \the [src].</span>")
		if(chambered)
			chambered = null
		update_icon()

/obj/item/gun/ballistic/revolver/mws/update_icon()

	cut_overlays()
	if(!chambered)
		return

	var/obj/item/ammo_casing/mws_batt/batt = chambered
	var/batt_color = batt.type_color //Used many times

	//Mode bar
	var/image/mode_bar = image(icon, icon_state = "[initial(icon_state)]_type")
	mode_bar.color = batt_color
	add_overlay(mode_bar)

	//Barrel color
	var/image/barrel_color = image(icon, icon_state = "[initial(icon_state)]_barrel")
	barrel_color.alpha = 150
	barrel_color.color = batt_color
	add_overlay(barrel_color)

	//Charge bar
	var/ratio = can_shoot() ? CEILING(CLAMP(batt.cell.charge / batt.cell.maxcharge, 0, 1) * charge_sections, 1) : 0
	for(var/i = 0, i < ratio, i++)
		var/image/charge_bar = image(icon, icon_state = "[initial(icon_state)]_charge")
		charge_bar.pixel_x = i
		charge_bar.color = batt_color
		add_overlay(charge_bar)

// The Magazine //
/obj/item/ammo_box/magazine/mws_mag
	name = "microbattery magazine"
	desc = "A microbattery holder for the 'Big Iron'"

	icon = 'icons/obj/ammo.dmi'
	icon_state = "mws_mag"
	caliber = "mws"
	ammo_type = /obj/item/ammo_casing/mws_batt
	start_empty = TRUE
	max_ammo = 3

	var/list/modes = list()

/obj/item/ammo_box/magazine/mws_mag/update_icon()
	cut_overlays()
	if(!stored_ammo.len)
		return //Why bother

	var/x_offset = 5
	var/current = 0
	for(var/B in stored_ammo)
		var/obj/item/ammo_casing/mws_batt/batt = B
		var/image/cap = image(icon, icon_state = "[initial(icon_state)]_cap")
		if(batt.cell.charge > 0)
			batt.shots_left = (batt.cell.charge / batt.cell.maxcharge) * 7
		else
			batt.shots_left = 0
		cap.color = batt.type_color
		cap.pixel_x = current * x_offset //Caps don't need a pixel_y offset
		add_overlay(cap)
		if(batt.shots_left)
			var/ratio = CEILING(CLAMP(batt.cell.charge / batt.cell.maxcharge, 0, 1) * 4, 1) //4 is how many lights we have a sprite for
			var/image/charge = image(icon, icon_state = "[initial(icon_state)]_charge-[ratio]")
			charge.color = "#29EAF4" //Could use battery color but eh.
			charge.pixel_x = current * x_offset
			add_overlay(charge)

		current++ //Increment for offsets

// The Casing //
/obj/item/ammo_casing/mws_batt
	name = "\'MWS\' microbattery - UNKNOWN"
	desc = "A miniature battery for an energy weapon."
	icon = 'icons/obj/ammo.dmi'
	icon_state = "mws_batt"
	slot_flags = SLOT_BELT | SLOT_EARS
	throwforce = 1

	caliber = "mws"
	var/shots_left = 6
	var/max_shots = 6
	var/type_color = null
	var/type_name = null

	var/obj/item/stock_parts/cell/cell
	var/cell_type = /obj/item/stock_parts/cell{charge = 600; maxcharge = 600}

	var/e_cost = 100
	projectile_type = /obj/item/projectile/beam

/obj/item/ammo_casing/mws_batt/Initialize()
	. = ..()
	pixel_x = rand(-10, 10)
	pixel_y = rand(-10, 10)
	cell = new cell_type(src)
	cell.give(cell.maxcharge)
	BB = null
	update_icon()

/obj/item/ammo_casing/mws_batt/update_icon()
	cut_overlays()

	var/image/ends = image(icon, icon_state = "[initial(icon_state)]_ends")
	ends.color = type_color
	add_overlay(ends)

// Specific batteries //
/obj/item/ammo_casing/mws_batt/lethal
	name = "\'MWS\' microbattery - LETHAL"
	type_color = "#bf3d3d"
	type_name = "<span style='color:#bf3d3d;font-weight:bold;'>LETHAL</span>"
	projectile_type = /obj/item/projectile/beam

/obj/item/ammo_casing/mws_batt/stun
	name = "\'MWS\' microbattery - STUN"
	type_color = "#0f81bc"
	type_name = "<span style='color:#0f81bc;font-weight:bold;'>STUN</span>"
	projectile_type = /obj/item/projectile/beam/disabler

/obj/item/ammo_casing/mws_batt/net
	name = "\'MWS\' microbattery - NET"
	type_color = "#43f136"
	type_name = "<span style='color:#43d136;font-weight:bold;'>NET</span>"
	projectile_type = /obj/item/projectile/energy/net

/obj/item/ammo_casing/mws_batt/xray
	name = "\'MWS\' microbattery - XRAY"
	type_color = "#32c025"
	type_name = "<span style='color:#32c025;font-weight:bold;'>XRAY</span>"
	projectile_type = /obj/item/projectile/beam/xray


/obj/item/ammo_casing/mws_batt/ion
	name = "\'MWS\' microbattery - ION"
	type_color = "#d084d6"
	type_name = "<span style='color:#d084d6;font-weight:bold;'>ION</span>"
	projectile_type = /obj/item/projectile/ion


/obj/item/ammo_casing/mws_batt/final
	name = "\'mws\' microbattery - FINAL OPTION"
	type_color = "#fcfc0f"
	type_name = "<span style='color:#000000;font-weight:bold;'>FINAL OPTION</span>" //Doesn't look good in yellow in chat
	projectile_type = /obj/item/projectile/beam/final_option

/obj/item/projectile/beam/final_option
	name = "final option beam"
	icon_state = "omnilaser"
	nodamage = 1
	damage = 5
	damage_type = STAMINA
	light_color = "#00CC33"

	tracer_type = /obj/effect/projectile/tracer/pulse
	muzzle_type = /obj/effect/projectile/muzzle/pulse
	impact_type = /obj/effect/projectile/impact/pulse

/obj/item/projectile/beam/final_option/on_hit(var/atom/impacted)
	if(isliving(impacted))
		var/mob/living/L = impacted
		L.gib()

	..()

/obj/item/gunbox
	name = "Modular Weapon Box"
	desc = "A box containing a micro-fabricator capable of creating one of two different weapon selections. How fancy!"
	icon = 'icons/obj/storage.dmi'
	icon_state = "lockbox+l"
	item_state = "syringe_kit"

/obj/item/gunbox/attack_self(mob/user)
	var/selection = input("Select weapon style.", "Modular Weapon Box", "Cancel") in list("X-01 Multiphase", "MWS-01 'Big Iron'", "Cancel")
	var/atom/A
	switch(selection)
		if("X-01 Multiphase")
			A = new /obj/item/gun/energy/e_gun/hos
			user.put_in_hands(A)
			qdel(src)
		if("MWS-01 'Big Iron'")
			A = new /obj/item/storage/secure/briefcase/mws_pack_hos
			user.put_in_hands(A)
			qdel(src)

/obj/item/storage/secure/briefcase/mws_pack
	name = "\improper \'MWS\' gun kit"
	desc = "A storage case for a multi-purpose handgun. Variety hour!"

/obj/item/storage/secure/briefcase/mws_pack/PopulateContents()
	new /obj/item/gun/ballistic/revolver/mws(src)
	new /obj/item/ammo_box/magazine/mws_mag(src)
	for(var/path in subtypesof(/obj/item/ammo_casing/mws_batt))
		new path(src)

/obj/item/storage/secure/briefcase/mws_pack_hos
	name = "\improper \'MWS\' gun kit"
	desc = "A storage case for a multi-purpose handgun. Variety hour!"

/obj/item/storage/secure/briefcase/mws_pack_hos/PopulateContents()
	new /obj/item/gun/ballistic/revolver/mws(src)
	new /obj/item/ammo_box/magazine/mws_mag(src)
	new /obj/item/ammo_casing/mws_batt/lethal(src)
	new /obj/item/ammo_casing/mws_batt/lethal(src)
	new /obj/item/ammo_casing/mws_batt/stun(src)
	new /obj/item/ammo_casing/mws_batt/stun(src)
	new /obj/item/ammo_casing/mws_batt/ion(src)