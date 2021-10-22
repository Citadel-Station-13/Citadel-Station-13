// /obj/item
/obj/item
	// Dimensions - used by all
	/// Dimension of worn icon files. Used for centering.
	var/worn_x_dimension = 32
	/// Dimension of worn icon files. Used for centering.
	var/worn_y_dimension = 32

	// Overrides - funny adminbus only, DO NOT USE THESE IN CODE. To enforce this, these are VAR_PRIVATE.
	/// Overrides worn state. Defaults to worn_state, then item_state if nonexistant
	VAR_PRIVATE/worn_state_override
	/// Overrides worn icon. If this is used, the above is automatically used.
	VAR_PRIVATE/icon/worn_icon_override

	// New rendering system - state determined by "[slot_state_id]_[bodytype]_[worn_state]"
	// Used if the above overrides are unset
	/// "I know what I'm doing, and if this breaks, you may replace my eyelids with chili peppers" - Disable all sanity checking in unit tests that enforces the below, because this item custom-builds its worn icons.
	var/worn_advanced_overlays = TRUE
	/// worn state - if none, reads item_state instead
	var/worn_state
	/// worn icon - one per item, or at most one per group of items.
	var/icon/worn_icon
	/// multi slots? if false, no slot append - you **MUST** have icon states for every slot_flag flag this has if set.
	var/worn_multi_slot = FALSE
	/// bodytypes supported
	var/worn_bodytypes = BODY_TYPE_NORMAL
	/// bodytypes support mode - you **MUST** have icon states for every bodytype if not normal or ignore
	var/worn_bodytype_support = BODYTYPE_SUPPORT_NONE
	/// mutantrace support - **only** active on BODY_TYPE_NORMAL - you **MUST** have icon states for every mutantrace flagged in this
	var/mutantrace_support = NONE

	/**
	 * Master format for state used on new rendering system:
	 *
	 * [worn_state]_[slot]_[bodytype_or_mutantrace]
	 * _[slot] is skipped if worn_multi_slot is FALSE
	 * _[bodytype_or_mutantrace] is skipped if not using a certain bodytype.
	 * Check __DEFINES/mobs/bodytypes.dm for appends
	 *
	 * examples:
	 * one-slot only mask = "mask"
	 * multi-slot mask/headgear = "bandana_mask", "bandana_head"
	 * one-slot gas mask with snout mutantrace = "mask_snout"
	 */


/**
 * Forces an update for ourselves. Use this when you change worn_state while it's being worn, or otherwise need it to update overlays.
 */
/obj/item/proc/update_worn_icon()

/**
 * New rendering system - get the state to use from worn_icon
 */
/obj/item/proc/effective_worn_state(slot, bodytype, mutantrace)
	ASSERT(!((bodytype == BODY_TYPE_NORMAL) && mutantrace))		// Mutually exclusive - do not allow both.
	return "[worn_state][worn_multi_slot? "_[slot]" : ""][(bodytype == BODY_TYPE_NORMAL)? (mutantrace? mutantrace_support_define_to_state_append(mutantrace): "") : body_type_define_to_state_append(bodytype)]"

/**
 * Builds worn icons - only should be called from inventory. INHANDS ARE NOT INVENTORY.
 *
 * Returns a list **always**. Inventory will strip the list out if it determines it isn't necessary.
 */
/obj/item/proc/build_worn_overlays(slotid_overide, bodytype_override, mutantrace_override)


// /datum/inventory
/**
 * Rebuilds all appearances
 */
/datum/inventory/proc/RebuildAllAppearances()

/**
 * Rebuilds a slot
 */
/datum/inventory/proc/RebuildSlotAppearance()
