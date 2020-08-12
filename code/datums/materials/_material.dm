/*! Material datum
Simple datum which is instanced once per type and is used for every object of said material. It has a variety of variables that define behavior. Subtyping from this makes it easier to create your own materials.
*/


/datum/material
	var/name = "material"
	var/desc = "its..stuff."
	///Base color of the material, is used for greyscale. Item isn't changed in color if this is null.
	var/color
	///Base alpha of the material, is used for greyscale icons.
	var/alpha
	///Materials "Traits". its a map of key = category | Value = Bool. Used to define what it can be used for
	var/list/categories = list()
	///The type of sheet this material creates. This should be replaced as soon as possible by greyscale sheets
	var/sheet_type
	///This is a modifier for force, and resembles the strength of the material
	var/strength_modifier = 1
	///This is a modifier for integrity, and resembles the strength of the material
	var/integrity_modifier = 1
	///This is the amount of value per 1 unit of the material
	var/value_per_unit = 0
	///Armor modifiers, multiplies an items normal armor vars by these amounts.
	var/armor_modifiers = list("melee" = 1, "bullet" = 1, "laser" = 1, "energy" = 1, "bomb" = 1, "bio" = 1, "rad" = 1, "fire" = 1, "acid" = 1)
	///How beautiful is this material per unit?
	var/beauty_modifier = 0
	///Can be used to override the sound items make, lets add some SLOSHing.
	var/item_sound_override
	///Can be used to override the stepsound a turf makes. MORE SLOOOSH
	var/turf_sound_override
	///what texture icon state to overlay
	var/texture_layer_icon_state
	///a cached filter for the texture icon
	var/cached_texture_filter

/datum/material/New()
	. = ..()
	if(texture_layer_icon_state)
		var/texture_icon = icon('icons/materials/composite.dmi', texture_layer_icon_state)
		cached_texture_filter = filter(type="layer", icon=texture_icon, blend_mode = BLEND_INSET_OVERLAY)

///This proc is called when the material is added to an object.
/datum/material/proc/on_applied(atom/source, amount, material_flags)
	if(material_flags & MATERIAL_COLOR) //Prevent changing things with pre-set colors, to keep colored toolboxes their looks for example
		if(color) //Do we have a custom color?
			source.add_atom_colour(color, FIXED_COLOUR_PRIORITY)
		if(alpha)
			source.alpha = alpha
		if(texture_layer_icon_state)
			ADD_KEEP_TOGETHER(source, MATERIAL_SOURCE(src))
			source.filters += cached_texture_filter

	if(material_flags & MATERIAL_ADD_PREFIX)
		source.name = "[name] [source.name]"

	if(beauty_modifier)
		addtimer(CALLBACK(source, /datum.proc/_AddElement, list(/datum/element/beauty, beauty_modifier * amount)), 0)

	if(istype(source, /obj)) //objs
		on_applied_obj(source, amount, material_flags)

	else if(isturf(source, /turf)) //turfs
		on_applied_turf(source, amount, material_flags)

	source.mat_update_desc(src)

///This proc is called when a material updates an object's description
/atom/proc/mat_update_desc(/datum/material/mat)
	return
///This proc is called when the material is added to an object specifically.
/datum/material/proc/on_applied_obj(var/obj/o, amount, material_flags)
	if(material_flags & MATERIAL_AFFECT_STATISTICS)
		var/new_max_integrity = CEILING(o.max_integrity * integrity_modifier, 1)
		o.modify_max_integrity(new_max_integrity)
		o.force *= strength_modifier
		o.throwforce *= strength_modifier

		var/list/temp_armor_list = list() //Time to add armor modifiers!

		if(!istype(o.armor))
			return
		var/list/current_armor = o.armor?.getList()

		for(var/i in current_armor)
			temp_armor_list[i] = current_armor[i] * armor_modifiers[i]
		o.armor = getArmor(arglist(temp_armor_list))
	if(!isitem(o))
		return
	var/obj/item/I = o
	if(!item_sound_override)
		return
	I.hitsound = item_sound_override
	I.usesound = item_sound_override
	I.throwhitsound = item_sound_override

/datum/material/proc/on_applied_turf(var/turf/T, amount, material_flags)
	if(isopenturf(T))
		if(!turf_sound_override)
			return
		var/turf/open/O = T
		O.footstep = turf_sound_override
		O.barefootstep = turf_sound_override
		O.clawfootstep = turf_sound_override
		O.heavyfootstep = turf_sound_override

///This proc is called when the material is removed from an object.
/datum/material/proc/on_removed(atom/source, material_flags)
	if(material_flags & MATERIAL_COLOR) //Prevent changing things with pre-set colors, to keep colored toolboxes their looks for example
		if(color)
			source.remove_atom_colour(FIXED_COLOUR_PRIORITY, color)
		source.alpha = initial(source.alpha)
		if(texture_layer_icon_state)
			source.filters -= cached_texture_filter
			REMOVE_KEEP_TOGETHER(source, MATERIAL_SOURCE(src))

	if(material_flags & MATERIAL_ADD_PREFIX)
		source.name = initial(source.name)

	if(istype(source, /obj)) //objs
		on_removed_obj(source, material_flags)

	else if(istype(source, /turf)) //turfs
		on_removed_turf(source, material_flags)

///This proc is called when the material is removed from an object specifically.
/datum/material/proc/on_removed_obj(obj/o, material_flags)
	if(material_flags & MATERIAL_AFFECT_STATISTICS)
		var/new_max_integrity = initial(o.max_integrity)
		o.modify_max_integrity(new_max_integrity)
		o.force = initial(o.force)
		o.throwforce = initial(o.throwforce)

/datum/material/proc/on_removed_turf(turf/T, material_flags)
	return
