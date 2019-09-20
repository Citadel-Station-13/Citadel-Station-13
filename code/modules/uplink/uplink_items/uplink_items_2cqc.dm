/**
 * See Uplink_items file for formating and vars
 *
 * Items that can be spawned from an uplink. Can be limited by gamemode.
**/

// Melee Weapons
/datum/uplink_item/cqc
	category = "Close-Quarters Combat Equipment"

//Non-Clown-Ops

/datum/uplink_item/cqc/doublesword
	name = "Double-Bladed Energy Sword"
	desc = "The double-bladed energy sword requires to hands to weild, and does slightly more damage than a standard energy sword. \
			It is capable of deflecting all energy projectiles, and can easily block melee strikes."
	item = /obj/item/twohanded/dualsaber
	player_minimum = 25
	cost = 16
	exclude_modes = list(/datum/game_mode/nuclear/clown_ops)

/datum/uplink_item/dangerous/doublesword/get_discount()
	return pick(4;0.8,2;0.65,1;0.5)

/datum/uplink_item/cqc/sword
	name = "Energy Sword"
	desc = "A small, pocketable device that can produce a deadly blade of energy when activated. Can block some attacks, but don't rely on it. \
			Activating it or attacking with it produces a loud, distinctive noise."
	item = /obj/item/melee/transforming/energy/sword/saber
	cost = 7
	exclude_modes = list(/datum/game_mode/nuclear/clown_ops)

/datum/uplink_item/cqc/rapier
	name = " Plastitanium Rapier"
	desc = "An incredibly sharp rapier capable of piercing all forms of armor with ease. \
			The rapier comes with its own jet black sheath, however this will generally alert hostiles to your allegience. \
			The rapier itself can be used to deflect melee strikes to some degree, and it can be used as a powerful projectile in a pinch."
	item = /obj/item/storage/belt/sabre/rapier
	cost = 8
	exclude_modes = list(/datum/game_mode/nuclear/clown_ops)

//Non-Nuke-Ops

//Non-Any-Ops

/datum/uplink_item/cqc/guardian
	name = "Holoparasites"
	desc = "Though capable of near sorcerous feats via use of hardlight holograms and nanomachines, they require an \
			organic host as a home base and source of fuel. Holoparasites come in various types and share damage with their host."
	item = /obj/item/storage/box/syndie_kit/guardian
	cost = 15
	refundable = TRUE
	cant_discount = TRUE
	surplus = 0
	exclude_modes = list(/datum/game_mode/nuclear, /datum/game_mode/nuclear/clown_ops)
	player_minimum = 25
	restricted = TRUE
	refund_path = /obj/item/guardiancreator/tech/choose/traitor

//Clown-Ops-Only

/datum/uplink_item/cqc/clownsword
	name = "Bananium Energy Sword"
	desc = "An energy sword that deals no damage, but will slip anyone it contacts, be it by melee attack, thrown \
	impact, or just stepping on it. Beware friendly fire, as even anti-slip shoes will not protect against it."
	item = /obj/item/melee/transforming/energy/sword/bananium
	cost = 3
	surplus = 0
	include_modes = list(/datum/game_mode/nuclear/clown_ops)

datum/uplink_item/cqc/taeclowndo_shoes
	name = "Tae-clown-do Shoes"
	desc = "A pair of shoes for the most elite agents of the honkmotherland. They grant the mastery of taeclowndo with some honk-fu moves as long as they're worn."
	cost = 12
	item = /obj/item/clothing/shoes/clown_shoes/taeclowndo
	include_modes = list(/datum/game_mode/nuclear/clown_ops)

//Both Ops

/datum/uplink_item/cqc/cqc
	name = "CQC Manual"
	desc = "A manual that teaches a single user tactical hand-to-hand Close-Quarters Combat before self-destructing."
	item = /obj/item/book/granter/martial/cqc
	include_modes = list(/datum/game_mode/nuclear, /datum/game_mode/nuclear/clown_ops)
	cost = 13
	surplus = 0

/datum/uplink_item/cqc/martialarts
	name = "Martial Arts Scroll"
	desc = "This scroll contains the secrets of an ancient martial arts technique. You will master unarmed combat, \
			deflecting all ranged weapon fire, but you also refuse to use dishonorable ranged weaponry."
	item = /obj/item/book/granter/martial/carp
	cost = 17
	surplus = 0
	exclude_modes = list(/datum/game_mode/nuclear, /datum/game_mode/nuclear/clown_ops)

/datum/uplink_item/cqc/combatglovesnano
	name = "Nanotech Combat Gloves"
	desc = "A pair of gloves that are fireproof and shock resistant, and features nanotechnology to teach the wearer the art of krav maga."
	item = /obj/item/clothing/gloves/krav_maga/combatglovesplus
	cost = 5
	include_modes = list(/datum/game_mode/nuclear, /datum/game_mode/nuclear/clown_ops)
	surplus = 0

//Any-one


/datum/uplink_item/cqc/throwingweapons
	name = "Box of Throwing Weapons"
	desc = "A box of throwing weapons, containing 5 shurikens and 2 reinforced bolas. \
			The bolas can knock a target down and slow them, while the shurikens will embed into targets."
	item = /obj/item/storage/box/syndie_kit/throwing_weapons
	cost = 3

/datum/uplink_item/cqc/dehy_carp
	name = "Dehydrated Space Carp"
	desc = "Looks like a plush toy carp, but just add water and it becomes a real-life space carp! Activate in \
			your hand before use so it knows not to kill you."
	item = /obj/item/toy/plush/carpplushie/dehy_carp
	cost = 1

/datum/uplink_item/cqc/edagger
	name = "Energy Dagger"
	desc = "A tiny dagger made of energy that looks and functions as a pen when deactivated. Activating or attacking with it produces a loud, distinctive noise. \
			Very easy to conceal, often goes unnoticed during searches, and makes an effective weapon when thrown."
	item = /obj/item/pen/edagger
	cost = 2

/datum/uplink_item/cqc/rapid
	name = "Gloves of the North Star"
	desc = "These gloves let the user punch people very fast. Does not improve the attack speed of any equipped weapons or the meaty fists of a hulk."
	item = /obj/item/clothing/gloves/rapid
	cost = 8

/datum/uplink_item/cqc/powerfist
	name = "Power Fist"
	desc = "The power-fist is a metal gauntlet with a built-in piston-ram powered by an external gas supply.\
		 Upon hitting a target, the piston-ram will extend forward to make contact for some serious damage. \
		 Using a wrench on the piston valve will allow you to tweak the amount of gas used per punch to \
		 deal extra damage and hit targets further. Use a screwdriver to take out any attached tanks."
	item = /obj/item/melee/powerfist
	cost = 7

/datum/uplink_item/cqc/plastitanium_toolbox
	name = "Plastitanium Toolbox"
	desc = "A particularly heavy duty toolbox. Great for letting out your inner ape and breaking things."
	item = /obj/item/storage/toolbox/plastitanium
	cost = 2		//18 damage on mobs, 50 on objects, 4.5 stam/hit

/datum/uplink_item/cqc/switchblade
	name = "Switchblade"
	desc = "A small, retractable blade that can easily be concealed in one's pocket.  \
			It is a lot quieter than the edagger but for a greater cost, while being much more likely to be noticed in a search."
	item = /obj/item/switchblade
	cost = 3