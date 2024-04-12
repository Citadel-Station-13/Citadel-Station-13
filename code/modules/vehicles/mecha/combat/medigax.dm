/obj/vehicle/sealed/mecha/medical/medigax
	desc = "A Gygax with it's actuator overload stripped and a slick white paint scheme, for medical use, These exosuits are developed and produced by Vey-Med. (&copy; All rights reserved)."
	name = "\improper Medical Gygax"
	icon_state = "medigax"
	allow_diagonal_movement = TRUE
	movedelay = 2
	dir_in = 1 //Facing North.
	max_integrity = 250
	deflect_chance = 15
	armor = list(MELEE = 25, BULLET = 20, LASER = 30, ENERGY = 15, BOMB = 0, BIO = 0, RAD = 0, FIRE = 100, ACID = 100)
	max_temperature = 25000
	wreckage = /obj/structure/mecha_wreckage/odysseus
	internal_damage_threshold = 35
	normal_step_energy_drain = 6
	infra_luminosity = 6
	internals_req_access = list(ACCESS_ROBOTICS, ACCESS_MEDICAL)

/obj/vehicle/sealed/mecha/medical/medigax/moved_inside(mob/living/carbon/human/H)
	. = ..()
	if(.)
		var/datum/atom_hud/hud = GLOB.huds[DATA_HUD_MEDICAL_ADVANCED]
		hud.add_hud_to(H)

/obj/vehicle/sealed/mecha/medical/medigax/remove_occupant(mob/M)
	if(isliving(M))
		var/mob/living/L = M
		var/datum/atom_hud/hud = GLOB.huds[DATA_HUD_MEDICAL_ADVANCED]
		hud.remove_hud_from(L)
	return ..()

/obj/vehicle/sealed/mecha/medical/medigax/mmi_moved_inside(obj/item/mmi/M, mob/user)
	. = ..()
	if(.)
		var/datum/atom_hud/hud = GLOB.huds[DATA_HUD_MEDICAL_ADVANCED]
		var/mob/living/brain/B = M.brainmob
		hud.add_hud_to(B)
