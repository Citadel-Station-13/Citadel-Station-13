/datum/outfit/vr
	name = "Basic VR"
	uniform = /obj/item/clothing/under/color/random
	shoes = /obj/item/clothing/shoes/sneakers/black
	ears = /obj/item/radio/headset
	id = /obj/item/card/id/locked_banking
	var/starting_funds = 350

/datum/outfit/vr/pre_equip(mob/living/carbon/human/H, visualsOnly = FALSE, client/preference_source)
	H.dna.species.before_equip_job(null, H)

/datum/outfit/vr/post_equip(mob/living/carbon/human/H, visualsOnly = FALSE, client/preference_source)
	var/obj/item/card/id/id = H.wear_id
	if(!istype(id))
		return
	id.access |= get_all_accesses()
	if(id.registered_account)
		id.registered_account.account_holder = "[H.real_name] (VR)"
		if(starting_funds && id.bank_support == ID_LOCKED_BANK_ACCOUNT) //No payroll or ability to virtually transfer funds to an external account.
			id.registered_account.adjust_money(starting_funds)

/datum/outfit/vr/syndicate
	name = "Syndicate VR Operative - Basic"
	uniform = /obj/item/clothing/under/syndicate
	shoes = /obj/item/clothing/shoes/combat
	gloves = /obj/item/clothing/gloves/tackler/combat/insulated
	back = /obj/item/storage/backpack
	id = /obj/item/card/id/syndicate/locked_banking
	belt = /obj/item/gun/ballistic/automatic/pistol
	l_pocket = /obj/item/paper/fluff/vr/fluke_ops
	backpack_contents = list(/obj/item/storage/box/syndie=1,\
		/obj/item/kitchen/knife/combat/survival)
	starting_funds = 0 //Should be operating, not shopping.

/datum/outfit/vr/syndicate/post_equip(mob/living/carbon/human/H, visualsOnly = FALSE, client/preference_source)
	. = ..()
	var/key = H.key ? H.key : preference_source ? preference_source.key : null
	var/obj/item/uplink/U = new /obj/item/uplink/nuclear_restricted(H, key, 80)
	H.equip_to_slot_or_del(U, SLOT_IN_BACKPACK)
	var/obj/item/implant/weapons_auth/W = new
	W.implant(H)
	var/obj/item/implant/explosive/E = new
	E.implant(H)
	H.faction |= ROLE_SYNDICATE
	H.update_icons()

/obj/item/paper/fluff/vr/fluke_ops
	name = "Where is my uplink?"
	info = "Use the radio in your backpack."