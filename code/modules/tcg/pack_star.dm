/datum/tcg_card/pack_star
	pack = 'icons/obj/tcg/pack_star.dmi'

/datum/tcg_card/pack_star/golem
	name = "Adamantine Golem"
	desc = "An adamantine golem, immune to magic and being able to coordinate other golems, has a great power in combat."
	rules = "Holy. Taunt."
	icon_state = "golem"

	mana_cost = 4
	attack = 4
	health = 5

	faction = "Unique"
	rarity = "Rare"
	card_type = "Unit"

/obj/item/tcg_card/special/golem
	datum_type = /datum/tcg_card/pack_star/golem

/datum/tcg_card/pack_star/xenomaid
	name = "Lusty Xenomorph Maid"
	desc = "Just a lusty xenomorph maid, nothing to see here."
	rules = "Blocker. Each turn, gain -1/-1."
	icon_state = "xenomaid"

	mana_cost = 3
	attack = 6
	health = 6

	faction = "Unique"
	rarity = "Epic"
	card_type = "Unit"

/obj/item/tcg_card/special/xenomaid
	datum_type = /datum/tcg_card/pack_star/xenomaid

/datum/tcg_card/pack_star/morph
	name = "Morph"
	desc = "A revolting, pulsating pile of flesh that can mimic everything it sees."
	rules = "On summon: Copy stats of an opponent's card."
	icon_state = "morph"

	mana_cost = 4
	attack = 0
	health = 1

	faction = "Unique"
	rarity = "Common"
	card_type = "Unit"

/obj/item/tcg_card/special/morph
	datum_type = /datum/tcg_card/pack_star/morph

/datum/tcg_card/pack_star/demonic_miner
	name = "Demonic Miner"
	desc = "An soul of extremely geared miner, driven crazy or possessed by the demonic forces here, either way a terrifying enemy."
	rules = "Each turn: Deal 1 damage to all the creatures on the field."
	icon_state = "demonic_miner"

	mana_cost = 7
	attack = 4
	health = 5

	faction = "Unique"
	rarity = "Rare"
	card_type = "Unit"

/obj/item/tcg_card/special/demonic_miner
	datum_type = /datum/tcg_card/pack_star/demonic_miner

/datum/tcg_card/pack_star/wendigo
	name = "Wendigo"
	desc = "A mythological man-eating legendary creature, you probably aren't going to survive this."
	rules = ""
	icon_state = "wendigo"

	mana_cost = 6
	attack = 5
	health = 3

	faction = "Unique"
	rarity = "Common"
	card_type = "Unit"

/obj/item/tcg_card/special/wendigo
	datum_type = /datum/tcg_card/pack_star/wendigo

/datum/tcg_card/pack_star/honk
	name = "H.O.N.K. Mech"
	desc = "Produced by \"Tyranny of Honk, INC\", this exosuit is designed as heavy clown-support. Used to spread the fun and joy of life. HONK!"
	rules = "Taunt."
	icon_state = "honk"

	mana_cost = 8
	attack = 6
	health = 8

	faction = "Unique"
	rarity = "Epic"
	card_type = "Unit"

/obj/item/tcg_card/special/honk
	datum_type = /datum/tcg_card/pack_star/honk

/datum/tcg_card/pack_star/ratvar
	name = "Clockwork Slab"
	desc = "A link between clockwork servants and the Celestial Derelict. It contains information, recites scripture, and is Servant's most vital tool."
	rules = "Equipped unit gains Clockwork and can't attack units with Holy."
	icon_state = "ratvar"

	mana_cost = 2
	attack = 3
	health = 0

	faction = "Unique"
	rarity = "Common"
	card_type = "Equipment"

/obj/item/tcg_card/special/ratvar
	datum_type = /datum/tcg_card/pack_star/ratvar

/datum/tcg_card/pack_star/hierophant
	name = "Hierophant Club"
	desc = "The strange technology of this large club allows various nigh-magical feats. It used to beat you, but now you can set the beat."
	rules = "Give equipped unit First Strike."
	icon_state = "hierophant"

	mana_cost = 4
	attack = 2
	health = 0

	faction = "Unique"
	rarity = "Rare"
	card_type = "Equipment"

/obj/item/tcg_card/special/hierophant
	datum_type = /datum/tcg_card/pack_star/hierophant

/datum/tcg_card/pack_star/abductor
	name = "Alien Gland"
	desc = "A nausea-inducing hunk of twisting flesh and metal. These things are often found after people were abducted by grey-skinned aliens."
	rules = "Each turn: Flip a coin. If heads, unit gain +1/+1. If tails, unit gains -2/-1."
	icon_state = "abductor"

	mana_cost = 2
	attack = 0
	health = 0

	faction = "Unique"
	rarity = "Common"
	card_type = "Equipment"

/obj/item/tcg_card/special/abductor
	datum_type = /datum/tcg_card/pack_star/abductor

/datum/tcg_card/pack_star/space_carp
	name = "Space Carp"
	desc = "A failed weaponery experiment, looking like a ferocious, fang-bearing creature that resembles a fish."
	rules = ""
	icon_state = "space_carp"

	mana_cost = 1
	attack = 2
	health = 1

	faction = "Unique"
	rarity = "Common"
	card_type = "Unit"

/obj/item/tcg_card/special/space_carp
	datum_type = /datum/tcg_card/pack_star/space_carp

/datum/tcg_card/pack_star/spess_pirate
	name = "Space Pirate"
	desc = "Space Pirate does whatever he wants because he is free. Sadly, Space Rum insn't free."
	rules = "On summon: Draw 2 cards. If there are no spells, discard them."
	icon_state = "spess_pirate"

	mana_cost = 4
	attack = 3
	health = 2

	faction = "Unique"
	rarity = "Rare"
	card_type = "Unit"

/obj/item/tcg_card/special/spess_pirate
	datum_type = /datum/tcg_card/pack_star/spess_pirate

/datum/tcg_card/pack_star/gondola
	name = "Gondola"
	desc = "Gondola is the silent walker. Having no hands he embodies the Taoist principle of wu-wei (non-action) while his smiling facial expression shows his utter and complete acceptance of the world as it is. Its hide is extremely valuable."
	rules = "Taunt. Holy."
	icon_state = "gondola"

	mana_cost = 6
	attack = 0
	health = 6

	faction = "Unique"
	rarity = "Epic"
	card_type = "Unit"

/obj/item/tcg_card/special/gondola
	datum_type = /datum/tcg_card/pack_star/gondola

/datum/tcg_card/pack_star/phazon
	name = "Phazon"
	desc = "The pinnacle of scientific research and pride of Nanotrasen, Phazon uses cutting edge bluespace technology and expensive materials."
	rules = "Whenever this unit takes damage, flip a coin. If heads, take no damage. If tails, take double damage."
	icon_state = "phazon"

	mana_cost = 8
	attack = 5
	health = 7

	faction = "Unique"
	rarity = "Rare"
	card_type = "Unit"

/obj/item/tcg_card/special/phazon
	datum_type = /datum/tcg_card/pack_star/phazon

//Ultimate Exodia cards. I really, really doubt that someone will ever find them.

/datum/tcg_card/exodia
	pack = 'icons/obj/tcg/pack_star.dmi'

/datum/tcg_card/exodia/exodia_singulo
	name = "Singularity"
	desc = "A monstrous gravitational singularity, pitch black(but not quiet) and very menacings."
	rules = "This card doesn't leave field. At the end of each turn: Remove all the cards(except other Exodia cards) from the field."
	icon_state = "exodia_singularity"

	mana_cost = 8

	faction = "Exodia"
	rarity = "Exodia"
	card_type = "Spell"

/datum/tcg_card/exodia/exodia_tesla
	name = "Energy Orb"
	desc = "An orb made out of hypercharged plasma. An ultimate bug zapper."
	rules = "This card doesn't leave field. Every turn all units take 4 damage."
	icon_state = "exodia_tesla"

	mana_cost = 8

	faction = "Exodia"
	rarity = "Exodia"
	card_type = "Spell"

/datum/tcg_card/exodia/exodia_narie
	name = "Nar-Sie"
	desc = "An avatar of the Nar-Sie, one of the Eldritch Gods."
	rules = "This card doesn't leave field. Every turn all units take 1 damage and you restore 1 lifeshard."
	icon_state = "exodia_narsie"

	mana_cost = 8

	faction = "Exodia"
	rarity = "Exodia"
	card_type = "Spell"

/datum/tcg_card/exodia/exodia_ratvar
	name = "Ratvar"
	desc = "Ratvar, the god of cogs and clockwork mechanisms, was trapped by Nar-Sie a long ago."
	rules = "This card doesn't leave field. Every turn enemy hero recieves 2 lifeshard damage."
	icon_state = "exodia_ratvar"

	mana_cost = 8

	faction = "Exodia"
	rarity = "Exodia"
	card_type = "Spell"

/datum/tcg_card/exodia/exodia
	name = "Eldritch Horror"
	desc = "The Eldritch Horror is a long forgotten demon that was the beginning of everything. Afterwards, his creations revolted and left him abadoned in endless void."
	rules = "This card doesn't leave field. If all other 4 Exodia cards are on the field(Singularity, Energy Orb, Nar-Sie and Ratvar), the game is won."
	icon_state = "exodia_eldritch"

	mana_cost = 8

	faction = "Exodia"
	rarity = "Unique" //No drop lads
	card_type = "Spell"

/obj/item/tcg_card/special/exodia_singulo
	datum_type = /datum/tcg_card/exodia/exodia_singulo

/obj/item/tcg_card/special/exodia_tesla
	datum_type = /datum/tcg_card/exodia/exodia_tesla

/obj/item/tcg_card/special/exodia_narie
	datum_type = /datum/tcg_card/exodia/exodia_narie

/obj/item/tcg_card/special/exodia_ratvar
	datum_type = /datum/tcg_card/exodia/exodia_ratvar

/obj/item/tcg_card/special/exodia
	datum_type = /datum/tcg_card/exodia/exodia

