/datum/uplink_item
	var/surplus_nullcrates //Chance of being included in null crates. null = pull from surplus

/datum/uplink_item/New()
	. = ..()
	if(isnull(surplus_nullcrates))
		surplus_nullcrates = surplus

/datum/uplink_item/device_tools/arm
	name = "Additional Arm"
	desc = "An additional arm harvested from slaves captured by the Syndicate. Comes with an implanter."
	item = /obj/item/extra_arm
	cost = 8
