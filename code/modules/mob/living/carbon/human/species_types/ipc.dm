/datum/species/ipc
	name = "I.P.C."
	id = "ipc"
	say_mod = "beeps"
	default_color = "00FF00"
	should_draw_citadel = TRUE
	blacklisted = 0
	sexes = 0
	species_traits = list(MUTCOLORS,NOEYES,NOTRANSSTING)
	inherent_biotypes = list(MOB_ROBOTIC, MOB_HUMANOID)
	mutant_bodyparts = list(FEAT_IPC_SCREEN, FEAT_IPC_ANTENNA)
	default_features = list(FEAT_IPC_SCREEN = "Blank", FEAT_IPC_ANTENNA = "None")
	meat = /obj/item/reagent_containers/food/snacks/meat/slab/human/mutant/ipc
	gib_types = list(/obj/effect/gibspawner/ipc, /obj/effect/gibspawner/ipc/bodypartless)
	mutanttongue = /obj/item/organ/tongue/robot/ipc
	mutant_heart = /obj/item/organ/heart/ipc
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
	var/new_ipc_screen = input(usr, "Choose your character's screen:", "Monitor Display") as null|anything in selectable_accessories(GLOB.mutant_features_list[FEAT_IPC_SCREEN], H.client.ckey)
	if(!new_ipc_screen)
		return
	H.dna.features[FEAT_IPC_SCREEN] = new_ipc_screen
	H.update_body()
