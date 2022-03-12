/datum/ghostrole/ashwalker
	name = "Ashwalker"
	instantiator = /datum/ghostrole_instantiator/human/random/species/ashwalker
	desc = "You are an ash walker. Your tribe worships the Necropolis."
	spawntext = "The wastes are sacred ground, its monsters a blessed bounty. You would never willingly leave your homeland behind. \
	You have seen lights in the distance... they foreshadow the arrival of outsiders to your domain. \
	Ensure your nest remains protected at all costs."
	assigned_role = "Ash Walker"
	allow_pick_spawner = TRUE
	jobban_role = ROLE_LAVALAND

/datum/ghostrole/ashwalker/Greet(mob/created)
	. = ..()
	var/turf/T = get_turf(created)
	if(is_mining_level(T.z))
		to_chat(created, "<b>Drag the corpses of men and beasts to your nest. It will absorb them to create more of your kind. Glory to the Necropolis!</b>")
		to_chat(created, "<b>You can expand the weather proof area provided by your shelters by using the 'New Area' key near the bottom right of your HUD.</b>")
	else
		to_chat(created, "<span class='userdanger'>You have been born outside of your natural home! Whether you decide to return home, or make due with your new home is your own decision.</span>")

/datum/ghostrole/ashwalker/AllowSpawn(client/C, list/params)
	if(params && params["team"])
		var/datum/team/ashwalkers/team = params["team"]
		if(C.ckey in team.players_spawned)
			to_chat(C, span_warning("<b>You have exhausted your usefulness to the Necropolis</b>."))
			return FALSE
	return ..()

/datum/ghostrole/ashwalker/PostInstantiate(mob/created, datum/component/ghostrole_spawnpoint/spawnpoint, list/params)
	. = ..()
	if(params["team"])
		var/datum/team/ashwalkers/team = spawnpoint.params["team"]
		team.players_spawned += ckey(created.key)
		created.mind.add_antag_datum(/datum/antagonist/ashwalker, team)

/datum/ghostrole_instantiator/human/random/species/ashwalker
	possible_species = list(
		/datum/species/lizard/ashwalker
	)
	equip_outfit = /datum/outfit/ashwalker

/datum/ghostrole_instantiator/human/random/species/ashwalker/Randomize(mob/living/carbon/human/H, list/params)
	. = ..()
	H.underwear = "Nude"
	H.undershirt = "Nude"
	H.socks = "Nude"
	H.update_body()
	H.real_name = random_unique_lizard_name(H.gender)

/obj/structure/ghost_role_spawner/ash_walker
	name = "ash walker egg"
	desc = "A man-sized yellow egg, spawned from some unfathomable creature. A humanoid silhouette lurks within. The egg shell looks resistant to temperature but otherwise rather brittle."
	icon = 'icons/mob/lavaland/lavaland_monsters.dmi'
	icon_state = "large_egg"
	anchored = FALSE
	move_resist = MOVE_FORCE_NORMAL
	density = FALSE
	role_type = /datum/ghostrole/ashwalker
	role_spawns = 1
	resistance_flags = LAVA_PROOF | FIRE_PROOF | FREEZE_PROOF
	max_integrity = 80
	var/datum/team/ashwalkers/team

/obj/structure/ghost_role_spawner/ash_walker/on_spawn(mob/created, datum/ghostrole/role, list/params)
	. = ..()
	qdel(src)

/obj/structure/ghost_role_spawner/ash_walker/Destroy()
	var/mob/living/carbon/human/yolk = new /mob/living/carbon/human/(get_turf(src))
	yolk.fully_replace_character_name(null,random_unique_lizard_name(gender))
	yolk.set_species(/datum/species/lizard/ashwalker)
	yolk.underwear = "Nude"
	yolk.equipOutfit(/datum/outfit/ashwalker)//this is an authentic mess we're making
	yolk.update_body()
	yolk.gib()
	return ..()

/datum/outfit/ashwalker
	name ="Ashwalker"
	head = /obj/item/clothing/head/helmet/gladiator
	uniform = /obj/item/clothing/under/costume/gladiator/ash_walker
