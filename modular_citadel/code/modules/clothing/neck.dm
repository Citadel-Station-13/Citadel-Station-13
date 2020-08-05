/datum/action/item_action/zanderlocket
	name = "Activate the locket"

/obj/item/clothing/neck/undertale
	name = "Sylphaen Heart Locket"
	desc = "A heart shaped locket...The name: 'Zander Sylphaen is inscribed on the front. Something about this necklace fills you with determination."
	icon = 'modular_citadel/icons/obj/clothing/cit_neck.dmi'
	item_state = "undertale"
	icon_state = "undertale"
	mob_overlay_icon = 'modular_citadel/icons/mob/clothing/necks.dmi'
	resistance_flags = FIRE_PROOF
	actions_types = list(/datum/action/item_action/zanderlocket)
	var/toggled = FALSE
	var/obj/effect/heart/heart

/datum/action/item_action/zanderlocket/Trigger()
	new/obj/effect/temp_visual/souldeath(owner.loc, owner)
	playsound(owner, 'sound/misc/souldeath.ogg', 100, FALSE)


/obj/item/clothing/neck/undertale/Initialize()
	..()
	AddComponent(/datum/component/souldeath/neck)
