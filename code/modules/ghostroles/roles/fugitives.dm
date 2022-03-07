/datum/ghostrole/fugitive_hunter
	name = "Fugitive Hunter"
	desc = "Independent bounty hunters sent after fugitives"
	instantiator = /datum/ghostrole_instantiator/human/random/fugitive_hunter

/datum/ghostrole/fugitive_hunter/PostInstantiate(mob/created, datum/component/ghostrole_spawnpoint/spawnpoint, list/params)
	. = ..()
	var/datum/antagonist/fugitive_hunter/fughunter = new
	fughunter.backstory = params["bcakstory"]
	created.mind.add_antag_datum(fughunter)
	fughunter.greet()
	message_admins("[ADMIN_LOOKUPFLW(created)] has been made into a Fugitive Hunter by an event.")
	log_game("[key_name(created)] was spawned as a Fugitive Hunter by an event.")

/datum/ghostrole_instantiator/human/random/fugitive_hunter

/datum/ghostrole_instantiator/human/random/fugitive_hunter/GetOutfit(client/C, mob/M, list/params)
	switch(params["outfit"])
		if("spacepol")
			return new /datum/outfit/spacepol
		if("russian")
			return new /datum/outfit/russiancorpse/hunter
		if("bountyarmor")
			return new /datum/outfit/bountyarmor
		if("bountygrapple")
			return new /datum/outfit/bountygrapple
		if("bountyhook")
			return new /datum/outfit/bountyhook
		if("bountysynth")
			return new /datum/outfit/bountysynth
	return ..()

/obj/structure/ghost_role_spawner/fugitive_hunter
	role_type = /datum/ghostrole/fugitive_hunter
	var/backstory
	var/outfit

/obj/structure/ghost_role_spawner/fugitive_hunter/Initialize(mapload, params, spawns)
	return ..(mapload, list(
		"backstory" = backstory,
		"outfit" = outfit
	))

/obj/structure/ghost_role_spawner/fugitive_hunter/spacepol
	name = "police pod"
	desc = "A small sleeper typically used to put people to sleep for briefing on the mission."
	backstory = "space cop"
	outfit = "spacepol"
	icon = 'icons/obj/machines/sleeper.dmi'
	icon_state = "sleeper"

/obj/structure/ghost_role_spawner/fugitive_hunter/russian
	name = "russian pod"
	desc = "A small sleeper typically used to make long distance travel a bit more bearable."
	backstory = "russian"
	outfit = "russian"
	icon = 'icons/obj/machines/sleeper.dmi'
	icon_state = "sleeper"

/obj/structure/ghost_role_spawner/fugitive_hunter/bounty
	name = "bounty hunter pod"
	desc = "A small sleeper typically used to make long distance travel a bit more bearable."
	backstory = "bounty hunters"
	outfit = "bountyaromr"
	icon = 'icons/obj/machines/sleeper.dmi'
	icon_state = "sleeper"

/obj/structure/ghost_role_spawner/fugitive_hunter/bounty/Destroy()
	var/obj/structure/fluff/empty_sleeper/S = new(drop_location())
	S.setDir(dir)
	return ..()

/obj/structure/ghost_role_spawner/fugitive_hunter/bounty/armor
	outfit = "bountyarmor"

/obj/structure/ghost_role_spawner/fugitive_hunter/bounty/hook
	outfit = "bountyhook"

/obj/structure/ghost_role_spawner/fugitive_hunter/bounty/synth
	outfit = "bountysynth"
