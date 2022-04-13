///Tool capable of taking biological samples from mobs
/obj/item/biopsy_tool
	name = "biopsy tool"
	desc = "Don't worry, it won't sting."
	icon = 'icons/obj/xenobiology/vatgrowing.dmi'
	icon_state = "biopsy"

///Adds the swabbing component to the biopsy tool
/obj/item/biopsy_tool/Initialize()
	. = ..()
	AddComponent(/datum/component/swabbing, FALSE, FALSE, TRUE, CALLBACK(src, .proc/update_swab_icon), max_items = 1)


/obj/item/biopsy_tool/proc/update_swab_icon(list/swabbed_items)
	if(LAZYLEN(swabbed_items))
		icon_state = "biopsy_full"
	else
		icon_state = "biopsy"

///Tool capable of taking biological samples from mobs
/obj/item/swab
	name = "swab"
	desc = "Some men use these for different reasons."
	icon = 'icons/obj/xenobiology/vatgrowing.dmi'
	icon_state = "swab"
	w_class = WEIGHT_CLASS_TINY

///Adds the swabbing component to the biopsy tool
/obj/item/swab/Initialize()
	. = ..()
	AddComponent(/datum/component/swabbing, TRUE, TRUE, FALSE, null, CALLBACK(src, .proc/update_swab_icon), max_items = 1)

/obj/item/swab/proc/update_swab_icon(overlays, var/list/swabbed_items)
	if(LAZYLEN(swabbed_items))
		var/datum/biological_sample/sample = LAZYACCESS(swabbed_items, 1) //Use the first one as our target
		var/mutable_appearance/swab_overlay = mutable_appearance(icon, "swab_[sample.sample_color]")
		swab_overlay.appearance_flags = RESET_COLOR
		overlays += swab_overlay
