/datum/tcg_card/pack_nuclear
	pack = 'icons/obj/tcg/pack_nuclear.dmi'

/datum/tcg_card/pack_nuclear/cayenne
	name = "Cayenne"
	desc = "A failed Syndicate experiment in weaponized space carp technology, it now serves as a lovable mascot."
	rules = "Only playable when there are other Syndicate units on the field."
	icon_state = "cayenne"

	mana_cost = 4
	attack = 4
	health = 3

	faction = "Syndicate"
	rarity = "Rare"
	card_type = "Unit"

/datum/tcg_card/pack_nuclear/esword
	name = "Energy Sword"
	desc = "Hard-light sword that doesn't leave burns. Don't ask questions."
	rules = ""
	icon_state = "esword"

	mana_cost = 3
	attack = 2
	health = 0

	faction = "Syndicate"
	rarity = "Common"
	card_type = "Equipment"

/datum/tcg_card/pack_nuclear/stechkin
	name = "Stechkin Pistol"
	desc = "A small, easily concealable 10mm handgun. Has a threaded barrel for suppressors."
	rules = "When equipping this card, flip it so opponent won't see it. Flip the card after the first attack."
	icon_state = "stechkin"

	mana_cost = 2
	attack = 2
	health = 0

	faction = "Syndicate"
	rarity = "Common"
	card_type = "Equipment"

/datum/tcg_card/pack_nuclear/c20r
	name = "C-20R SMG"
	desc = "A bullpup two-round burst .45 SMG, designated 'C-20r'. Has a 'Scarborough Arms - Per falcis, per pravitas' buttstamp."
	rules = "After attack, flip a coin. If heads, leave the weapon. If tails, unequip this card."
	icon_state = "c20r"

	mana_cost = 4
	attack = 4
	health = 0

	faction = "Syndicate"
	rarity = "Rare"
	card_type = "Equipment"

/datum/tcg_card/pack_nuclear/l6saw
	name = "L6 Saw LMG"
	desc = "A heavily modified 1.95x129mm light machine gun, designated 'L6 SAW'. Has 'Aussec Armoury - 2531' engraved on the receiver below the designation."
	rules = "After equipped unit dies, this card goes to the bottom of draw deck"
	icon_state = "l6saw"

	mana_cost = 8
	attack = 6
	health = 0

	faction = "Syndicate"
	rarity = "Epic"
	card_type = "Equipment"

/datum/tcg_card/pack_nuclear/bulldog
	name = "Bulldog Shotgun"
	desc = "A semi-auto, mag-fed shotgun for combat in narrow corridors, nicknamed 'Bulldog' by boarding parties. Compatible only with specialized 8-round drum magazines."
	rules = "After attack, deal 1 damage to enemy units next to the attacked one."
	icon_state = "bulldog"

	mana_cost = 3
	attack = 3
	health = 0

	faction = "Syndicate"
	rarity = "Rare"
	card_type = "Equipment"

/datum/tcg_card/pack_nuclear/nuke_op_leader
	name = "Nuclear Team Commander"
	desc = "All commanders of elite nuclear teams are equipped with high-tier gear and weaponery. And, sometimes, gaming cards."
	rules = "Squad Tactics. Give all Syndicate units on your side +1/0."
	icon_state = "nuke_op_leader"

	mana_cost = 5
	attack = 3
	health = 4

	faction = "Syndicate"
	rarity = "Epic"
	card_type = "Unit"

/datum/tcg_card/pack_nuclear/nuke_op
	name = "Nuclear Team Commander"
	desc = "An unequipped nuclear operative, ready to buy some gear and go full ham!"
	rules = "Squad Tactics. On summon: Search your deck for Syndicate equipment. Equip it on this unit. Shuffle it afterwards."
	icon_state = "nuke_op"

	mana_cost = 3
	attack = 2
	health = 3

	faction = "Syndicate"
	rarity = "Common"
	card_type = "Unit"

/datum/tcg_card/pack_nuclear/dark_gygax
	name = "Dark Gygax"
	desc = "A lightweight exosuit, painted in a dark scheme. This model appears to have some modifications."
	rules = "Squad Tactics."
	icon_state = "dark_gygax"

	mana_cost = 6
	attack = 8
	health = 4

	faction = "Syndicate"
	rarity = "Epic"
	card_type = "Unit"

/datum/tcg_card/pack_nuclear/mauler
	name = "Mauler"
	desc = "Heavy-duty, combat exosuit, developed off of the existing Marauder model. A perfect killing machine equipped with best weaponery in the world."
	rules = "Squad Tactics. Deadeye."
	icon_state = "mauler"

	mana_cost = 8
	attack = 8
	health = 8

	faction = "Syndicate"
	rarity = "Legendary"
	card_type = "Unit"

/datum/tcg_card/pack_nuclear/saboteur
	name = "Syndicate Saboteur Cyborg"
	desc = "A streamlined engineering cyborg, equipped with covert modules. Allows to sabotage all the systems you want without being suspicious."
	rules = "Block the first spell your opponent plays against your hero."
	icon_state = "saboteur"

	mana_cost = 3
	attack = 1
	health = 3

	faction = "Syndicate"
	rarity = "Rare"
	card_type = "Unit"

/datum/tcg_card/pack_nuclear/medic
	name = "Syndicate Medical Cyborg"
	desc = "A combat medical cyborg. Has limited offensive potential, but makes more than up for it with its support capabilities."
	rules = "Each turn you can give one of your units 0/+1."
	icon_state = "medic"

	mana_cost = 4
	attack = 1
	health = 2

	faction = "Syndicate"
	rarity = "Rare"
	card_type = "Unit"

/datum/tcg_card/pack_nuclear/combat
	name = "Syndicate Assault Cyborg"
	desc = "A cyborg designed and programmed for systematic extermination of non-Syndicate personnel."
	rules = "Squad Tactics. Fury."
	icon_state = "combat"

	mana_cost = 5
	attack = 4
	health = 4

	faction = "Syndicate"
	rarity = "Epic"
	card_type = "Unit"

/datum/tcg_card/pack_nuclear/emag
	name = "Cryptographic Sequencer"
	desc = "It's a card with a magnetic strip attached to some circuitry."
	rules = "Convert an enemy silicon unit to your side."
	icon_state = "emag"

	mana_cost = 4

	faction = "Syndicate"
	rarity = "Common"
	card_type = "Spell"

/datum/tcg_card/pack_nuclear/bomb
	name = "Syndicate Bomb"
	desc = "A large and menacing device. Can be bolted down with a wrench."
	rules = "Deal 6 damage to all units on the field after 2 turns."
	icon_state = "bomb"

	mana_cost = 6

	faction = "Syndicate"
	rarity = "Rare"
	card_type = "Spell"

/datum/tcg_card/pack_nuclear/honkbomb
	name = "H.O.N.K. Bomb"
	desc = "A bomb filled to the brim with bananium and dehydrated clowns!"
	rules = "Search your deck for up to 3 Clowns. Play them for free. Shuffle the deck afterwards."
	icon_state = "honkbomb"

	mana_cost = 8

	faction = "Syndicate"
	rarity = "Epic"
	card_type = "Spell"

/datum/tcg_card/pack_nuclear/assault_pod
	name = "Assault Pod"
	desc = "Raining Steel. Nothing personnel, just disky."
	rules = "Summon up to 3 units from your hand with 4 mana discount each."
	icon_state = "assault_pod"

	mana_cost = 8

	faction = "Syndicate"
	rarity = "Epic"
	card_type = "Spell"

/datum/tcg_card/pack_nuclear/c4
	name = "C4"
	desc = "A bunch of plastic explosives wired together."
	rules = "Deal 2 damage to an enemy unit."
	icon_state = "c4"

	mana_cost = 1

	faction = "Syndicate"
	rarity = "Common"
	card_type = "Spell"

/datum/tcg_card/pack_nuclear/emp
	name = "EMP Grenade"
	desc = "A modern-looking grenade which creates a powerful EMP upon activation. Do not eat."
	rules = "Deal 2 damage to an enemy silicon unit."
	icon_state = "emp"

	mana_cost = 0

	faction = "Syndicate"
	rarity = "Common"
	card_type = "Spell"

/datum/tcg_card/pack_nuclear/zombie
	name = "Romerol Zombie"
	desc = "A horrible abomination, resembling a dead human. Has green skin and red claws. Wait, is it blood dripping from them?"
	rules = "After killing an enemy unit, search your deck for a Zombie and summon it for free."
	icon_state = "zombie"

	mana_cost = 8
	attack = 4
	health = 3

	faction = "Syndicate"
	rarity = "Epic"
	card_type = "Unit"

/datum/tcg_card/pack_nuclear/north_star
	name = "North Star Armbands"
	desc = "The armbands of a deadly martial artist. Makes you pretty keen to put an end to evil in an extremely violent manner."
	rules = "Equipped unit can attack twice per turn."
	icon_state = "north_star"

	mana_cost = 4

	faction = "Syndicate"
	rarity = "Rare"
	card_type = "Equipment"

/datum/tcg_card/pack_nuclear/fastdetonation
	name = "Big-Ass Red Button"
	desc = "A menacing red button. What could it do?"
	rules = "Activate all spells that require several turns to occur."
	icon_state = "fastdetonation"

	mana_cost = 2

	faction = "Syndicate"
	rarity = "Common"
	card_type = "Spell"

/datum/tcg_card/pack_nuclear/rpg
	name = "PML-9 Rocket Launcher"
	desc = "A reusable rocket propelled grenade launcher. The words \"NT this way\" and an arrow have been written near the barrel."
	rules = "When equipped unit attacks enemy units, flip a coin. If heads, destroy the unit. If tails, deal 1/2 damage instead of the full blow."
	icon_state = "rpg"

	mana_cost = 8
	attack = 6

	faction = "Syndicate"
	rarity = "Legendary"
	card_type = "Equipment"

/datum/tcg_card/pack_nuclear/darkhonk
	name = "Dark H.O.N.K. Mech"
	desc = "Produced by \"Tyranny of Honk, INC\", this exosuit is designed as heavy clown-support. This one was painted black for maximum HONKing!"
	rules = "Taunt. Squad Tactics. Blocker."
	icon_state = "darkhonk"

	mana_cost = 8
	attack = 6
	health = 8

	faction = "Syndicate"
	rarity = "Epic"
	card_type = "Unit"

/datum/tcg_card/pack_nuclear/shielded_hardsuit
	name = "Shielded Blood-red Hardsuit"
	desc = "An advanced version of Gorlex Maradeurs' hardsuit with built-in energy shielding."
	rules = "Give equipped unit First Strike."
	icon_state = "shielded_hardsuit"

	mana_cost = 4
	attack = 0
	health = 4

	faction = "Syndicate"
	rarity = "Epic"
	card_type = "Equipment"

/datum/tcg_card/pack_nuclear/nuclear_disk
	name = "Nuclear Authentication Disk"
	desc = "Better keep this safe."
	rules = "Give equipped unit Taunt. After the equipped unit dies, re-equip this card to the killer."
	icon_state = "nuclear_disk"

	mana_cost = 0
	attack = 1
	health = 1

	faction = "Syndicate"
	rarity = "Epic"
	card_type = "Equipment"

/datum/tcg_card/pack_nuclear/buzzkill
	name = "Buzzkill grenade"
	desc = "A whole swarm of angry bees filled with deadly toxins. Nasty!"
	rules = "Hivemind."
	icon_state = "buzzkill"

	mana_cost = 4
	attack = 1
	health = 5

	faction = "Syndicate"
	rarity = "Rare"
	card_type = "Unit"

/datum/tcg_card/pack_nuclear/syndicate_minibomb
	name = "Syndicate Minibomb"
	desc = "A syndicate manufactured explosive used to sow destruction and chaos."
	rules = "Deal 3 damage to an enemy unit and units adjacent to it."
	icon_state = "syndicate_minibomb"

	mana_cost = 3

	faction = "Syndicate"
	rarity = "Common"
	card_type = "Spell"

/datum/tcg_card/pack_nuclear/viscerator
	name = "Viscerator"
	desc = "A small yet deadly machine, designed to rip it's targets apart."
	rules = "Gain +1/+1 for every other viscerator on field."
	icon_state = "viscerator"

	mana_cost = 2
	attack = 3
	health = 1

	faction = "Syndicate"
	rarity = "Common"
	card_type = "Unit"

/datum/tcg_card/pack_nuclear/cqc
	name = "CQC Manual"
	desc = "A manual that teaches a single user tactical Close-Quarters Combat before self-destructing."
	rules = "Give equipped unit Deadeye and First Strike."
	icon_state = "cqc"

	mana_cost = 4
	attack = 4
	health = 3

	faction = "Syndicate"
	rarity = "Epic"
	card_type = "Equipment"

/datum/tcg_card/pack_nuclear/holoparasite
	name = "Holoparasite"
	desc = "A mysterious being that stands by its charge, ever vigilant."
	rules = "On summon: \"Link\" this unit to another unit. Whenever this unit takes damage, instead, transfer all damage to the linked unit."
	icon_state = "holoparasite"

	mana_cost = 6
	attack = 8
	health = 0

	faction = "Syndicate"
	rarity = "Legendary"
	card_type = "Unit"

/datum/tcg_card/pack_nuclear/rapier
	name = "Rapier"
	desc = "An elegant plastitanium rapier with a diamond tip and coated in a specialized knockout poison."
	rules = ""
	icon_state = "rapier"

	mana_cost = 2
	attack = 3
	health = 0

	faction = "Syndicate"
	rarity = "Rare"
	card_type = "Equipment"

/datum/tcg_card/pack_nuclear/sniper
	name = "Sniper Rifle"
	desc = "A long ranged weapon that does significant damage. No, you can't quickscope."
	rules = "Give equipped unit Deadeye."
	icon_state = "sniper"

	mana_cost = 6
	attack = 5
	health = 0

	faction = "Syndicate"
	rarity = "Epic"
	card_type = "Equipment"

/datum/tcg_card/pack_nuclear/honksword
	name = "Bananium Sword"
	desc = "An elegant weapon, for a more \"civilized\" age."
	rules = "Equipped unit does not deal damage. Instead, it taps the attacked card without activating it's effects."
	icon_state = "honksword"

	mana_cost = 3
	attack = 0
	health = 0

	faction = "Syndicate"
	rarity = "Common"
	card_type = "Equipment"

/datum/tcg_card/pack_nuclear/mustache
	name = "Mustache Grenade"
	desc = "A handsomely-attired teargas grenade."
	rules = "Unequip all enemy units. Unequipped equipment cards must be discarded."
	icon_state = "mustache"

	mana_cost = 5

	faction = "Syndicate"
	rarity = "Common"
	card_type = "Spell"

/datum/tcg_card/pack_nuclear/taeclowndo
	name = "Tae-Clown-Do"
	desc = "A pair of clown shoes, infused with bananium. Rumors say that these can teach their wearer the art of Tae-Clown-Do."
	rules = "Flip a coin. If heads, your enemy skips a turn. If tails, you skip a turn instead."
	icon_state = "taeclowndo"

	mana_cost = 3

	faction = "Syndicate"
	rarity = "Epic"
	card_type = "Spell"
