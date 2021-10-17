/obj/item/clothing/examine(mob/user)
	. = ..()
	if(damaged_clothes == CLOTHING_SHREDDED)
		. += "<span class='warning'><b>It is completely shredded and requires mending!</b></span>"
		return
	for(var/zone in damage_by_parts)
		var/pct_damage_part = damage_by_parts[zone] / limb_integrity * 100
		var/zone_name = parse_zone(zone)
		switch(pct_damage_part)
			if(100 to INFINITY)
				. += "<span class='warning'><b>The [zone_name] is useless and requires mending!</b></span>"
			if(60 to 99)
				. += "<span class='warning'>The [zone_name] is heavily shredded!</span>"
			if(30 to 59)
				. += "<span class='danger'>The [zone_name] is partially shredded.</span>"
	var/datum/component/storage/pockets = GetComponent(/datum/component/storage)
	if(pockets)
		var/list/how_cool_are_your_threads = list("<span class='notice'>")
		if(pockets.attack_hand_interact)
			how_cool_are_your_threads += "[src]'s storage opens when clicked.\n"
		else
			how_cool_are_your_threads += "[src]'s storage opens when dragged to yourself.\n"
		how_cool_are_your_threads += "[src] can store [pockets.max_items] item\s.\n"
		how_cool_are_your_threads += "[src] can store items that are [weightclass2text(pockets.max_w_class)] or smaller.\n"
		if(pockets.quickdraw)
			how_cool_are_your_threads += "You can quickly remove an item from [src] using Alt-Click.\n"
		if(pockets.silent)
			how_cool_are_your_threads += "Adding or removing items from [src] makes no noise.\n"
		how_cool_are_your_threads += "</span>"
		. += how_cool_are_your_threads.Join()

	if(LAZYLEN(armor_list))
		armor_list.Cut()
	if(armor.bio)
		armor_list += list("TOXIN" = armor.bio)
	if(armor.bomb)
		armor_list += list("EXPLOSIVE" = armor.bomb)
	if(armor.bullet)
		armor_list += list("BULLET" = armor.bullet)
	if(armor.energy)
		armor_list += list("ENERGY" = armor.energy)
	if(armor.laser)
		armor_list += list("LASER" = armor.laser)
	if(armor.magic)
		armor_list += list("MAGIC" = armor.magic)
	if(armor.melee)
		armor_list += list("MELEE" = armor.melee)
	if(armor.rad)
		armor_list += list("RADIATION" = armor.rad)

	if(LAZYLEN(durability_list))
		durability_list.Cut()
	if(armor.fire)
		durability_list += list("FIRE" = armor.fire)
	if(armor.acid)
		durability_list += list("ACID" = armor.acid)

	if(LAZYLEN(armor_list) || LAZYLEN(durability_list))
		. += "<span class='notice'>It has a <a href='?src=[REF(src)];list_armor=1'>tag</a> listing its protection classes.</span>"

/obj/item/clothing/Topic(href, href_list)
	. = ..()

	if(href_list["list_armor"])
		var/list/readout = list("<span class='notice'><u><b>PROTECTION CLASSES (I-X)</u></b>")
		if(LAZYLEN(armor_list))
			readout += "\n<b>ARMOR</b>"
			for(var/dam_type in armor_list)
				var/armor_amount = armor_list[dam_type]
				readout += "\n[dam_type] [armor_to_protection_class(armor_amount)]" //e.g. BOMB IV
		if(LAZYLEN(durability_list))
			readout += "\n<b>DURABILITY</b>"
			for(var/dam_type in durability_list)
				var/durability_amount = durability_list[dam_type]
				readout += "\n[dam_type] [armor_to_protection_class(durability_amount)]" //e.g. FIRE II
		readout += "</span>"

		to_chat(usr, "[readout.Join()]")

/**
  * Rounds armor_value to nearest 10, divides it by 10 and then expresses it in roman numerals up to 10
  *
  * Rounds armor_value to nearest 10, divides it by 10
  * and then expresses it in roman numerals up to 10
  * Arguments:
  * * armor_value - Number we're converting
  */
/obj/item/clothing/proc/armor_to_protection_class(armor_value)
	armor_value = round(armor_value,10) / 10
	switch (armor_value)
		if (1)
			. = "I"
		if (2)
			. = "II"
		if (3)
			. = "III"
		if (4)
			. = "IV"
		if (5)
			. = "V"
		if (6)
			. = "VI"
		if (7)
			. = "VII"
		if (8)
			. = "VIII"
		if (9)
			. = "IX"
		if (10 to INFINITY)
			. = "X"
	return .
