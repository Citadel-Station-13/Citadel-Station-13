/**
 * See Uplink_items file for formating and vars
 *
 * Items that can be spawned from an uplink. Can be limited by gamemode.
**/
// Guns, Launchers, and other ranged weapons of destruction
/datum/uplink_item/munitions
	category = "Syndicate Firearms"

//Non-Clown-ops

/datum/uplink_item/munitions/pistol
	name = "Stechkin Pistol"
	desc = "A small, easily concealable handgun, which fires 10mm rounds from an 8 round magazine. \
			The preferred weapon for stealth operations on a budget. Compatible with supressors."
	item = /obj/item/gun/ballistic/automatic/pistol
	cost = 6
	exclude_modes = list(/datum/game_mode/nuclear/clown_ops)

/datum/uplink_item/munitions/revolver
	name = "Syndicate Revolver"
	desc = "A bulky and powerful hand cannon that fires devastating .357 rounds from 7 chambers. \
			Capable of dispatching targets with ease at the cost of making a lot of noise."
	item = /obj/item/gun/ballistic/revolver/syndie
	cost = 13
	surplus = 50
	exclude_modes = list(/datum/game_mode/nuclear/clown_ops)

/datum/uplink_item/munitions/machinepistol
	name = "VP78 Machine Pistol"
	desc = "An automatic machine pistol that fires 9mm rounds in 2-round bursts from a 16 round magazine. \
			For when you just need to spray and pray. Compatible with supressors."
	item = /obj/item/gun/ballistic/automatic/pistol/machinepistol
	cost = 9
	exclude_modes = list(/datum/game_mode/nuclear/clown_ops)

//Non-Nukie-ops

//Non-Any-Ops

/datum/uplink_item/munitions/doublebarrel
	name = "Sawn-Off Double Barrel Shotgun"
	desc = "A brutally simple double barrel shotgun, precut for portability. \
			Designed for close quarter target elimination. Pre-loaded with buckshot shells"
	item = /obj/item/gun/ballistic/revolver/doublebarrel/sawn
	cost = 10
	exclude_modes = list(/datum/game_mode/nuclear, /datum/game_mode/nuclear/clown_ops)

//Only Nukie-Ops

/datum/uplink_item/munitions/sniper
	name = "Anti-Material Sniper Rifle"
	desc = "A long-range, scoped, specialist rifle that fires devastating .50 caliber rounds from a 5 round magazine. \
			Incredible at neutralizing nearly any kind of individual target, but absolutely terrible at close range, or against multiple opponents."
	item = /obj/item/gun/ballistic/automatic/sniper_rifle/syndicate
	cost = 16
	surplus = 25
	include_modes = list(/datum/game_mode/nuclear)

/datum/uplink_item/munitions/antitank
	name = "Anti-Material Pistol"
	desc = "Essentially an anti-material snipe rifle stripped down of all rifling. \
			Fires .50 caliber rounds from a 5 round magazine, but with terrible accuracy. \
			Cheaper than the revolver, and absolutely devastating if it hits"
	item = /obj/item/gun/ballistic/automatic/pistol/antitank/syndicate
	cost = 14
	surplus = 25
	include_modes = list(/datum/game_mode/nuclear)

/datum/uplink_item/munitions/shotgun
	name = "Bulldog Shotgun"
	desc = "A semi-automatic shotgun fed by 8-round drums. Compatible with all 12g rounds. Designed for close \
			quarter anti-personnel engagements. Pre-loaded with a buckshot drum."
	item = /obj/item/gun/ballistic/automatic/shotgun/bulldog
	cost = 8
	surplus = 40
	include_modes = list(/datum/game_mode/nuclear)

/datum/uplink_item/munitions/smg
	name = "C-20r Submachine Gun"
	desc = "An ergonomic Scarborough Arms bullpup submachine gun that fires 10mm rounds in 2 round bursts from a 28-round magazine. \
			Highly versatile and reliable. Compatible with suppressors"
	item = /obj/item/gun/ballistic/automatic/c20r
	cost = 10
	surplus = 40
	include_modes = list(/datum/game_mode/nuclear)

/datum/uplink_item/munitions/flechettegun
	name = "Flechette Launcher"
	desc = "A highly illegal compact bullpup carbine that fires micro-flechette rounds in 8 round bursts from a 64 round magazine.\
			Flechettes deal very little damage individually, but shred the targets internal organs, causing them to quickly bleed to death. \
			Ideal for extended engagements."
	item = /obj/item/gun/ballistic/automatic/flechette
	cost = 14
	surplus = 30
	include_modes = list(/datum/game_mode/nuclear)

/datum/uplink_item/munitions/ion
	name = "Ion Rifle"
	desc = "A man-portable anti-electronics weapon designed to disrupt electrical systems and mechanical targets."
	item = /obj/item/gun/energy/ionrifle //They get one on base, so they can have more then one
	cost = 12
	include_modes = list(/datum/game_mode/nuclear)

/datum/uplink_item/munitions/machinegun
	name = "L6 Squad Automatic Weapon"
	desc = "A heavy duty Aussec Armoury belt-fed machine gun that carries a massive 100-round magazine of armor piercing 5.56×45mm ammunition that \
			is fired in 5 round bursts. Requires two hands to fire. The L6 is ideal for suppressive fire and support roles."
	item = /obj/item/gun/ballistic/automatic/l6_saw
	cost = 18
	surplus = 0
	include_modes = list(/datum/game_mode/nuclear)

/datum/uplink_item/munitions/pdw
	name = "M-90gl PDW"
	desc = "A compact personal defense weapon that fires armor piercing 5.7x28mm ammunition in 4-round bursts from a 48 round magazine. \
			This specific model comes with an underbarrel grenade launcher, for flushing out enemies behind cover. \
			While expensive, it is the most versatile and effective of its size on offer."
	item = /obj/item/gun/ballistic/automatic/m90
	cost = 22
	surplus = 50
	include_modes = list(/datum/game_mode/nuclear)

/datum/uplink_item/munitions/flamethrower
	name = "Plasma Flamethrower"
	desc = "A flamethrower, fueled by a tank of highly flammable biotoxins stolen from Nanotrasen \
			Make a statement by roasting the filth in their own greed. Use with extreme caution. \
			Ensure the igniter is on before firing."
	item = /obj/item/flamethrower/full/tank
	cost = 4
	surplus = 40
	include_modes = list(/datum/game_mode/nuclear)

//CURRENTLY UNABLE TO LOAD ROCKETS INTO LAUNCHER. UNCOMMENT ONCE FIXED
/*datum/uplink_item/munitions/rocketlauncher
	name = "PML-9 Rocket Launcher"
	desc = "A powerful and reusable rocket launcher preloaded with an armor piercing HEDP round. \
			Ideal for eliminating heavily armored targets, or, when loaded with HE rounds, large groups of targets."
	item = /obj/item/gun/ballistic/rocketlauncher
	cost = 8
	surplus = 30
	include_modes = list(/datum/game_mode/nuclear)*/

/datum/uplink_item/munitions/bolt_action
	name = "Surplus Rifle"
	desc = "A horribly outdated bolt action weapon that fires 7.62x51mm rounds from a 5-round clip. \
			Generally only purchased as a last resort, but suprisingly robust on a per shot basis."
	item = /obj/item/gun/ballistic/shotgun/boltaction
	cost = 2
	include_modes = list(/datum/game_mode/nuclear)


//Only Clown-ops

/datum/uplink_item/munitions/pie_cannon
	name = "Banana Cream Pie Cannon"
	desc = "A special pie cannon for a special clown, this gadget can hold up to 20 pies and automatically fabricates one every two seconds!"
	cost = 10
	item = /obj/item/pneumatic_cannon/pie/selfcharge
	surplus = 0
	include_modes = list(/datum/game_mode/nuclear/clown_ops)

//Both Ops

/datum/uplink_item/munitions/medgun
	name = "Medbeam Gun"
	desc = "A wonder of Syndicate engineering, the Medbeam gun, or Medi-Gun enables a medic to keep his fellow \
			operatives in the fight, even while under fire. Don't cross the streams!"
	item = /obj/item/gun/medbeam
	cost = 15
	include_modes = list(/datum/game_mode/nuclear, /datum/game_mode/nuclear/clown_ops)

/datum/uplink_item/munitions/foammachinegun
	name = "Toy Machine Gun"
	desc = "A Donksoft belt-fed machine gun. This weapon has a massive 75-round magazine of devastating \
			riot grade darts, that can briefly incapacitate someone in just one volley."
	item = /obj/item/gun/ballistic/automatic/l6_saw/toy
	cost = 12
	surplus = 0
	include_modes = list(/datum/game_mode/nuclear, /datum/game_mode/nuclear/clown_ops)

/datum/uplink_item/munitions/foamsmg
	name = "Toy Submachine Gun"
	desc = "A Donksoft bullpup submachine gun that fires riot grade darts from a 28-round magazine."
	item = /obj/item/gun/ballistic/automatic/c20r/toy
	cost = 6
	surplus = 0
	include_modes = list(/datum/game_mode/nuclear, /datum/game_mode/nuclear/clown_ops)

//Anyone Can use

/datum/uplink_item/munitions/foampistol
	name = "Toy Pistol with Riot Darts"
	desc = "A Donksoft pistol designed to fire foam darts. Carries 8 darts per magazine, \
			and comes pre-loaded with riot darts."
	item = /obj/item/gun/ballistic/automatic/toy/pistol/riot
	cost = 3
	surplus = 10