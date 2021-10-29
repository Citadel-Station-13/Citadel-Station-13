/**
 * Holder data for procedural generation
 */
/datum/procedural_generation
	/// name
	var/name = "Unknown Procedural Generator"
	/// seed
	var/seed
	/// width
	var/width
	/// height
	var/height
	/// is generation complete
	VAR_PROTECTED/complete = FALSE
	/// constant - do we generate 0 to 1's or 0 OR 1's
	VAR_PROTECTED/binary = FALSE
	/// generated data cache if any
	VAR_PROTECTED/cache

/**
 * Public proc - inits with these args
 */
/datum/procedural_generation/proc/Initialize(...)
	SHOULD_NOT_OVERRIDE(TRUE)
	ASSERT(!complete)		// we are not modifiable post-init
	var/list/valid = Variables()
	for(var/key in args)
		if(key in valid)
			vars[key] = args[key]
	name = "[initial(name)] - [seed]"

/**
 * Public proc - supported variables
 */
/datum/procedural_generation/proc/Variables()
	return list(NAMEOF(src, width) = VV_NUM, NAMEOF(src, height) = VV_NUM, NAMEOF(src, seed) = VV_TEXT)

/**
 * Public proc - gets value at a coordinate
 */
/datum/procedural_generation/proc/Get(x, y)
	ASSERT(complete)
	ASSERT(ISINRANGE(x, 1, width))
	ASSERT(ISINRANGE(y, 1, height))
	return get_at(x, y)

/**
 * Private proc - gets value at a coordinate
 */
/datum/procedural_generation/proc/get_at(x, y)
	PROTECTED_PROC(TRUE)

/**
 * Public proc - generates
 */
/datum/procedural_generation/proc/Generate()
	ASSERT(!complete)
	run()

/**
 * Private proc - does the generation
 */
/datum/procedural_generation/proc/run()
	PROTECTED_PROC(TRUE)

/datum/procedural_generation/vv_get_dropdown()
	. = ..()
	. += "---"
	VV_DROPDOWN_OPTION(VV_HK_PROCGEN_RENDER, "View Debug Render")

/datum/procedural_generation/vv_do_topic(list/href_list)
	. = ..()
	if(href_list[VV_HK_PROCGEN_RENDER])
		Render(usr)

/**
 * Shows a debug render
 *
 * Can be overriden
 */
/datum/procedural_generation/proc/Render(mob/user)
	ui_interact(user)

/datum/procedural_generation/ui_interact(mob/user, datum/tgui/ui)
	. = ..()
	ui = SStgui.try_update_ui(user, src, ui)
	if(!ui)
		ui = new(user, src, "ProceduralGenerationRender")

#warn finish the above, use canvas and tgui if possible.

/datum/procedural_generation/ui_static_data(mob/user)
	. = ..()
	var/list/L = list()
	for(var/i in variables)
		L[i] = vars[i]
	.["vars"] = L
	.["width"] = width
	.["height"] = height
	.["binary"] = FORCE_BOOLEAN(binary)
	.["gridmap"] = render_image_grid_binary()

/**
 * Renders to a 2d image grid - single value, 0 to 1
 *
 * Only used in debug UIs
 */
/datum/procedural_generation/proc/render_image_grid_binary()
	var/list/XL = list()
	XL.len = width
	for(var/x in 1 to width)
		var/list/YL = list()
		YL.len = height
		XL[x] = YL
		for(var/y in 1 to width)
			XL[x][y] = binary? FORCE_BOOLEAN(Get(x, y)) : Get(x, y)
