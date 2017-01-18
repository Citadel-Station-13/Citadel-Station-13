//
// Size Gun
//
/*
/obj/item/weapon/gun/energy/sizegun
	name = "shrink ray"
	desc = "A highly advanced ray gun with two settings: Shrink and Grow. Warning: Do not insert into mouth."
	icon = 'icons/obj/gun_vr.dmi'
	icon_state = "sizegun-shrink100" // Someone can probably do better. -Ace
	item_state = null	//so the human update icon uses the icon_state instead
	fire_sound = 'sound/weapons/wave.ogg'
	charge_cost = 100
	projectile_type = /obj/item/projectile/beam/shrinklaser
	origin_tech = "redspace=1;bluespace=4"
	modifystate = "sizegun-shrink"
	selfcharge = 1
	firemodes = list(
		list(mode_name		= "grow",
			projectile_type	= /obj/item/projectile/beam/growlaser,
			modifystate		= "sizegun-grow",
			fire_sound		= 'sound/weapons/pulse3.ogg'
		),
		list(mode_name		= "shrink",
			projectile_type	= /obj/item/projectile/beam/shrinklaser,
			modifystate		= "sizegun-shrink",
			fire_sound		= 'sound/weapons/wave.ogg'
		))

//
// Beams for size gun
//
// tracers TBD

/obj/item/projectile/beam/shrinklaser
	name = "shrink beam"
	icon_state = "xray"
	nodamage = 1
	damage = 0
	check_armour = "laser"

	muzzle_type = /obj/effect/projectile/xray/muzzle
	tracer_type = /obj/effect/projectile/xray/tracer
	impact_type = /obj/effect/projectile/xray/impact

/obj/item/projectile/beam/shrinklaser/on_hit(var/atom/target, var/blocked = 0)
	if(istype(target, /mob/living))
		var/mob/living/M = target
		switch(M.size_multiplier)
			if(RESIZE_HUGE to INFINITY)
				M.resize(RESIZE_BIG)
			if(RESIZE_BIG to RESIZE_HUGE)
				M.resize(RESIZE_NORMAL)
			if(RESIZE_NORMAL to RESIZE_BIG)
				M.resize(RESIZE_SMALL)
			if((0 - INFINITY) to RESIZE_NORMAL)
				M.resize(RESIZE_TINY)
		M.update_icons()
	return 1

/obj/item/projectile/beam/growlaser
	name = "growth beam"
	icon_state = "bluelaser"
	nodamage = 1
	damage = 0
	check_armour = "laser"

	muzzle_type = /obj/effect/projectile/laser_blue/muzzle
	tracer_type = /obj/effect/projectile/laser_blue/tracer
	impact_type = /obj/effect/projectile/laser_blue/impact

/obj/item/projectile/beam/growlaser/on_hit(var/atom/target, var/blocked = 0)
	if(istype(target, /mob/living))
		var/mob/living/M = target
		switch(M.size_multiplier)
			if(RESIZE_BIG to RESIZE_HUGE)
				M.resize(RESIZE_HUGE)
			if(RESIZE_NORMAL to RESIZE_BIG)
				M.resize(RESIZE_BIG)
			if(RESIZE_SMALL to RESIZE_NORMAL)
				M.resize(RESIZE_NORMAL)
			if((0 - INFINITY) to RESIZE_TINY)
				M.resize(RESIZE_SMALL)
		M.update_icons()
	return 1
*/

datum/design/sizeray
	name = "Size Ray"
	desc = "Abuse bluespace tech to alter living matter scale."
	id = "sizeray"
	req_tech = list("combat" = 5, "materials" = 4, "engineering" = 5, "bluespace" = 4)
	build_type = PROTOLATHE
	materials = list("$metal" = 5000, "$glass" = 1000, "$diamond" = 1500)
	build_path = /obj/item/weapon/gun/energy/laser/sizeray
	category = list("Weapons")

/obj/item/projectile/sizeray
	name = "sizeray beam"
	icon_state = "omnilaser"
	hitsound = null
	damage = 0
	damage_type = STAMINA
	flag = "laser"
	pass_flags = PASSTABLE | PASSGLASS | PASSGRILLE

/obj/item/projectile/sizeray/shrinkray
	icon_state="bluelaser"

/obj/item/projectile/sizeray/growthray
	icon_state="laser"

/obj/item/projectile/sizeray/shrinkray/on_hit(var/atom/target, var/blocked = 0)
	if(istype(target, /mob/living))
		var/mob/living/M = target
		switch(M.size_multiplier)
			if(RESIZE_HUGE to INFINITY)
				M.resize(RESIZE_BIG)
			if(RESIZE_BIG to RESIZE_HUGE)
				M.resize(RESIZE_NORMAL)
			if(RESIZE_NORMAL to RESIZE_BIG)
				M.resize(RESIZE_SMALL)
			if((0 - INFINITY) to RESIZE_NORMAL)
				M.resize(RESIZE_TINY)
		M.update_icons()
	return 1

/obj/item/projectile/sizeray/growthray/on_hit(var/atom/target, var/blocked = 0)
	if(istype(target, /mob/living))
		var/mob/living/M = target
		switch(M.size_multiplier)
			if(RESIZE_BIG to RESIZE_HUGE)
				M.resize(RESIZE_HUGE)
			if(RESIZE_NORMAL to RESIZE_BIG)
				M.resize(RESIZE_BIG)
			if(RESIZE_SMALL to RESIZE_NORMAL)
				M.resize(RESIZE_NORMAL)
			if((0 - INFINITY) to RESIZE_TINY)
				M.resize(RESIZE_SMALL)
		M.update_icons()
	return 1

/obj/item/ammo_casing/energy/laser/growthray
	projectile_type = /obj/item/projectile/sizeray/growthray
	select_name = "Growth"

/obj/item/ammo_casing/energy/laser/shrinkray
	projectile_type = /obj/item/projectile/sizeray/shrinkray
	select_name = "Shrink"


//Gun here
/obj/item/weapon/gun/energy/laser/sizeray
	name = "size ray"
	icon_state = "bluetag"
	desc = "Size manipulator using bluespace breakthroughs."
	item_state = null	//so the human update icon uses the icon_state instead.
	ammo_type = list(/obj/item/ammo_casing/energy/laser/shrinkray, /obj/item/ammo_casing/energy/laser/growthray)
	origin_tech = "combat=1;magnets=2"
	selfcharge = 1
	charge_delay = 5
	ammo_x_offset = 2
	clumsy_check = 1

	attackby(obj/item/W, mob/user)
		if(W==src)
			if(icon_state=="bluetag")
				icon_state="redtag"
				ammo_type = list(/obj/item/ammo_casing/energy/laser/growthray)
			else
				icon_state="bluetag"
				ammo_type = list(/obj/item/ammo_casing/energy/laser/shrinkray)
		return ..()