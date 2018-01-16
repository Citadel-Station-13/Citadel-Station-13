//This is the file that handles donator loadout items.

/datum/gear/aaapingcoderfailsafe
	name = "IF YOU SEE THIS, PING A CODER RIGHT NOW!"
	category = slot_in_backpack
	path = /obj/item/bikehorn/golden
	ckeywhitelist = list("This entry should never appear with this variable set. If it does, then that means somebody fucked up the whitelist system hardcore")

/datum/gear/donortestingbikehorn
	name = "Only coders should see this"
	category = slot_in_backpack
	path = /obj/item/bikehorn
	ckeywhitelist = list("deathride58")
