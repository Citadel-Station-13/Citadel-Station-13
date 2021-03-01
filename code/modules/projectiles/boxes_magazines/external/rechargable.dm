/obj/item/ammo_box/magazine/recharge
	name = "power pack"
	desc = "A rechargeable, detachable battery that serves as a magazine for laser rifles."
	icon_state = "oldrifle-20"
	ammo_type = /obj/item/ammo_casing/caseless/laser
	caliber = "laser"
	max_ammo = 20

/obj/item/ammo_box/magazine/recharge/update_icon()
	desc = "[initial(desc)] It has [stored_ammo.len] shot\s left."
	icon_state = "oldrifle-[round(ammo_count(),4)]"

/obj/item/ammo_box/magazine/recharge/attack_self() //No popping out the "bullets"
	return

// MWS Magazine //
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

/obj/item/ammo_box/magazine/mws_mag/update_overlays()
	.=..()
	if(!stored_ammo.len)
		return //Why bother

	var/x_offset = 5
	var/current = 0
	for(var/B in stored_ammo)
		var/obj/item/ammo_casing/mws_batt/batt = B
		var/mutable_appearance/cap = mutable_appearance(icon, "[initial(icon_state)]_cap", color = batt.type_color)
		cap.pixel_x = current * x_offset //Caps don't need a pixel_y offset
		. += cap
		if(batt.cell.charge > 0)
			var/ratio = CEILING(clamp(batt.cell.charge / batt.cell.maxcharge, 0, 1) * 4, 1) //4 is how many lights we have a sprite for
			var/mutable_appearance/charge = mutable_appearance(icon, "[initial(icon_state)]_charge-[ratio]", color =  "#29EAF4") //Could use battery color but eh.
			charge.pixel_x = current * x_offset
			. += charge

		current++ //Increment for offsets


// MWS Batteries //
/obj/item/ammo_casing/mws_batt
	name = "\'MWS\' microbattery - UNKNOWN"
	desc = "A miniature battery for an energy weapon."
	icon = 'icons/obj/ammo.dmi'
	icon_state = "mws_batt"
	slot_flags = SLOT_BELT | SLOT_EARS
	throwforce = 1

	caliber = "mws"
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
	update_icon()

/obj/item/ammo_casing/mws_batt/update_overlays()
	.=..()

	var/mutable_appearance/ends = mutable_appearance(icon, "[initial(icon_state)]_ends", color = type_color)
	. += ends

/obj/item/ammo_casing/mws_batt/get_cell()
	return cell

/obj/item/ammo_casing/mws_batt/proc/chargeshot()
	if(cell.charge >= e_cost)
		cell.use(e_cost)
		newshot()
		return

// Specific batteries //
/obj/item/ammo_casing/mws_batt/lethal
	name = "'MWS' microbattery - LETHAL"
	type_color = "#bf3d3d"
	type_name = "<span class='lethal'>LETHAL</span>"
	projectile_type = /obj/item/projectile/beam

/obj/item/ammo_casing/mws_batt/stun
	name = "'MWS' microbattery - STUN"
	type_color = "#0f81bc"
	type_name = "<span class='stun'>STUN</span>"
	projectile_type = /obj/item/projectile/beam/disabler

/obj/item/ammo_casing/mws_batt/xray
	name = "'MWS' microbattery - XRAY"
	type_color = "#32c025"
	type_name = "<span class='xray'>XRAY</span>"
	projectile_type = /obj/item/projectile/beam/xray

/obj/item/ammo_casing/mws_batt/ion
	name = "'MWS' microbattery - ION"
	type_color = "#d084d6"
	type_name = "<span class='ion'>ION</span>"
	projectile_type = /obj/item/projectile/ion
