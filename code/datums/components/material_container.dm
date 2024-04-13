/*!
	This datum should be used for handling mineral contents of machines and whatever else is supposed to hold minerals and make use of them.

	Variables:
		amount - raw amount of the mineral this container is holding, calculated by the defined value MINERAL_MATERIAL_AMOUNT=2000.
		max_amount - max raw amount of mineral this container can hold.
		sheet_type - type of the mineral sheet the container handles, used for output.
		parent - object that this container is being used by, used for output.
		MAX_STACK_SIZE - size of a stack of mineral sheets. Constant.
*/

/datum/component/material_container
	/// The total amount of materials this material container contains
	var/total_amount = 0
	/// The maximum amount of materials this material container can contain
	var/max_amount
	/// Map of material ref -> amount
	var/list/materials //Map of key = material ref | Value = amount
	/// The list of materials that this material container can accept
	var/list/allowed_materials
	var/show_on_examine
	var/disable_attackby
	var/list/allowed_typecache
	/// The last main material that was inserted into this container
	var/last_inserted_id
	/// Whether or not this material container allows specific amounts from sheets to be inserted
	var/precise_insertion = FALSE
	/// A callback invoked before materials are inserted into this container
	var/datum/callback/precondition
	/// A callback invoked after materials are inserted into this container
	var/datum/callback/after_insert

/// Sets up the proper signals and fills the list of materials with the appropriate references.
/datum/component/material_container/Initialize(list/mat_list, max_amt = 0, _show_on_examine = FALSE, list/allowed_types, datum/callback/_precondition, datum/callback/_after_insert, _disable_attackby)
	if(!isatom(parent))
		return COMPONENT_INCOMPATIBLE

	materials = list()
	max_amount = max(0, max_amt)
	show_on_examine = _show_on_examine
	disable_attackby = _disable_attackby

	allowed_materials = mat_list || list()
	if(allowed_types)
		if(ispath(allowed_types) && allowed_types == /obj/item/stack)
			allowed_typecache = GLOB.typecache_stack
		else
			allowed_typecache = typecacheof(allowed_types)

	precondition = _precondition
	after_insert = _after_insert

	RegisterSignal(parent, COMSIG_PARENT_ATTACKBY, PROC_REF(on_attackby))
	RegisterSignal(parent, COMSIG_PARENT_EXAMINE, PROC_REF(on_examine))

	for(var/mat in mat_list) //Make the assoc list material reference -> amount
		var/mat_ref = SSmaterials.GetMaterialRef(mat)
		if(isnull(mat_ref))
			continue
		var/mat_amt = mat_list[mat]
		if(isnull(mat_amt))
			mat_amt = 0
		materials[mat_ref] += mat_amt

/datum/component/material_container/Destroy(force, silent)
	materials = null
	allowed_typecache = null
	// if(insertion_check)
	// 	QDEL_NULL(insertion_check)
	if(precondition)
		QDEL_NULL(precondition)
	if(after_insert)
		QDEL_NULL(after_insert)
	return ..()

/datum/component/material_container/proc/on_examine(datum/source, mob/user, list/examine_list)
	SIGNAL_HANDLER

	if(show_on_examine)
		for(var/I in materials)
			var/datum/material/M = I
			var/amt = materials[I]
			if(amt)
				examine_list += "<span class='notice'>It has [amt] units of [lowertext(M.name)] stored.</span>"

/// Proc that allows players to fill the parent with mats
/datum/component/material_container/proc/on_attackby(datum/source, obj/item/I, mob/living/user)
	SIGNAL_HANDLER

	var/list/tc = allowed_typecache
	if(disable_attackby)
		return
	if(user.a_intent != INTENT_HELP)
		return
	if(I.item_flags & ABSTRACT)
		return
	if((I.flags_1 & HOLOGRAM_1) || (I.item_flags & NO_MAT_REDEMPTION) || (tc && !is_type_in_typecache(I, tc)))
		// if(!(mat_container_flags & MATCONTAINER_SILENT))
		to_chat(user, "<span class='warning'>[parent] won't accept [I]!</span>")
		return
	. = COMPONENT_NO_AFTERATTACK
	var/datum/callback/pc = precondition
	if(pc && !pc.Invoke(user))
		return
	var/material_amount = get_item_material_amount(I) //, mat_container_flags)
	if(!material_amount)
		to_chat(user, "<span class='warning'>[I] does not contain sufficient materials to be accepted by [parent].</span>")
		return
	if((!precise_insertion || !GLOB.typecache_stack[I.type]) && !has_space(material_amount))
		to_chat(user, "<span class='warning'>[parent] is full. Please remove materials from [parent] in order to insert more.</span>")
		return
	user_insert(I, user) //, mat_container_flags)

/// Proc used for when player inserts materials
/datum/component/material_container/proc/user_insert(obj/item/I, mob/living/user, datum/component/remote_materials/remote = null)
	set waitfor = FALSE
	var/active_held = user.get_active_held_item()  // differs from I when using TK
	var/inserted = 0

	//handle stacks specially
	if(istype(I, /obj/item/stack))
		var/atom/current_parent = remote ? remote.parent : parent //is the user using a remote materials component?
		var/obj/item/stack/S = I

		//try to get ammount to use
		var/requested_amount
		if(precise_insertion)
			requested_amount = input(user, "How much do you want to insert?", "Inserting [S.singular_name]s") as num|null
		else
			requested_amount= S.amount

		if(isnull(requested_amount) || (requested_amount <= 0))
			return
		if(QDELETED(I) || QDELETED(user) || QDELETED(src) || user.get_active_held_item() != active_held)
			return
		//are we still in range after the user input?
		if((remote ? remote.parent : parent) != current_parent || user.physical_can_use_topic(current_parent) < UI_INTERACTIVE)
			return
		inserted = insert_stack(S, requested_amount)
	else
		if(!user.temporarilyRemoveItemFromInventory(I))
			to_chat(user, "<span class='warning'>[I] is stuck to you and cannot be placed into [parent].</span>")
			return
		inserted = insert_item(I)
		qdel(I)

	if(inserted)
		to_chat(user, "<span class='notice'>You insert a material total of [inserted] into [parent].</span>")
		if(after_insert)
			after_insert.Invoke(I, last_inserted_id, inserted)
		if(remote && remote.after_insert)
			remote.after_insert.Invoke(I, last_inserted_id, inserted)

//Inserts a number of sheets from a stack, returns the amount of sheets used.
/datum/component/material_container/proc/insert_stack(obj/item/stack/S, amt, multiplier = 1)
	if(isnull(amt))
		amt = S.amount

	if(amt <= 0)
		return FALSE

	if(amt > S.amount)
		amt = S.amount

	var/material_amt = get_item_material_amount(S)
	if(!material_amt)
		return FALSE

	//get max number of sheets we have room to add
	var/mat_per_sheet = material_amt/S.amount
	amt = min(amt, round((max_amount - total_amount) / (mat_per_sheet)))
	if(!amt)
		return FALSE

	//add the mats and keep track of how much was added
	var/starting_total = total_amount
	for(var/MAT in materials)
		materials[MAT] += S.mats_per_unit[MAT] * amt * multiplier
		total_amount += S.mats_per_unit[MAT] * amt * multiplier
	var/total_added = total_amount - starting_total

	//update last_inserted_id with mat making up majority of the stack
	var/primary_mat
	var/max_mat_value = 0
	for(var/MAT in materials)
		if(S.mats_per_unit[MAT] > max_mat_value)
			max_mat_value = S.mats_per_unit[MAT]
			primary_mat = MAT
	last_inserted_id = primary_mat

	S.use(amt)
	return total_added

/// Proc specifically for inserting items, returns the amount of materials entered.
/datum/component/material_container/proc/insert_item(obj/item/I, var/multiplier = 1)
	if(QDELETED(I))
		return FALSE

	multiplier = CEILING(multiplier, 0.01)

	var/material_amount = get_item_material_amount(I)
	if(!material_amount || !has_space(material_amount))
		return FALSE

	last_inserted_id = insert_item_materials(I, multiplier)
	return material_amount

/**
 * Inserts the relevant materials from an item into this material container.
 *
 * Arguments:
 * - [source][/obj/item]: The source of the materials we are inserting.
 * - multiplier: The multiplier for the materials being inserted.
 * - breakdown_flags: The breakdown bitflags that will be used to retrieve the materials from the source
 */
/datum/component/material_container/proc/insert_item_materials(obj/item/I, multiplier = 1)
	var/primary_mat
	var/max_mat_value = 0
	var/list/item_materials = I.custom_materials
	for(var/MAT in item_materials)
		if(!can_hold_material(MAT))
			continue
		materials[MAT] += item_materials[MAT] * multiplier
		total_amount += item_materials[MAT] * multiplier
		if(item_materials[MAT] > max_mat_value)
			max_mat_value = item_materials[MAT]
			primary_mat = MAT

	return primary_mat

/**
 * The default check for whether we can add materials to this material container.
 *
 * Arguments:
 * - [mat][/atom/material]: The material we are checking for insertability.
 */
/datum/component/material_container/proc/can_hold_material(datum/material/mat)
	if(mat in allowed_typecache)
		return TRUE
	if(istype(mat) && ((mat.id in allowed_typecache) || (mat.type in allowed_materials)))
		allowed_materials += mat // This could get messy with passing lists by ref... but if you're doing that the list expansion is probably being taken care of elsewhere anyway...
		return TRUE
	// if(insertion_check?.Invoke(mat))
	// 	allowed_materials += mat
	// 	return TRUE
	return FALSE

/// For inserting an amount of material
/datum/component/material_container/proc/insert_amount_mat(amt, var/datum/material/mat)
	if(!istype(mat))
		mat = SSmaterials.GetMaterialRef(mat)
	if(amt > 0 && has_space(amt))
		var/total_amount_saved = total_amount
		if(mat)
			materials[mat] += amt
			total_amount += amt
		else
			for(var/i in materials)
				materials[i] += amt
				total_amount += amt
		return (total_amount - total_amount_saved)
	return FALSE

/// Uses an amount of a specific material, effectively removing it.
/datum/component/material_container/proc/use_amount_mat(amt, var/datum/material/mat)
	if(!istype(mat))
		mat = SSmaterials.GetMaterialRef(mat)
	var/amount = materials[mat]
	if(mat)
		if(amount >= amt)
			materials[mat] -= amt
			total_amount -= amt
			return amt
	return FALSE

/// Proc for transfering materials to another container.
/datum/component/material_container/proc/transer_amt_to(var/datum/component/material_container/T, amt, var/datum/material/mat)
	if(!istype(mat))
		mat = SSmaterials.GetMaterialRef(mat)
	if((amt==0)||(!T)||(!mat))
		return FALSE
	if(amt<0)
		return T.transer_amt_to(src, -amt, mat)
	var/tr = min(amt, materials[mat],T.can_insert_amount_mat(amt, mat))
	if(tr)
		use_amount_mat(tr, mat)
		T.insert_amount_mat(tr, mat)
		return tr
	return FALSE

/// Proc for checking if there is room in the component, returning the amount or else the amount lacking.
/datum/component/material_container/proc/can_insert_amount_mat(amt, mat)
	if(amt && mat)
		var/datum/material/M = mat
		if(M)
			if((total_amount + amt) <= max_amount)
				return amt
			else
				return	(max_amount-total_amount)


/// For consuming a dictionary of materials. mats is the map of materials to use and the corresponding amounts, example: list(M/datum/material/glass =100, datum/material/iron=200)
/datum/component/material_container/proc/use_materials(list/mats, multiplier=1)
	if(!mats || !length(mats))
		return FALSE

	var/list/mats_to_remove = list() //Assoc list MAT | AMOUNT

	for(var/x in mats) //Loop through all required materials
		var/datum/material/req_mat = x
		if(!istype(req_mat))
			req_mat = SSmaterials.GetMaterialRef(req_mat) //Get the ref if necesary
		if(!materials[req_mat]) //Do we have the resource?
			return FALSE //Can't afford it
		var/amount_required = mats[x] * multiplier
		if(!(materials[req_mat] >= amount_required)) // do we have enough of the resource?
			return FALSE //Can't afford it
		mats_to_remove[req_mat] += amount_required //Add it to the assoc list of things to remove
		continue

	var/total_amount_save = total_amount

	for(var/i in mats_to_remove)
		total_amount_save -= use_amount_mat(mats_to_remove[i], i)

	return total_amount_save - total_amount

/// For spawning mineral sheets at a specific location. Used by machines to output sheets.
/datum/component/material_container/proc/retrieve_sheets(sheet_amt, var/datum/material/M, target = null)
	if(!M.sheet_type)
		return FALSE //Add greyscale sheet handling here later
	if(sheet_amt <= 0)
		return FALSE

	if(!target)
		target = get_turf(parent)
	if(materials[M] < (sheet_amt * MINERAL_MATERIAL_AMOUNT))
		sheet_amt = round(materials[M] / MINERAL_MATERIAL_AMOUNT)
	var/count = 0
	while(sheet_amt > MAX_STACK_SIZE)
		new M.sheet_type(target, MAX_STACK_SIZE)
		count += MAX_STACK_SIZE
		use_amount_mat(sheet_amt * MINERAL_MATERIAL_AMOUNT, M)
		sheet_amt -= MAX_STACK_SIZE
	if(sheet_amt >= 1)
		new M.sheet_type(target, sheet_amt)
		count += sheet_amt
		use_amount_mat(sheet_amt * MINERAL_MATERIAL_AMOUNT, M)
	return count


/// Proc to get all the materials and dump them as sheets
/datum/component/material_container/proc/retrieve_all(target = null)
	var/result = 0
	for(var/MAT in materials)
		var/amount = materials[MAT]
		result += retrieve_sheets(amount2sheet(amount), MAT, target)
	return result

/// Proc that returns TRUE if the container has space
/datum/component/material_container/proc/has_space(amt = 0)
	return (total_amount + amt) <= max_amount

/// Checks if its possible to afford a certain amount of materials. Takes a dictionary of materials.
/datum/component/material_container/proc/has_materials(list/mats, multiplier=1)
	if(!mats || !mats.len)
		return FALSE

	for(var/x in mats) //Loop through all required materials
		var/datum/material/req_mat = x
		if(!istype(req_mat))
			if(ispath(req_mat)) //Is this an actual material, or is it a category?
				req_mat = SSmaterials.GetMaterialRef(req_mat) //Get the ref

			else // Its a category. (For example MAT_CATEGORY_RIGID)
				if(!has_enough_of_category(req_mat, mats[req_mat], multiplier)) //Do we have enough of this category?
					return FALSE
				else
					continue

		if(!has_enough_of_material(req_mat, mats[req_mat], multiplier))//Not a category, so just check the normal way
			return FALSE

	return TRUE

/// Returns all the categories in a recipe.
/datum/component/material_container/proc/get_categories(list/mats)
	var/list/categories = list()
	for(var/x in mats) //Loop through all required materials
		if(!istext(x)) //This means its not a category
			continue
		categories += x
	return categories


/// Returns TRUE if you have enough of the specified material.
/datum/component/material_container/proc/has_enough_of_material(var/datum/material/req_mat, amount, multiplier=1)
	if(!materials[req_mat]) //Do we have the resource?
		return FALSE //Can't afford it
	var/amount_required = amount * multiplier
	if(materials[req_mat] >= amount_required) // do we have enough of the resource?
		return TRUE
	return FALSE //Can't afford it

/// Returns TRUE if you have enough of a specified material category (Which could be multiple materials)
/datum/component/material_container/proc/has_enough_of_category(category, amount, multiplier=1)
	for(var/i in SSmaterials.materials_by_category[category])
		var/datum/material/mat = i
		if(materials[mat] >= amount) //we have enough
			return TRUE
	return FALSE

/// Turns a material amount into the amount of sheets it should output
/datum/component/material_container/proc/amount2sheet(amt)
	if(amt >= MINERAL_MATERIAL_AMOUNT)
		return round(amt / MINERAL_MATERIAL_AMOUNT)
	return FALSE

/// Turns an amount of sheets into the amount of material amount it should output
/datum/component/material_container/proc/sheet2amount(sheet_amt)
	if(sheet_amt > 0)
		return sheet_amt * MINERAL_MATERIAL_AMOUNT
	return FALSE


///returns the amount of material relevant to this container; if this container does not support glass, any glass in 'I' will not be taken into account
/datum/component/material_container/proc/get_item_material_amount(obj/item/I)
	if(!istype(I) || !I.custom_materials)
		return FALSE
	var/material_amount = 0
	for(var/MAT in materials)
		material_amount += I.custom_materials[MAT]
	return material_amount

/// Returns the amount of a specific material in this container.
/datum/component/material_container/proc/get_material_amount(var/datum/material/mat)
	if(!istype(mat))
		mat = SSmaterials.GetMaterialRef(mat)
	return(materials[mat])
