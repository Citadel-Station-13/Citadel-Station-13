/datum/sprite_accessory/quills
	icon = 'icons/mob/mutant_bodyparts.dmi'
	relevant_layers = list(HORNS_LAYER)

/datum/sprite_accessory/quills/is_not_visible(var/mob/living/carbon/human/H, var/tauric)
	var/obj/item/bodypart/head/HD = H.get_bodypart(BODY_ZONE_HEAD)
	return (!H.dna.features["quills"] || H.dna.features["quills"] == "None" || H.head && (H.head.flags_inv & HIDEHAIR) || (H.wear_mask && (H.wear_mask.flags_inv & HIDEHAIR)) || !HD || HD.status == BODYPART_ROBOTIC)

/datum/sprite_accessory/quills/none
	name = "None"
	icon_state = "none"
	relevant_layers = null

/datum/sprite_accessory/quills/kingly
	name = "Kingly"
	icon_state = "kingly"

/datum/sprite_accessory/quills/afro
	name = "Afro"
	icon_state = "afro"

/datum/sprite_accessory/quills/mowhawk
	name = "Voxhawk"
	icon_state = "mowhawk"

/datum/sprite_accessory/quills/yasu
	name = "Yasu"
	icon_state = "Yasu"

/datum/sprite_accessory/quills/horns
	name = "Horns"
	icon_state = "horns"

/datum/sprite_accessory/quills/knight
	name = "Knight"
	icon_state = "knight"

/datum/sprite_accessory/quills/surfer
	name = "Surfer"
	icon_state = "surfer"

/datum/sprite_accessory/quills/cropped
	name = "Cropped"
	icon_state = "cropped"

/datum/sprite_accessory/quills/beard
	name = "beard"
	icon_state = "beard"

/datum/sprite_accessory/quills/beardhawk
	name = "Beardhawk"
	icon_state = "beardhawk"

/datum/sprite_accessory/quills/rows
	name = "Rows"
	icon_state = "rows"

/datum/sprite_accessory/quills/ponytail
	name = "Ponytail"
	icon_state = "ponytail"

/datum/sprite_accessory/quills/mangy
	name = "Mangy"
	icon_state = "mangy"

/datum/sprite_accessory/quills/colonel
	name = "Colonel"
	icon_state = "colonel"

/datum/sprite_accessory/quills/fu
	name = "Fu"
	icon_state = "fu"

/datum/sprite_accessory/quills/neck
	name = "Neckbeard"
	icon_state = "neck"

/datum/sprite_accessory/quills/mustache
	name = "Voxstache"
	icon_state = "mustache"
