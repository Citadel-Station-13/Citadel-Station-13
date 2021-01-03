/obj/mecha/medical/medigax
	desc = "A Gygax with it's actuator overload stripped and a slick white paint scheme, for medical use, These exosuits are developed and produced by Vey-Med. (&copy; All rights reserved)."
	name = "\improper Medical Gygax"
	icon_state = "medigax"
	step_in = 1.75 // a little faster than an odysseus
	max_temperature = 25000
	max_integrity = 250
	wreckage = /obj/structure/mecha_wreckage/odysseus
	armor = list("melee" = 25, "bullet" = 20, "laser" = 30, "energy" = 15, "bomb" = 0, "bio" = 0, "rad" = 0, "fire" = 100, "acid" = 100)
	internal_damage_threshold = 35
	deflect_chance = 15
	step_energy_drain = 6
	infra_luminosity = 6


/obj/mecha/medical/medigax/moved_inside(mob/living/carbon/human/H)
	. = ..()
	if(.)
		var/datum/atom_hud/hud = GLOB.huds[DATA_HUD_MEDICAL_ADVANCED]
		hud.add_hud_to(H)

/obj/mecha/medical/medigax/go_out()
	if(isliving(occupant))
		var/mob/living/carbon/human/L = occupant
		var/datum/atom_hud/hud = GLOB.huds[DATA_HUD_MEDICAL_ADVANCED]
		hud.remove_hud_from(L)
	..()

/obj/mecha/medical/medigax/mmi_moved_inside(obj/item/mmi/mmi_as_oc, mob/user)
	. = ..()
	if(.)
		var/datum/atom_hud/hud = GLOB.huds[DATA_HUD_MEDICAL_ADVANCED]
		var/mob/living/brain/B = mmi_as_oc.brainmob
		hud.add_hud_to(B)
