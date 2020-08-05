/datum/sprite_accessory/snouts
	icon = 'icons/mob/mutant_bodyparts.dmi'
	mutant_part_string = "snout"
	relevant_layers = list(BODY_ADJ_LAYER, BODY_FRONT_LAYER)

/datum/sprite_accessory/snouts/sharp
	name = "Sharp"
	icon_state = "sharp"

/datum/sprite_accessory/snouts/round
	name = "Round"
	icon_state = "round"

/datum/sprite_accessory/snouts/sharplight
	name = "Sharp + Light"
	icon_state = "sharplight"

/datum/sprite_accessory/snouts/roundlight
	name = "Round + Light"
	icon_state = "roundlight"

/datum/sprite_accessory/snout/guilmon
	name = "Guilmon"
	icon_state = "guilmon"
	color_src = MATRIXED

//christ this was a mistake, but it's here just in case someone wants to selectively fix -- Pooj
/************* Lizard compatable snoots ***********
/datum/sprite_accessory/snouts/bird
	name = "Beak"
	icon_state = "bird"
	icon = 'modular_citadel/icons/mob/mam_snouts.dmi'
	color_src = MATRIXED

/datum/sprite_accessory/snouts/bigbeak
	name = "Big Beak"
	icon_state = "bigbeak"
	icon = 'modular_citadel/icons/mob/mam_snouts.dmi'
	color_src = MATRIXED

/datum/sprite_accessory/snouts/bug
	name = "Bug"
	icon_state = "bug"
	icon = 'modular_citadel/icons/mob/mam_snouts.dmi'
	extra2 = TRUE
	extra2_color_src = MUTCOLORS3

/datum/sprite_accessory/snouts/elephant
	name = "Elephant"
	icon_state = "elephant"
	icon = 'modular_citadel/icons/mob/mam_snouts.dmi'
	color_src = MATRIXED
	extra = TRUE
	extra_color_src = MUTCOLORS3

/datum/sprite_accessory/snouts/lcanid
	name = "Mammal, Long"
	icon_state = "lcanid"
	icon = 'modular_citadel/icons/mob/mam_snouts.dmi'
	color_src = MATRIXED

/datum/sprite_accessory/snouts/lcanidalt
	name = "Mammal, Long ALT"
	icon_state = "lcanidalt"
	icon = 'modular_citadel/icons/mob/mam_snouts.dmi'
	color_src = MATRIXED

/datum/sprite_accessory/snouts/scanid
	name = "Mammal, Short"
	icon_state = "scanid"
	icon = 'modular_citadel/icons/mob/mam_snouts.dmi'
	color_src = MATRIXED

/datum/sprite_accessory/snouts/scanidalt
	name = "Mammal, Short ALT"
	icon_state = "scanidalt"
	icon = 'modular_citadel/icons/mob/mam_snouts.dmi'
	color_src = MATRIXED

/datum/sprite_accessory/snouts/wolf
	name = "Mammal, Thick"
	icon_state = "wolf"
	icon = 'modular_citadel/icons/mob/mam_snouts.dmi'
	color_src = MATRIXED

/datum/sprite_accessory/snouts/wolfalt
	name = "Mammal, Thick ALT"
	icon_state = "wolfalt"
	icon = 'modular_citadel/icons/mob/mam_snouts.dmi'
	color_src = MATRIXED

/datum/sprite_accessory/snouts/redpanda
	name = "WahCoon"
	icon_state = "wah"
	icon = 'modular_citadel/icons/mob/mam_snouts.dmi'
	color_src = MATRIXED

/datum/sprite_accessory/snouts/rhino
	name = "Horn"
	icon_state = "rhino"
	icon = 'modular_citadel/icons/mob/mam_snouts.dmi'
	color_src = MATRIXED
	extra = TRUE
	extra = MUTCOLORS3

/datum/sprite_accessory/snouts/rodent
	name = "Rodent"
	icon_state = "rodent"
	icon = 'modular_citadel/icons/mob/mam_snouts.dmi'
	color_src = MATRIXED

/datum/sprite_accessory/snouts/husky
	name = "Husky"
	icon_state = "husky"
	icon = 'modular_citadel/icons/mob/mam_snouts.dmi'
	color_src = MATRIXED

/datum/sprite_accessory/snouts/otie
	name = "Otie"
	icon_state = "otie"
	icon = 'modular_citadel/icons/mob/mam_snouts.dmi'
	color_src = MATRIXED

/datum/sprite_accessory/snouts/pede
	name = "Scolipede"
	icon_state = "pede"
	icon = 'modular_citadel/icons/mob/mam_snouts.dmi'
	color_src = MATRIXED

/datum/sprite_accessory/snouts/sergal
	name = "Sergal"
	icon_state = "sergal"
	icon = 'modular_citadel/icons/mob/mam_snouts.dmi'
	color_src = MATRIXED

/datum/sprite_accessory/snouts/shark
	name = "Shark"
	icon_state = "shark"
	color_src = MATRIXED
	icon = 'modular_citadel/icons/mob/mam_snouts.dmi'

/datum/sprite_accessory/snouts/toucan
	name = "Toucan"
	icon_state = "toucan"
	icon = 'modular_citadel/icons/mob/mam_snouts.dmi'
	color_src = MATRIXED
*/

/******************************************
************** Mammal Snouts **************
*******************************************/

/datum/sprite_accessory/mam_snouts
	color_src = MATRIXED
	icon = 'modular_citadel/icons/mob/mam_snouts.dmi'
	recommended_species = list("mammal", "slimeperson", "insect", "podweak")
	mutant_part_string = "snout"
	relevant_layers = list(BODY_ADJ_LAYER, BODY_FRONT_LAYER)

/datum/sprite_accessory/mam_snouts/none
	name = "None"
	icon_state = "none"
	recommended_species = null
	relevant_layers = null

/datum/sprite_accessory/mam_snouts/bird
	name = "Beak"
	icon_state = "bird"

/datum/sprite_accessory/mam_snouts/bigbeak
	name = "Big Beak"
	icon_state = "bigbeak"

/datum/sprite_accessory/mam_snouts/bug
	name = "Bug"
	icon_state = "bug"
	color_src = MUTCOLORS
	extra2 = TRUE
	extra2_color_src = MUTCOLORS3

/datum/sprite_accessory/mam_snouts/elephant
	name = "Elephant"
	icon_state = "elephant"
	extra = TRUE
	extra_color_src = MUTCOLORS3

/datum/sprite_accessory/mam_snouts/lcanid
	name = "Mammal, Long"
	icon_state = "lcanid"

/datum/sprite_accessory/mam_snouts/lcanidalt
	name = "Mammal, Long ALT"
	icon_state = "lcanidalt"

/datum/sprite_accessory/mam_snouts/scanid
	name = "Mammal, Short"
	icon_state = "scanid"

/datum/sprite_accessory/mam_snouts/scanidalt
	name = "Mammal, Short ALT"
	icon_state = "scanidalt"

/datum/sprite_accessory/mam_snouts/scanidalt2
	name = "Mammal, Short ALT 2"
	icon_state = "scanidalt2"

/datum/sprite_accessory/mam_snouts/wolf
	name = "Mammal, Thick"
	icon_state = "wolf"

/datum/sprite_accessory/mam_snouts/wolfalt
	name = "Mammal, Thick ALT"
	icon_state = "wolfalt"

/datum/sprite_accessory/mam_snouts/redpanda
	name = "WahCoon"
	icon_state = "wah"

/datum/sprite_accessory/mam_snouts/redpandaalt
	name = "WahCoon ALT"
	icon_state = "wahalt"

/datum/sprite_accessory/mam_snouts/rhino
	name = "Horn"
	icon_state = "rhino"
	extra = TRUE
	extra = MUTCOLORS3

/datum/sprite_accessory/mam_snouts/rodent
	name = "Rodent"
	icon_state = "rodent"

/datum/sprite_accessory/mam_snouts/husky
	name = "Husky"
	icon_state = "husky"

/datum/sprite_accessory/mam_snouts/otie
	name = "Otie"
	icon_state = "otie"

/datum/sprite_accessory/mam_snouts/pede
	name = "Scolipede"
	icon_state = "pede"

/datum/sprite_accessory/mam_snouts/sergal
	name = "Sergal"
	icon_state = "sergal"

/datum/sprite_accessory/mam_snouts/shark
	name = "Shark"
	icon_state = "shark"

/datum/sprite_accessory/mam_snouts/hshark
	name = "hShark"
	icon_state = "hshark"

/datum/sprite_accessory/mam_snouts/toucan
	name = "Toucan"
	icon_state = "toucan"

/datum/sprite_accessory/mam_snouts/sharp
	name = "Sharp"
	icon_state = "sharp"
	color_src = MUTCOLORS

/datum/sprite_accessory/mam_snouts/round
	name = "Round"
	icon_state = "round"
	color_src = MUTCOLORS

/datum/sprite_accessory/mam_snouts/sharplight
	name = "Sharp + Light"
	icon_state = "sharplight"
	color_src = MUTCOLORS

/datum/sprite_accessory/mam_snouts/roundlight
	name = "Round + Light"
	icon_state = "roundlight"
	color_src = MUTCOLORS


/******************************************
**************** Snouts *******************
*************but higher up*****************/

/datum/sprite_accessory/mam_snouts/fbird
	name = "Beak (Top)"
	icon_state = "fbird"

/datum/sprite_accessory/mam_snouts/fbigbeak
	name = "Big Beak (Top)"
	icon_state = "fbigbeak"

/datum/sprite_accessory/mam_snouts/fbug
	name = "Bug (Top)"
	icon_state = "fbug"
	color_src = MUTCOLORS
	extra2 = TRUE
	extra2_color_src = MUTCOLORS3

/datum/sprite_accessory/mam_snouts/felephant
	name = "Elephant (Top)"
	icon_state = "felephant"
	extra = TRUE
	extra_color_src = MUTCOLORS3

/datum/sprite_accessory/mam_snouts/flcanid
	name = "Mammal, Long (Top)"
	icon_state = "flcanid"

/datum/sprite_accessory/mam_snouts/flcanidalt
	name = "Mammal, Long ALT (Top)"
	icon_state = "flcanidalt"

/datum/sprite_accessory/mam_snouts/fscanid
	name = "Mammal, Short (Top)"
	icon_state = "fscanid"

/datum/sprite_accessory/mam_snouts/fscanidalt
	name = "Mammal, Short ALT (Top)"
	icon_state = "fscanidalt"

/datum/sprite_accessory/mam_snouts/fscanidalt2
	name = "Mammal, Short ALT 2 (Top)"
	icon_state = "fscanidalt2"

/datum/sprite_accessory/mam_snouts/fwolf
	name = "Mammal, Thick (Top)"
	icon_state = "fwolf"

/datum/sprite_accessory/mam_snouts/fwolfalt
	name = "Mammal, Thick ALT (Top)"
	icon_state = "fwolfalt"

/datum/sprite_accessory/mam_snouts/fredpanda
	name = "WahCoon (Top)"
	icon_state = "fwah"

/datum/sprite_accessory/mam_snouts/frhino
	name = "Horn (Top)"
	icon_state = "frhino"
	extra = TRUE
	extra = MUTCOLORS3

/datum/sprite_accessory/mam_snouts/frodent
	name = "Rodent (Top)"
	icon_state = "frodent"

/datum/sprite_accessory/mam_snouts/fhusky
	name = "Husky (Top)"
	icon_state = "fhusky"

/datum/sprite_accessory/mam_snouts/fotie
	name = "Otie (Top)"
	icon_state = "fotie"

/datum/sprite_accessory/mam_snouts/fpede
	name = "Scolipede (Top)"
	icon_state = "fpede"

/datum/sprite_accessory/mam_snouts/fsergal
	name = "Sergal (Top)"
	icon_state = "fsergal"

/datum/sprite_accessory/mam_snouts/fshark
	name = "Shark (Top)"
	icon_state = "fshark"

/datum/sprite_accessory/mam_snouts/ftoucan
	name = "Toucan (Top)"
	icon_state = "ftoucan"

/datum/sprite_accessory/mam_snouts/fsharp
	name = "Sharp (Top)"
	icon_state = "fsharp"
	color_src = MUTCOLORS

/datum/sprite_accessory/mam_snouts/fround
	name = "Round (Top)"
	icon_state = "fround"
	color_src = MUTCOLORS

/datum/sprite_accessory/mam_snouts/fsharplight
	name = "Sharp + Light (Top)"
	icon_state = "fsharplight"
	color_src = MUTCOLORS

/datum/sprite_accessory/mam_snouts/froundlight
	name = "Round + Light (Top)"
	icon_state = "froundlight"
	color_src = MUTCOLORS
