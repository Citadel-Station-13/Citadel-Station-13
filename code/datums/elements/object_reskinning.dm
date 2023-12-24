/*
 * # Element: Object Reskinning
 *
 * Allows players to modify the appearance of their object (and other attributes if possible)
 * PLEASE DO NOT HAVE INVALID VALUES IN unique_reskin I DON'T EVEN WANT TO KNOW WHAT HAPPENS.
 * USAGE:
 * unique_reskins = list(
 * 	"skin 1" = list(
 * 		"desc" = "very cool description",
 * 		"icon" = 'very_cool_icon.dmi'
 *		),
 * 	"skin 2" = list(
 *		"desc" = "not as cool description",
 *		"icon" = 'the_boring_skin.dmi'
 * 		)
 * )
*/
/datum/element/object_reskinning
	element_flags = ELEMENT_DETACH

/datum/element/object_reskinning/Attach(obj/target)
	. = ..()
	if(!istype(target))
		return ELEMENT_INCOMPATIBLE
	if(!islist(target.unique_reskin) || !length(target.unique_reskin))
		message_admins("[src] was given to an object without any unique reskins, if you really need to, give it a couple skins first.")
		return ELEMENT_INCOMPATIBLE

	RegisterSignal(target, COMSIG_PARENT_EXAMINE, .proc/on_examine)
	RegisterSignal(target, target.reskin_binding, .proc/reskin)
	RegisterSignal(target, COMSIG_ATOM_REQUESTING_CONTEXT_FROM_ITEM, .proc/on_requesting_context_from_item)

/datum/element/object_reskinning/Detach(obj/source, force)
	UnregisterSignal(source, list(COMSIG_PARENT_EXAMINE, source.reskin_binding, COMSIG_ATOM_REQUESTING_CONTEXT_FROM_ITEM))
	return ..()

/datum/element/object_reskinning/proc/on_examine(obj/obj, mob/user, list/examine_list)
	examine_list += span_notice("[capitalize(replacetext(obj.reskin_binding, "_", "-"))] to reskin it ([length(obj.unique_reskin)] possible styles).")
	if(obj.always_reskinnable)
		examine_list += span_notice("It has no limit to reskinning.")

/*
 * Reskins an object according to user's choice.
 * Will detach itself if there's no skins or if done successfully but not always reskinnable.
 *
 * Arguments:
 * * to_reskin The object we will be reskinning
 * * user The user who wants to choose a skin for the object
*/
/datum/element/object_reskinning/proc/reskin(obj/to_reskin, mob/user)
	// Just stop early
	if(!LAZYLEN(to_reskin.unique_reskin))
		message_admins("[ADMIN_LOOKUPFLW(user)] attempted to reskin an object that has no skins!")
		Detach(to_reskin)
		return FALSE

	// Can't use
	if(!user.canUseTopic(to_reskin, BE_CLOSE, NO_DEXTERY, NO_TK))
		return FALSE

	// Get our choices
	var/list/items = list()
	for(var/reskin_option in to_reskin.unique_reskin)
		var/image/item_image = image(
			icon = to_reskin.unique_reskin[reskin_option]["icon"] ? to_reskin.unique_reskin[reskin_option]["icon"] : to_reskin.icon,
			icon_state = to_reskin.unique_reskin[reskin_option]["icon_state"] ? to_reskin.unique_reskin[reskin_option]["icon_state"] : to_reskin.icon_state)
		items += list("[reskin_option]" = item_image)
	sort_list(items)

	// Display to the user
	var/pick = show_radial_menu(user, to_reskin, items, custom_check = CALLBACK(src, .proc/check_reskin_menu, user, to_reskin), radius = 38, require_near = TRUE)
	if(!pick)
		return FALSE

	// Finish the work
	to_reskin.current_skin = pick
	for(var/reskin_var in to_reskin.unique_reskin[pick])
		to_reskin.vars[reskin_var] = to_reskin.unique_reskin[pick][reskin_var]
	to_chat(user, "[to_reskin] is now skinned as '[pick].'")
	to_reskin.reskin_obj(user)

	// Only once or always?
	if(!to_reskin.always_reskinnable)
		Detach(to_reskin)
	return TRUE

/**
  * Checks if we are allowed to interact with a radial menu for reskins
  *
  * Arguments:
  * * user The mob interacting with the menu
  * * obj The obj to be checking against
  */
/datum/element/object_reskinning/proc/check_reskin_menu(mob/user, obj/obj)
	if(QDELETED(obj))
		return FALSE
	if(!obj.always_reskinnable && obj.current_skin)
		return FALSE
	if(!istype(user))
		return FALSE
	if(user.incapacitated())
		return FALSE
	return TRUE

/datum/element/object_reskinning/proc/on_requesting_context_from_item(
	obj/source,
	list/context,
	obj/item/held_item,
	mob/living/user,
)
	SIGNAL_HANDLER

	switch(source.reskin_binding)
		if(COMSIG_CLICK_CTRL_SHIFT)
			LAZYSET(context[SCREENTIP_CONTEXT_CTRL_SHIFT_LMB], INTENT_ANY, "Reskin PDA")
		else
			LAZYSET(context[SCREENTIP_CONTEXT_ALT_LMB], INTENT_ANY, "Reskin [source]")
	return CONTEXTUAL_SCREENTIP_SET
