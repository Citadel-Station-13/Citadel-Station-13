/* Stack type objects!
 * Contains:
 * 		Stacks
 * 		Recipe datum
 * 		Recipe list datum
 */

/*
 * Stacks
 */

/obj/item/stack
	icon = 'icons/obj/stack_objects.dmi'
	gender = PLURAL
	material_modifier = 0.01
	// material_modifier = 0.05 //5%, so that a 50 sheet stack has the effect of 5k materials instead of 100k.
	max_integrity = 100
	var/list/datum/stack_recipe/recipes
	var/singular_name
	var/amount = 1
	var/max_amount = 50 //also see stack recipes initialisation, param "max_res_amount" must be equal to this max_amount
	var/is_cyborg = FALSE // It's TRUE if module is used by a cyborg, and uses its storage
	var/datum/robot_energy_storage/source
	var/cost = 1 // How much energy from storage it costs
	var/merge_type = null // This path and its children should merge with this stack, defaults to src.type
	var/full_w_class = WEIGHT_CLASS_NORMAL //The weight class the stack should have at amount > 2/3rds max_amount
	var/novariants = TRUE //Determines whether the item should update it's sprites based on amount.
	var/list/mats_per_unit //list that tells you how much is in a single unit.
	///Datum material type that this stack is made of
	var/material_type
	//NOTE: When adding grind_results, the amounts should be for an INDIVIDUAL ITEM - these amounts will be multiplied by the stack size in on_grind()
	var/obj/structure/table/tableVariant // we tables now (stores table variant to be built from this stack)

		// The following are all for medical treatment, they're here instead of /stack/medical because sticky tape can be used as a makeshift bandage or splint
	/// If set and this used as a splint for a broken bone wound, this is used as a multiplier for applicable slowdowns (lower = better) (also for speeding up burn recoveries)
	var/splint_factor
	/// How much blood flow this stack can absorb if used as a bandage on a cut wound, note that absorption is how much we lower the flow rate, not the raw amount of blood we suck up
	var/absorption_capacity
	/// How quickly we lower the blood flow on a cut wound we're bandaging. Expected lifetime of this bandage in ticks is thus absorption_capacity/absorption_rate, or until the cut heals, whichever comes first
	var/absorption_rate
	/// Amount of matter for RCD
	var/matter_amount = 0

/obj/item/stack/Initialize(mapload, new_amount, merge = TRUE)
	if(is_cyborg)
		if(!istype(loc, /obj/item/robot_module))
			stack_trace("Cyborg stack created outside of a robot module, deleting.")
			return INITIALIZE_HINT_QDEL
		prepare_estorage(loc)

	if(new_amount != null)
		amount = new_amount
	while(amount > max_amount)
		amount -= max_amount
		new type(loc, max_amount, FALSE)
	if(!merge_type)
		merge_type = src.type

	if(LAZYLEN(mats_per_unit))
		set_mats_per_unit(mats_per_unit, 1)
	else if(LAZYLEN(custom_materials))
		// DO NOT REMOVE! we have to inflate the values first
		for(var/i in custom_materials)
			custom_materials[i] *= amount
		set_mats_per_unit(custom_materials, amount ? 1/amount : 1)

	. = ..()
	if(merge)
		for(var/obj/item/stack/S in loc)
			if(can_merge(S))
				INVOKE_ASYNC(src, .proc/merge, S)
	var/list/temp_recipes = get_main_recipes()
	recipes = temp_recipes.Copy()
	if(material_type)
		var/datum/material/M = SSmaterials.GetMaterialRef(material_type) //First/main material
		for(var/i in M.categories)
			switch(i)
				if(MAT_CATEGORY_BASE_RECIPES)
					var/list/temp = SSmaterials.base_stack_recipes.Copy()
					recipes += temp
				if(MAT_CATEGORY_RIGID)
					var/list/temp = SSmaterials.rigid_stack_recipes.Copy()
					recipes += temp
	update_weight()
	update_icon()

/** Sets the amount of materials per unit for this stack.
 *
 * Arguments:
 * - [mats][/list]: The value to set the mats per unit to.
 * - multiplier: The amount to multiply the mats per unit by. Defaults to 1.
 */
/obj/item/stack/proc/set_mats_per_unit(list/mats, multiplier=1)
	mats_per_unit = SSmaterials.FindOrCreateMaterialCombo(mats, multiplier)
	update_custom_materials()

/** Updates the custom materials list of this stack.
 */
/obj/item/stack/proc/update_custom_materials()
	set_custom_materials(mats_per_unit, amount, is_update=TRUE)

/**
 * Override to make things like metalgen accurately set custom materials
 */
/obj/item/stack/set_custom_materials(list/materials, multiplier=1, is_update=FALSE)
	return is_update ? ..() : set_mats_per_unit(materials, multiplier / (amount || 1))

/obj/item/stack/on_grind()
	. = ..()
	for(var/i in 1 to length(grind_results)) //This should only call if it's ground, so no need to check if grind_results exists
		grind_results[grind_results[i]] *= get_amount() //Gets the key at position i, then the reagent amount of that key, then multiplies it by stack size

/obj/item/stack/grind_requirements()
	if(is_cyborg)
		to_chat(usr, "<span class='warning'>[src] is electronically synthesized in your chassis and can't be ground up!</span>")
		return
	return TRUE

/obj/item/stack/proc/get_main_recipes()
	SHOULD_CALL_PARENT(TRUE)
	return list()//empty list

/obj/item/stack/proc/update_weight()
	if(amount <= (max_amount * (1/3)))
		w_class = clamp(full_w_class-2, WEIGHT_CLASS_TINY, full_w_class)
	else if (amount <= (max_amount * (2/3)))
		w_class = clamp(full_w_class-1, WEIGHT_CLASS_TINY, full_w_class)
	else
		w_class = full_w_class

/obj/item/stack/update_icon_state()
	if(novariants)
		return
	if(amount <= (max_amount * (1/3)))
		icon_state = initial(icon_state)
	else if (amount <= (max_amount * (2/3)))
		icon_state = "[initial(icon_state)]_2"
	else
		icon_state = "[initial(icon_state)]_3"

/obj/item/stack/update_overlays()
	. = ..()
	if(isturf(loc))
		return
	var/atom/movable/screen/storage/item_holder/holder = locate(/atom/movable/screen/storage/item_holder) in vis_locs
	if(holder?.master && istype(holder.master, /datum/component/storage/concrete))
		var/datum/component/storage/concrete/storage = holder.master
		if(storage.display_numerical_stacking)
			return // It's being handled by the storage we're in, forget about it.
	var/mutable_appearance/number = mutable_appearance(appearance_flags = APPEARANCE_UI_IGNORE_ALPHA)
	number.maptext = MAPTEXT(get_amount())
	. += number

/obj/item/stack/examine(mob/user)
	. = ..()
	if (is_cyborg)
		if(singular_name)
			. += "There is enough energy for [get_amount()] [singular_name]\s."
		else
			. += "There is enough energy for [get_amount()]."
		return
	if(singular_name)
		if(get_amount()>1)
			. += "There are [get_amount()] [singular_name]\s in the stack."
		else
			. += "There is [get_amount()] [singular_name] in the stack."
	else if(get_amount()>1)
		. += "There are [get_amount()] in the stack."
	else
		. += "There is [get_amount()] in the stack."
	. += "<span class='notice'>Alt-click to take a custom amount.</span>"

/obj/item/stack/equipped(mob/user, slot)
	. = ..()
	update_icon()

/obj/item/stack/dropped(mob/user, slot)
	. = ..()
	update_icon()

/obj/item/stack/proc/get_amount()
	if(is_cyborg)
		. = round(source?.energy / cost)
	else
		. = (amount)

/**
 * Builds all recipes in a given recipe list and returns an association list containing them
 *
 * Arguments:
 * * recipe_to_iterate - The list of recipes we are using to build recipes
 */
/obj/item/stack/proc/recursively_build_recipes(list/recipe_to_iterate)
	var/list/L = list()
	for(var/recipe in recipe_to_iterate)
		if(istype(recipe, /datum/stack_recipe_list))
			var/datum/stack_recipe_list/R = recipe
			L["[R.title]"] = recursively_build_recipes(R.recipes)
		if(istype(recipe, /datum/stack_recipe))
			var/datum/stack_recipe/R = recipe
			L["[R.title]"] = build_recipe(R)
	return L

/**
 * Returns a list of properties of a given recipe
 *
 * Arguments:
 * * R - The stack recipe we are using to get a list of properties
 */
/obj/item/stack/proc/build_recipe(datum/stack_recipe/R)
	return list(
		"res_amount" = R.res_amount,
		"max_res_amount" = R.max_res_amount,
		"req_amount" = R.req_amount,
		"ref" = "\ref[R]",
	)

/**
 * Checks if the recipe is valid to be used
 *
 * Arguments:
 * * R - The stack recipe we are checking if it is valid
 * * recipe_list - The list of recipes we are using to check the given recipe
 */
/obj/item/stack/proc/is_valid_recipe(datum/stack_recipe/R, list/recipe_list)
	for(var/S in recipe_list)
		if(S == R)
			return TRUE
		if(istype(S, /datum/stack_recipe_list))
			var/datum/stack_recipe_list/L = S
			if(is_valid_recipe(R, L.recipes))
				return TRUE
	return FALSE

/obj/item/stack/ui_state(mob/user)
	return GLOB.hands_state

/obj/item/stack/ui_interact(mob/user, datum/tgui/ui)
	ui = SStgui.try_update_ui(user, src, ui)
	if(!ui)
		ui = new(user, src, "Stack", name)
		ui.open()

/obj/item/stack/ui_data(mob/user)
	var/list/data = list()
	data["amount"] = get_amount()
	return data

/obj/item/stack/ui_static_data(mob/user)
	var/list/data = list()
	data["recipes"] = recursively_build_recipes(recipes)
	return data

/obj/item/stack/ui_act(action, params)
	. = ..()
	if(.)
		return

	switch(action)
		if("make")
			if(get_amount() < 1 && !is_cyborg)
				qdel(src)
				return
			var/datum/stack_recipe/R = locate(params["ref"])
			if(!is_valid_recipe(R, recipes)) //href exploit protection
				return
			var/multiplier = text2num(params["multiplier"])
			if(!multiplier || (multiplier <= 0)) //href exploit protection
				return
			if(!building_checks(R, multiplier))
				return
			if(R.time)
				var/adjusted_time = 0
				usr.visible_message("<span class='notice'>[usr] starts building \a [R.title].</span>", "<span class='notice'>You start building \a [R.title]...</span>")
				if(HAS_TRAIT(usr, R.trait_booster))
					adjusted_time = (R.time * R.trait_modifier)
				else
					adjusted_time = R.time
				if(!do_after(usr, adjusted_time, target = usr))
					return
				if(!building_checks(R, multiplier))
					return

			var/obj/O
			if(R.max_res_amount > 1) //Is it a stack?
				O = new R.result_type(usr.drop_location(), R.res_amount * multiplier)
			else if(ispath(R.result_type, /turf))
				var/turf/T = usr.drop_location()
				if(!isturf(T))
					return
				T.PlaceOnTop(R.result_type, flags = CHANGETURF_INHERIT_AIR)
			else
				O = new R.result_type(usr.drop_location())
			if(O)
				O.setDir(usr.dir)
			use(R.req_amount * multiplier)

			if(R.applies_mats && LAZYLEN(mats_per_unit))
				if(isstack(O))
					var/obj/item/stack/crafted_stack = O
					crafted_stack.set_mats_per_unit(mats_per_unit, R.req_amount / R.res_amount)
				else
					O.set_custom_materials(mats_per_unit, R.req_amount / R.res_amount)

			if(istype(O, /obj/structure/windoor_assembly))
				var/obj/structure/windoor_assembly/W = O
				W.ini_dir = W.dir
			else if(istype(O, /obj/structure/window))
				var/obj/structure/window/W = O
				W.ini_dir = W.dir

			if(QDELETED(O))
				return //It's a stack and has already been merged

			if(isitem(O))
				usr.put_in_hands(O)
			O.add_fingerprint(usr)

			//BubbleWrap - so newly formed boxes are empty
			if(istype(O, /obj/item/storage))
				for (var/obj/item/I in O)
					qdel(I)
			//BubbleWrap END
			return TRUE

/obj/item/stack/vv_edit_var(vname, vval)
	if(vname == NAMEOF(src, amount))
		add(clamp(vval, 1-amount, max_amount - amount)) //there must always be one.
		return TRUE
	else if(vname == NAMEOF(src, max_amount))
		max_amount = max(vval, 1)
		add((max_amount < amount) ? (max_amount - amount) : 0) //update icon, weight, ect
		return TRUE
	return ..()

/obj/item/stack/proc/building_checks(datum/stack_recipe/recipe, multiplier)
	if (get_amount() < recipe.req_amount*multiplier)
		if (recipe.req_amount*multiplier>1)
			to_chat(usr, "<span class='warning'>You haven't got enough [src] to build \the [recipe.req_amount*multiplier] [recipe.title]\s!</span>")
		else
			to_chat(usr, "<span class='warning'>You haven't got enough [src] to build \the [recipe.title]!</span>")
		return FALSE
	var/turf/dest_turf = get_turf(usr)

	// If we're making a window, we have some special snowflake window checks to do.
	if(ispath(recipe.result_type, /obj/structure/window))
		var/obj/structure/window/result_path = recipe.result_type
		if(!valid_window_location(dest_turf, usr.dir, is_fulltile = initial(result_path.fulltile)))
			to_chat(usr, "<span class='warning'>The [recipe.title] won't fit here!</span>")
			return FALSE

	if(recipe.one_per_turf && (locate(recipe.result_type) in dest_turf))
		to_chat(usr, "<span class='warning'>There is another [recipe.title] here!</span>")
		return FALSE

	if(recipe.on_floor)
		if(!isfloorturf(dest_turf))
			to_chat(usr, "<span class='warning'>\The [recipe.title] must be constructed on the floor!</span>")
			return FALSE

		for(var/obj/object in dest_turf)
			if(istype(object, /obj/structure/grille))
				continue
			if(istype(object, /obj/structure/table))
				continue
			if(istype(object, /obj/structure/window))
				var/obj/structure/window/window_structure = object
				if(!window_structure.fulltile)
					continue
			if(object.density)
				to_chat(usr, "<span class='warning'>There is \a [object.name] here. You cant make \a [recipe.title] here!</span>")
				return FALSE
	if(recipe.placement_checks)
		switch(recipe.placement_checks)
			if(STACK_CHECK_CARDINALS)
				var/turf/step
				for(var/direction in GLOB.cardinals)
					step = get_step(dest_turf, direction)
					if(locate(recipe.result_type) in step)
						to_chat(usr, "<span class='warning'>\The [recipe.title] must not be built directly adjacent to another!</span>")
						return FALSE
			if(STACK_CHECK_ADJACENT)
				if(locate(recipe.result_type) in range(1, dest_turf))
					to_chat(usr, "<span class='warning'>\The [recipe.title] must be constructed at least one tile away from others of its type!</span>")
					return FALSE
	return TRUE

/obj/item/stack/use(used, transfer = FALSE, check = TRUE) // return 0 = borked; return 1 = had enough
	if(check && zero_amount())
		return FALSE
	if (is_cyborg)
		. = source.use_charge(used * cost)
		update_icon()
		return
	if (amount < used)
		return FALSE
	amount -= used
	if(check && zero_amount())
		return TRUE
	if(length(mats_per_unit))
		update_custom_materials()
	update_icon()
	update_weight()
	return TRUE

/obj/item/stack/tool_use_check(mob/living/user, amount)
	if(get_amount() < amount)
		if(singular_name)
			if(amount > 1)
				to_chat(user, "<span class='warning'>You need at least [amount] [singular_name]\s to do this!</span>")
			else
				to_chat(user, "<span class='warning'>You need at least [amount] [singular_name] to do this!</span>")
		else
			to_chat(user, "<span class='warning'>You need at least [amount] to do this!</span>")

		return FALSE

	return TRUE

/obj/item/stack/proc/zero_amount()
	if(is_cyborg)
		return source.energy < cost
	if(amount < 1)
		qdel(src)
		return TRUE
	return FALSE

/** Adds some number of units to this stack.
 *
 * Arguments:
 * - _amount: The number of units to add to this stack.
 */
/obj/item/stack/proc/add(_amount)
	if (is_cyborg)
		source.add_charge(_amount * cost)
	else
		amount += _amount
	if(length(mats_per_unit))
		update_custom_materials()
	update_icon()
	update_weight()

/** Checks whether this stack can merge itself into another stack.
 *
 * Arguments:
 * - [check][/obj/item/stack]: The stack to check for mergeability.
 */
/obj/item/stack/proc/can_merge(obj/item/stack/check)
	if(!istype(check, merge_type))
		return FALSE
	if(!check.is_cyborg && (mats_per_unit != check.mats_per_unit)) // Cyborg stacks don't have materials. This lets them recycle sheets and floor tiles.
		return FALSE
	return TRUE

/obj/item/stack/proc/merge(obj/item/stack/S) //Merge src into S, as much as possible
	if(QDELETED(S) || QDELETED(src) || S == src) //amusingly this can cause a stack to consume itself, let's not allow that.
		return
	var/transfer = get_amount()
	if(S.is_cyborg)
		transfer = min(transfer, round((S.source.max_energy - S.source.energy) / S.cost))
	else
		transfer = min(transfer, S.max_amount - S.amount)
	if(pulledby)
		pulledby.start_pulling(S)
	S.copy_evidences(src)
	use(transfer, TRUE)
	S.add(transfer)
	return transfer

/obj/item/stack/Crossed(atom/movable/crossing)
	if(!crossing.throwing && can_merge(crossing))
		merge(crossing)
	. = ..()

/obj/item/stack/hitby(atom/movable/hitting, skipcatch, hitpush, blocked, datum/thrownthing/throwingdatum)
	if(can_merge(hitting))
		merge(hitting)
	. = ..()

//ATTACK HAND IGNORING PARENT RETURN VALUE
/obj/item/stack/on_attack_hand(mob/user)
	if(user.get_inactive_held_item() == src)
		if(zero_amount())
			return
		return split_stack(user, 1)
	else
		. = ..()

/obj/item/stack/AltClick(mob/living/user)
	. = ..()
	// if(isturf(loc)) // to prevent people that are alt clicking a tile to see its content from getting undesidered pop ups
	// 	return
	if(is_cyborg || !user.canUseTopic(src, BE_CLOSE, TRUE, FALSE) || zero_amount()) //, !iscyborg(user)
		return
	//get amount from user
	var/max = get_amount()
	var/list/quick_split
	for(var/option in list(2, 3, 4, 5, 6, 7, "One", "Five", "Ten", "Custom"))
		var/mutable_appearance/option_display = new(src)
		option_display.filters = null
		option_display.cut_overlays()
		option_display.pixel_x = 0
		option_display.pixel_y = 0

		switch(option)
			if("Custom")
				var/list/sort_numbers = quick_split
				sort_numbers = sort_list(sort_numbers, /proc/cmp_numeric_text_desc)
				option_display.maptext = MAPTEXT("?")
				quick_split = list("Custom" = option_display)
				quick_split += sort_numbers
			if("One")
				option = 1
				option_display.maptext = MAPTEXT("1")
			if("Five")
				if(max > 5)
					option = 5
					option_display.maptext = MAPTEXT("5")
				else
					continue
			if("Ten")
				if(max > 10)
					option = 10
					option_display.maptext = MAPTEXT("10")
				else
					continue
			else
				if(max % option == 0)
					option_display.maptext = MAPTEXT(max / option)
					option = max / option
				else
					continue
		if(option != "Custom")
			LAZYSET(quick_split, "[option]", option_display)
	var/stackmaterial
	if(length(quick_split) <= 2)
		stackmaterial = round(input(user, "How many sheets do you wish to take out of this stack?\nMax: [max]") as null|num)
	else
		stackmaterial = show_radial_menu(user, get_atom_on_turf(src), quick_split, require_near = TRUE, tooltips = TRUE)
		if(stackmaterial == "Custom")
			stackmaterial = round(input(user, "How many sheets do you wish to take out of this stack?\nMax: [max]") as null|num)
		stackmaterial = isnum(stackmaterial) ? stackmaterial : text2num(stackmaterial)
	stackmaterial = min(get_amount(), stackmaterial)
	if(stackmaterial == null || stackmaterial <= 0 || !user.canUseTopic(src, BE_CLOSE, TRUE, FALSE)) //, !iscyborg(user)
		return
	split_stack(user, stackmaterial)
	to_chat(user, "<span class='notice'>You take [stackmaterial] sheets out of the stack.</span>")

/** Splits the stack into two stacks.
 *
 * Arguments:
 * - [user][/mob]: The mob splitting the stack.
 * - amount: The number of units to split from this stack.
 */
/obj/item/stack/proc/split_stack(mob/user, amount)
	if(!use(amount, TRUE, FALSE))
		return null
	var/obj/item/stack/F = new type(user? user : drop_location(), amount, FALSE)
	. = F
	F.set_mats_per_unit(mats_per_unit, 1) // Required for greyscale sheets and tiles.
	F.copy_evidences(src)
	if(user)
		if(!user.put_in_hands(F, merge_stacks = FALSE))
			F.forceMove(user.drop_location())
		add_fingerprint(user)
		F.add_fingerprint(user)
	if(!zero_amount())
		var/atom/movable/screen/storage/item_holder/holder = locate(/atom/movable/screen/storage/item_holder) in vis_locs
		if(holder?.master && istype(holder.master, /datum/component/storage/concrete))
			var/datum/component/storage/concrete/storage = holder.master
			storage.refresh_mob_views()

/obj/item/stack/attackby(obj/item/W, mob/user, params)
	if(can_merge(W))
		var/obj/item/stack/S = W
		if(merge(S))
			to_chat(user, "<span class='notice'>Your [S.name] stack now contains [S.get_amount()] [S.singular_name]\s.</span>")
	else
		. = ..()

/obj/item/stack/proc/copy_evidences(obj/item/stack/from)
	if(from.blood_DNA)
		blood_DNA = from.blood_DNA.Copy()
	if(from.fingerprints)
		fingerprints = from.fingerprints.Copy()
	if(from.fingerprintshidden)
		fingerprintshidden = from.fingerprintshidden.Copy()
	fingerprintslast = from.fingerprintslast
	//TODO bloody overlay

/obj/item/stack/microwave_act(obj/machinery/microwave/M)
	if(istype(M) && M.dirty < 100)
		M.dirty += amount

/obj/item/stack/proc/prepare_estorage(obj/item/robot_module/module)
	if(source)
		source = module.get_or_create_estorage(source)

/obj/item/stack/Moved(old_loc, dir)
	. = ..()
	if(isturf(loc))
		update_icon()
