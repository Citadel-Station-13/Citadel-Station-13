/**
 * See Uplink_items file for formating and vars
 *
 * Items that can be spawned from an uplink. Can be limited by gamemode.
**/

// Ammunition
/datum/uplink_item/ammo
	category = "Ammunition"
	surplus = 40

/datum/uplink_item/ammo/pistol
	name = "10mm Standard Magazine"
	desc = "An additional 8-round 10mm magazine; compatible with the M92 Pistol. These rounds are dirt cheap, \
			but weak when compared to higher caliber options."
	item = /obj/item/ammo_box/magazine/m10mm
	cost = 1
	exclude_modes = list(/datum/game_mode/nuclear/clown_ops)

/datum/uplink_item/ammo/pistolap
	name = "10mm Armour Piercing Magazine"
	desc = "An additional 8-round 10mm magazine; compatible with the M92 Pistol. \
			These rounds are less effective at injuring the target, but are useful for penetrating protective gear."
	item = /obj/item/ammo_box/magazine/m10mm/ap
	cost = 1
	exclude_modes = list(/datum/game_mode/nuclear/clown_ops)

/datum/uplink_item/ammo/pistolhp
	name = "10mm Hollow Point Magazine"
	desc = "An additional 8-round 10mm magazine; compatible with the M92 Pistol. \
			These rounds cause more internal damage to the target, but are easily stopped by armor."
	item = /obj/item/ammo_box/magazine/m10mm/hp
	cost = 2
	exclude_modes = list(/datum/game_mode/nuclear/clown_ops)

/datum/uplink_item/ammo/pistolfire
	name = "10mm Incendiary Magazine"
	desc = "An additional 8-round 10mm magazine; compatible with the M92 Pistol. \
			Loaded with incendiary rounds which are weak in impact, but carry a payload that will ignite the target."
	item = /obj/item/ammo_box/magazine/m10mm/fire
	cost = 2
	exclude_modes = list(/datum/game_mode/nuclear/clown_ops)

/datum/uplink_item/ammo/pistolzzz
	name = "10mm Soporific Magazine"
	desc = "An additional 8-round 10mm magazine; compatible with the M92 Pistol. Loaded with soporific rounds that put the target to sleep. \
			Remember that it takes about three shots to actually put the target to sleep, so plan accordinlgy."
	item = /obj/item/ammo_box/magazine/m10mm/soporific
	cost = 3
	exclude_modes = list(/datum/game_mode/nuclear/clown_ops)

/datum/uplink_item/ammo/machinepistol
	cost = 1
	exclude_modes = list(/datum/game_mode/nuclear/clown_ops)

/datum/uplink_item/ammo/machinepistol/standard
	name = "9mm Standard Magazine"
	desc = "An additional 16-round 9mm magazine; compativle with the VP78 Machine Pistol. These rounds are fairly weak individually \
			so be prepared to buy plenty of these."
	item = /obj/item/ammo_box/magazine/pistolm9mm

/datum/uplink_item/ammo/machinepistol/ap
	name = "9mm Armour Piercing Magazine"
	desc = "An additional 16-round 9mm magazine; compatible with the VP78 Machine Pistol. \
			These rounds are less effective at injuring the target, but are useful for penetrating protective gear."
	item = /obj/item/ammo_box/magazine/pistolm9mm/ap

/datum/uplink_item/ammo/machinepistol/hp
	name = "9mm Hollow Point Magazine"
	desc = "An additional 16-round 9mm magazine; compatible with the VP98 Machine Pistol. \
			These rounds cause more internal damage to the target, but are easily stopped by armor."
	item = /obj/item/ammo_box/magazine/pistolm9mm/hp
	cost = 2

/datum/uplink_item/ammo/machinepistol/fire
	name = "9mm Incendiary Magazine"
	desc = "An additional 16-round 9mm magazine; compatible with the VP98 Machine Pistol. \
			Loaded with incendiary rounds which are weak in impact, but carry a payload that will ignite the target."
	item = /obj/item/ammo_box/magazine/pistolm9mm/fire
	cost = 2
	exclude_modes = list(/datum/game_mode/nuclear/clown_ops)

/datum/uplink_item/ammo/revolver
	name = ".357 Speed Loader"
	desc = "A speed loader that contains seven additional lethal .357 Magnum rounds; compatible with the Nagant revolver. \
			For when you really need a lot of things dead."
	item = /obj/item/ammo_box/a357
	cost = 1
	exclude_modes = list(/datum/game_mode/nuclear/clown_ops)

/datum/uplink_item/ammo/revolver/rubber
	name = ".357 Rubber Speed Loader"
	desc = "A speed loader that contains seven additional rubber .357 Magnum rounds; compatible with the Nagant revolver. \
			For when you really need a lot of things alive."
	item = /obj/item/ammo_box/a357/rubber
	cost = 2
	exclude_modes = list(/datum/game_mode/nuclear/clown_ops)

/datum/uplink_item/ammo/shell
	cost = 1
	exclude_modes = list(/datum/game_mode/nuclear, /datum/game_mode/nuclear/clown_ops)

/datum/uplink_item/ammo/shell/buck
	name = "Box of 12g Buckshot Shells"
	desc = "An additional seven shells of buckshot in a box. Devastating at close range."
	item = /obj/item/storage/box/lethalshot

/datum/uplink_item/ammo/shell/slug
	name = "Box of 12g Slug Shells"
	desc = "An additional seven shells of slug in a box. \
			Ideal for engaging at longer ranges."
	item = /obj/item/storage/box/lethalslugs

/datum/uplink_item/ammo/shell/rubber
	name = "Box of 12g Rubber Shells"
	desc = "An alternative seven shells of rubber in a box. \
			Highly effective at taking down targets non-lethally."
	cost = 2
	item = /obj/item/storage/box/rubber

/datum/uplink_item/ammo/shell/incendiary
	name = "Box of 12g Incendiary Shells"
	desc = "An alternative seven shells of incendiary in a box. \
			Shoots multiple pellets that will set any target hit on fire. Great against crowds."
	cost = 2
	item = /obj/item/storage/box/fireshot

/datum/uplink_item/ammo/shell/scatter
	name = "Box of 12g Scatter Laser Shells"
	desc = "An alternative seven shells of scatter laser in a box. \
			Mostly useful against hostiles using bullet proof gear."
	item = /obj/item/storage/box/lasershot
	cost = 3 // most armor has less laser protection then bullet

/datum/uplink_item/ammo/shotgun
	cost = 2
	include_modes = list(/datum/game_mode/nuclear)

/datum/uplink_item/ammo/shotgun/buck
	name = "12g Buckshot Drum"
	desc = "An additional 8-round buckshot magazine for use with the Bulldog shotgun. Devastating at close range."
	item = /obj/item/ammo_box/magazine/m12g

/datum/uplink_item/ammo/shotgun/slug
	name = "12g Slug Drum"
	desc = "An additional 8-round slug magazine for use with the Bulldog shotgun. \
			Ideal for engaging at longer ranges."
	item = /obj/item/ammo_box/magazine/m12g/slug

/datum/uplink_item/ammo/shotgun/dragon
	name = "12g Dragon's Breath Drum"
	desc = "An alternative 8-round dragon's breath magazine for use in the Bulldog shotgun. \
			Shoots multiple pellets that will set any target hit on fire. Great against crowds."
	item = /obj/item/ammo_box/magazine/m12g/dragon
	cost = 3

/datum/uplink_item/ammo/shotgun/scatter
	name = "12g Scatter Laser shot Slugs"
	desc = "An alternative 8-round Scatter Laser Shot magazine for use in the Bulldog shotgun. \
			Mostly useful against hostiles using bullet proof gear."
	item = /obj/item/ammo_box/magazine/m12g/scatter
	cost = 4 // most armor has less laser protection then bullet

/datum/uplink_item/ammo/shotgun/meteor
	name = "12g Meteorslug Shells"
	desc = "An alternative 8-round meteorslug magazine for use in the Bulldog shotgun. \
            Great for blasting airlocks off their frames and knocking down enemies."
	item = /obj/item/ammo_box/magazine/m12g/meteor

/datum/uplink_item/ammo/shotgun/stun
	name = "12g Stun Slug Drum"
	desc = "An alternative 8-round stun slug magazine for use with the Bulldog shotgun. \
			Effective for quickly disabling a target without killing them outright."
	item = /obj/item/ammo_box/magazine/m12g/stun
	cost = 3

/datum/uplink_item/ammo/smg
	cost = 3
	include_modes = list(/datum/game_mode/nuclear)

/datum/uplink_item/ammo/smg/standard
	name = "10mm SMG Magazine"
	desc = "An additional 28-round 10mm magazine suitable for use with the C-20r submachine gun."
	item = /obj/item/ammo_box/magazine/smgm10mm

/datum/uplink_item/ammo/smg/ap
	name = "10mm SMG AP Magazine"
	desc = "An additional 28-round 10mm magazine suitable for use with the C-20r submachine gun. \
			These rounds are less effective at injuring the target, but are useful for penetrating protective gear."
	item = /obj/item/ammo_box/magazine/smgm10mm/ap

/datum/uplink_item/ammo/smg/hp
	name = "10mm SMG HP Magazine"
	desc = "An additional 28-round 10mm magazine suitable for use with the C-20r submachine gun. \
			These rounds cause more internal damage to the target, but are easily stopped by armor."
	item = /obj/item/ammo_box/magazine/smgm10mm/hp

/datum/uplink_item/ammo/smg/fire
	name = "10mm SMG Incendiary Magazine"
	desc = "An additional 28-round 10mm magazine suitable for use with the C-20r submachine gun. \
			Loaded with incendiary rounds which are weak in impact, but carry a payload that will ignite the target."
	item = /obj/item/ammo_box/magazine/smgm10mm/fire
	cost = 4

/datum/uplink_item/ammo/flechettes
	name = "Serrated Flechette Magazine"
	desc = "An additional 64-round flechette magazine; compatible with the Flechette Launcer. \
			Loaded with serrated flechettes that shreds flesh, but is stopped dead in its tracks by armor. \
			These flechettes are highly likely to sever arteries, and even limbs."
	item = /obj/item/ammo_box/magazine/flechette/s
	cost = 2
	include_modes = list(/datum/game_mode/nuclear)

/datum/uplink_item/ammo/flechetteap
	name = "Armor Piercing Flechette Magazine"
	desc = "An additional 64-round flechette magazine; compatible with the Flechette Launcer. \
			Loaded with armor piercing flechettes that are highly effective against armor, but are unable to shred flesh."
	item = /obj/item/ammo_box/magazine/flechette
	cost = 2
	include_modes = list(/datum/game_mode/nuclear)

/datum/uplink_item/ammo/pdw
	name = "5.7x28mm Toploader Magazine"
	desc = "An additional 48-round 5.7x28mm magazine; suitable for use with the M-90gl carbine. \
			Armor piercing out of the box, with a large capacity, these magazines will take you far."
	item = /obj/item/ammo_box/magazine/a57x28
	cost = 4
	include_modes = list(/datum/game_mode/nuclear)

/datum/uplink_item/ammo/pdwhp
	name = "5.7x28mm HP Toploader Magazine"
	desc = "An alternative 48-round 5.7x28mm HP magazine; suitable for use with the M-90gl carbine. \
			Forfeits the armor piercing capabilities of standard rounds for raw damage."
	item = /obj/item/ammo_box/magazine/a57x28/hp
	cost = 5
	include_modes = list(/datum/game_mode/nuclear)

/datum/uplink_item/ammo/a40mm
	name = "40mm Grenade"
	desc = "A 40mm HE grenade for use with the M-90gl's under-barrel grenade launcher. \
			Ideal for flushing out the enemy. Not for use in enclosed spaces."
	item = /obj/item/ammo_casing/a40mm
	cost = 2
	include_modes = list(/datum/game_mode/nuclear)

/datum/uplink_item/ammo/bolt_action
	name = "Surplus Rifle Clip"
	desc = "A stripper clip used to quickly load bolt action rifles. Contains 5 rounds."
	item = /obj/item/ammo_box/a762
	cost = 1
	include_modes = list(/datum/game_mode/nuclear)

/datum/uplink_item/ammo/lmg
	cost = 4
	include_modes = list(/datum/game_mode/nuclear)

/datum/uplink_item/ammo/lmg/basic
	name = "5.56x45mm Box Magazine"
	desc = "An additional 100-round box magazine for the L6 SAW. Suppressive fire in, \
			suppressive fire out, we do the hokey pokey and that's what it's all about."
	item = /obj/item/ammo_box/magazine/mm556x45

/datum/uplink_item/ammo/lmg/ap
	name = "5.56x45mm (Armor Piercing) Box Magazine"
	desc = "An alternative 100-round box magazine of armor piercing rounds for the L6 SAW. \
			Is much more effective against armored targers, but generally has a reduced impact on target."
	item = /obj/item/ammo_box/magazine/mm556x45/ap
	cost = 5

/datum/uplink_item/ammo/lmg/hollow
	name = "5.56x45mm (Hollow-Point) Box Magazine"
	desc = "An unethical 75-round box magazine of shredding hollow-point rounds for the L6 SAW. \
			Is incredibly effective at mowing down the unarmored masses of the crew."
	item = /obj/item/ammo_box/magazine/mm556x45/hollow
	cost = 5

/datum/uplink_item/ammo/lmg/incen
	name = "5.56x45mm (Incendiary) Box Magazine"
	desc = "An alternative 75-round box magazine of incendiary rounds for the L6 Saw. \
			Sets targets alight with every bullet, just be careful not to set your squad mates on fire."
	item = /obj/item/ammo_box/magazine/mm556x45/incen
	cost = 6

/datum/uplink_item/ammo/sniper
	cost = 4
	include_modes = list(/datum/game_mode/nuclear)

/datum/uplink_item/ammo/sniper/basic
	name = ".50 Anti-Material Magazine"
	desc = "An additional standard 5-round magazine for use with .50 sniper rifles."
	item = /obj/item/ammo_box/magazine/sniper_rounds

/datum/uplink_item/ammo/sniper/penetrator
	name = ".50 Penetrator Magazine"
	desc = "A 5-round magazine of penetrator ammo designed for use with .50 sniper rifles. \
			Can pierce walls and multiple enemies with one bullet."
	item = /obj/item/ammo_box/magazine/sniper_rounds/penetrator
	cost = 5

/datum/uplink_item/ammo/sniper/soporific
	name = ".50 Soporific Magazine"
	desc = "A 3-round magazine of soporific ammo designed for use with .50 sniper rifles. Puts enemies to sleep in only one shot."
	item = /obj/item/ammo_box/magazine/sniper_rounds/soporific
	cost = 6

/*datum/uplink_item/ammo/rocket
	include_modes = list(/datum/game_mode/nuclear)
/datum/uplink_item/ammo/rocket/he
	name = "84mm HE Rocket"
	desc = "A high explosive anti-personnel rocket, for dealing a lot of damage to a wide area."
	item = /obj/item/ammo_casing/caseless/rocket
	cost = 4
/datum/uplink_item/ammo/rocket/hedp
	name = "84mm HEDP Rocket"
	desc = "A high-yield HEDP rocket; extremely effective against armored targets, while impacting a smaller area."
	item = /obj/item/ammo_casing/caseless/rocket/hedp
	cost = 5*/

/datum/uplink_item/ammo/plasma
	name = "Flamethrower Fuel Tank"
	desc = "An additional plasma tank for fueling the flamethrower. Handle with care."
	item = /obj/item/tank/internals/plasma
	cost = 4
	include_modes = list(/datum/game_mode/nuclear)

/datum/uplink_item/ammo/toydarts
	name = "Box of Riot Darts"
	desc = "A box of 40 Donksoft riot darts, for reloading any compatible foam dart magazine. Don't forget to share!"
	item = /obj/item/ammo_box/foambox/riot
	cost = 2
	surplus = 0
