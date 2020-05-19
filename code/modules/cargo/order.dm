/obj/item/paper/fluff/jobs/cargo/manifest
	var/order_cost = 0
	var/order_id = 0
	var/errors = 0

/obj/item/paper/fluff/jobs/cargo/manifest/New(atom/A, id, cost)
	..()
	order_id = id
	order_cost = cost

	if(prob(MANIFEST_ERROR_CHANCE))
		errors |= MANIFEST_ERROR_NAME
	if(prob(MANIFEST_ERROR_CHANCE))
		errors |= MANIFEST_ERROR_CONTENTS
	if(prob(MANIFEST_ERROR_CHANCE))
		errors |= MANIFEST_ERROR_ITEM

/obj/item/paper/fluff/jobs/cargo/manifest/proc/is_approved()
	return stamped && stamped.len && !is_denied()

/obj/item/paper/fluff/jobs/cargo/manifest/proc/is_denied()
	return stamped && ("stamp-deny" in stamped)

/datum/supply_order
	var/id
	var/orderer
	var/orderer_rank
	var/orderer_ckey
	var/reason
	var/datum/supply_pack/pack
	var/datum/bank_account/paying_account

/datum/supply_order/New(datum/supply_pack/pack, orderer, orderer_rank, orderer_ckey, reason, paying_account)
	id = SSshuttle.ordernum++
	src.pack = pack
	src.orderer = orderer
	src.orderer_rank = orderer_rank
	src.orderer_ckey = orderer_ckey
	src.reason = reason
	src.paying_account = paying_account

/datum/supply_order/proc/generateRequisition(turf/T)
	var/obj/item/paper/P = new(T)

	P.name = "requisition form - #[id] ([pack.name])"
	P.info += "<h2>[station_name()] Supply Requisition</h2>"
	P.info += "<hr/>"
	P.info += "Order #[id]<br/>"
	P.info += "Item: [pack.name]<br/>"
	P.info += "Access Restrictions: [get_access_desc(pack.access)]<br/>"
	P.info += "Requested by: [orderer]<br/>"
	if(paying_account)
		P.info += "Paid by: [paying_account.account_holder]<br/>"
	P.info += "Rank: [orderer_rank]<br/>"
	P.info += "Comment: [reason]<br/>"

	P.update_icon()
	return P

/datum/supply_order/proc/generateManifest(obj/structure/closet/crate/C)
	var/obj/item/paper/fluff/jobs/cargo/manifest/P = new(C, id, pack.cost)

	var/station_name = (P.errors & MANIFEST_ERROR_NAME) ? new_station_name() : station_name()

	P.name = "shipping manifest - #[id] ([pack.name])"
	P.info += "<h2>[command_name()] Shipping Manifest</h2>"
	P.info += "<hr/>"
	if(paying_account)
		P.info += "Direct purchase from [paying_account.account_holder]<br/>"
		P.name += " - Purchased by [paying_account.account_holder]"
	P.info += "Order #[id]<br/>"
	P.info += "Destination: [station_name]<br/>"
	P.info += "Item: [pack.name]<br/>"
	P.info += "Contents: <br/>"
	P.info += "<ul>"
	for(var/atom/movable/AM in C.contents - P - C.lockerelectronics)
		if((P.errors & MANIFEST_ERROR_CONTENTS) && prob(50))
			continue
		P.info += "<li>[AM.name]</li>"
	P.info += "</ul>"
	P.info += "<h4>Stamp below to confirm receipt of goods:</h4>"

	P.update_icon()
	P.forceMove(C)
	C.manifest = P
	C.update_icon()

	return P

/datum/supply_order/proc/generate(atom/A)
	var/obj/structure/closet/crate/C = pack.generate(A, paying_account)
	var/obj/item/paper/fluff/jobs/cargo/manifest/M = generateManifest(C)

	if(M.errors & MANIFEST_ERROR_ITEM)
		if(istype(C, /obj/structure/closet/crate/secure) || istype(C, /obj/structure/closet/crate/large))
			M.errors &= ~MANIFEST_ERROR_ITEM
		else
			var/lost = max(round(C.contents.len / 10), 1)
			while(--lost >= 0)
				qdel(pick(C.contents))
	return C

//Paperwork for NT
/obj/item/folder/paperwork
	name = "Incomplete Paperwork"
	desc = "These should've been filled out four months ago! Unfinished grant papers issued by Nanotrasen's finance department. Complete this page for additional funding."
	icon = 'icons/obj/bureaucracy.dmi'
	icon_state = "docs_generic"

/obj/item/folder/paperwork_correct
	name = "Finished Paperwork"
	desc = "A neat stack of filled-out forms, in triplicate and signed. Is there anything more satisfying? Make sure they get stamped."
	icon = 'icons/obj/bureaucracy.dmi'
	icon_state = "docs_verified"

//Trade paper work, we are a subtype of paperwork for a reason.
/obj/item/folder/permit
	name = "Blank permit"
	desc = "This isnt ment to be blank though..."
	icon = 'icons/obj/bureaucracy.dmi'
	icon_state = "docs_verified"
	var/examine_helper = TRUE

/obj/item/folder/permit/examine(mob/user)
	. = ..()
	if(examine_helper)
		. += "<span class='notice'>The paperwork needs to be <b>uploaded</b> to the cargo console to unlock more packets.</span>"

/obj/item/folder/permit/space_gear
	name = "VW-CWG of 23"
	desc = "Paper that verifies the buyer is able to handle hardsuits and other space gear that is restricted."
	examine_helper = TRUE

/obj/item/folder/permit/heavy_firearms
	name = "IHF-433 Section 13"
	desc = "Paper that verifies the Importation of Heavy Firearms into Section 13 of space."
	examine_helper = TRUE

/obj/item/folder/permit/medco_trade
	name = "NT-MedCo Trade Aggrement"
	desc = "Paper that reinstates NT import of MedCo latest products."
	examine_helper = TRUE

/obj/item/folder/permit/blackmarket
	name = "Space Queen Claims"
	desc = "Outdated space-claims on a trade route that is not well known and seems to have been misfiled. As outdated they are it might be still worth it to upload them to a cargo onsole."

/obj/item/folder/permit/animal_handing
	name = "Animal Handling License"
	desc = "License for importation and handling of exotic animals."
	examine_helper = TRUE

//Right, this one is for unlocking RnD based gear, such as node disks, or maybe items that decon into Rnd points.
//This should NOT hold any items other then blueprints ever.
/obj/item/folder/permit/adv_sci
	name = "NT Space Market Transportation Syncing"
	desc = "Paperwork that connects the station to a privet market of stations."
	examine_helper = TRUE