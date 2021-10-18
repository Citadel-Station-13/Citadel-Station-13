/obj/item/clothing
	/// what kind of accessory this is - either FALSE or a list of accessory types.
	var/is_accessory = FALSE
	/// flags of accessory types we're allowed to attach
	var/accessory_types = ACCESSORY_TYPE_DECAL
	/// decal accessories - up to a defined limit
	var/list/accessory_decals
	/// accessories - 1 each
	var/list/accessories
	/// accessory flags currently attached
	var/accessory_types_attached = NONE

/obj/item/clothing/proc/attach_accessory(obj/item/clothing/C)

/obj/item/clothing/proc/can_attach_accessory(obj/item/clothing/C)

/obj/item/clothing/proc/on_accessory_attach(obj/item/clothing/C)

/obj/item/clothing/proc/on_accessory_detach(obj/item/clothing/C)

/obj/item/clothing/proc/can_be_accessory_for(obj/item/clothing/C)

/obj/item/clothing/proc/detach_accessory(obj/item/clothing/C)

/obj/item/clothing/proc/recalculate_accessories()
