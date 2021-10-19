/datum/inventory/proc/ShowTo(mob/user)

/datum/inventory/proc/HideFrom(mob/user)

/atom/movable/screen/inventory
	name = "unknown slot"
	desc = ""
	/// slot we belong to
	var/datum/inventory_slot_meta/slot/master

/atom/movable/screen/inventory/Initialize(mapload, datum/inventory_slot_meta/slot, name, icon, icon_state, screen_loc)
	src.master = slot
	src.name = name
	src.icon = icon
	src.icon_state = icon_state
	src.screen_loc = screen_loc

/atom/movable/screen/inventory/examine(mob/user)
	. = ..()
	. += master.on_examine(user)
