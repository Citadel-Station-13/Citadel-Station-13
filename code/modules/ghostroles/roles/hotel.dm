/datum/ghostrole/space_hotel
	instantiator = /datum/ghostrole_instantiator/human/random/space_hotel
	name = "Space Hotel Staff"
	desc = "You are a staff member of a top-of-the-line space hotel! Cater to guests and make sure the manager doesn't fire you."
	automatic_objective = "You are a staff member of a top-of-the-line space hotel! Cater to guests and make sure the manager doesn't fire you."
	assigned_role = "Hotel Staff"

/datum/ghostrole/space_hotel/security
	instantiator = /datum/ghostrole_instantiator/human/random/space_hotel/security
	name = "Space Hotel Security"
	desc = "You have been assigned to this hotel to protect the interests of the company while keeping the peace between \
		guests and the staff."
	automatic_objective = "Do not leave your assigned hotel. Try and keep the peace between staff and guests, non-lethal force heavily advised if possible."

/datum/ghostrole_instantiator/human/random/space_hotel
	equip_outfit = /datum/outfit/hotelstaff
	mob_traits = list(
		TRAIT_EXEMPT_HEALTH_EVENTS
	)

/datum/ghostrole_instantiator/human/random/space_hotel/security
	equip_outfit = /datum/outfit/hotelstaff/security

//Space Hotel Staff
/obj/structure/ghost_role_spawner/space_hotel //not free antag u little shits
	name = "staff sleeper"
	desc = "A sleeper designed for long-term stasis between guest visits."
	role_type = /datum/ghostrole/space_hotel
	icon = 'icons/obj/machines/sleeper.dmi'
	icon_state = "sleeper_s"

/obj/structure/ghost_role_spawner/space_hotel/Destroy()
	new/obj/structure/fluff/empty_sleeper/syndicate(get_turf(src))
	return ..()

/obj/structure/ghost_role_spawner/space_hotel/security
	name = "hotel security sleeper"
	role_type = /datum/ghostrole/space_hotel/security

/datum/outfit/hotelstaff
	name = "Hotel Staff"
	uniform = /obj/item/clothing/under/suit/telegram
	shoes = /obj/item/clothing/shoes/laceup
	head = /obj/item/clothing/head/hotel
	r_pocket = /obj/item/radio/off
	back = /obj/item/storage/backpack
	implants = list(/obj/item/implant/mindshield)

/datum/outfit/hotelstaff/security
	name = "Hotel Secuirty"
	uniform = /obj/item/clothing/under/rank/security/officer/blueshirt
	shoes = /obj/item/clothing/shoes/jackboots
	suit = /obj/item/clothing/suit/armor/vest/blueshirt
	head = /obj/item/clothing/head/helmet/blueshirt
	back = /obj/item/storage/backpack/security
	belt = /obj/item/storage/belt/security/full
