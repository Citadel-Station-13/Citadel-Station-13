
// Dangerous Items

/*
	Uplink Items:
	Unlike categories, uplink item entries are automatically sorted alphabetically on server init in a global list,
	When adding new entries to the file, please keep them sorted by category.
*/

/datum/uplink_item/dangerous/pistol
	name = "Stechkin Pistol"
	desc = "A sleek box containing a small, easily concealable handgun that uses 10mm auto rounds in 8-round magazines. The handgun is compatible \
			with suppressors."
	item = /obj/item/storage/box/syndie_kit/pistol
	cost = 7
	purchasable_from = ~UPLINK_CLOWN_OPS

/datum/uplink_item/dangerous/revolver
	name = "Syndicate Revolver Kit"
	desc = "A sleek box containing a brutally simple Syndicate revolver that fires .357 Magnum rounds and has 7 chambers, and an extra speedloader."
	item = /obj/item/storage/box/syndie_kit/revolver
	cost = 13
	player_minimum = 15
	surplus = 50
	purchasable_from = ~UPLINK_CLOWN_OPS

/datum/uplink_item/dangerous/rawketlawnchair
	name = "84mm Rocket Propelled Grenade Launcher"
	desc = "A reusable rocket propelled grenade launcher preloaded with a low-yield 84mm HE round. \
		Guaranteed to send your target out with a bang or your money back!"
	item = /obj/item/gun/ballistic/rocketlauncher
	cost = 8
	surplus = 30
	purchasable_from = UPLINK_NUKE_OPS

/datum/uplink_item/dangerous/antitank
	name = "Anti Tank Pistol"
	desc = "Essentially amounting to a sniper rifle with no stock and barrel (or indeed, any rifling at all), \
			this extremely dubious pistol is guaranteed to dislocate your wrists and hit the broad side of a barn! \
	 		Uses sniper ammo. \
	 		Bullets tend to veer off-course. We are not responsible for any unintentional damage or injury resulting from inaacuracy."
	item = /obj/item/gun/ballistic/automatic/pistol/antitank/syndicate
	cost = 14
	surplus = 25
	purchasable_from = UPLINK_NUKE_OPS

/datum/uplink_item/dangerous/pie_cannon
	name = "Banana Cream Pie Cannon"
	desc = "A special pie cannon for a special clown, this gadget can hold up to 20 pies and automatically fabricates one every two seconds!"
	cost = 10
	item = /obj/item/pneumatic_cannon/pie/selfcharge
	surplus = 0
	purchasable_from = UPLINK_CLOWN_OPS

/datum/uplink_item/dangerous/bananashield
	name = "Bananium Energy Shield"
	desc = "A clown's most powerful defensive weapon, this personal shield provides near immunity to ranged energy attacks \
		by bouncing them back at the ones who fired them. It can also be thrown to bounce off of people, slipping them, \
		and returning to you even if you miss. WARNING: DO NOT ATTEMPT TO STAND ON SHIELD WHILE DEPLOYED, EVEN IF WEARING ANTI-SLIP SHOES."
	item = /obj/item/shield/energy/bananium
	cost = 16
	surplus = 0
	purchasable_from = UPLINK_CLOWN_OPS

/datum/uplink_item/dangerous/clownsword
	name = "Bananium Energy Sword"
	desc = "An energy sword that deals no damage, but will slip anyone it contacts, be it by melee attack, thrown \
	impact, or just stepping on it. Beware friendly fire, as even anti-slip shoes will not protect against it."
	item = /obj/item/melee/transforming/energy/sword/bananium
	cost = 3
	surplus = 0
	purchasable_from = UPLINK_CLOWN_OPS

/datum/uplink_item/dangerous/bioterror
	name = "Biohazardous Chemical Sprayer"
	desc = "A handheld chemical sprayer that allows a wide dispersal of selected chemicals. Especially tailored by the Tiger \
			Cooperative, the deadly blend it comes stocked with will disorient, damage, and disable your foes... \
			Use with extreme caution, to prevent exposure to yourself and your fellow operatives."
	item = /obj/item/reagent_containers/spray/chemsprayer/bioterror
	cost = 20
	surplus = 0
	purchasable_from = UPLINK_NUKE_OPS | UPLINK_CLOWN_OPS

/datum/uplink_item/dangerous/throwingweapons
	name = "Box of Throwing Weapons"
	desc = "A box of shurikens and reinforced bolas from ancient Earth martial arts. They are highly effective \
			 throwing weapons. The bolas can knock a target down and the shurikens will embed into limbs."
	item = /obj/item/storage/box/syndie_kit/throwing_weapons
	cost = 3

/datum/uplink_item/dangerous/shotgun
	name = "Bulldog Shotgun"
	desc = "A fully-loaded semi-automatic drum-fed shotgun. Compatible with all 12g rounds. Designed for close \
			quarter anti-personnel engagements."
	item = /obj/item/gun/ballistic/automatic/shotgun/bulldog
	cost = 8
	surplus = 40
	purchasable_from = UPLINK_NUKE_OPS

/datum/uplink_item/dangerous/smg
	name = "C-20r Submachine Gun"
	desc = "A fully-loaded Scarborough Arms bullpup submachine gun. The C-20r fires .45 rounds with a \
			24-round magazine and is compatible with suppressors."
	item = /obj/item/gun/ballistic/automatic/c20r
	cost = 10
	surplus = 40
	purchasable_from = UPLINK_NUKE_OPS

/datum/uplink_item/dangerous/doublesword
	name = "Double-Bladed Energy Sword"
	desc = "The double-bladed energy sword does slightly more damage than a standard energy sword and will deflect \
			all energy projectiles, but requires two hands to wield."
	item = /obj/item/dualsaber
	player_minimum = 25
	cost = 16
	purchasable_from = ~UPLINK_CLOWN_OPS

/datum/uplink_item/dangerous/doublesword/get_discount()
	return pick(4;0.8,2;0.65,1;0.5)

/datum/uplink_item/dangerous/hyperblade
	name = "Hypereutactic Blade"
	desc = "The result of two Dragon Tooth swords combining, you wouldn't want to see this coming at you down the hall! \
			Requires two hands to wield and it slows you down.  You can also recolor it!"
	item = /obj/item/dualsaber/hypereutactic
	player_minimum = 25
	cost = 16
	purchasable_from = ~UPLINK_CLOWN_OPS

/datum/uplink_item/dangerous/hyperblade/get_discount()
	return pick(4;0.8,2;0.65,1;0.5)

/datum/uplink_item/dangerous/sword
	name = "Energy Sword"
	desc = "The energy sword is an edged weapon with a blade of pure energy. The sword is small enough to be \
			pocketed when inactive. Activating it produces a loud, distinctive noise."
	item = /obj/item/melee/transforming/energy/sword/saber
	cost = 8
	purchasable_from = ~UPLINK_CLOWN_OPS

/datum/uplink_item/dangerous/shield
	name = "Energy Shield"
	desc = "An incredibly useful personal shield projector, capable of reflecting energy projectiles and defending \
			against other attacks. Pair with an Energy Sword for a killer combination."
	item = /obj/item/shield/energy
	cost = 16
	surplus = 20
	purchasable_from = UPLINK_NUKE_OPS

/datum/uplink_item/dangerous/rapier
	name = "Rapier"
	desc = "An elegant plastitanium rapier with a diamond tip and coated in a specialized knockout poison. \
			The rapier comes with its own sheath, and is capable of puncturing through almost any defense. \
			However, due to the size of the blade and obvious nature of the sheath, the weapon stands out as being obviously nefarious."
	item = /obj/item/storage/belt/sabre/rapier
	cost = 8
	purchasable_from = ~UPLINK_CLOWN_OPS

/datum/uplink_item/dangerous/flamethrower
	name = "Flamethrower"
	desc = "A flamethrower, fueled by a portion of highly flammable biotoxins stolen previously from Nanotrasen \
			stations. Make a statement by roasting the filth in their own greed. Use with caution."
	item = /obj/item/flamethrower/full/tank
	cost = 4
	surplus = 40
	purchasable_from = UPLINK_NUKE_OPS

/datum/uplink_item/dangerous/flechettegun
	name = "Flechette Launcher"
	desc = "A compact bullpup that fires micro-flechettes.\
			Flechettes have very poor performance idividually, but can be very deadly in numbers. \
			Pre-loaded with armor piercing flechettes that are capable of puncturing most kinds of armor."
	item = /obj/item/gun/ballistic/automatic/flechette
	cost = 12
	surplus = 30
	purchasable_from = UPLINK_NUKE_OPS

/datum/uplink_item/dangerous/rapid
	name = "Bands of the North Star"
	desc = "These armbands let the user punch people very fast and with the lethality of a legendary martial artist. \
			Does not improve weapon attack speed or the meaty fists of a hulk, but you will be unmatched in martial power. \
			Combines with all martial arts, but the user will be unable to bring themselves to use guns, nor remove the armbands."
	item = /obj/item/clothing/gloves/fingerless/pugilist/rapid
	cost = 30
	purchasable_from = UPLINK_NUKE_OPS

/datum/uplink_item/dangerous/guardian
	name = "Holoparasites"
	desc = "Though capable of near sorcerous feats via use of hardlight holograms and nanomachines, they require an \
			organic host as a home base and source of fuel. Holoparasites come in various types and share damage with their host."
	item = /obj/item/storage/box/syndie_kit/guardian
	cost = 12
	limited_stock = 1 // you can only have one holopara apparently?
	refundable = TRUE
	cant_discount = TRUE
	surplus = 0
	purchasable_from = ~(UPLINK_NUKE_OPS | UPLINK_CLOWN_OPS)
	player_minimum = 25
	restricted = TRUE
	refund_path = /obj/item/guardiancreator/tech/choose/traitor

/datum/uplink_item/dangerous/nukieguardian // just like the normal holoparasites but without the support or deffensive stands because nukies shouldnt turtle
	name = "Holoparasites"
	desc = "Though capable of near sorcerous feats via use of hardlight holograms and nanomachines, they require an \
			organic host as a home base and source of fuel. Holoparasites come in various types and share damage with their host."
	item = /obj/item/storage/box/syndie_kit/nukieguardian
	cost = 8
	refundable = TRUE
	surplus = 50
	refund_path = /obj/item/guardiancreator/tech/choose/nukie
	purchasable_from = UPLINK_NUKE_OPS

/datum/uplink_item/dangerous/machinegun
	name = "L6 Squad Automatic Weapon"
	desc = "A fully-loaded Aussec Armoury belt-fed machine gun. \
			This deadly weapon has a massive 50-round magazine of devastating 7.12x82mm ammunition."
	item = /obj/item/gun/ballistic/automatic/l6_saw
	cost = 18
	surplus = 0
	purchasable_from = UPLINK_NUKE_OPS

/datum/uplink_item/dangerous/carbine
	name = "M-90gl Carbine"
	desc = "A fully-loaded, specialized three-round burst carbine that fires 5.56mm ammunition from a 30 round magazine \
			with a toggleable 40mm underbarrel grenade launcher."
	item = /obj/item/gun/ballistic/automatic/m90
	cost = 18
	surplus = 50
	purchasable_from = UPLINK_NUKE_OPS

/datum/uplink_item/dangerous/maulergauntlets
	name = "Mauler Gauntlets"
	desc = "Mauler gauntlets are a pair of high-tech plastitanium gauntlets fused with illegal nanite auto-injectors designed \
	to grant the wearer sextuple the strength of an average human being. Wearing these, you will punch harder, inflict more injuries \
	with your fists, and be able to slam people through tables with immense force. \
	Unfortunately, due to the size of the gloves you will be unable to wield firearms with them equipped."
	item = /obj/item/clothing/gloves/fingerless/pugilist/mauler
	cost = 8

/datum/uplink_item/dangerous/powerfist
	name = "Power Fist"
	desc = "The power-fist is a metal gauntlet with a built-in piston-ram powered by an external gas supply.\
		 Upon hitting a target, the piston-ram will extend forward to make contact for some serious damage. \
		 Using a wrench on the piston valve will allow you to tweak the amount of gas used per punch to \
		 deal extra damage and hit targets further. Use a screwdriver to take out any attached tanks."
	item = /obj/item/melee/powerfist
	cost = 8

/datum/uplink_item/dangerous/sniper
	name = "Sniper Rifle"
	desc = "Ranged fury, Syndicate style. Guaranteed to cause shock and awe or your TC back!"
	item = /obj/item/gun/ballistic/automatic/sniper_rifle/syndicate
	cost = 16
	surplus = 25
	purchasable_from = UPLINK_NUKE_OPS

/datum/uplink_item/dangerous/bolt_action
	name = "Surplus Rifle"
	desc = "A horribly outdated bolt action weapon. You've got to be desperate to use this."
	item = /obj/item/gun/ballistic/shotgun/boltaction
	cost = 2
	purchasable_from = UPLINK_NUKE_OPS

/datum/uplink_item/dangerous/foamsmg
	name = "Toy Submachine Gun"
	desc = "A fully-loaded Donksoft bullpup submachine gun that fires riot grade darts with a 20-round magazine."
	item = /obj/item/gun/ballistic/automatic/c20r/toy
	cost = 5
	surplus = 0
	purchasable_from = UPLINK_NUKE_OPS | UPLINK_CLOWN_OPS

/datum/uplink_item/dangerous/foammachinegun
	name = "Toy Machine Gun"
	desc = "A fully-loaded Donksoft belt-fed machine gun. This weapon has a massive 50-round magazine of devastating \
			riot grade darts, that can briefly incapacitate someone in just one volley."
	item = /obj/item/gun/ballistic/automatic/l6_saw/toy
	cost = 10
	surplus = 0
	purchasable_from = UPLINK_NUKE_OPS | UPLINK_CLOWN_OPS

/datum/uplink_item/dangerous/foampistol
	name = "Toy Pistol with Riot Darts"
	desc = "An innocent-looking toy pistol designed to fire foam darts. Comes loaded with riot-grade \
			darts effective at incapacitating a target."
	item = /obj/item/gun/ballistic/automatic/toy/pistol/riot
	cost = 3
	surplus = 10

/datum/uplink_item/dangerous/motivation
	name = "Motivation"
	desc = "An ancient blade said to have ties with Lavaland's most inner demons. \
			Allows you to cut from a far distance!"
	item = /obj/item/gun/magic/staff/motivation
	cost = 10
	purchasable_from = UPLINK_NUKE_OPS | UPLINK_CLOWN_OPS
