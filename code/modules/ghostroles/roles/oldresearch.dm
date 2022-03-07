/datum/ghostrole/old_research
	name = "Oldstation Crew"
	allow_pick_spawner = TRUE
	desc = "You were a Nanotrasen employee from an era past, stationed upon a state of the art research station. \
	You vaguely recall rushing into a cryogenics pod due to an oncoming radiation storm. \
	The last thing you remember is the station's Artificial Program telling you that you would only be asleep for eight hours. As you open \
	your eyes, everything seems rusted and broken, a dark feeling swells in your gut as you climb out of your pod."
	automatic_objective = "Work as a team with your fellow survivors and do not abandon them."
	assigned_role = "Ancient Crew"

	instantiator = /datum/ghostrole_instantiator/human/random/old_research

/datum/ghostrole_instantiator/human/random/old_research/GetOutfit(client/C, mob/M, list/params)
	. = ..()
	switch(params["role"])
		if("Officer")
			return /datum/outfit/old_research/security
		if("Engineer")
			return /datum/outfit/old_research/engineer
		if("Scientist")
			return /datum/outfit/old_research/scientist

/obj/structure/ghost_role_spawner/old_research
	role_type = /datum/ghostrole/old_research
	name = "old cryogenics pod"
	desc = "A humming cryo pod. You can barely recognise a security uniform underneath the built up ice. The machine is attempting to wake up its occupant."
	icon = 'icons/obj/machines/sleeper.dmi'
	icon_state = "sleeper"

/obj/structure/ghost_role_spawner/old_research/Destroy()
	new /obj/structure/showcase/machinery/oldpod/used(drop_location())
	return ..()

/obj/structure/ghost_role_spawner/old_research/security
	role_params = list("role" = "Officer")

/obj/structure/ghost_role_spawner/old_research/engineer
	role_params = list("role" = "Engineer")

/obj/structure/ghost_role_spawner/old_research/scientist
	role_params = list("role" = "Scientist")

/datum/outfit/old_research/security
	uniform = /obj/item/clothing/under/rank/security/officer
	shoes = /obj/item/clothing/shoes/jackboots
	id = /obj/item/card/id/away/old/sec
	r_pocket = /obj/item/restraints/handcuffs
	l_pocket = /obj/item/assembly/flash/handheld

/datum/outfit/old_research/engineer
	uniform = /obj/item/clothing/under/rank/engineering/engineer
	shoes = /obj/item/clothing/shoes/workboots
	id = /obj/item/card/id/away/old/eng
	gloves = /obj/item/clothing/gloves/color/fyellow/old
	l_pocket = /obj/item/tank/internals/emergency_oxygen

/datum/outfit/old_research/scientist
	uniform = /obj/item/clothing/under/rank/rnd/scientist
	shoes = /obj/item/clothing/shoes/laceup
	id = /obj/item/card/id/away/old/sci
	l_pocket = /obj/item/stack/medical/suture
