//Synth snouts (This is the most important part)
/datum/sprite_accessory/snouts/mam_snouts/synthliz
	recommended_species = list("synthliz")
	icon = 'modular_citadel/icons/mob/synthliz_snouts.dmi'
	color_src = MUTCOLORS
	name = "Synthetic Lizard - Snout"
	icon_state = "synthliz_basic"
	mutable_category = "HEAD"

/datum/sprite_accessory/snouts/mam_snouts/synthliz/synthliz_under
	icon = 'modular_citadel/icons/mob/synthliz_snouts.dmi'
	color_src = MATRIXED
	name = "Synthetic Lizard - Snout Under"
	icon_state = "synthliz_under"
	matrixed_sections = MATRIX_RED_GREEN

/datum/sprite_accessory/snouts/mam_snouts/synthliz/synthliz_tert
	icon = 'modular_citadel/icons/mob/synthliz_snouts.dmi'
	color_src = MATRIXED
	name = "Synthetic Lizard - Snout Tertiary"
	icon_state = "synthliz_tert"
	matrixed_sections = MATRIX_RED_BLUE

/datum/sprite_accessory/snouts/mam_snouts/synthliz/synthliz_tertunder
	icon = 'modular_citadel/icons/mob/synthliz_snouts.dmi'
	color_src = MATRIXED
	name = "Synthetic Lizard - Snout Tertiary Under"
	icon_state = "synthliz_tertunder"
	matrixed_sections = MATRIX_ALL

//Synth body markings
/datum/sprite_accessory/mam_body_markings/synthliz/synthliz_pecs
	icon = 'modular_citadel/icons/mob/synthliz_body_markings.dmi'
	name = "Synthetic Lizard - Pecs"
	icon_state = "synthlizpecs"
	covered_limbs = list("Chest" = MATRIX_GREEN)

/datum/sprite_accessory/mam_body_markings/synthliz/synthliz_pecslight
	icon = 'modular_citadel/icons/mob/synthliz_body_markings.dmi'
	name = "Synthetic Lizard - Pecs Light"
	icon_state = "synthlizpecslight"
	covered_limbs = list("Chest" = MATRIX_GREEN_BLUE, "Left Arm" = MATRIX_BLUE, "Right Arm" = MATRIX_BLUE, "Left Leg" = MATRIX_GREEN, "Right Leg" = MATRIX_GREEN)

/datum/sprite_accessory/mam_body_markings/synthliz
	recommended_species = list("synthliz")
	icon = 'modular_citadel/icons/mob/synthliz_body_markings.dmi'
	name = "Synthetic Lizard - Plates"
	icon_state = "synthlizscutes"
	covered_limbs = list("Chest" = MATRIX_GREEN, "Left Leg" = MATRIX_GREEN, "Right Leg" = MATRIX_GREEN)

//Synth tails
/datum/sprite_accessory/tails/mam_tails/synthliz
	recommended_species = list("synthliz")
	icon = 'modular_citadel/icons/mob/synthliz_tails.dmi'
	color_src = MUTCOLORS
	name = "Synthetic Lizard"
	icon_state = "synthliz"

/datum/sprite_accessory/tails_animated/mam_tails_animated/synthliz
	recommended_species = list("synthliz")
	icon = 'modular_citadel/icons/mob/synthliz_tails.dmi'
	color_src = MUTCOLORS
	name = "Synthetic Lizard"
	icon_state = "synthliz"

//Synth Antennae
/datum/sprite_accessory/antenna/synthliz
	recommended_species = list("synthliz")
	icon = 'modular_citadel/icons/mob/synthliz_antennas.dmi'
	color_src = MUTCOLORS
	name = "Synthetic Lizard - Antennae"
	icon_state = "synth_antennae"

/datum/sprite_accessory/antenna/synthliz/synthliz_curled
	icon = 'modular_citadel/icons/mob/synthliz_antennas.dmi'
	color_src = MUTCOLORS
	name = "Synthetic Lizard - Curled"
	icon_state = "synth_curled"

/datum/sprite_accessory/antenna/synthliz/synth_horns
	icon = 'modular_citadel/icons/mob/synthliz_antennas.dmi'
	color_src = MUTCOLORS
	name = "Synthetic Lizard - Horns"
	icon_state = "synth_horns"

/datum/sprite_accessory/antenna/synthliz/synth_hornslight
	icon = 'modular_citadel/icons/mob/synthliz_antennas.dmi'
	color_src = MATRIXED
	name = "Synthetic Lizard - Horns Light"
	icon_state = "synth_hornslight"
	matrixed_sections = MATRIX_RED_BLUE

/datum/sprite_accessory/antenna/synthliz/synth_short
	icon = 'modular_citadel/icons/mob/synthliz_antennas.dmi'
	color_src = MUTCOLORS
	name = "Synthetic Lizard - Short"
	icon_state = "synth_short"

/datum/sprite_accessory/antenna/synthliz/synth_sharp
	icon = 'modular_citadel/icons/mob/synthliz_antennas.dmi'
	color_src = MUTCOLORS
	name = "Synthetic Lizard - Sharp"
	icon_state = "synth_sharp"

/datum/sprite_accessory/antenna/synthliz/synth_sharplight
	icon = 'modular_citadel/icons/mob/synthliz_antennas.dmi'
	color_src = MATRIXED
	name = "Synthetic Lizard - Sharp Light"
	icon_state = "synth_sharplight"
	matrixed_sections = MATRIX_RED_BLUE

/datum/sprite_accessory/antenna/synthliz/synthliz_thick
	icon = 'modular_citadel/icons/mob/synthliz_antennas.dmi'
	color_src = MUTCOLORS
	name = "Synthetic Lizard - Thick"
	icon_state = "synth_thick"

/datum/sprite_accessory/antenna/synthliz/synth_thicklight
	icon = 'modular_citadel/icons/mob/synthliz_antennas.dmi'
	color_src = MATRIXED
	name = "Synthetic Lizard - Thick Light"
	icon_state = "synth_thicklight"
	matrixed_sections = MATRIX_RED_BLUE

//Synth Taurs (Ported from Virgo)
/datum/sprite_accessory/taur/synthliz
	name = "Virgo - Synthetic Lizard"
	icon_state = "synthlizard"
	taur_mode = STYLE_PAW_TAURIC
	recommended_species = list("synthliz")
	matrixed_sections = MATRIX_RED_GREEN

/datum/sprite_accessory/taur/synthliz/inv
	name = "Virgo - Synthetic Lizard (Inverted)"
	icon_state = "synthlizardinv"

/datum/sprite_accessory/taur/synthliz/feline
	name = "Virgo - Synthetic Feline"
	icon_state = "synthfeline"

/datum/sprite_accessory/taur/synthliz/feline/inv
	name = "Virgo - Synthetic Feline (Inverted)"
	icon_state = "synthfelineinv"

/datum/sprite_accessory/taur/synthliz/horse
	name = "Virgo - Synthetic Horse"
	icon_state = "synthhorse"
	taur_mode = STYLE_HOOF_TAURIC
	alt_taur_mode = STYLE_PAW_TAURIC

/datum/sprite_accessory/taur/synthliz/horse/inv
	name = "Virgo - Synthetic Horse (Inverted)"
	icon_state = "synthhorseinv"

/datum/sprite_accessory/taur/synthliz/wolf
	name = "Virgo - Synthetic Wolf"
	icon_state = "synthwolf"

/datum/sprite_accessory/taur/synthliz/wolf/inv
	name = "Virgo - Synthetic Wolf (Inverted)"
	icon_state = "synthwolfinv"
