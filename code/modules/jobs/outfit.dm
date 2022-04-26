/datum/outfit/job
	name = "Standard Gear"

	var/jobtype = null

	uniform = /obj/item/clothing/under/color/grey
	id = /obj/item/card/id
	ears = /obj/item/radio/headset
	belt = /obj/item/pda
	back = /obj/item/storage/backpack
	shoes = /obj/item/clothing/shoes/sneakers/black
	box = /obj/item/storage/box/survival

	var/backpack = /obj/item/storage/backpack
	var/satchel  = /obj/item/storage/backpack/satchel
	var/duffelbag = /obj/item/storage/backpack/duffelbag

	var/pda_slot = ITEM_SLOT_BACK

/datum/outfit/job/pre_equip(mob/living/carbon/human/H, visualsOnly = FALSE, datum/preferences/preference_source)
	var/preference_backpack = preference_source?.backbag

	if(preference_backpack)
		switch(preference_backpack)
			if(DBACKPACK)
				back = backpack //Department backpack
			if(DSATCHEL)
				back = satchel //Department satchel
			if(DDUFFELBAG)
				back = duffelbag //Department duffel bag
			else
				var/find_preference_backpack = GLOB.backbaglist[preference_backpack] //attempt to find non-department backpack
				if(find_preference_backpack)
					back = find_preference_backpack
				else //tried loading in a backpack that we don't allow as a loadout one
					back = backpack
	else //somehow doesn't have a preference set, should never reach this point but just-in-case
		back = backpack

	//converts the uniform string into the path we'll wear, whether it's the skirt or regular variant
	var/holder
	if(preference_source && preference_source.prefs.jumpsuit_style == PREF_SKIRT)
		holder = "[uniform]/skirt"
		if(!text2path(holder))
			holder = "[uniform]"
	else
		holder = "[uniform]"
	uniform = text2path(holder)

/datum/outfit/job/post_equip(mob/living/carbon/human/H, visualsOnly = FALSE, datum/preferences/prefs)
	if(visualsOnly)
		return

	var/datum/job/J = SSjob.GetJobType(jobtype)
	if(!J)
		J = SSjob.GetJobName(H.job)

	if(H.nameless && J.dresscodecompliant)
		if(J.title in SSjob.GetDepartmentJobNames(/datum/department/command))
			H.real_name = J.title
		else
			H.real_name = "[J.title] #[rand(10000, 99999)]"

	var/obj/item/card/id/C = H.wear_id
	if(istype(C) && C.bank_support)
		C.access = J.get_access()
		shuffle_inplace(C.access) // Shuffle access list to make NTNet passkeys less predictable
		C.registered_name = H.real_name
		C.assignment = prefs?.GetPreferredAltTitle(J.title) || J.title
		C.update_label()
		for(var/A in SSeconomy.bank_accounts)
			var/datum/bank_account/B = A
			if(B.account_id == H.account_id)
				C.registered_account = B
				B.bank_cards += C
				break
		H.sec_hud_set_ID()

	var/obj/item/pda/PDA = H.get_item_by_slot(pda_slot)
	if(istype(PDA))
		PDA.owner = H.real_name
		PDA.ownjob = J.title
		PDA.update_label()
		if(prefs && !PDA.equipped) //PDA's screen color, font style and look depend on client preferences.
			PDA.update_style(prefs)

/datum/outfit/job/get_chameleon_disguise_info()
	var/list/types = ..()
	types -= /obj/item/storage/backpack //otherwise this will override the actual backpacks
	types += backpack
	types += satchel
	types += duffelbag
	return types
