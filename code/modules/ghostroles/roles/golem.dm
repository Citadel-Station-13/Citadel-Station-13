/datum/ghostrole/golem/free
	name = "Free Golem"
	desc = "You are a Free Golem. Your family worships The Liberator."
	spawntext = "In his infinite and divine wisdom, he set your clan free to \
	travel the stars with a single declaration: \"Yeah go do whatever.\" Though you are bound to the one who created you, it is customary in your society to repeat those same words to newborn \
	golems, so that no golem may ever be forced to serve again."

/datum/ghostrole/golem/servant
	name = "Servant Golem"
	desc = "You are a golem."
	spawntext = "You move slowly, but are highly resistant to heat and cold as well as blunt trauma. You are unable to wear clothes, but can still use most tools."

/datum/ghostrole/golem/servant/PostInstantiate(mob/created, datum/component/ghostrole_spawnpoint/spawnpoint, list/params)
	. = ..()
	var/datum/mind/creator_mind = params["creator"]
	if(!creator_mind)
		return

#warn finish

/datum/ghostrole_instantiator/human/random/species/golem
	possible_species = typesof(/datum/species/golem)

/datum/ghostrole_instantiator/human/random/species/golem/GetSpeciesPath(mob/living/carbon/human/H, list/params)
	var/predestined = params["species"]
	if(istext(predestined))
		predestined = text2path(predestined)
	if(!ispath(predestined, /datum/species/golem))
		return ..()
	return predestined


#warn convert


//Golem shells: Spawns in Free Golem ships in lavaland. Ghosts become mineral golems and are advised to spread personal freedom.
/obj/structure/ghost_role_spawner/golem
	name = "inert free golem shell"
	desc = "A humanoid shape, empty, lifeless, and full of potential."
	icon = 'icons/obj/wizard.dmi'
	icon_state = "construct"
	death = FALSE
	anchored = FALSE
	move_resist = MOVE_FORCE_NORMAL
	density = FALSE
	/// can we possibly have an owner
	var/has_owner = FALSE
	/// can golems switch bodies to this shell
	var/can_transfer = TRUE

/obj/structure/ghost_role_spawner/golem/Initialize(mapload, datum/species/golem/species, mob/creator)
	if(species) //spawners list uses object name to register so this goes before ..()
		name += " ([initial(species.prefix)])"
		mob_species = species
	return ..(mapload, list(
		"species" = species,
		"creator" = istype(creator, /datum/mind)? creator : creator.mind
	), (has_owner && creator)? /datum/ghostrole/golem/servant : /datum/ghostrole/golem/free)

	if(has_owner && creator)
		important_info = "Serve [creator], and assist [creator.p_them()] in completing [creator.p_their()] goals at any cost."
		owner = creator

/obj/structure/ghost_role_spawner/golem/special(mob/living/new_spawn, name)
	var/datum/species/golem/X = mob_species
	to_chat(new_spawn, "[initial(X.info_text)]")
	if(!owner)
		to_chat(new_spawn, "Build golem shells in the autolathe, and feed refined mineral sheets to the shells to bring them to life! You are generally a peaceful group unless provoked.")
	else
		new_spawn.mind.store_memory("<b>Serve [owner.real_name], your creator.</b>")
		new_spawn.mind.enslave_mind_to_creator(owner)
		log_game("[key_name(new_spawn)] possessed a golem shell enslaved to [key_name(owner)].")
		log_admin("[key_name(new_spawn)] possessed a golem shell enslaved to [key_name(owner)].")
	if(ishuman(new_spawn))
		var/mob/living/carbon/human/H = new_spawn
		if(has_owner)
			var/datum/species/golem/G = H.dna.species
			G.owner = owner
		H.set_cloned_appearance()
		if(!name)
			if(has_owner)
				H.real_name = "[initial(X.prefix)] Golem ([rand(1,999)])"
			else
				H.real_name = H.dna.species.random_name()
		else
			H.real_name = name
	if(has_owner)
		new_spawn.mind.assigned_role = "Servant Golem"
	else
		new_spawn.mind.assigned_role = "Free Golem"

/obj/structure/ghost_role_spawner/golem/on_attack_hand(mob/user, act_intent = user.a_intent, unarmed_attack_flags)
	if(isgolem(user) && can_transfer)
		// this is a bit special
		// we want them to keep their mind, so....
		var/datum/ghostrole/G = get_ghostrole_datum(/datum/ghostrole/golem/free)
		if(!G?.instantiator)
			CRASH("Couldn't locate freegolem instantiator")
		var/datum/ghostrole_instantiator/I = G.instantiator
		var/transfer_choice = alert("Transfer your soul to [src]? (Warning, your old body will die!)",,"Yes","No")
		if(transfer_choice != "Yes" || QDELETED(src) || uses <= 0 || !user.canUseTopic(src, BE_CLOSE, NO_DEXTERY, NO_TK))
			return
		log_game("[key_name(user)] golem-swapped into [src]")
		user.visible_message("<span class='notice'>A faint light leaves [user], moving to [src] and animating it!</span>","<span class='notice'>You leave your old body behind, and transfer into [src]!</span>")
		var/mob/living/created = I.Run(user.client, loc, list())
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
	mob_name = "a free golem"
	can_transfer = FALSE
	mob_species = /datum/species/golem/adamantine
