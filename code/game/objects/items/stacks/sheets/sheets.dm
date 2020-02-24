/obj/item/stack/sheet
	name = "sheet"
	lefthand_file = 'icons/mob/inhands/misc/sheets_lefthand.dmi'
	righthand_file = 'icons/mob/inhands/misc/sheets_righthand.dmi'
	full_w_class = WEIGHT_CLASS_NORMAL
	force = 5
	throwforce = 5
	max_amount = 50
	throw_speed = 1
	throw_range = 3
	attack_verb = list("bashed", "battered", "bludgeoned", "thrashed", "smashed")
	novariants = FALSE
	mats_per_stack = MINERAL_MATERIAL_AMOUNT
	var/sheettype = null //this is used for girders in the creation of walls/false walls
	var/point_value = 0 //turn-in value for the gulag stacker - loosely relative to its rarity
	var/is_fabric = FALSE //is this  a valid material for the loom?
	var/loom_result //result from pulling on the loom
	var/pull_effort = 0 //amount of delay when pulling on the loom
	var/shard_type // the shard debris typepath left over by solar panels and windows etc.

/obj/item/stack/sheet/Initialize(mapload, new_amount, merge)
	. = ..()
	pixel_x = rand(-4, 4)
	pixel_y = rand(-4, 4)

/**
  * Called on the glass sheet upon solar construction (duh):
  * Different glass sheets can modify different stas/vars, such as obj_integrity or efficiency
  * and possibly extra effects if you wish to code them.
  * Keep in mind the solars' max_integrity is set equal to the obj_integrity later,
  * so you won't have to do so here.
  */
/obj/item/stack/sheet/proc/on_solar_construction(/obj/machinery/power/solar/S)
	return
