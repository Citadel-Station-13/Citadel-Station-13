/obj/effect/proc_holder/spell/targeted/barnyardcurse
	name = "Curse of the Barnyard"
	desc = "This spell dooms the fate of any unlucky soul to the speech and facial attributes of a barnyard animal"
	school = "transmutation"
	charge_type = "recharge"
	charge_max	= 150
	charge_counter = 0
	clothes_req = 0
	stat_allowed = 0
	invocation = "KN'A FTAGHU, PUCK 'BTHNK!"
	invocation_type = "shout"
	range = 7
	cooldown_min = 30
	selection_type = "range"
	var/list/compatible_mobs = list(/mob/living/carbon/human,/mob/living/carbon/monkey)

	action_icon_state = "barn"

/obj/effect/proc_holder/spell/targeted/barnyardcurse/cast(list/targets, mob/user = usr)
	if(!targets.len)
		user << "<span class='notice'>No target found in range.</span>"
		return

	var/mob/living/carbon/target = targets[1]

	if(!(target.type in compatible_mobs))
		user << "<span class='notice'>You are unable to curse [target]'s head!</span>"
		return

	if(!(target in oview(range)))
		user << "<span class='notice'>They are too far away!</span>"
		return

	var/list/masks = list(/obj/item/clothing/mask/spig, /obj/item/clothing/mask/cowmask, /obj/item/clothing/mask/horsehead)
	var/list/mSounds = list("sound/magic/PigHead_curse.ogg", "sound/magic/CowHead_Curse.ogg", "sound/magic/HorseHead_curse.ogg")
	var/randM = rand(1,3)


	var/choice = masks[randM]
	var/obj/item/clothing/mask/magichead = new choice
	magichead.flags |=NODROP
	magichead.flags_inv = null
	target.visible_message("<span class='danger'>[target]'s face lights up in fire, and after the event a barnyard animal's head takes it's place!</span>", \
						   "<span class='danger'>Your face burns up, and shortly after the fire you realise you have the face of a barnyard animal!</span>")
	if(!target.unEquip(target.wear_mask))
		qdel(target.wear_mask)
	target.equip_to_slot_if_possible(magichead, slot_wear_mask, 1, 1)
	playsound(get_turf(target), mSounds[randM], 50, 1)

	target.flash_act()
