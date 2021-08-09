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
	///this is used for girders in the creation of walls/false walls
	var/sheettype = null
	///turn-in value for the gulag stacker - loosely relative to its rarity
	var/point_value = 0
	/// the shard debris typepath left over by solar panels and windows etc.
	var/shard_type
	///What type of wall does this sheet spawn
	var/walltype

/obj/item/stack/sheet/Initialize(mapload, new_amount, merge = TRUE)
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
