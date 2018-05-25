/datum/outfit/vr
	name = "Basic VR"
	uniform = /obj/item/clothing/under/color/random
	shoes = /obj/item/clothing/shoes/sneakers/black
	ears = /obj/item/radio/headset
	id = /obj/item/card/id

/datum/outfit/vr/post_equip(mob/living/carbon/human/H)
	var/datum/job/captain/J = new/datum/job/captain
	var/obj/item/card/id/id = H.wear_id
	if (id)
		id.access = J.get_access()

/datum/outfit/vr/syndicate
	name = "Syndicate VR Operative - Basic"
	uniform = /obj/item/clothing/under/syndicate
	shoes = /obj/item/clothing/shoes/combat
	gloves = /obj/item/clothing/gloves/combat
	back = /obj/item/storage/backpack
	id = /obj/item/card/id/syndicate
	belt = /obj/item/gun/ballistic/automatic/pistol
	l_pocket = /obj/item/paper/fluff/vr/fluke_ops
	backpack_contents = list(/obj/item/storage/box/syndie=1,\
		/obj/item/kitchen/knife/combat/survival)

/datum/outfit/vr/syndicate/post_equip(mob/living/carbon/human/H)
	. = ..()
	var/obj/item/radio/uplink/U = new /obj/item/radio/uplink/nuclear_restricted(H, H.key, 80)
	H.equip_to_slot_or_del(U, SLOT_IN_BACKPACK)
	var/obj/item/implant/weapons_auth/W = new/obj/item/implant/weapons_auth(H)
	W.implant(H)
	var/obj/item/implant/explosive/E = new/obj/item/implant/explosive(H)
	E.implant(H)
	H.faction |= ROLE_SYNDICATE
	H.update_icons()

/obj/item/paper/fluff/vr/fluke_ops
	name = "Where is my uplink?"
	info = "Use the radio in your backpack."