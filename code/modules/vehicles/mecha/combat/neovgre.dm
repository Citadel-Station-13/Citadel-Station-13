/obj/vehicle/sealed/mecha/combat/neovgre
	name = "Neovgre, the Anima Bulwark"
	desc = "Nezbere's most powerful creation, a mighty war machine of unmatched power said to have ended wars in a single night. Armed with a heavy laser and a tesla sphere generator. Requires a pilot and a gunner."
	icon = 'icons/mecha/neovgre.dmi'
	icon_state = "neovgre"
	max_integrity = 500 //This is THE ratvarian superweaon, its deployment is an investment
	armor = list("melee" = 50, "bullet" = 40, "laser" = 25, "energy" = 25, "bomb" = 50, "bio" = 100, "rad" = 100, "fire" = 100, "acid" = 100) //Its similar to the clockwork armour albeit with a few buffs becuase RATVARIAN SUPERWEAPON!!
	force = 50 //SMASHY SMASHY!!
	movedelay = 3
	internal_damage_threshold = 0
	pixel_x = -16
	layer = ABOVE_MOB_LAYER
	max_occupants = 2
	var/breach_time = 100 //ten seconds till all goes to shit
	var/recharge_rate = 100
	internals_req_access = list()
	wreckage = /obj/structure/mecha_wreckage/durand/neovgre
	stepsound = 'sound/mecha/neostep2.ogg'
	turnsound = 'sound/mecha/powerloader_step.ogg'
	var/aiming_tesla
	var/obj/item/projectile/tesla_shot = /obj/item/projectile/energy/tesla/sphere //do YOU want to make Neo Vg Re shoot things other than tesla balls?

	COOLDOWN_DECLARE(tesla_cooldown)
	///cooldown time between tesla uses
	var/tesla_cooldown_time = 20 SECONDS

/obj/vehicle/sealed/mecha/combat/neovgre/auto_assign_occupant_flags(mob/new_occupant)
	if(driver_amount() < max_drivers) //movement
		add_control_flags(new_occupant, VEHICLE_CONTROL_DRIVE|VEHICLE_CONTROL_SETTINGS)
	else //weapons
		add_control_flags(new_occupant, VEHICLE_CONTROL_MELEE|VEHICLE_CONTROL_EQUIPMENT)

/obj/vehicle/sealed/mecha/combat/neovgre/generate_actions()
	initialize_passenger_action_type(/datum/action/vehicle/sealed/mecha/swap_seat)
	. = ..()
	initialize_controller_action_type(/datum/action/vehicle/sealed/mecha/tesla_launch, VEHICLE_CONTROL_EQUIPMENT)

/obj/vehicle/sealed/mecha/combat/neovgre/remove_occupant(mob/getting_out)
	//gunner getting out ends any tesla aiming
	//while the gunner cannot leave we dont want to leave them 'aiming' if the mech dies
	if(aiming_tesla && (getting_out in return_controllers_with_flag(VEHICLE_CONTROL_EQUIPMENT)))
		end_tesla_targeting(getting_out)
	. = ..()



/obj/vehicle/sealed/mecha/mob_exit(mob/M, silent, forced)
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
	addtimer(CALLBACK(src,.proc/go_critical),breach_time)

/obj/vehicle/sealed/mecha/combat/neovgre/proc/go_critical()
	explosion(get_turf(loc), 3, 5, 10, 20, 30)
	Destroy(src)

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

/obj/vehicle/sealed/mecha/combat/neovgre/Initialize()
	.=..()
	GLOB.neovgre_exists ++
	var/obj/item/mecha_parts/mecha_equipment/weapon/energy/laser/heavy/neovgre/N = new
	N.attach(src)

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
		return 1
	return 0


/obj/vehicle/sealed/mecha/combat/neovgre/proc/start_tesla_targeting(mob/gunner)
	to_chat(gunner, "You begin preparing a firing solution for the tesla sphere generator.")
	aiming_tesla = TRUE
	RegisterSignal(src, COMSIG_MECHA_MELEE_CLICK, .proc/on_melee_click)
	RegisterSignal(src, COMSIG_MECHA_EQUIPMENT_CLICK, .proc/on_equipment_click)
	SEND_SOUND(gunner, 'sound/machines/terminal_on.ogg') //spammable so I don't want to make it audible to anyone else

/obj/vehicle/sealed/mecha/combat/neovgre/proc/end_tesla_targeting(mob/gunner)
	aiming_tesla = FALSE
	UnregisterSignal(src, list(COMSIG_MECHA_MELEE_CLICK, COMSIG_MECHA_EQUIPMENT_CLICK))

///signal called from clicking with no equipment
/obj/vehicle/sealed/mecha/combat/neovgre/proc/on_melee_click(datum/source, mob/living/pilot, atom/target, on_cooldown, is_adjacent)
	SIGNAL_HANDLER
	if(!target)
		return
	tesla_fire(pilot, target)

///signal called from clicking with equipment
/obj/vehicle/sealed/mecha/combat/neovgre/proc/on_equipment_click(datum/source, mob/living/pilot, atom/target)
	SIGNAL_HANDLER
	if(!target)
		return
	tesla_fire(pilot, target)

/obj/vehicle/sealed/mecha/combat/neovgre/proc/tesla_fire(mob/gunner, atom/target)
	var/obj/item/projectile/A = new tesla_shot(get_turf(src))
	A.preparePixelProjectile(target, src, spread = 0)
	A.fire()
	SEND_SOUND(gunner, 'sound/machines/triple_beep.ogg')
	end_tesla_targeting(gunner)
	var/datum/action/vehicle/sealed/mecha/acter = occupant_actions[gunner][/datum/action/vehicle/sealed/mecha/tesla_launch]
	acter.button_icon_state = "mech_teslastrike_cooldown"
	acter.UpdateButtonIcon()
	addtimer(CALLBACK(acter, /datum/action/vehicle/sealed/mecha/tesla_launch.proc/reset_button_icon), tesla_cooldown_time)


/datum/action/vehicle/sealed/mecha/tesla_launch
	name = "Fire Tesla Generator"
	button_icon_state = "mech_teslastrike"

/datum/action/vehicle/sealed/mecha/tesla_launch/Trigger()
	if(!owner || !chassis || !(owner in chassis.occupants))
		return
	var/obj/vehicle/sealed/mecha/combat/neovgre/animab = chassis
	if(!COOLDOWN_FINISHED(animab, tesla_cooldown))
		var/timeleft = COOLDOWN_TIMELEFT(animab, tesla_cooldown)
		to_chat(owner, "<span class='warning'>You need to wait [DisplayTimeText(timeleft, 1)] before the tesla generator is recharged.</span>")
		return
	if(animab.aiming_tesla)
		animab.end_tesla_targeting(owner)
	else
		animab.start_tesla_targeting(owner)


/datum/action/vehicle/sealed/mecha/tesla_launch/proc/reset_button_icon()
	button_icon_state = "mech_teslastrike"
	UpdateButtonIcon()
