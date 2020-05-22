/obj/item/hatchet/saw
	name = "handsaw"
	desc = "A very sharp handsaw, it's compact."
	icon = 'icons/obj/tools.dmi'
	icon_state = "saw"
	item_state = "sawhandle_greyscale"
	lefthand_file = 'icons/mob/inhands/equipment/kitchen_lefthand.dmi'
	righthand_file = 'icons/mob/inhands/equipment/kitchen_righthand.dmi'
	tool_behaviour = TOOL_SAW
	force = 10
	throwforce = 8
	throw_speed = 3
	throw_range = 5
	custom_materials = list(/datum/material/iron = 5000)
	attack_verb = list("sawed", "sliced", "cut")
	hitsound = 'sound/weapons/bladeslice.ogg'
	sharpness = IS_SHARP
	var/random_color = TRUE //code taken from screwdrivers.dm; cool handles are cool.
	var/static/list/saw_colors = list(
		"blue" = rgb(24, 97, 213),
		"red" = rgb(255, 0, 0),
		"pink" = rgb(213, 24, 141),
		"brown" = rgb(160, 82, 18),
		"green" = rgb(14, 127, 27),
		"cyan" = rgb(24, 162, 213),
		"yellow" = rgb(255, 165, 0)
	)

/obj/item/hatchet/saw/Initialize()
	. = ..()
	if(random_color)
		icon_state = "sawhandle_greyscale"
		var/our_color = pick(saw_colors)
		add_atom_colour(saw_colors[our_color], FIXED_COLOUR_PRIORITY)
		update_icon()
	if(prob(75))
		pixel_y = rand(-8, 8)

/obj/item/hatchet/saw/update_overlays()
	. = ..()
	if(!random_color) //icon override
		return
	var/mutable_appearance/base_overlay = mutable_appearance(icon, "sawblade")
	base_overlay.appearance_flags = RESET_COLOR
	. += base_overlay

// END