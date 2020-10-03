 /*
  * Loot piles structures, somewhat inspired from Polaris 13 ones but without the one search per pile ckey/mind restriction
  * because the actual code is located its own element and has enough variables already. the piles themselves merely cosmetical.
  */
/obj/structure/loot_pile
	name = "pile of junk"
	desc = "Lots of junk lying around. They say one man's trash is another man's treasure."
	icon = 'icons/obj/loot_piles.dmi'
	icon_state = "randompile"
	density = FALSE
	anchored = TRUE
	var/loot_amount = 5
	var/delete_on_depletion = FALSE
	var/can_use_hands = TRUE
	var/scavenge_time = 12 SECONDS
	var/allowed_tools = list(TOOL_SHOVEL = 0.6) //list of tool_behaviours with associated speed multipliers (lower is better)
	var/icon_states_to_use = list("junk_pile1", "junk_pile2", "junk_pile3", "junk_pile4", "junk_pile5")
	var/list/loot

 /*
  * Associated values in this list are not weights but numbers of times the kery can be rolled
  * before being removed from ALL piles with same kind. This is why I wanted 'scavenging' to be an element and not a component.
  */
	var/list/unique_loot

 /*
  * used for restrictions such as "one per mind", "one per ckey". Depending on the setting, these can be either limited to
  * the current pile or shared throughout all atoms attached to this element.
  */
	var/loot_restriction = NO_LOOT_RESTRICTION
	var/maximum_loot_per_player = 1

/obj/structure/loot_pile/Initialize()
	. = ..()
	icon_state = pick(icon_states_to_use)

/obj/structure/loot_pile/ComponentInitialize()
	. = ..()
	if(loot)
		AddElement(/datum/element/scavenging, loot_amount, loot, unique_loot, scavenge_time, can_use_hands, allowed_tools, null, delete_on_depletion, loot_restriction, maximum_loot_per_player)

//uses the maintenance_loot global list, mostly boring stuff and mices.
/obj/structure/loot_pile/maint
	name = "trash pile"
	desc = "A heap of garbage, but maybe there's something interesting inside?"
	density = TRUE
	layer = TABLE_LAYER
	climbable = TRUE
	pass_flags = LETPASSTHROW
	loot = list(
		SCAVENGING_FOUND_NOTHING = 50,
		SCAVENGING_SPAWN_MOUSE = 10,
		SCAVENGING_SPAWN_MICE = 5,
		SCAVENGING_SPAWN_TOM = 1,
		/obj/item/clothing/gloves/color/yellow = 0.5)
	unique_loot = list(/obj/item/clothing/gloves/color/yellow = 5, SCAVENGING_SPAWN_TOM = 1)

/obj/structure/loot_pile/maint/ComponentInitialize()
	var/static/safe_maint_items
	if(!safe_maint_items)
		safe_maint_items = list()
		for(var/A in GLOB.maintenance_loot)
			if(ispath(A, /obj/item))
				safe_maint_items[A] = GLOB.maintenance_loot[A]
	loot += safe_maint_items
	return ..()
