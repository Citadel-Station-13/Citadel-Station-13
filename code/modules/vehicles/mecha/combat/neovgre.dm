/obj/vehicle/sealed/mecha/combat/neovgre
	name = "Neovgre, the Anima Bulwark"
	desc = "Nezbere's most powerful creation, a mighty war machine of unmatched power said to have ended wars in a single night. Armed with a heavy laser and a tesla sphere generator. Requires a pilot and a gunner."
	icon = 'icons/mecha/neovgre.dmi'
	icon_state = "neovgre"
	max_integrity = 500 //This is THE ratvarian superweaon, its deployment is an investment
	armor = list(MELEE = 60, BULLET = 70, LASER = 65, ENERGY = 65, BOMB = 60, BIO = 100, RAD = 100, FIRE = 100, ACID = 100) //Its similar to the clockwork armour albeit with a few buffs becuase RATVARIAN SUPERWEAPON!!
	force = 50 //SMASHY SMASHY!!
	movedelay = 4
	internal_damage_threshold = 500
	pixel_x = -16
	layer = ABOVE_MOB_LAYER
	var/breach_time = 100 //ten seconds till all goes to shit
	var/recharge_rate = 100
	internals_req_access = list()
	wreckage = /obj/structure/mecha_wreckage/durand/neovgre
	stepsound = 'sound/mecha/neostep2.ogg'
	turnsound = 'sound/mecha/powerloader_step.ogg'
	max_occupants = 2

//override this proc if you need to split up mecha control between multiple people (see savannah_ivanov.dm)
/obj/vehicle/sealed/mecha/combat/neovgre/auto_assign_occupant_flags(mob/M)
	if(driver_amount() < max_drivers)
		add_control_flags(M, VEHICLE_CONTROL_DRIVE|VEHICLE_CONTROL_SETTINGS)
	else
		add_control_flags(M, VEHICLE_CONTROL_MELEE|VEHICLE_CONTROL_EQUIPMENT)

/obj/vehicle/sealed/mecha/combat/neovgre/mob_exit(mob/M, silent, randomstep, forced)
	if(forced)
		..()

/obj/vehicle/sealed/mecha/combat/neovgre/MouseDrop_T(mob/M, mob/user)
	if(!is_servant_of_ratvar(user))
		to_chat(user, "<span class='neovgre'>BEGONE HEATHEN!</span>")
		return
	else
		..()

/obj/vehicle/sealed/mecha/combat/neovgre/moved_inside(mob/living/carbon/human/H)
	var/list/Itemlist = H.get_contents()
	for(var/obj/item/clockwork/slab/W in Itemlist)
		to_chat(H, "<span class='brass'>You safely store [W] inside [src].</span>")
		qdel(W)
	. = ..()

/obj/vehicle/sealed/mecha/combat/neovgre/obj_destruction()
	for(var/mob/M in src)
		to_chat(M, "<span class='brass'>You are consumed by the fires raging within Neovgre...</span>")
		M.dust()
	playsound(src, 'sound/effects/neovgre_exploding.ogg', 100, 0)
	src.visible_message("<span class = 'userdanger'>The reactor has gone critical, its going to blow!</span>")
	addtimer(CALLBACK(src,PROC_REF(go_critical)),breach_time)

/obj/vehicle/sealed/mecha/combat/neovgre/proc/go_critical()
	explosion(get_turf(loc), 3, 5, 10, 20, 30)
	if(!QDELETED(src))
		qdel(src)

/obj/vehicle/sealed/mecha/combat/neovgre/container_resist(mob/living/user)
	to_chat(user, "<span class='brass'>Neovgre requires a lifetime commitment friend, no backing out now!</span>")
	return

/obj/vehicle/sealed/mecha/combat/neovgre/process()
	..()
	if(!obj_integrity) //Integrity is zero but we would heal out of that state if we went into this before it recognises it being zero
		return
	if(GLOB.ratvar_awakens) // At this point only timley intervention by lord singulo could hope to stop the superweapon
		cell.charge = INFINITY
		max_integrity = INFINITY
		obj_integrity = max_integrity
	else
		if(cell.charge < cell.maxcharge)
			for(var/obj/effect/clockwork/sigil/transmission/T in range(SIGIL_ACCESS_RANGE, src))
				var/delta = min(recharge_rate, cell.maxcharge - cell.charge)
				if (get_clockwork_power() >= delta)
					cell.charge += delta
					adjust_clockwork_power(-delta)
		if(obj_integrity < max_integrity && istype(loc, /turf/open/floor/clockwork))
			obj_integrity += min(max_integrity - obj_integrity, max_integrity / 200)

/obj/vehicle/sealed/mecha/combat/neovgre/Initialize(mapload)
	.=..()
	GLOB.neovgre_exists ++
	var/obj/item/mecha_parts/mecha_equipment/weapon/energy/laser/heavy/neovgre/N = new
	N.attach(src)
	var/obj/item/mecha_parts/mecha_equipment/weapon/energy/tesla/shocking = new
	shocking.attach(src)

/obj/structure/mecha_wreckage/durand/neovgre
	name = "\improper Neovgre wreckage?"
	desc = "On closer inspection this looks like the wreck of a durand with some spraypainted cardboard duct taped to it!"

/obj/item/mecha_parts/mecha_equipment/weapon/energy/laser/heavy/neovgre
	equip_cooldown = 8 //Rapid fire heavy laser cannon, simple yet elegant
	energy_drain = 30
	name = "Arbiter Laser Cannon"
	desc = "Please re-attach this to neovgre and stop asking questions about why it looks like a normal Nanotrasen issue Solaris laser cannon - Nezbere"
	fire_sound = 'sound/weapons/neovgre_laser.ogg'

/obj/item/mecha_parts/mecha_equipment/weapon/energy/laser/heavy/neovgre/can_attach(obj/vehicle/sealed/mecha/combat/neovgre/M)
	if(istype(M))
		return TRUE
	return FALSE
