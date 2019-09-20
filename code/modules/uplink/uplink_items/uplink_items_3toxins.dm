/**
 * See Uplink_items file for formating and vars
 *
 * Items that can be spawned from an uplink. Can be limited by gamemode.
**/

// Deadly Toxins
/datum/uplink_item/toxins
	category = "Toxins and Biohazardous Chemicals"


//Non-Clown-Ops

//Non-Nuke-Ops

/datum/uplink_item/toxins/sleepy_pen
	name = "Sleepy Pen"
	desc = "A syringe disguised as a functional pen, filled with a potent mix of drugs, including a \
			strong anesthetic and a chemical that prevents the target from speaking. \
			The pen holds one dose of the mixture, and can be refilled with any chemicals. Note that before the target \
			falls asleep, they will be able to move and act."
	item = /obj/item/pen/sleepy
	cost = 4
	exclude_modes = list(/datum/game_mode/nuclear)

//Non-Any-Ops

/datum/uplink_item/toxins/crossbow
	name = "Miniature Energy Crossbow"
	desc = "A short bow mounted across a tiller in miniature. Small enough to \
		fit into a pocket or slip into a bag unnoticed. It will synthesize \
		and fire bolts tipped with a soporific toxin that will briefly stun \
		targets and cause them to gradually lose conciousness. It can produce an \
		infinite number of bolts, but takes time to automatically recharge \
		after each shot."
	item = /obj/item/gun/energy/kinetic_accelerator/crossbow
	cost = 12
	surplus = 50
	exclude_modes = list(/datum/game_mode/nuclear, /datum/game_mode/nuclear/clown_ops)

//Clown-Ops-Only

//Nuke-Ops-Only

//Both Ops

/datum/uplink_item/toxins/bioterror
	name = "Biohazardous Chemical Sprayer"
	desc = "A handheld chemical sprayer that allows a wide dispersal of selected chemicals. Especially tailored by the Tiger \
			Cooperative, the deadly blend it comes stocked with will disorient, damage, and disable your foes... \
			Use with extreme caution, to prevent exposure to yourself and your fellow operatives."
	item = /obj/item/reagent_containers/spray/chemsprayer/bioterror
	cost = 20
	surplus = 0
	include_modes = list(/datum/game_mode/nuclear, /datum/game_mode/nuclear/clown_ops)

/datum/uplink_item/toxins/bioterror
	name = "Box of Bioterror Syringes"
	desc = "A box full of preloaded syringes, containing various chemicals that seize up the victim's motor \
			and broca systems, making it impossible for them to move or speak for some time."
	item = /obj/item/storage/box/syndie_kit/bioterror
	cost = 6
	include_modes = list(/datum/game_mode/nuclear, /datum/game_mode/nuclear/clown_ops)

//Any-one

/datum/uplink_item/toxins/syringe
	name = "Box of Syringes"
	desc = "A box of seven syringes, perfect for use with the dart gun."
	item = /obj/item/storage/box/syringes
	cost = 1
	surplus = 0

/datum/uplink_item/toxins/dart_pistol
	name = "Dart Pistol"
	desc = "A miniaturized version of a normal syringe gun. It is very quiet when fired and can fit into any \
			space a small item can."
	item = /obj/item/gun/syringe/syndicate
	cost = 4
	surplus = 50

/datum/uplink_item/toxins/traitor_chem_bottle
	name = "Poison Kit"
	desc = "An assortment of deadly chemicals packed into a compact box. Comes with a syringe for more precise application."
	item = /obj/item/storage/box/syndie_kit/chemical
	cost = 6
	surplus = 50

/datum/uplink_item/toxins/rad_laser
	name = "Radioactive Microlaser"
	desc = "A radioactive microlaser disguised as a standard Nanotrasen health analyzer. When used, it emits a \
			powerful burst of radiation, which, after a short delay, can incapacitate all but the most protected \
			of humanoids. It has two settings: intensity, which controls the power of the radiation, \
			and wavelength, which controls the delay before the effect kicks in."
	item = /obj/item/healthanalyzer/rad_laser
	cost = 3

/datum/uplink_item/toxins/romerol_kit
	name = "Romerol"
	desc = "A highly experimental bioterror agent which creates dormant nodules to be etched into the grey matter of the brain. \
			On death, these nodules take control of the dead body, causing limited revivification, \
			along with slurred speech, aggression, and the ability to infect others with this agent."
	item = /obj/item/storage/box/syndie_kit/romerol
	cost = 25
	cant_discount = TRUE
