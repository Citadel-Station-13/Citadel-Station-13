/**
 * Rendering
 */
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
	/// worn state - if none, reads item_state instead
	var/worn_state
	/// worn icon - one per item, or at most one per group of items.
	var/icon/worn_icon

/**
 * Forces an update for ourselves. Use this when you change worn_state while it's being worn, or otherwise need it to update overlays.
 */
/obj/item/proc/update_worn_icon()

/**
 * Builds worn icons - only should be called from inventory.
 *
 * Returns a list **always**. Inventory will strip the list out if it determines it isn't necessary.
 */

