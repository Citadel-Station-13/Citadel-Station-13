/datum/gear/unlockable
	category = LOADOUT_CATEGORY_UNLOCKABLE
	slot = SLOT_NECK

	var/progress_required //what does our progress need to be to unlock it
	var/progress_key //what is the key used to retrieve existing progress for this unlockable

/datum/gear/unlockable/janitor
	name = "Janitor Bedsheet"
	description = "Clean 100 messes with a mop to unlock this. It has a warning sign on!"
	path = /obj/item/bedsheet/unlockable/janitor

	progress_required = 100
	progress_key = "janitor"

/datum/gear/unlockable/cook
	name = "Cook Bedsheet"
	description = "Cook 250 items using the microwave to unlock this. It has a microwave on!"
	path = /obj/item/bedsheet/unlockable/cook

	progress_required = 250
	progress_key = "cook"

/datum/gear/unlockable/miner
	name = "Miner Bedsheet"
	description = "Redeem a total of 100,000 miner points to unlock this. It's made out of goliath hide!"
	path = /obj/item/bedsheet/unlockable/miner

	progress_required = 100000
	progress_key = "miner"
