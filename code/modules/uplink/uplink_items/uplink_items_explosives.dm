/**
 * See Uplink_items file for formating and vars
 *
 * Items that can be spawned from an uplink. Can be limited by gamemode.
**/

/datum/uplink_item/explosives
	category = "Grenades and Explosives"

//Non-Clown-Ops

/datum/uplink_item/explosives/incendiary
	name = "Incendiary Grenade"
	desc = "A spicy grenade with a five-second fuse. Upon detonation, it will set anything in an area around it on fire. \
			Perfect for striking fear into your enemies."
	item = /obj/item/grenade/chem_grenade/incendiary
	cost = 2
	exclude_modes = list(/datum/game_mode/nuclear/clown_ops)

/datum/uplink_item/explosives/frag
	name = "Fragmentation Grenade"
	desc = "The classic fragmentation grenade is a high explosive grenade with a five-second fuse. Upon damage it will seriously injure \
			anyone in the immediate area. A weaker version of the minibomb."
	item = /obj/item/grenade/syndieminibomb/concussion/frag
	cost = 4
	exclude_modes = list(/datum/game_mode/nuclear/clown_ops)

/datum/uplink_item/explosives/syndicate_minibomb
	name = "Syndicate Minibomb"
	desc = "The minibomb is a high explosive grenade with a five-second fuse. Upon detonation, it will create a small hull breach \
			in addition to dealing serious damage to nearby personnel."
	item = /obj/item/grenade/syndieminibomb
	cost = 6
	exclude_modes = list(/datum/game_mode/nuclear/clown_ops)

//Non-Nuke-Ops

//Non-Any-Ops

//Clown-Ops-Only

/datum/uplink_item/explosives/bombanana
	name = "Bombanana"
	desc = "A banana with an explosive taste! discard the peel quickly, as it will explode with the force of a syndicate minibomb \
		a few seconds after the banana is eaten."
	item = /obj/item/reagent_containers/food/snacks/grown/banana/bombanana
	cost = 4 //it is a bit cheaper than a minibomb because you have to take off your helmet to eat it, which is how you arm it
	surplus = 0
	include_modes = list(/datum/game_mode/nuclear/clown_ops)

/datum/uplink_item/explosives/tearstache
	name = "Teachstache Grenade"
	desc = "A teargas grenade that launches sticky moustaches onto the face of anyone not wearing a clown or mime mask. The moustaches will \
		remain attached to the face of all targets for one minute, preventing the use of breath masks and other such devices."
	item = /obj/item/grenade/chem_grenade/teargas/moustache
	cost = 3
	surplus = 0
	include_modes = list(/datum/game_mode/nuclear/clown_ops)

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
	include_modes = list(/datum/game_mode/nuclear/clown_ops)

//Nuke-Ops-Only

/datum/uplink_item/explosives/gluon
	name = "Gluon Grenade"
	desc = "A highly advanced grenade that releases a harmful stream of radioactive gluons around the point of detonation. \
			The gluons seriously cool the surrounding area and tire anyone hit from the impact."
	item = /obj/item/grenade/gluon
	cost = 10
	include_modes = list(/datum/game_mode/nuclear)

//Both Ops

/datum/uplink_item/explosives/bioterrorfoam
	name = "Bioterror Foam Grenade"
	desc = "A powerful chemical foam grenade which creates a deadly torrent of foam that will mute, blind, confuse, \
			mutate, and irritate carbon lifeforms. Specially brewed by Tiger Cooperative chemical weapons specialists \
			using additional spore toxin. Ensure suit is sealed before use."
	item = /obj/item/grenade/chem_grenade/bioterrorfoam
	cost = 5
	surplus = 35
	include_modes = list(/datum/game_mode/nuclear, /datum/game_mode/nuclear/clown_ops)

/datum/uplink_item/explosives/virus_grenade
	name = "Fungal Tuberculosis Grenade"
	desc = "A primed bio-grenade packed into a compact box. Comes with five Bio Virus Antidote Kit (BVAK) \
			autoinjectors for rapid application on up to two targets each, a syringe, and a bottle containing \
			the BVAK solution. WARNING: EXTREME BIOHAZARD. HANDLE WITH CAUTION."
	item = /obj/item/storage/box/syndie_kit/tuberculosisgrenade
	cost = 8
	surplus = 35
	include_modes = list(/datum/game_mode/nuclear, /datum/game_mode/nuclear/clown_ops)
	restricted = TRUE

/datum/uplink_item/explosives/viscerators
	name = "Viscerator Delivery Grenade"
	desc = "A unique grenade that deploys a swarm of viscerator drones upon activation, which will chase down and shred \
			any non-operatives in the area."
	item = /obj/item/grenade/spawnergrenade/manhacks
	cost = 5
	surplus = 35
	include_modes = list(/datum/game_mode/nuclear, /datum/game_mode/nuclear/clown_ops)

/datum/uplink_item/explosives/buzzkill
	name = "Buzzkill Grenade Box"
	desc = "A box with three grenades that release a swarm of angry bees upon activation. These bees indiscriminately attack friend or foe \
			with random toxins. Courtesy of the BLF and Tiger Cooperative."
	item = /obj/item/storage/box/syndie_kit/bee_grenades
	cost = 15
	surplus = 35
	include_modes = list(/datum/game_mode/nuclear, /datum/game_mode/nuclear/clown_ops)

/datum/uplink_item/explosives/syndicate_detonator
	name = "Syndicate Detonator"
	desc = "The Syndicate detonator is a companion device to the Syndicate bomb. Simply press the included button \
			and an encrypted radio frequency will instruct all live Syndicate bombs to detonate. \
			Useful for when speed matters or you wish to synchronize multiple bomb blasts. Be sure to stand clear of \
			the blast radius before using the detonator."
	item = /obj/item/syndicatedetonator
	cost = 3
	include_modes = list(/datum/game_mode/nuclear, /datum/game_mode/nuclear/clown_ops)

//Any-one

/datum/uplink_item/explosives/c4
	name = "Composition C-4"
	desc = "C-4 is a versatile plastic explosive of the common variety Composition C. You can use it to breach into rooms, sabotage equipment, or connect \
			an assembly to it in order to alter the way it detonates. It can be attached to almost all objects and has a modifiable timer with a \
			minimum setting of 10 seconds. If you are clever, you can use C-4 as a makeshift grenade."
	item = /obj/item/grenade/plastic/c4
	cost = 1

/datum/uplink_item/explosives/x4
	name = "Composition X-4"
	desc = "X-4 is a plastic explosive of the variety Composition X. It is similar to C-4, but with a stronger, directional blast instead of circular. \
			It is generally less useful for sabotage and assemblies, but is much better for breaching, as it will seriously injure anyone on the other side of a wall. \
			For when you want a controlled explosion that leaves a wider, deeper, hole."
	item = /obj/item/grenade/plastic/x4
	cost = 1
	cant_discount = TRUE

/datum/uplink_item/explosives/detomatix
	name = "Detomatix PDA Cartridge"
	desc = "When inserted into a personal digital assistant, this cartridge gives you four opportunities to \
			detonate PDAs of crewmembers who have their message feature enabled. \
			The concussive effect from the explosion will knock the recipient out for a short period, and deafen them for longer."
	item = /obj/item/cartridge/virus/syndicate
	cost = 5
	restricted = TRUE

//datum/uplink_item/explosives/doorcharge
//	name = "Airlock Charge"
//	desc = "A small explosive charged that can be placed into the wiring of any airlock. \
//			The moment someone attempts to open the airlock, the charge will detonate, destroying the airlock and injuring anyone nearby."
//	item = /obj/item/doorCharge
//	cost = 4

/datum/uplink_item/explosives/pizza_bomb
	name = "Pizza Bomb"
	desc = "A pizza box with a bomb cunningly attached to the lid. The timer needs to be set by opening the box; afterwards, \
			opening the box again will trigger the detonation after the timer has elapsed. Comes with free pizza, for you or your target!"
	item = /obj/item/pizzabox/bomb
	cost = 6
	surplus = 8

/datum/uplink_item/explosives/flashbang
	name = "Box of Flashbangs"
	desc = "A box of four non-lethal grenade with a five-second fuse that can be used to blind, deafen, and incapacitate nearby opponents. \
			Just be careful not to be in the blast radius."
	item = /obj/item/storage/box/syndie_kit/flashbang
	cost = 2

/datum/uplink_item/explosives/soap_clusterbang
	name = "Slipocalypse Clusterbang"
	desc = "A traditional clusterbang grenade with a payload consisting entirely of Syndicate soap. Useful in any scenario!"
	item = /obj/item/grenade/clusterbuster/soap
	cost = 6

/datum/uplink_item/explosives/emp
	name = "Box of EMP Grenades"
	desc = "A box of five rather useful utility grenades with a five-second fuse that generates a small electro-magnetic pulse upon detonation. \
			Useful for disabling cyborgs, mechs, and other electronic devices."
	item = /obj/item/storage/box/syndie_kit/emp
	cost = 1

/datum/uplink_item/explosives/syndicate_bomb
	name = "Syndicate Bomb"
	desc = "The Syndicate bomb is a fearsome device capable of massive destruction. It has an adjustable timer, \
			with a minimum of 60 seconds, and can be bolted to the floor with a wrench to prevent \
			movement. The bomb is bulky and cannot be moved; upon ordering this item, a smaller beacon will be \
			transported to you that will teleport the actual bomb to it upon activation. Note that this bomb can \
			be defused, and some crew may attempt to do so."
	item = /obj/item/sbeacondrop/bomb
	cost = 11