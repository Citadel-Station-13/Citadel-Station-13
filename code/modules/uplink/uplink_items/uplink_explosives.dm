
/*
	Uplink Items:
	Unlike categories, uplink item entries are automatically sorted alphabetically on server init in a global list,
	When adding new entries to the file, please keep them sorted by category.
*/

//Grenades and Explosives

/datum/uplink_item/explosives/bioterrorfoam
	name = "Bioterror Foam Grenade"
	desc = "A powerful chemical foam grenade which creates a deadly torrent of foam that will mute, blind, confuse, \
			mutate, and irritate carbon lifeforms. Specially brewed by Tiger Cooperative chemical weapons specialists \
			using additional spore toxin. Ensure suit is sealed before use."
	item = /obj/item/grenade/chem_grenade/bioterrorfoam
	cost = 5
	surplus = 35
	purchasable_from = UPLINK_NUKE_OPS | UPLINK_CLOWN_OPS

/datum/uplink_item/explosives/bombanana
	name = "Bombanana"
	desc = "A banana with an explosive taste! discard the peel quickly, as it will explode with the force of a syndicate minibomb \
		a few seconds after the banana is eaten."
	item = /obj/item/reagent_containers/food/snacks/grown/banana/bombanana
	cost = 4 //it is a bit cheaper than a minibomb because you have to take off your helmet to eat it, which is how you arm it
	surplus = 0
	purchasable_from = UPLINK_CLOWN_OPS

/datum/uplink_item/explosives/buzzkill
	name = "Buzzkill Grenade Box"
	desc = "A box with three grenades that release a swarm of angry bees upon activation. These bees indiscriminately attack friend or foe \
			with random toxins. Courtesy of the BLF and Tiger Cooperative."
	item = /obj/item/storage/box/syndie_kit/bee_grenades
	cost = 15
	surplus = 35
	purchasable_from = UPLINK_NUKE_OPS | UPLINK_CLOWN_OPS

/datum/uplink_item/explosives/c4
	name = "Composition C-4"
	desc = "C-4 is plastic explosive of the common variety Composition C. You can use it to breach walls, sabotage equipment, or connect \
			an assembly to it in order to alter the way it detonates. It can be attached to almost all objects and has a modifiable timer with a \
			minimum setting of 10 seconds."
	item = /obj/item/grenade/plastic/c4
	cost = 1

/datum/uplink_item/explosives/c4bag
	name = "Bag of C-4 explosives"
	desc = "Because sometimes quantity is quality. Contains 10 C-4 plastic explosives."
	item = /obj/item/storage/backpack/duffelbag/syndie/c4
	cost = 9 //10% discount!
	cant_discount = TRUE

/datum/uplink_item/explosives/x4bag
	name = "Bag of X-4 explosives"
	desc = "Contains 3 X-4 shaped plastic explosives. Similar to C4, but with a stronger blast that is directional instead of circular. \
			X-4 can be placed on a solid surface, such as a wall or window, and it will blast through the wall, injuring anything on the opposite side, while being safer to the user. \
			For when you want a controlled explosion that leaves a wider, deeper, hole."
	item = /obj/item/storage/backpack/duffelbag/syndie/x4
	cost = 4 //
	cant_discount = TRUE

/datum/uplink_item/explosives/clown_bomb_clownops
	name = "Clown Bomb"
	desc = "The Clown bomb is a hilarious device capable of massive pranks. It has an adjustable timer, \
			with a minimum of 60 seconds, and can be bolted to the floor with a wrench to prevent \
			movement. The bomb is bulky and cannot be moved; upon ordering this item, a smaller beacon will be \
			transported to you that will teleport the actual bomb to it upon activation. Note that this bomb can \
			be defused, and some crew may attempt to do so."
	item = /obj/item/sbeacondrop/clownbomb
	cost = 15
	surplus = 0
	purchasable_from = UPLINK_CLOWN_OPS

/datum/uplink_item/explosives/detomatix
	name = "Detomatix PDA Cartridge"
	desc = "When inserted into a personal digital assistant, this cartridge gives you four opportunities to \
			detonate PDAs of crewmembers who have their message feature enabled. \
			The concussive effect from the explosion will knock the recipient out for a short period, and deafen them for longer."
	item = /obj/item/cartridge/virus/syndicate
	cost = 5
	restricted = TRUE
	limited_stock = 1

/datum/uplink_item/explosives/emp
	name = "EMP Grenades and Implanter Kit"
	desc = "A box that contains five EMP grenades and an EMP implant with three uses. Useful to disrupt communications, \
			security's energy weapons and silicon lifeforms when you're in a tight spot."
	item = /obj/item/storage/box/syndie_kit/emp
	cost = 2

/datum/uplink_item/explosives/virus_grenade
	name = "Fungal Tuberculosis Grenade"
	desc = "A primed bio-grenade packed into a compact box. Comes with five Bio Virus Antidote Kit (BVAK) \
			autoinjectors for rapid application on up to two targets each, a syringe, and a bottle containing \
			the BVAK solution."
	item = /obj/item/storage/box/syndie_kit/tuberculosisgrenade
	cost = 8
	surplus = 35
	purchasable_from = UPLINK_NUKE_OPS | UPLINK_CLOWN_OPS
	restricted = TRUE

/datum/uplink_item/explosives/grenadier
	name = "Grenadier's belt"
	desc = "A belt containing 26 lethally dangerous and destructive grenades. Comes with an extra multitool and screwdriver."
	item = /obj/item/storage/belt/grenade/full
	purchasable_from = UPLINK_NUKE_OPS
	cost = 22
	surplus = 0

/datum/uplink_item/explosives/pizza_bomb
	name = "Pizza Bomb"
	desc = "A pizza box with a bomb cunningly attached to the lid. The timer needs to be set by opening the box; afterwards, \
			opening the box again will trigger the detonation after the timer has elapsed. Comes with free pizza, for you or your target!"
	item = /obj/item/pizzabox/bomb
	cost = 6
	surplus = 8

/datum/uplink_item/explosives/syndicate_bomb
	name = "Syndicate Bomb"
	desc = "The Syndicate bomb is a fearsome device capable of massive destruction. It has an adjustable timer, \
			with a minimum of 60 seconds, and can be bolted to the floor with a wrench to prevent \
			movement. The bomb is bulky and cannot be moved; upon ordering this item, a smaller beacon will be \
			transported to you that will teleport the actual bomb to it upon activation. Note that this bomb can \
			be defused, and some crew may attempt to do so."
	item = /obj/item/sbeacondrop/bomb
	cost = 11

/datum/uplink_item/explosives/syndicate_detonator
	name = "Syndicate Detonator"
	desc = "The Syndicate detonator is a companion device to the Syndicate bomb. Simply press the included button \
			and an encrypted radio frequency will instruct all live Syndicate bombs to detonate. \
			Useful for when speed matters or you wish to synchronize multiple bomb blasts. Be sure to stand clear of \
			the blast radius before using the detonator."
	item = /obj/item/syndicatedetonator
	cost = 3
	purchasable_from = UPLINK_NUKE_OPS | UPLINK_CLOWN_OPS

/datum/uplink_item/explosives/syndicate_minibomb
	name = "Syndicate Minibomb"
	desc = "The minibomb is a grenade with a five-second fuse. Upon detonation, it will create a small hull breach \
			in addition to dealing high amounts of damage to nearby personnel."
	item = /obj/item/grenade/syndieminibomb
	cost = 6
	purchasable_from = ~UPLINK_CLOWN_OPS

/datum/uplink_item/explosives/tearstache
	name = "Teachstache Grenade"
	desc = "A teargas grenade that launches sticky moustaches onto the face of anyone not wearing a clown or mime mask. The moustaches will \
		remain attached to the face of all targets for two minutes, preventing the use of breath masks and other such devices."
	item = /obj/item/grenade/chem_grenade/teargas/moustache
	cost = 3
	surplus = 0
	purchasable_from = UPLINK_CLOWN_OPS

/datum/uplink_item/explosives/viscerators
	name = "Viscerator Delivery Grenade"
	desc = "A unique grenade that deploys a swarm of viscerators upon activation, which will chase down and shred \
			any non-operatives in the area."
	item = /obj/item/grenade/spawnergrenade/manhacks
	cost = 5
	surplus = 35
	purchasable_from = UPLINK_NUKE_OPS | UPLINK_CLOWN_OPS
