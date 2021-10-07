/**
 * Rig styles
 *
 * Determines the sealed and unsealed appearances of pieces.
 */
/datum/rig_style
	/// Name
	var/name = "Unfinished"
	/// Item name to prepend if any.
	var/name_prepend = "unfinished"

	///
	/// Icon state default
	var/base_state = "rig"
	/// Icon state sealed (append)
	var/state_append_sealed = "-sealed"
	/// overlay for lighting (append on add_overlay(state))
	var/state_apepnd_
