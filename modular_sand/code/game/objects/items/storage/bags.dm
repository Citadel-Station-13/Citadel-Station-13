/obj/item/storage/bag/bio/ComponentInitialize()
	. = ..()
	var/datum/component/storage/STR = GetComponent(/datum/component/storage)
	STR.can_hold_extra = typecacheof(list(/obj/item/reagent_containers/dropper, /obj/item/slimecross/stabilized))
