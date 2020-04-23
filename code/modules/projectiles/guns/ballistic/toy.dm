/obj/item/gun/ballistic/automatic/toy
	name = "foam force SMG"
	desc = "A prototype three-round burst toy submachine gun. Ages 8 and up."
	icon = 'icons/obj/guns/toy.dmi'
	icon_state = "saber"
	item_state = "gun"
	mag_type = /obj/item/ammo_box/magazine/toy/smg
	fire_sound = 'sound/weapons/gunshot_smg.ogg'
	force = 0
	throwforce = 0
	burst_size = 3
	can_suppress = TRUE
	clumsy_check = 0
	item_flags = NONE
	casing_ejector = FALSE

/obj/item/gun/ballistic/automatic/toy/unrestricted
	pin = /obj/item/firing_pin

/obj/item/gun/ballistic/automatic/toy/pistol
	name = "foam force pistol"
	desc = "A small, easily concealable toy handgun. Ages 8 and up."
	icon_state = "pistol"
	w_class = WEIGHT_CLASS_SMALL
	mag_type = /obj/item/ammo_box/magazine/toy/pistol
	fire_sound = 'sound/weapons/gunshot.ogg'
	burst_size = 1
	fire_delay = 0
	actions_types = list()

/obj/item/gun/ballistic/automatic/toy/pistol/update_icon()
	..()
	icon_state = "[initial(icon_state)][chambered ? "" : "-e"][suppressed ? "-suppressed" : ""]"

/obj/item/gun/ballistic/automatic/toy/pistol/riot
	mag_type = /obj/item/ammo_box/magazine/toy/pistol/riot

/obj/item/gun/ballistic/automatic/toy/pistol/riot/Initialize()
	magazine = new /obj/item/ammo_box/magazine/toy/pistol/riot(src)
	return ..()

/obj/item/gun/ballistic/automatic/toy/pistol/unrestricted
	pin = /obj/item/firing_pin

/obj/item/gun/ballistic/automatic/toy/pistol/riot/unrestricted
	pin = /obj/item/firing_pin

/obj/item/gun/ballistic/shotgun/toy
	name = "foam force shotgun"
	desc = "A toy shotgun with wood furniture and a four-shell capacity underneath. Ages 8 and up."
	icon = 'icons/obj/guns/toy.dmi'
	force = 0
	throwforce = 0
	mag_type = /obj/item/ammo_box/magazine/internal/shot/toy
	clumsy_check = FALSE
	item_flags = NONE
	casing_ejector = FALSE
	can_suppress = FALSE

/obj/item/gun/ballistic/shotgun/toy/process_chamber(empty_chamber = 0)
	..()
	if(chambered && !chambered.BB)
		qdel(chambered)

/obj/item/gun/ballistic/shotgun/toy/unrestricted
	pin = /obj/item/firing_pin

/obj/item/gun/ballistic/shotgun/toy/crossbow
	name = "foam force crossbow"
	desc = "A weapon favored by many overactive children. Ages 8 and up."
	icon = 'icons/obj/toy.dmi'
	icon_state = "foamcrossbow"
	item_state = "crossbow"
	mag_type = /obj/item/ammo_box/magazine/internal/shot/toy/crossbow
	fire_sound = 'sound/items/syringeproj.ogg'
	slot_flags = ITEM_SLOT_BELT
	w_class = WEIGHT_CLASS_SMALL

/obj/item/gun/ballistic/automatic/c20r/toy //This is the syndicate variant with syndicate firing pin and riot darts.
	name = "donksoft SMG"
	desc = "A bullpup two-round burst toy SMG, designated 'C-20r'. Ages 8 and up."
	icon = 'icons/obj/guns/toy.dmi'
	can_suppress = TRUE
	item_flags = NONE
	mag_type = /obj/item/ammo_box/magazine/toy/smgm45/riot
	casing_ejector = FALSE
	clumsy_check = FALSE

/obj/item/gun/ballistic/automatic/c20r/toy/unrestricted //Use this for actual toys
	pin = /obj/item/firing_pin
	mag_type = /obj/item/ammo_box/magazine/toy/smgm45

/obj/item/gun/ballistic/automatic/c20r/toy/unrestricted/riot
	mag_type = /obj/item/ammo_box/magazine/toy/smgm45/riot

/obj/item/gun/ballistic/automatic/l6_saw/toy //This is the syndicate variant with syndicate firing pin and riot darts.
	name = "donksoft LMG"
	desc = "A heavily modified toy light machine gun, designated 'L6 SAW'. Ages 8 and up."
	icon = 'icons/obj/guns/toy.dmi'
	can_suppress = FALSE
	item_flags = NONE
	mag_type = /obj/item/ammo_box/magazine/toy/m762/riot
	casing_ejector = FALSE
	clumsy_check = FALSE

/obj/item/gun/ballistic/automatic/l6_saw/toy/unrestricted //Use this for actual toys
	pin = /obj/item/firing_pin
	mag_type = /obj/item/ammo_box/magazine/toy/m762

/obj/item/gun/ballistic/automatic/l6_saw/toy/unrestricted/riot
	mag_type = /obj/item/ammo_box/magazine/toy/m762/riot

/obj/item/gun/ballistic/automatic/toy/magrifle
	name = "foamag rifle"
	desc = "A foam launching magnetic rifle. Ages 8 and up."
	icon_state = "foamagrifle"
	obj_flags = NONE
	mag_type = /obj/item/ammo_box/magazine/toy/foamag
	fire_sound = 'sound/weapons/magrifle.ogg'
	burst_size = 1
	actions_types = null
	fire_delay = 3
	spread = 60
	recoil = 0.1
	can_suppress = FALSE
	inaccuracy_modifier = 0.5
	weapon_weight = WEAPON_MEDIUM
	dualwield_spread_mult = 1.4
	w_class = WEIGHT_CLASS_BULKY

/obj/item/gun/ballistic/shotgun/toy/mag
	name = "foam force magpistol"
	desc = "A fancy toy sold alongside light-up foam force darts. Ages 8 and up."
	icon_state = "toymag"
	item_state = "gun"
	mag_type = /obj/item/ammo_box/magazine/internal/shot/toy/mag
	fire_sound = 'sound/weapons/magpistol.ogg'
	fire_delay = 2
	recoil = 0.1
	inaccuracy_modifier = 0.25
	dualwield_spread_mult = 1.4
	slot_flags = SLOT_BELT
	w_class = WEIGHT_CLASS_NORMAL
	weapon_weight = WEAPON_MEDIUM

/*
// NEW TOYS GUNS GO HERE
*/

/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//HITSCAN EXPERIMENT

/obj/item/gun/energy/pumpaction/toy
	icon_state = "blastertoy"
	name = "pump-action plastic blaster"
	desc = "A fearsome toy of terrible power. It has the ability to fire beams of pure light in either dispersal mode or overdrive mode. Requires the operation of a 40KW power shunt between every shot to prepare the beam focusing chamber."
	item_state = "particleblaster"
	lefthand_file = 'icons/mob/inhands/guns_lefthand.dmi'
	righthand_file = 'icons/mob/inhands/guns_righthand.dmi'
	ammo_type = list(/obj/item/ammo_casing/energy/laser/dispersal, /obj/item/ammo_casing/energy/laser/wavemotion)
	ammo_x_offset = 2
	modifystate = 1
	selfcharge = EGUN_SELFCHARGE
	item_flags = NONE
	clumsy_check = FALSE

//////////////////////////////////////////////////////////////////////////////////////////////////////////////
//TOY REVOLVER

/obj/item/toy/gun/justicar
	name = "\improper replica F3 Justicar"
	desc = "An authentic cap-firing reproduction of a F3 Justicar big-bore revolver! Pretend to blow your friend's brains out with this 100% safe toy! Satisfaction guaranteed!"
	icon_state = "justicar"
	icon = 'icons/obj/guns/toys.dmi'
	custom_materials = list(/datum/material/iron=2000, /datum/material/glass=250)


/obj/item/toy/gun/m41
	name = "Toy M41A Pulse Rifle"
	desc = "A toy replica of the Corporate Mercenaries' standard issue rifle. For Avtomat is inscribed on the side."
	icon_state = "toym41"
	icon = 'icons/obj/guns/toys.dmi'
	custom_materials = list(/datum/material/iron=2000, /datum/material/glass=250)

/*
//	PUMP-ACTION ENERGY GUNS
*/

/obj/item/gun/energy/pumpaction		//parent object with all procs defined under. Useless in-game, but VERY important codewise
	icon_state = "blaster"
	name = "pump-action particle blaster"
	desc = "A pump action energy gun that requires manual racking to charge supercapacitors."
	icon = 'icons/obj/guns/pumpactionblaster.dmi'
	cell_type = /obj/item/stock_parts/cell/pumpaction
	var/recentpump = 0 // to prevent spammage

/obj/item/gun/energy/pumpaction/emp_act(severity)	//makes it not rack itself when emp'd
	cell.use(round(cell.charge / severity))
	chambered = 0 //we empty the chamber
	update_icon()

/obj/item/gun/energy/pumpaction/process()	//makes it not rack itself when self-charging
	if(selfcharge && cell?.charge < cell.maxcharge)
		charge_tick++
		if(charge_tick < charge_delay)
			return
		charge_tick = 0
		if(selfcharge == EGUN_SELFCHARGE_BORG)
			var/atom/owner = loc
			if(istype(owner, /obj/item/robot_module))
				owner = owner.loc
			if(!iscyborg(owner))
				return
			var/mob/living/silicon/robot/R = owner
			if(!R.cell?.use(100))
				return
		cell.give(100)
	update_icon()

/obj/item/gun/energy/pumpaction/attack_self(mob/living/user)	//makes clicking on it in hand pump it
	if(recentpump > world.time)
		return
	pump(user)
	recentpump = world.time + 10
	return

/obj/item/gun/energy/pumpaction/process_chamber()	//makes it so that it doesn't rack itself after firing
	if(chambered && !chambered.BB) //if BB is null, i.e the shot has been fired...
		var/obj/item/ammo_casing/energy/shot = chambered
		cell.use(shot.e_cost)//... drain the cell cell
	chambered = 0 //either way, released the prepared shot

/obj/item/gun/energy/pumpaction/post_set_firemode()
	var/has_shot = chambered
	. = ..(recharge_newshot = FALSE)
	if(has_shot)
		recharge_newshot(TRUE)

/obj/item/gun/energy/pumpaction/update_icon()	//adds racked indicators
	..()
	var/obj/item/ammo_casing/energy/shot = ammo_type[current_firemode_index]
	if(chambered)
		add_overlay("[icon_state]_rack_[shot.select_name]")
	else
		add_overlay("[icon_state]_rack_empty")

/obj/item/gun/energy/pumpaction/proc/pump(mob/M)	//pumping proc. Checks if the gun is empty and plays a different sound if it is.
	var/obj/item/ammo_casing/energy/shot = ammo_type[current_firemode_index]
	if(cell.charge < shot.e_cost)
		playsound(M, 'sound/weapons/laserPumpEmpty.ogg', 100, 1)	//Ends with three beeps made from highly processed knife honing noises
	else
		playsound(M, 'sound/weapons/laserPump.ogg', 100, 1)		//Ends with high pitched charging noise
	recharge_newshot() //try to charge a new shot
	update_icon()
	return 1

/obj/item/gun/energy/pumpaction/AltClick(mob/living/user)	//for changing firing modes since attackself is already used for pumping
	. = ..()
	if(!in_range(src, user))	//Basic checks to prevent abuse
		return

	if(ammo_type.len > 1)
		if(user.incapacitated() || !istype(user))
			to_chat(user, "<span class='warning'>You can't do that right now!</span>")
		else
			select_fire(user)
			update_icon()
		return TRUE

/obj/item/gun/energy/pumpaction/examine(mob/user)	//so people don't ask HOW TO CHANGE FIRING MODE
	. = ..()
	. += "<span class='notice'>Alt-click to change firing modes.</span>"

/obj/item/gun/energy/pumpaction/worn_overlays(isinhands, icon_file, used_state, style_flags = NONE)	//ammo counter for inhands
	. = ..()
	var/ratio = CEILING((cell.charge / cell.maxcharge) * charge_sections, 1)
	var/obj/item/ammo_casing/energy/shot = ammo_type[current_firemode_index]
	if(isinhands)
		if(cell.charge < shot.e_cost)
			var/mutable_appearance/ammo_inhand = mutable_appearance(icon_file, "[item_state]_empty")
			. += ammo_inhand
		else
			var/mutable_appearance/ammo_inhand = mutable_appearance(icon_file, "[item_state]_charge_[shot.select_name][ratio]")
			. += ammo_inhand
		if(chambered)
			var/mutable_appearance/rack_inhand = mutable_appearance(icon_file, "[item_state]_rack_[shot.select_name]")
			. += rack_inhand
		else
			var/mutable_appearance/rack_inhand = mutable_appearance(icon_file, "[item_state]_rack_empty")
			. += rack_inhand

/obj/item/stock_parts/cell/pumpaction	//nice number to achieve the amount of shots wanted
	name = "pump action particle blaster power supply"
	maxcharge = 1200

//PUMP ACTION DISABLER

/obj/item/gun/energy/pumpaction/blaster
	icon_state = "blaster"
	name = "pump-action particle blaster"
	desc = "A non-lethal pump-action particle blaster with an overdrive firing mode. Requires manual racking after every shot to charge an integral bank of supercapacitors."
	item_state = "particleblaster"
	lefthand_file = 'icons/mob/inhands/guns_lefthand.dmi'
	righthand_file = 'icons/mob/inhands/guns_righthand.dmi'
	ammo_type = list(/obj/item/ammo_casing/energy/laser/scatter/disabler/pump, /obj/item/ammo_casing/energy/disabler/slug)
	ammo_x_offset = 2
	modifystate = 1

//WARDEN'S SPECIAL vERSION

/obj/item/gun/energy/pumpaction/defender
	icon_state = "defender"
	name = "particle defender"
	desc = "A pump-action particle blaster with a unique particle focusing chamber optimized for decisive de-escalation. Requires manual racking after every shot to charge an integral bank of supercapacitors."
	item_state = "particleblaster"
	lefthand_file = 'icons/mob/inhands/guns_lefthand.dmi'
	righthand_file = 'icons/mob/inhands/guns_righthand.dmi'
	ammo_type = list(/obj/item/ammo_casing/energy/electrode/pump, /obj/item/ammo_casing/energy/laser/pump)
	ammo_x_offset = 2
	modifystate = 1