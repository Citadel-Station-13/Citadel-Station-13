
/datum/ghostrole/ghost_cafe
	name = "Ghost Cafe Visitor"
	assigned_role = "Ghost Cafe Visitor"
	desc = "Off-station area for ghosts to roleplay in."
	spawntext = "You know one thing for sure. You aren't actually alive! Are you in a simulation?"
	jobban_role = ROLE_GHOSTCAFE
	instantiator = /datum/ghostrole_instantiator/human/player_static/ghost_cafe

/obj/structure/ghost_role_spawner/ghost_cafe
	name = "Ghost Cafe Sleeper"
	icon = 'icons/obj/machines/sleeper.dmi'
	icon_state = "sleeper"
	role_type = /datum/ghostrole/ghost_cafe
	role_spawns = INFINITY

/datum/action/toggle_dead_chat_mob
	icon_icon = 'icons/mob/mob.dmi'
	button_icon_state = "ghost"
	name = "Toggle deadchat"
	desc = "Turn off or on your ability to hear ghosts."

/datum/action/toggle_dead_chat_mob/Trigger()
	if(!..())
		return 0
	var/mob/M = target
	if(HAS_TRAIT_FROM(M,TRAIT_SIXTHSENSE,GHOSTROLE_TRAIT))
		REMOVE_TRAIT(M,TRAIT_SIXTHSENSE,GHOSTROLE_TRAIT)
		to_chat(M,"<span class='notice'>You're no longer hearing deadchat.</span>")
	else
		ADD_TRAIT(M,TRAIT_SIXTHSENSE,GHOSTROLE_TRAIT)
		to_chat(M,"<span class='notice'>You're once again longer hearing deadchat.</span>")

/datum/action/disguise
	name = "Disguise"
	button_icon_state = "ling_transform"
	icon_icon = 'icons/mob/actions/actions_changeling.dmi'
	background_icon_state = "bg_mime"
	var/currently_disguised = FALSE
	var/static/list/mob_blacklist = typecacheof(list(
		/mob/living/simple_animal/pet,
		/mob/living/simple_animal/hostile/retaliate/goose,
		/mob/living/simple_animal/hostile/poison,
		/mob/living/simple_animal/hostile/retaliate/goat,
		/mob/living/simple_animal/cow,
		/mob/living/simple_animal/chick,
		/mob/living/simple_animal/chicken,
		/mob/living/simple_animal/kiwi,
		/mob/living/simple_animal/babyKiwi,
		/mob/living/simple_animal/deer,
		/mob/living/simple_animal/parrot,
		/mob/living/simple_animal/hostile/lizard,
		/mob/living/simple_animal/crab,
		/mob/living/simple_animal/cockroach,
		/mob/living/simple_animal/butterfly,
		/mob/living/simple_animal/mouse,
		/mob/living/simple_animal/sloth,
		/mob/living/simple_animal/opossum,
		/mob/living/simple_animal/hostile/bear,
		/mob/living/simple_animal/hostile/asteroid/polarbear,
		/mob/living/simple_animal/hostile/asteroid/wolf,
		/mob/living/carbon/monkey,
		/mob/living/simple_animal/hostile/gorilla,
		/mob/living/carbon/alien/larva,
		/mob/living/simple_animal/hostile/retaliate/frog
	))


/datum/action/disguise/Trigger()
	var/mob/living/carbon/human/H = owner
	if(!currently_disguised)
		var/user_object_type = input(H, "Disguising as OBJECT or MOB?") as null|anything in list("OBJECT", "MOB")
		if(user_object_type)
			var/search_term = stripped_input(H, "Enter the search term")
			if(search_term)
				var/list_to_search
				if(user_object_type == "MOB")
					list_to_search = subtypesof(/mob) - mob_blacklist
				else
					list_to_search = subtypesof(/obj)
				var/list/filtered_results = list()
				for(var/some_search_item in list_to_search)
					if(findtext("[some_search_item]", search_term))
						filtered_results += some_search_item
				if(!length(filtered_results))
					to_chat(H, "Nothing matched your search query!")
				else
					var/disguise_selection = input("Select item to disguise as") as null|anything in filtered_results
					if(disguise_selection)
						var/atom/disguise_item = disguise_selection
						var/image/I = image(icon = initial(disguise_item.icon), icon_state = initial(disguise_item.icon_state), loc = H)
						I.override = TRUE
						I.layer = ABOVE_MOB_LAYER
						H.add_alt_appearance(/datum/atom_hud/alternate_appearance/basic/everyone, "ghost_cafe_disguise", I)
						currently_disguised = TRUE
	else
		H.remove_alt_appearance("ghost_cafe_disguise")
		currently_disguised = FALSE

/datum/ghostrole/ghost_cafe/Greet(mob/created, datum/component/ghostrole_spawnpoint/spawnpoint, list/params)
	. = ..()
	to_chat(created,"<span class='boldwarning'>Ghosting is free!</span>")

/datum/ghostrole_instantiator/human/player_static/ghost_cafe
	equip_outfit = /datum/outfit/ghostcafe
	mob_traits = list(
		TRAIT_SIXTHSENSE,
		TRAIT_EXEMPT_HEALTH_EVENTS,
		TRAIT_NO_MIDROUND_ANTAG
	)

/datum/ghostrole_instantiator/human/player_static/ghost_cafe/Create(client/C, atom/location, list/params)
	. = ..()
	var/mob/living/carbon/human/H = .
	H.AddElement(/datum/element/ghost_role_eligibility, free_ghosting = TRUE)
	H.AddElement(/datum/element/dusts_on_catatonia)
	var/area/A = get_area(H)
	H.AddElement(/datum/element/dusts_on_leaving_area,list(A.type,/area/hilbertshotel))
	var/datum/action/toggle_dead_chat_mob/D = new(H)
	D.Grant(H)
	var/datum/action/disguise/disguise_action = new(H)
	disguise_action.Grant(H)

/datum/outfit/ghostcafe
	name = "ID, jumpsuit and shoes"
	uniform = /obj/item/clothing/under/color/random
	shoes = /obj/item/clothing/shoes/sneakers/black
	id = /obj/item/card/id/no_banking
	r_hand = /obj/item/storage/box/syndie_kit/chameleon/ghostcafe


/datum/outfit/ghostcafe/pre_equip(mob/living/carbon/human/H, visualsOnly = FALSE, client/preference_source)
	..()
	if (isplasmaman(H))
		head = /obj/item/clothing/head/helmet/space/plasmaman
		uniform = /obj/item/clothing/under/plasmaman
		l_hand= /obj/item/tank/internals/plasmaman/belt/full
		mask = /obj/item/clothing/mask/breath
		return

	var/suited = !preference_source || preference_source.prefs.jumpsuit_style == PREF_SUIT
	if (CONFIG_GET(flag/grey_assistants))
		uniform = suited ? /obj/item/clothing/under/color/grey : /obj/item/clothing/under/color/jumpskirt/grey
	else
		if(SSevents.holidays && SSevents.holidays[PRIDE_MONTH])
			uniform = suited ? /obj/item/clothing/under/color/rainbow : /obj/item/clothing/under/color/jumpskirt/rainbow
		else
			uniform = suited ? /obj/item/clothing/under/color/random : /obj/item/clothing/under/color/jumpskirt/random

/datum/outfit/ghostcafe/post_equip(mob/living/carbon/human/H, visualsOnly = FALSE, client/preference_source)
	H.internal = H.get_item_for_held_index(1)
	H.update_internals_hud_icon(1)

/obj/item/storage/box/syndie_kit/chameleon/ghostcafe
	name = "ghost cafe costuming kit"
	desc = "Look just the way you did in life - or better!"

/obj/item/storage/box/syndie_kit/chameleon/ghostcafe/PopulateContents() // Doesn't contain a PDA, for isolation reasons.
	new /obj/item/clothing/under/chameleon(src)
	new /obj/item/clothing/suit/chameleon(src)
	new /obj/item/clothing/gloves/chameleon(src)
	new /obj/item/clothing/shoes/chameleon(src)
	new /obj/item/clothing/glasses/chameleon(src)
	new /obj/item/clothing/head/chameleon(src)
	new /obj/item/clothing/mask/chameleon(src)
	new /obj/item/storage/backpack/chameleon(src)
	new /obj/item/clothing/neck/cloak/chameleon(src)
