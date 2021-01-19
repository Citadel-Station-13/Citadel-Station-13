/obj/item/stack/tile
	/// Cached associative lazy list to hold the radial options for tile reskinning. See tile_reskinning.dm for more information. Pattern: list[type] -> image
	var/list/tile_reskin_types

/obj/item/stack/tile/Initialize(mapload, amount)
	. = ..()
	if(tile_reskin_types)
		tile_reskin_types = tile_reskin_list(tile_reskin_types)
