/datum/species/ipc
	name = "I.P.C."
	id = "ipc"
	say_mod = "beeps"
	default_color = "00FF00"
	icon_limbs = DEFAULT_BODYPART_ICON_CITADEL
	blacklisted = 0
	sexes = 0
	species_traits = list(MUTCOLORS,NOEYES,NOTRANSSTING)
	inherent_biotypes = MOB_ROBOTIC|MOB_HUMANOID
	mutant_bodyparts = list("ipc_screen", "ipc_antenna")
	default_features = list("ipc_screen" = "Blank", "ipc_antenna" = "None")
	meat = /obj/item/reagent_containers/food/snacks/meat/slab/human/mutant/ipc
	gib_types = list(/obj/effect/gibspawner/ipc, /obj/effect/gibspawner/ipc/bodypartless)
	mutanttongue = /obj/item/organ/tongue/robot/ipc
//Just robo looking parts.
	mutant_heart = /obj/item/organ/heart/ipc
	mutantlungs = /obj/item/organ/lungs/ipc
	mutantliver = /obj/item/organ/liver/ipc
	mutantstomach = /obj/item/organ/stomach/ipc
	mutanteyes = /obj/item/organ/eyes/ipc

	exotic_bloodtype = "HF"

	var/datum/action/innate/monitor_change/screen

/datum/species/ipc/on_species_gain(mob/living/carbon/human/C)
	if(isipcperson(C) && !screen)
		screen = new
		screen.Grant(C)
	..()

/datum/species/ipc/on_species_loss(mob/living/carbon/human/C)
	if(screen)
		screen.Remove(C)
	..()

/datum/action/innate/monitor_change
	name = "Screen Change"
	check_flags = AB_CHECK_CONSCIOUS
	icon_icon = 'icons/mob/actions/actions_silicon.dmi'
	button_icon_state = "drone_vision"

/datum/action/innate/monitor_change/Activate()
	var/mob/living/carbon/human/H = owner
	var/new_ipc_screen = input(usr, "Choose your character's screen:", "Monitor Display") as null|anything in GLOB.ipc_screens_list
	if(!new_ipc_screen)
		return
	H.dna.features["ipc_screen"] = new_ipc_screen
	H.update_body()
