/obj/item/extinguisher
	/// Icon state when inside a tank holder
	var/tank_holder_icon_state = "holder_extinguisher"

/obj/item/extinguisher/ComponentInitialize()
	. = ..()
	if(tank_holder_icon_state)
		AddComponent(/datum/component/container_item/tank_holder, tank_holder_icon_state)

/obj/item/extinguisher/advanced
	tank_holder_icon_state = "holder_foam_extinguisher"
