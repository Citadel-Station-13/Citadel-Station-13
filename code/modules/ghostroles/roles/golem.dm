/datum/ghostrole/golem
	instantiator = /datum/ghostrole_instantiator/human/random/species/golem

/datum/ghostrole/golem/Greet(mob/created, datum/component/ghostrole_spawnpoint/spawnpoint, list/params)
	. = ..()
	var/mob/living/carbon/human/H = created
	if(!istype(H))
		return
	var/datum/species/golem/G = H.dna.species
	if(!istype(G))
		return
	to_chat(created, G.info_text)

/datum/ghostrole/golem/free
	name = "Free Golem"
	desc = "You are a Free Golem. Your family worships The Liberator."
	spawntext = "In his infinite and divine wisdom, he set your clan free to \
	travel the stars with a single declaration: \"Yeah go do whatever.\" Though you are bound to the one who created you, it is customary in your society to repeat those same words to newborn \
	golems, so that no golem may ever be forced to serve again."

/datum/ghostrole/golem/free/Greet(mob/created, datum/component/ghostrole_spawnpoint/spawnpoint, list/params)
	. = ..()
	to_chat(created, span_boldwarning("Build golem shells in the autolathe, and feed refined mineral sheets to the shells to bring them to life! You are generally a peaceful group unless provoked."))

/datum/ghostrole/golem/servant
	name = "Servant Golem"
	desc = "You are a golem."
	spawntext = "You move slowly, but are highly resistant to heat and cold as well as blunt trauma. You are unable to wear clothes, but can still use most tools."
	inject_params = list(
		"servant" = TRUE
	)

/datum/ghostrole/golem/servant/PostInstantiate(mob/created, datum/component/ghostrole_spawnpoint/spawnpoint, list/params)
	. = ..()
	var/datum/mind/creator_mind = params["creator"]
	if(!creator_mind)
		return
	var/creator_name = creator_mind.name
	log_game("[key_name(created)] possessed a golem shell enslaved to [creator_mind.name]/[creator_mind.key].")
	log_admin("[key_name(created)] possessed a golem shell enslaved to [creator_mind.name]/[creator_mind.key].")
	created.mind.store_memory( "Serve [creator_name][creator_mind.current && " (currently [creator_mind.current.name])"], and assist them in completing their goals at any cost.")
	to_chat(created, span_boldwarning("Serve [creator_name][creator_mind.current && " (currently [creator_mind.current.name])"], and assist them in completing their goals at any cost."))
	var/mob/living/carbon/human/H = created
	var/datum/species/golem/G = H.dna.species
	G.owner = creator_mind

/datum/ghostrole_instantiator/human/random/species/golem

/datum/ghostrole_instantiator/human/random/species/golem/GetSpeciesPath(mob/living/carbon/human/H, list/params)
	var/predestined = params["species"]
	if(istext(predestined))
		predestined = text2path(predestined)
	if(!ispath(predestined, /datum/species/golem))
		return pick(typesof(/datum/species/golem))
	return predestined

/datum/ghostrole_instantiator/human/random/species/golem/Randomize(mob/living/carbon/human/H, list/params)
	. = ..()
	H.set_cloned_appearance()
	var/datum/species/golem/G = H.dna.species
	H.real_name = params["name"] || (params["servant"]? "[initial(G.prefix)] Golem ([rand(1,999)])" : H.dna.species.random_name())

//Golem shells: Spawns in Free Golem ships in lavaland. Ghosts become mineral golems and are advised to spread personal freedom.
/obj/structure/ghost_role_spawner/golem
	name = "inert free golem shell"
	desc = "A humanoid shape, empty, lifeless, and full of potential."
	icon = 'icons/obj/wizard.dmi'
	icon_state = "construct"
	anchored = FALSE
	move_resist = MOVE_FORCE_NORMAL
	density = FALSE
	/// can we possibly have an owner
	var/has_owner = FALSE
	/// can golems switch bodies to this shell
	var/can_transfer = TRUE
	/// override golem species?
	var/golem_species_override

/obj/structure/ghost_role_spawner/golem/Initialize(mapload, datum/species/golem/species, mob/creator)
	if(golem_species_override)
		species = golem_species_override
	if(species) //spawners list uses object name to register so this goes before ..()
		name += " ([initial(species.prefix)])"
		golem_species_override = species		// yes semi-circular-reference sue me
	return ..(mapload, list(
		"species" = species,
		"creator" = creator && (istype(creator, /datum/mind)? creator : creator.mind)
	), (has_owner && creator)? /datum/ghostrole/golem/servant : /datum/ghostrole/golem/free)

/obj/structure/ghost_role_spawner/golem/on_attack_hand(mob/user, act_intent = user.a_intent, unarmed_attack_flags)
	if(isgolem(user) && can_transfer)
		// this is a bit special
		// we want them to keep their mind, so....
		var/datum/ghostrole/G = get_ghostrole_datum(/datum/ghostrole/golem/free)
		if(!G?.instantiator)
			CRASH("Couldn't locate freegolem instantiator")
		var/datum/ghostrole_instantiator/I = G.instantiator
		var/transfer_choice = alert("Transfer your soul to [src]? (Warning, your old body will die!)",,"Yes","No")
		if(transfer_choice != "Yes" || QDELETED(src) || !user.canUseTopic(src, BE_CLOSE, NO_DEXTERY, NO_TK))
			return
		log_game("[key_name(user)] golem-swapped into [src]")
		user.visible_message("<span class='notice'>A faint light leaves [user], moving to [src] and animating it!</span>","<span class='notice'>You leave your old body behind, and transfer into [src]!</span>")
		var/mob/living/created = I.Run(user.client, loc, list(
			"species" = golem_species_override,
			"name" = user.real_name
		))
		if(!created)
			CRASH("Couldn't make a valid golem, cancelling.")
		user.mind.transfer_to(created)
		user.death()
		qdel(src)
		return
	return ..()

/obj/structure/ghost_role_spawner/golem/servant
	has_owner = TRUE
	name = "inert servant golem shell"

/obj/structure/ghost_role_spawner/golem/adamantine
	name = "dust-caked free golem shell"
	desc = "A humanoid shape, empty, lifeless, and full of potential."
	can_transfer = FALSE
	golem_species_override = /datum/species/golem/adamantine
