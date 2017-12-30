/atom/movable/lighting_object
	var/mutable_appearance/additivelightsprite = mutable_appearance(LIGHTING_ICON,"dark",ADDITIVE_LIGHTING_LAYER)

/atom/movable/lighting_object/Initialize(mapload)
	. = ..()
	if(additivelightsprite)
		additivelightsprite.plane = ADDITIVE_LIGHTING_PLANE
