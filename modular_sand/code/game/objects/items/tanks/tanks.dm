/obj/item/tank
	/// Icon state when in a tank holder. Null makes it incompatible with tank holder.
	var/tank_holder_icon_state = "holder_generic"

/obj/item/tank/ComponentInitialize()
	. = ..()
	if(tank_holder_icon_state)
		AddComponent(/datum/component/container_item/tank_holder, tank_holder_icon_state)
