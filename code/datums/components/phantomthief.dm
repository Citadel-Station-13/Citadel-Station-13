//This component applies a customizable drop_shadow filter to its wearer when they toggle combat mode on or off. This can stack.

/datum/component/wearertargeting/phantomthief
	dupe_mode = COMPONENT_DUPE_UNIQUE_PASSARGS
	signals = list(COMSIG_COMBAT_TOGGLED)
	proctype = .proc/handlefilterstuff
	var/filter_x
	var/filter_y
	var/filter_size
	var/filter_border
	var/filter_color

/datum/component/wearertargeting/phantomthief/Initialize(_x = -2, _y = 0, _size = 0, _border = 0, _color = "#E62111", list/_valid_slots = list(SLOT_GLASSES))
	. = ..()
	if(. == COMPONENT_INCOMPATIBLE)
		return
	filter_x = _x
	filter_y = _y
	filter_size = _size
	filter_border = _border
	filter_color = _color
	valid_slots = _valid_slots

/datum/component/wearertargeting/phantomthief/proc/handlefilterstuff(datum/source, mob/user, combatmodestate)
	if(istype(user))
		var/thefilter = filter(type = "drop_shadow", x = filter_x, y = filter_y, size = filter_size, border = filter_border, color = filter_color)
		if(!combatmodestate)
			user.filters -= thefilter
		else
			user.filters += thefilter

/datum/component/wearertargeting/phantomthief/proc/stripdesiredfilter(mob/user)
	if(istype(user))
		var/thefilter = filter(type = "drop_shadow", x = filter_x, y = filter_y, size = filter_size, border = filter_border, color = filter_color)
		user.filters -= thefilter

/datum/component/wearertargeting/phantomthief/on_drop(datum/source, mob/user)
	. = ..()
	stripdesiredfilter(user)
