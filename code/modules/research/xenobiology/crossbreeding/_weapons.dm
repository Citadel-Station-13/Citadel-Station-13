//Bloodchiller - Chilling Green
/obj/item/gun/magic/bloodchill
	name = "blood chiller"
	desc = "A horrifying weapon made of your own bone and blood vessels. It shoots slowing globules of your own blood. Ech."
	icon = 'icons/obj/slimecrossing.dmi'
	icon_state = "bloodgun"
	item_state = "bloodgun"
	lefthand_file = 'icons/mob/inhands/weapons/guns_lefthand.dmi'
	righthand_file = 'icons/mob/inhands/weapons/guns_righthand.dmi'
	item_flags = ABSTRACT | DROPDEL
	w_class = WEIGHT_CLASS_HUGE
	slot_flags = NONE
	force = 5
	max_charges = 1 //Recharging costs blood.
	recharge_rate = 1
	ammo_type = /obj/item/ammo_casing/magic/bloodchill
	fire_sound = 'sound/effects/attackblob.ogg'
	total_mass = TOTAL_MASS_HAND_REPLACEMENT

/obj/item/gun/magic/bloodchill/Initialize(mapload)
	. = ..()
	ADD_TRAIT(src, TRAIT_NODROP, HAND_REPLACEMENT_TRAIT)

/obj/item/gun/magic/bloodchill/process()
	charge_tick++
	if(charge_tick < recharge_rate || charges >= max_charges)
		return FALSE
	charge_tick = 0
	var/mob/living/M = loc
	if(istype(M) && M.blood_volume >= 5)
		charges++
		M.blood_volume -= 5
	if(charges == 1)
		recharge_newshot()
	return TRUE

/obj/item/ammo_casing/magic/bloodchill
	projectile_type = /obj/item/projectile/magic/bloodchill

/obj/item/projectile/magic/bloodchill
	name = "blood ball"
	icon_state = "pulse0_bl"
	damage = 0
	damage_type = OXY
	nodamage = 1
	hitsound = 'sound/effects/splat.ogg'

/obj/item/projectile/magic/bloodchill/on_hit(mob/living/target)
	. = ..()
	if(isliving(target))
		target.apply_status_effect(/datum/status_effect/bloodchill)
