/******************************************
************* Lizard Markings *************
*******************************************/

/datum/sprite_accessory/body_markings
	icon = 'icons/mob/mutant_bodyparts.dmi'
	relevant_layers = list(BODY_ADJ_LAYER)

/datum/sprite_accessory/body_markings/none
	name = "None"
	icon_state = "none"
	relevant_layers = null

/datum/sprite_accessory/body_markings/dtiger
	name = "Dark Tiger Body"
	icon_state = "dtiger"
	gender_specific = 1

/datum/sprite_accessory/body_markings/ltiger
	name = "Light Tiger Body"
	icon_state = "ltiger"
	gender_specific = 1

/datum/sprite_accessory/body_markings/lbelly
	name = "Light Belly"
	icon_state = "lbelly"
	gender_specific = 1

/******************************************
************ Furry Markings ***************
*******************************************/

// These are all color matrixed and applied per-limb by default. you MUST comply with this if you want to have your markings work --Pooj
// use the HumanScissors tool to break your sprite up into the zones easier.
// Although Byond supposedly doesn't have an icon limit anymore of 512 states after 512.1478, just be careful about too many additions.

/datum/sprite_accessory/mam_body_markings
	extra = FALSE
	extra2 = FALSE
	color_src = MATRIXED
	gender_specific = 0
	icon = 'modular_citadel/icons/mob/mam_markings.dmi'
	recommended_species = list("mammal", "xeno", "slimeperson", "podweak")

/datum/sprite_accessory/mam_body_markings/none
	name = "None"
	icon_state = "none"
	ckeys_allowed = list("yousshouldnteverbeseeingthisyoumeme")
	icon = 'modular_citadel/icons/mob/markings_notmammals.dmi'
	relevant_layers = null

/datum/sprite_accessory/mam_body_markings/plain
	name = "Plain"
	icon_state = "plain"
	icon = 'modular_citadel/icons/mob/markings_notmammals.dmi'

/datum/sprite_accessory/mam_body_markings/redpanda
	name = "Redpanda"
	icon_state = "redpanda"

/datum/sprite_accessory/mam_body_markings/bat
	name = "Bat"
	icon_state = "bat"

/datum/sprite_accessory/mam_body_markings/bee
	name = "Bee"
	icon_state = "bee"
	icon = 'modular_citadel/icons/mob/markings_notmammals.dmi'

/datum/sprite_accessory/mam_body_markings/belly
	name = "Belly"
	icon_state = "belly"
	icon = 'modular_citadel/icons/mob/markings_notmammals.dmi'

/datum/sprite_accessory/mam_body_markings/bellyslim
	name = "Bellyslim"
	icon_state = "bellyslim"
	icon = 'modular_citadel/icons/mob/markings_notmammals.dmi'

/datum/sprite_accessory/mam_body_markings/corgi
	name = "Corgi"
	icon_state = "corgi"

/datum/sprite_accessory/mam_body_markings/cow
	name = "Bovine"
	icon_state = "bovine"

/datum/sprite_accessory/mam_body_markings/corvid
	name = "Corvid"
	icon_state = "corvid"

/datum/sprite_accessory/mam_body_markings/dalmation
	name = "Dalmation"
	icon_state = "dalmation"

/datum/sprite_accessory/mam_body_markings/deer
	name = "Deer"
	icon_state = "deer"

/datum/sprite_accessory/mam_body_markings/dog
	name = "Dog"
	icon_state = "dog"

/datum/sprite_accessory/mam_body_markings/eevee
	name = "Eevee"
	icon_state = "eevee"

/datum/sprite_accessory/mam_body_markings/fennec
	name = "Fennec"
	icon_state = "Fennec"

/datum/sprite_accessory/mam_body_markings/fox
	name = "Fox"
	icon_state = "fox"

/datum/sprite_accessory/mam_body_markings/frog
	name = "Frog"
	icon_state = "frog"
	icon = 'modular_citadel/icons/mob/markings_notmammals.dmi'

/datum/sprite_accessory/mam_body_markings/goat
	name = "Goat"
	icon_state = "goat"

/datum/sprite_accessory/mam_body_markings/handsfeet
	name = "Handsfeet"
	icon_state = "handsfeet"
	icon = 'modular_citadel/icons/mob/markings_notmammals.dmi'

/datum/sprite_accessory/mam_body_markings/hawk
	name = "Hawk"
	icon_state = "hawk"

/datum/sprite_accessory/mam_body_markings/husky
	name = "Husky"
	icon_state = "husky"

/datum/sprite_accessory/mam_body_markings/hyena
	name = "Hyena"
	icon_state = "hyena"

/datum/sprite_accessory/mam_body_markings/lab
	name = "Lab"
	icon_state = "lab"

/datum/sprite_accessory/mam_body_markings/insect
	name = "Insect"
	icon_state = "insect"
	icon = 'modular_citadel/icons/mob/markings_notmammals.dmi'

/datum/sprite_accessory/mam_body_markings/otie
	name = "Otie"
	icon_state = "otie"

/datum/sprite_accessory/mam_body_markings/otter
	name = "Otter"
	icon_state = "otter"

/datum/sprite_accessory/mam_body_markings/orca
	name = "Orca"
	icon_state = "orca"

/datum/sprite_accessory/mam_body_markings/panther
	name = "Panther"
	icon_state = "panther"

/datum/sprite_accessory/mam_body_markings/possum
	name = "Possum"
	icon_state = "possum"

/datum/sprite_accessory/mam_body_markings/raccoon
	name = "Raccoon"
	icon_state = "raccoon"

/datum/sprite_accessory/mam_body_markings/pede
	name = "Scolipede"
	icon_state = "scolipede"
	icon = 'modular_citadel/icons/mob/markings_notmammals.dmi'

/datum/sprite_accessory/mam_body_markings/shark
	name = "Shark"
	icon_state = "shark"

/datum/sprite_accessory/mam_body_markings/skunk
	name = "Skunk"
	icon_state = "skunk"

/datum/sprite_accessory/mam_body_markings/sergal
	name = "Sergal"
	icon_state = "sergal"

/datum/sprite_accessory/mam_body_markings/shepherd
	name = "Shepherd"
	icon_state = "shepherd"

/datum/sprite_accessory/mam_body_markings/tajaran
	name = "Tajaran"
	icon_state = "tajaran"

/datum/sprite_accessory/mam_body_markings/tiger
	name = "Tiger"
	icon_state = "tiger"

/datum/sprite_accessory/mam_body_markings/turian
	name = "Turian"
	icon_state = "turian"
	icon = 'modular_citadel/icons/mob/markings_notmammals.dmi'

/datum/sprite_accessory/mam_body_markings/wolf
	name = "Wolf"
	icon_state = "wolf"

/datum/sprite_accessory/mam_body_markings/xeno
	name = "Xeno"
	icon_state = "xeno"
	icon = 'modular_citadel/icons/mob/markings_notmammals.dmi'

/******************************************
************* Insect Markings *************
*******************************************/

/datum/sprite_accessory/insect_fluff
	icon = 'icons/mob/wings.dmi'
	color_src = 0
	relevant_layers = list(BODY_FRONT_LAYER)

/datum/sprite_accessory/insect_fluff/none
	name = "None"
	icon_state = "none"
	relevant_layers = null

/datum/sprite_accessory/insect_fluff/plain
	name = "Plain"
	icon_state = "plain"

/datum/sprite_accessory/insect_fluff/reddish
	name = "Reddish"
	icon_state = "redish"

/datum/sprite_accessory/insect_fluff/royal
	name = "Royal"
	icon_state = "royal"

/datum/sprite_accessory/insect_fluff/gothic
	name = "Gothic"
	icon_state = "gothic"

/datum/sprite_accessory/insect_fluff/lovers
	name = "Lovers"
	icon_state = "lovers"

/datum/sprite_accessory/insect_fluff/whitefly
	name = "White Fly"
	icon_state = "whitefly"

/datum/sprite_accessory/insect_fluff/punished
	name = "Burnt Off"
	icon_state = "punished"

/datum/sprite_accessory/insect_fluff/firewatch
	name = "Firewatch"
	icon_state = "firewatch"

/datum/sprite_accessory/insect_fluff/deathhead
	name = "Deathshead"
	icon_state = "deathhead"

/datum/sprite_accessory/insect_fluff/poison
	name = "Poison"
	icon_state = "poison"

/datum/sprite_accessory/insect_fluff/ragged
	name = "Ragged"
	icon_state = "ragged"

/datum/sprite_accessory/insect_fluff/moonfly
	name = "Moon Fly"
	icon_state = "moonfly"

/datum/sprite_accessory/insect_fluff/snow
	name = "Snow"
	icon_state = "snow"

/datum/sprite_accessory/insect_fluff/oakworm
	name = "Oak Worm"
	icon_state = "oakworm"

/datum/sprite_accessory/insect_fluff/jungle
	name = "Jungle"
	icon_state = "jungle"

/datum/sprite_accessory/insect_fluff/witchwing
	name = "Witch Wing"
	icon_state = "witchwing"

/datum/sprite_accessory/insect_fluff/colored
	name = "Colored (Hair)"
	icon_state = "snow"
	color_src = HAIR

/datum/sprite_accessory/insect_fluff/colored1
	name = "Colored (Primary)"
	icon_state = "snow"
	color_src = MUTCOLORS

/datum/sprite_accessory/insect_fluff/colored2
	name = "Colored (Secondary)"
	icon_state = "snow"
	color_src = MUTCOLORS2

/datum/sprite_accessory/insect_fluff/colored3
	name = "Colored (Tertiary)"
	icon_state = "snow"
	color_src = MUTCOLORS3