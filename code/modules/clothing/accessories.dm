/obj/item/clothing
	/// what kind of accessory this is - either FALSE or a single ACCESSORY_TYPE_XYZ.
	var/is_accessory = FALSE
	///
	/// flags of accessory types we're allowed to attach
	var/accessory_types = ACCESSORY_TYPE_DECAL
	/// decal accessories
	var/list/accessory_decals
	/// accessories
	var/list/accessories
