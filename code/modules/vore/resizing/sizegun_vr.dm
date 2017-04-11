//
// Size Gun
//

datum/design/sizeray
	name = "Size Ray"
	desc = "Abuse bluespace tech to alter living matter scale."
	id = "sizeray"
	req_tech = list("combat" = 5, "materials" = 4, "engineering" = 5, "bluespace" = 4)
	build_type = PROTOLATHE
	materials = list(MAT_METAL = 1000, MAT_GLASS = 1000, MAT_DIAMOND = 2500, MAT_URANIUM = 2500, MAT_TITANIUM = 1000)
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
			if(GLOB.SIZESCALE_HUGE to INFINITY)
				M.sizescale(GLOB.SIZESCALE_BIG)
			if(GLOB.SIZESCALE_BIG to GLOB.SIZESCALE_HUGE)
				M.sizescale(GLOB.SIZESCALE_NORMAL)
			if(GLOB.SIZESCALE_NORMAL to GLOB.SIZESCALE_BIG)
				M.sizescale(GLOB.SIZESCALE_SMALL)
			if((0 - INFINITY) to GLOB.SIZESCALE_NORMAL)
				M.sizescale(GLOB.SIZESCALE_TINY)
		M.update_transform()
	return TRUE

/obj/item/projectile/sizeray/growthray/on_hit(var/atom/target, var/blocked = 0)
	if(istype(target, /mob/living))
		var/mob/living/M = target
		switch(M.size_multiplier)
			if(GLOB.SIZESCALE_BIG to GLOB.SIZESCALE_HUGE)
				M.sizescale(GLOB.SIZESCALE_HUGE)
			if(GLOB.SIZESCALE_NORMAL to GLOB.SIZESCALE_BIG)
				M.sizescale(GLOB.SIZESCALE_BIG)
			if(GLOB.SIZESCALE_SMALL to GLOB.SIZESCALE_NORMAL)
				M.sizescale(GLOB.SIZESCALE_NORMAL)
			if((0 - INFINITY) to GLOB.SIZESCALE_TINY)
				M.sizescale(GLOB.SIZESCALE_SMALL)
		M.update_transform()
	return TRUE

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
	selfcharge = TRUE
	charge_delay = 5
	ammo_x_offset = 2
	clumsy_check = TRUE

	attackby(obj/item/W, mob/user)
		if(W==src)
			if(icon_state=="bluetag")
				icon_state="redtag"
				ammo_type = list(/obj/item/ammo_casing/energy/laser/growthray)
			else
				icon_state="bluetag"
				ammo_type = list(/obj/item/ammo_casing/energy/laser/shrinkray)
		return ..()