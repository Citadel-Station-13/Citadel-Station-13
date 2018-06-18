/obj/item/clothing/glasses/phantomthief
	name = "suspicious paper mask"
	desc = "A cheap, Syndicate-branded paper face mask. They'll never see it coming."
	alternate_worn_icon = 'icons/mob/mask.dmi'
	icon = 'icons/obj/clothing/masks.dmi'
	icon_state = "s-ninja"
	item_state = "s-ninja"

/obj/item/clothing/glasses/phantomthief/Initialize()
	. = ..()
	AddComponent(/datum/component/phantomthief)
