/**
 * file contains all base item rendering backend for showing which items are equipped on a mob visually
 */
/obj/item
	// worn icons
	/// base worn state - if this is set to NON NULL, the item will use new rendering system - **All worn states/etc must be in the same icon file as its normal icon!** if we ever convert the whole codebase, remove this latter part of the comment.
	var/worn_state
	/// if you have to be a little snowflake and override worn icon instead of the above, use this.
	var/worn_icon
	/// pixels x width of worn icon
	var/worn_x_dimension = 32
	/// pixels y width of worn icon
	var/worn_y_dimension = 32
	/// do not do [_slot] in dmi state generation so [worn_base_state][_slot][_bodytype] becomes [worn_base_state][_bodytype]
	var/worn_slots_monostate = FALSE
	/// if non null, override layer when worn instead of using slot default
	var/worn_layer_override
	// INHANDS - These use worn_state, but have their own render keys, as they're bodytype agnostic.
	/// left hand slot string
	var/worn_render_key_lefthand = "_left"
	/// right hand slot string
	var/worn_render_key_righthand = "_right"
	// ADMINBUS - NEVER USE IN CODE, ENFORCED USING FINAL
	/// when set via vv, overrides worn state in a slot, no matter what
	VAR_FINAL/list/worn_state_slot_overide
	/// when set via vv, overrides worn icon in a slot, no matter what
	VAR_FINAL/list/worn_icon_slot_override


	// bodytypes
	/// which bodytypes are allowed to wear this? if one is and it isn't in bodytypes_supported, the automatic fallback list/template icons will be used.
	var/bodytypes_allowed = ALL
	/// supported bodytypes - these bodytypes will have their keys added in worn state.
	var/bodytypes_supported = NONE
	/// bodytypes where we give up and use a template if none are founud - this will go AFTER bodytypes_supported, so if one isn't supported but IS templated, it will be used instead of none.
	var/bodytypes_templated = NONE
	/// bodyypes that are flattened to being **omitted** e.g. if BODYTYPE_HUMAN is in here, it'd be [worn_base_state][_slot] instead of [worn_base_state][_slot][_bodytype]
	var/bodytypes_omitted = ALL

	// greyscaling
	///The config type to use for greyscaled worn sprites. Both this and greyscale_colors must be assigned to work.
	var/greyscale_config_worn

#warn ugh - hook allowed bodytypes, modify species to get effective bodytype lists.
#warn figure out how to do templating too..
#warn unit tests...
#warn refactor how species offsets work!

/**
 * master proc to build worn overlays. returns a single mutable_appearance.
 *
 * how this picks icon file:
 *
 * how this picks icon state:
 */
/obj/item/proc/build_worn_appearance(datum/inventory_slot/slot, requested_bodytype, mob/living/L)
	slot = get_inventory_slot_datum(slot)
	#warn how to handle current default icons
	#warn how to handle female uniform

#warn impl: 1. slot key, 2. inhand key if inhand, 3. overrides

/obj/item/proc/get_worn_icon(datum/inventory_slot/slot, requested_bodytype, templating)
	slot = get_inventory_slot_datum(slot)


/obj/item/proc/get_worn_state(datum/inventory_slot/slot, requested_bodytype, templating)
	slot = get_inventory_slot_datum(slot)

#warn refactor?
//Overlays for the worn overlay so you can overlay while you overlay
//eg: ammo counters, primed grenade flashing, etc.
//"icon_file" is used automatically for inhands etc. to make sure it gets the right inhand file
/obj/item/proc/worn_overlays(isinhands = FALSE, icon_file, used_state, style_flags = NONE)
	. = list()
	SEND_SIGNAL(src, COMSIG_ITEM_WORN_OVERLAYS, isinhands, icon_file, used_state, style_flags, .)

// greyscale
// body type
// digitgrade if body type is human
// slot datum/meta datums? for icon key. same for left/right hand, abstract?
// [(bodytype != BODYTYPE_HUMAN && bodytype_) || mutantrace_][inhand_icon_state || worn_icon_state][_slotstring]
// icon state caching yeah or nah
// standard mutantrace clip mask?
// GAGS --> vendor, loadout, colormate + color matrix editing for loadout/colormate
// accessories - removal, addition, layering, slots, max slots, etc? generics? need nested equipped and dropped calls too


/obj/item/set_greyscale(list/colors, new_config, new_worn_config, new_inhand_left, new_inhand_right)
	if(new_worn_config)
		greyscale_config_worn = new_worn_config
	return ..()

/// Checks if this atom uses the GAGS system and if so updates the worn and inhand icons
/obj/item/update_greyscale()
	. = ..()
	if(!greyscale_colors)
		return
	if(greyscale_config_worn)
		worn_icon = SSgreyscale.GetColoredIconByType(greyscale_config_worn, greyscale_colors)

/*
Does everything in relation to building the /mutable_appearance used in the mob's overlays list
covers:
 inhands and any other form of worn item
 centering large appearances
 layering appearances on custom layers
 building appearances from custom icon files

By Remie Richards (yes I'm taking credit because this just removed 90% of the copypaste in update_icons())

override_state: A string to use as the state, otherwise item_state or icon_state will be used.

default_layer: The layer to draw this on if no other layer is specified

default_icon_file: The icon file to draw states from if no other icon file is specified

isinhands: If true then mob_overlay_icon is skipped so that default_icon_file is used,
in this situation default_icon_file is expected to match either the lefthand_ or righthand_ file var

femalueuniform: A value matching a uniform item's fitted var, if this is anything but NO_FEMALE_UNIFORM, we
generate/load female uniform sprites matching all previously decided variables

style_flags: mutant race appearance flags, mostly used for worn_overlays()

alpha_mask: a text string or list of text, the actual icons are stored in a global list and associated with said text string(s).

use_mob_overlay_icon: if FALSE, it will always use the default_icon_file even if mob_overlay_icon is present.

*/
/obj/item/proc/build_worn_icon(default_layer = 0, default_icon_file = null, isinhands = FALSE, femaleuniform = NO_FEMALE_UNIFORM, override_state, style_flags = NONE, use_mob_overlay_icon = TRUE, alpha_mask)

	var/t_state
	t_state = override_state || item_state || icon_state

	//Find a valid icon file from variables+arguments
	var/file2use
	if(!isinhands && mob_overlay_icon && use_mob_overlay_icon)
		file2use = mob_overlay_icon
	if(!file2use)
		file2use = default_icon_file

	//Find a valid layer from variables+arguments
	var/layer2use
	if(alternate_worn_layer)
		layer2use = alternate_worn_layer
	if(!layer2use)
		layer2use = default_layer

	var/mutable_appearance/standing
	if(femaleuniform || alpha_mask)
		standing = wear_alpha_masked_version(t_state, file2use, layer2use, femaleuniform, alpha_mask)
	if(!standing)
		standing = mutable_appearance(file2use, t_state, -layer2use)

	//Get the overlays for this item when it's being worn
	//eg: ammo counters, primed grenade flashes, etc.
	var/list/worn_overlays = worn_overlays(isinhands, file2use, t_state, style_flags)
	if(worn_overlays && worn_overlays.len)
		standing.overlays.Add(worn_overlays)

	standing = center_image(standing, isinhands ? inhand_x_dimension : worn_x_dimension, isinhands ? inhand_y_dimension : worn_y_dimension)

	//Handle held offsets
	var/mob/M = loc
	if(istype(M))
		var/list/L = get_held_offsets()
		if(L)
			standing.pixel_x += L["x"] //+= because of center()ing
			standing.pixel_y += L["y"]

	standing.alpha = alpha
	standing.color = color

	return standing


/obj/item/proc/get_held_offsets()
	var/list/L
	if(ismob(loc))
		var/mob/M = loc
		L = M.get_item_offsets_for_index(M.get_held_index_of_item(src))
	return L


//Can't think of a better way to do this, sadly
/mob/proc/get_item_offsets_for_index(i)
	switch(i)
		if(3) //odd = left hands
			return list("x" = 0, "y" = 16)
		if(4) //even = right hands
			return list("x" = 0, "y" = 16)
		else //No offsets or Unwritten number of hands
			return list("x" = 0, "y" = 0)
