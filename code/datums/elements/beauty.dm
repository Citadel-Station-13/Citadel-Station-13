/datum/element/beauty
	element_flags = ELEMENT_BESPOKE|ELEMENT_DETACH
	id_arg_index = 2
	var/beauty = 0

/datum/element/beauty/Attach(datum/target, beautyamount)
	. = ..()
	if(. == ELEMENT_INCOMPATIBLE || !isatom(target) || isarea(target))
		return ELEMENT_INCOMPATIBLE
	beauty = beautyamount

	if(ismovable(target))
		RegisterSignal(target, COMSIG_ENTER_AREA, PROC_REF(enter_area))
		RegisterSignal(target, COMSIG_EXIT_AREA, PROC_REF(exit_area))

	var/area/A = get_area(target)
	if(A)
		enter_area(null, A)

/datum/element/beauty/Detach(datum/target)
	UnregisterSignal(target, list(COMSIG_ENTER_AREA, COMSIG_EXIT_AREA))
	var/area/A = get_area(target)
	if(A)
		exit_area(null, A)
	return ..()

/datum/element/beauty/proc/enter_area(datum/source, area/A)
	if(A.outdoors)
		return
	A.totalbeauty += beauty
	A.update_beauty()

/datum/element/beauty/proc/exit_area(datum/source, area/A)
	if(A.outdoors)
		return
	A.totalbeauty -= beauty
	A.update_beauty()
