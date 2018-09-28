/datum/sprite_accessory
	var/extra = FALSE
	var/extra_icon = 'modular_citadel/icons/mob/mam_bodyparts.dmi'
	var/extra_color_src = MUTCOLORS2						//The color source for the extra overlay.
	var/extra2 = FALSE
	var/extra2_icon = 'modular_citadel/icons/mob/mam_bodyparts.dmi'
	var/extra2_color_src = MUTCOLORS3
	var/list/ckeys_allowed

/* tbi eventually idk
/datum/sprite_accessory/legs/digitigrade_mam
	name = "Anthro Digitigrade Legs"
	icon = 'modular_citadel/icons/mob/mam_bodyparts.dmi'
*/

/datum/sprite_accessory/moth_wings/none
	name = "None"
	icon_state = "none"

/***************** Alphabetical Order please ***************
************* Keep it to Ears, Tails, Tails Animated *********/


/datum/sprite_accessory/tails/lizard/none
	name = "None"
	icon_state = "None"

/datum/sprite_accessory/tails_animated/lizard/none
	name = "None"
	icon_state = "None"

/******************************************
************ Human Ears/Tails *************
*******************************************/

/datum/sprite_accessory/tails/human/ailurus
	name = "Red Panda"
	icon_state = "ailurus"
	color_src = 0
	icon = 'modular_citadel/icons/mob/mam_bodyparts.dmi'

/datum/sprite_accessory/ears/human/axolotl
	name = "Axolotl"
	icon_state = "axolotl"

/datum/sprite_accessory/tails/human/axolotl
	name = "Axolotl"
	icon_state = "axolotl"

/datum/sprite_accessory/tails_animated/axolotl
	name = "Axolotl"
	icon_state = "axolotl"

/datum/sprite_accessory/ears/human/bear
	name = "Bear"
	icon_state = "bear"
	icon = 'modular_citadel/icons/mob/mam_bodyparts.dmi'

/datum/sprite_accessory/tails/human/bear
	name = "Bear"
	icon_state = "bear"
	icon = 'modular_citadel/icons/mob/mam_bodyparts.dmi'

/datum/sprite_accessory/tails_animated/human/bear
	name = "Bear"
	icon_state = "bear"
	icon = 'modular_citadel/icons/mob/mam_bodyparts.dmi'

/datum/sprite_accessory/tails/human/catbig
	name = "Cat, Big"
	icon_state = "catbig"
	icon = 'modular_citadel/icons/mob/mam_bodyparts.dmi'

/datum/sprite_accessory/tails_animated/human/catbig
	name = "Cat, Big"
	icon_state = "catbig"
	icon = 'modular_citadel/icons/mob/mam_bodyparts.dmi'

/datum/sprite_accessory/ears/human/cow
	name = "Cow"
	icon_state = "cow"
	icon = 'modular_citadel/icons/mob/mam_bodyparts.dmi'
	gender_specific = 1

/datum/sprite_accessory/tails/human/cow
	name = "Cow"
	icon_state = "cow"
	icon = 'modular_citadel/icons/mob/mam_bodyparts.dmi'

/datum/sprite_accessory/tails_animated/human/cow
	name = "Cow"
	icon_state = "cow"
	icon = 'modular_citadel/icons/mob/mam_bodyparts.dmi'

/datum/sprite_accessory/ears/human/curled
	name = "Curled Horn"
	icon_state = "horn1"
	icon = 'modular_citadel/icons/mob/mam_bodyparts.dmi'
	color_src = MUTCOLORS3

/datum/sprite_accessory/tails/human/eevee
	name = "Eevee"
	icon_state = "eevee"
	extra = TRUE
	icon = 'modular_citadel/icons/mob/mam_bodyparts.dmi'

/datum/sprite_accessory/ears/human/eevee
	name = "Eevee"
	icon_state = "eevee"
	icon = 'modular_citadel/icons/mob/mam_bodyparts.dmi'

/datum/sprite_accessory/tails_animated/human/eevee
	name = "Eevee"
	icon_state = "eevee"
	extra = TRUE
	icon = 'modular_citadel/icons/mob/mam_bodyparts.dmi'

/datum/sprite_accessory/ears/human/elephant
	name = "Elephant"
	icon_state = "elephant"
	icon = 'modular_citadel/icons/mob/mam_bodyparts.dmi'

//datum/sprite_accessory/ears/elf
//	name = "Elf"
//	icon_state = "elf"
//	icon = 'modular_citadel/icons/mob/mam_bodyparts.dmi'
//	ckeys_allowed = list("atiefling")

/datum/sprite_accessory/ears/fennec
	name = "Fennec"
	icon_state = "fennec"
	icon = 'modular_citadel/icons/mob/mam_bodyparts.dmi'
	hasinner = 1

/datum/sprite_accessory/tails/human/fennec
	name = "Fennec"
	icon_state = "fennec"
	icon = 'modular_citadel/icons/mob/mam_bodyparts.dmi'

/datum/sprite_accessory/tails_animated/human/fennec
	name = "Fennec"
	icon_state = "fennec"
	icon = 'modular_citadel/icons/mob/mam_bodyparts.dmi'

/datum/sprite_accessory/ears/fish
	name = "Fish"
	icon_state = "fish"
	icon = 'modular_citadel/icons/mob/mam_bodyparts.dmi'
	color_src = MUTCOLORS3

/datum/sprite_accessory/tails/human/fish
	name = "Fish"
	icon_state = "fish"
	icon = 'modular_citadel/icons/mob/mam_bodyparts.dmi'
	extra = TRUE
	extra_color_src = MUTCOLORS3

/datum/sprite_accessory/tails_animated/human/fish
	name = "Fish"
	icon_state = "fish"
	icon = 'modular_citadel/icons/mob/mam_bodyparts.dmi'
	extra = TRUE
	extra_color_src = MUTCOLORS3

/datum/sprite_accessory/ears/fox
	name = "Fox"
	icon_state = "fox"
	hasinner = 1
	icon = 'modular_citadel/icons/mob/mam_bodyparts.dmi'

/datum/sprite_accessory/tails/human/fox
	name = "Fox"
	icon_state = "fox"
	icon = 'modular_citadel/icons/mob/mam_bodyparts.dmi'
	extra = TRUE

/datum/sprite_accessory/tails_animated/human/fox
	name = "Fox"
	icon_state = "fox"
	icon = 'modular_citadel/icons/mob/mam_bodyparts.dmi'
	extra = TRUE

/datum/sprite_accessory/tails/human/horse
	name = "Horse"
	icon_state = "horse"
	icon = 'modular_citadel/icons/mob/mam_bodyparts.dmi'
	color_src = HAIR

/datum/sprite_accessory/tails_animated/human/horse
	name = "Horse"
	icon_state = "horse"
	icon = 'modular_citadel/icons/mob/mam_bodyparts.dmi'
	color_src = HAIR

/datum/sprite_accessory/tails/human/husky
	name = "Husky"
	icon_state = "husky"
	icon = 'modular_citadel/icons/mob/mam_bodyparts.dmi'
	extra = TRUE

/datum/sprite_accessory/tails_animated/human/husky
	name = "Husky"
	icon_state = "husky"
	icon = 'modular_citadel/icons/mob/mam_bodyparts.dmi'
	extra = TRUE

	/datum/sprite_accessory/tails/human/insect
	name = "Insect"
	icon_state = "insect"
	icon = 'modular_citadel/icons/mob/mam_bodyparts.dmi'

/datum/sprite_accessory/tails_animated/human/insect
	name = "insect"
	icon_state = "insect"
	icon = 'modular_citadel/icons/mob/mam_bodyparts.dmi'

/datum/sprite_accessory/ears/human/jellyfish
	name = "Jellyfish"
	icon_state = "jellyfish"
	color_src = HAIR

/datum/sprite_accessory/tails/human/kitsune
	name = "Kitsune"
	icon_state = "kitsune"
	extra = TRUE
	extra_color_src = MUTCOLORS2
	icon = 'modular_citadel/icons/mob/mam_bodyparts.dmi'

/datum/sprite_accessory/tails_animated/human/kitsune
	name = "Kitsune"
	icon_state = "kitsune"
	extra = TRUE
	extra_color_src = MUTCOLORS2
	icon = 'modular_citadel/icons/mob/mam_bodyparts.dmi'

/datum/sprite_accessory/ears/lab
	name = "Dog, Floppy"
	icon_state = "lab"
	hasinner = 0
	icon = 'modular_citadel/icons/mob/mam_bodyparts.dmi'

/datum/sprite_accessory/ears/murid
	name = "Murid"
	icon_state = "murid"
	icon = 'modular_citadel/icons/mob/mam_bodyparts.dmi'

/datum/sprite_accessory/tails/human/murid
	name = "Murid"
	icon_state = "murid"
	color_src = 0
	icon = 'modular_citadel/icons/mob/mam_bodyparts.dmi'

/datum/sprite_accessory/tails_animated/human/murid
	name = "Murid"
	icon_state = "murid"
	color_src = 0
	icon = 'modular_citadel/icons/mob/mam_bodyparts.dmi'

/datum/sprite_accessory/ears/human/otie
	name = "Otusian"
	icon_state = "otie"
	hasinner= 1
	icon = 'modular_citadel/icons/mob/mam_bodyparts.dmi'

/datum/sprite_accessory/tails/human/otie
	name = "Otusian"
	icon_state = "otie"
	icon = 'modular_citadel/icons/mob/mam_bodyparts.dmi'

/datum/sprite_accessory/tails_animated/human/otie
	name = "Otusian"
	icon_state = "otie"
	icon = 'modular_citadel/icons/mob/mam_bodyparts.dmi'

/datum/sprite_accessory/tails/orca
	name = "Orca"
	icon_state = "orca"
	extra = TRUE
	icon = 'modular_citadel/icons/mob/mam_bodyparts.dmi'

/datum/sprite_accessory/tails_animated/orca
	name = "Orca"
	icon_state = "orca"
	extra = TRUE
	icon = 'modular_citadel/icons/mob/mam_bodyparts.dmi'

/datum/sprite_accessory/ears/human/pede
	name = "Scolipede"
	icon_state = "pede"
	icon = 'modular_citadel/icons/mob/mam_bodyparts.dmi'
	extra = TRUE
	color_src = MUTCOLORS2
	extra_color_src = MUTCOLORS3

/datum/sprite_accessory/tails/human/pede
	name = "Scolipede"
	icon_state = "pede"
	icon = 'modular_citadel/icons/mob/mam_bodyparts.dmi'
	extra = TRUE
	extra2 = TRUE
	color_src = MUTCOLORS
	extra_color_src = MUTCOLORS2
	extra2_color_src = MUTCOLORS3

/datum/sprite_accessory/tails_animated/human/pede
	name = "Scolipede"
	icon_state = "pede"
	icon = 'modular_citadel/icons/mob/mam_bodyparts.dmi'
	extra = TRUE
	extra2 = TRUE
	color_src = MUTCOLORS
	extra_color_src = MUTCOLORS2
	extra2_color_src = MUTCOLORS3

/datum/sprite_accessory/ears/human/rabbit
    name = "Rabbit"
    icon_state = "rabbit"
    hasinner= 1
    icon = 'modular_citadel/icons/mob/mam_bodyparts.dmi'

/datum/sprite_accessory/tails/human/rabbit
	name = "Rabbit"
	icon_state = "rabbit"
	color_src = 0
	icon = 'modular_citadel/icons/mob/mam_bodyparts.dmi'

/datum/sprite_accessory/tails_animated/human/rabbit
	name = "Rabbit"
	icon_state = "rabbit"
	color_src = 0
	icon = 'modular_citadel/icons/mob/mam_bodyparts.dmi'

/datum/sprite_accessory/ears/human/sergal
	name = "Sergal"
	icon_state = "sergal"
	hasinner= 1
	icon = 'modular_citadel/icons/mob/mam_bodyparts.dmi'

/datum/sprite_accessory/tails/human/sergal
	name = "Sergal"
	icon_state = "sergal"
	icon = 'modular_citadel/icons/mob/mam_bodyparts.dmi'

/datum/sprite_accessory/tails_animated/human/sergal
	name = "Sergal"
	icon_state = "sergal"
	icon = 'modular_citadel/icons/mob/mam_bodyparts.dmi'

/datum/sprite_accessory/ears/human/skunk
	name = "skunk"
	icon_state = "skunk"
	icon = 'modular_citadel/icons/mob/mam_bodyparts.dmi'

/datum/sprite_accessory/tails/human/skunk
	name = "skunk"
	icon_state = "skunk"
	color_src = 0

/datum/sprite_accessory/tails_animated/human/skunk
	name = "skunk"
	icon_state = "skunk"
	color_src = 0

/datum/sprite_accessory/tails/human/shark
	name = "Shark"
	icon_state = "shark"
	color_src = MUTCOLORS
	icon = 'modular_citadel/icons/mob/mam_bodyparts.dmi'

/datum/sprite_accessory/tails/human/shark/datashark
	name = "datashark"
	icon_state = "datashark"
	color_src = 0
	icon = 'modular_citadel/icons/mob/mam_bodyparts.dmi'

/datum/sprite_accessory/ears/squirrel
	name = "Squirrel"
	icon_state = "squirrel"
	hasinner= 1
	icon = 'modular_citadel/icons/mob/mam_bodyparts.dmi'

/datum/sprite_accessory/tails/human/squirrel
	name = "Squirrel"
	icon_state = "squirrel"
	icon = 'modular_citadel/icons/mob/mam_bodyparts.dmi'

/datum/sprite_accessory/tails_animated/human/squirrel
	name = "Squirrel"
	icon_state = "squirrel"
	icon = 'modular_citadel/icons/mob/mam_bodyparts.dmi'

/datum/sprite_accessory/tails/human/yentacle
	name = "Tentacle"
	icon_state = "tentacle"
	icon = 'modular_citadel/icons/mob/mam_bodyparts.dmi'

/datum/sprite_accessory/tails_animated/human/tentacle
	name = "Tentacle"
	icon_state = "tentacle"
	icon = 'modular_citadel/icons/mob/mam_bodyparts.dmi'

/datum/sprite_accessory/ears/wolf
	name = "Wolf"
	icon_state = "wolf"
	hasinner = 1
	icon = 'modular_citadel/icons/mob/mam_bodyparts.dmi'

/datum/sprite_accessory/tails/human/wolf
	name = "Wolf"
	icon_state = "wolf"
	icon = 'modular_citadel/icons/mob/mam_bodyparts.dmi'

/datum/sprite_accessory/tails_animated/human/wolf
	name = "Wolf"
	icon_state = "wolf"
	icon = 'modular_citadel/icons/mob/mam_bodyparts.dmi'

/******************************************
*************** Body Parts ****************
*******************************************/

/datum/sprite_accessory/mam_ears
	icon = 'modular_citadel/icons/mob/mam_bodyparts.dmi'
/datum/sprite_accessory/mam_ears/none
	name = "None"

/datum/sprite_accessory/mam_tails
	icon = 'modular_citadel/icons/mob/mam_bodyparts.dmi'

/datum/sprite_accessory/mam_tails/none
	name = "None"

/datum/sprite_accessory/mam_tails_animated
	icon = 'modular_citadel/icons/mob/mam_bodyparts.dmi'

/datum/sprite_accessory/mam_tails_animated/none
	name = "None"

/******************************************
**************** Snouts *******************
*******************************************/

/datum/sprite_accessory/snouts/none
	name = "None"
	icon_state = "none"
	icon = 'modular_citadel/icons/mob/mam_bodyparts.dmi'

/datum/sprite_accessory/snouts/bird
	name = "Beak"
	icon_state = "bird"
	icon = 'modular_citadel/icons/mob/mam_bodyparts.dmi'
	color_src = MUTCOLORS3

/datum/sprite_accessory/snouts/bigbeak
	name = "Big Beak"
	icon_state = "bigbeak"
	icon = 'modular_citadel/icons/mob/mam_bodyparts.dmi'
	color_src = MUTCOLORS3

/datum/sprite_accessory/snouts/elephant
	name = "Elephant"
	icon_state = "elephant"
	icon = 'modular_citadel/icons/mob/mam_bodyparts.dmi'
	extra = TRUE
	extra_color_src = MUTCOLORS3

/datum/sprite_accessory/snouts/lcanid
	name = "Fox, Long"
	icon_state = "lcanid"
	icon = 'modular_citadel/icons/mob/mam_bodyparts.dmi'
	extra = TRUE

/datum/sprite_accessory/snouts/scanid
	name = "Fox, Short"
	icon_state = "scanid"
	icon = 'modular_citadel/icons/mob/mam_bodyparts.dmi'
	extra = TRUE

/datum/sprite_accessory/snouts/wolf
	name = "Wolf"
	icon_state = "wolf"
	icon = 'modular_citadel/icons/mob/mam_bodyparts.dmi'
	extra = TRUE

/datum/sprite_accessory/snouts/rhino
	name = "Horn"
	icon_state = "rhino"
	icon = 'modular_citadel/icons/mob/mam_bodyparts.dmi'
	extra = TRUE
	extra = MUTCOLORS3

/datum/sprite_accessory/snouts/husky
	name = "Husky"
	icon_state = "husky"
	icon = 'modular_citadel/icons/mob/mam_bodyparts.dmi'
	extra = TRUE

/datum/sprite_accessory/snouts/otie
	name = "Otie"
	icon_state = "otie"
	icon = 'modular_citadel/icons/mob/mam_bodyparts.dmi'
	extra = TRUE

/datum/sprite_accessory/snouts/pede
	name = "Scolipede"
	icon_state = "pede"
	icon = 'modular_citadel/icons/mob/mam_bodyparts.dmi'
	extra = TRUE
	color_src = MUTCOLORS
	extra_color_src = MUTCOLORS2

/datum/sprite_accessory/snouts/sergal
	name = "Sergal"
	icon_state = "sergal"
	icon = 'modular_citadel/icons/mob/mam_bodyparts.dmi'
	color_src = MUTCOLORS2

/datum/sprite_accessory/snouts/toucan
	name = "Toucan"
	icon_state = "toucan"
	icon = 'modular_citadel/icons/mob/mam_bodyparts.dmi'
	color_src = MUTCOLORS3

/******************************************
************ Actual Species ***************
*******************************************/

/datum/sprite_accessory/mam_tails/ailurus
	name = "Ailurus"
	icon_state = "ailurus"
	extra = TRUE

/datum/sprite_accessory/mam_tails_animated/ailurus
	name = "Ailurus"
	icon_state = "ailurus"
	extra = TRUE

/datum/sprite_accessory/mam_ears/axolotl
	name = "Axolotl"
	icon_state = "axolotl"

/datum/sprite_accessory/mam_tails/axolotl
	name = "Axolotl"
	icon_state = "axolotl"

/datum/sprite_accessory/mam_tails_animated/axolotl
	name = "Axolotl"
	icon_state = "axolotl"

/datum/sprite_accessory/mam_ears/bear
	name = "Bear"
	icon_state = "bear"

/datum/sprite_accessory/mam_tails/bear
	name = "Bear"
	icon_state = "bear"

/datum/sprite_accessory/mam_tails_animated/bear
	name = "Bear"
	icon_state = "bear"

/datum/sprite_accessory/mam_ears/catbig
	name = "Cat, Big"
	icon_state = "catbig"
	hasinner = 1

/datum/sprite_accessory/mam_tails/catbig
	name = "Cat, Big"
	icon_state = "catbig"

/datum/sprite_accessory/mam_tails_animated/catbig
	name = "Cat, Big"
	icon_state = "catbig"

/datum/sprite_accessory/mam_ears/cow
	name = "Cow"
	icon_state = "cow"
	gender_specific = 1

/datum/sprite_accessory/mam_tail/cow
	name = "Cow"
	icon_state = "cow"

/datum/sprite_accessory/mam_tails_animated/cow
	name = "Cow"
	icon_state = "cow"

/datum/sprite_accessory/mam_ears/curled
	name = "Curled Horn"
	icon_state = "horn1"

/datum/sprite_accessory/mam_ears/deer
	name = "Deer"
	icon_state = "deer"

/datum/sprite_accessory/mam_tails/eevee
	name = "Eevee"
	icon_state = "eevee"
	extra = TRUE

/datum/sprite_accessory/mam_ears/eevee
	name = "Eevee"
	icon_state = "eevee"

/datum/sprite_accessory/mam_tails_animated/eevee
	name = "Eevee"
	icon_state = "eevee"
	extra = TRUE

/datum/sprite_accessory/mam_ears/elephant
	name = "Elephant"
	icon_state = "elephant"

/datum/sprite_accessory/mam_ears/fennec
	name = "Fennec"
	icon_state = "fennec"
	hasinner = 1

/datum/sprite_accessory/mam_tails/fennec
	name = "Fennec"
	icon_state = "fennec"

/datum/sprite_accessory/mam_tails_animated/fennec
	name = "Fennec"
	icon_state = "fennec"

/datum/sprite_accessory/mam_ears/fish
	name = "Fish"
	icon_state = "fish"
	color_src = MUTCOLORS3

/datum/sprite_accessory/mam_tails/human/fish
	name = "Fish"
	icon_state = "fish"
	extra = TRUE
	extra_color_src = MUTCOLORS3

/datum/sprite_accessory/mam_tails_animated/human/fish
	name = "Fish"
	icon_state = "fish"
	extra = TRUE
	extra_color_src = MUTCOLORS3

/datum/sprite_accessory/mam_ears/fox
	name = "Fox"
	icon_state = "fox"
	hasinner = 1

/datum/sprite_accessory/mam_tails/fox
	name = "Fox"
	icon_state = "fox"
	extra = TRUE

/datum/sprite_accessory/mam_tails_animated/fox
	name = "Fox"
	icon_state = "fox"
	extra = TRUE

/datum/sprite_accessory/mam_tails/hawk
	name = "Hawk"
	icon_state = "hawk"

/datum/sprite_accessory/mam_tails_animated/hawk
	name = "Hawk"
	icon_state = "hawk"

/datum/sprite_accessory/mam_tails/horse
	name = "Horse"
	icon_state = "horse"
	color_src = HAIR

/datum/sprite_accessory/mam_tails_animated/horse
	name = "Horse"
	icon_state = "Horse"
	color_src = HAIR

/datum/sprite_accessory/mam_ears/husky
	name = "Husky"
	icon_state = "wolf"
	icon = 'modular_citadel/icons/mob/mam_bodyparts.dmi'
	extra = TRUE

/datum/sprite_accessory/mam_tails/husky
	name = "Husky"
	icon_state = "husky"
	extra = TRUE

/datum/sprite_accessory/mam_tails_animated/husky
	name = "Husky"
	icon_state = "husky"
	extra = TRUE

datum/sprite_accessory/mam_tails/insect
	name = "Insect"
	icon_state = "insect"

/datum/sprite_accessory/mam_tails_animated/insect
	name = "Insect"
	icon_state = "insect"

/datum/sprite_accessory/mam_ears/kangaroo
	name = "kangaroo"
	icon_state = "kangaroo"
	extra = TRUE

/datum/sprite_accessory/mam_tails/kangaroo
	name = "kangaroo"
	icon_state = "kangaroo"

/datum/sprite_accessory/mam_tails_animated/kangaroo
	name = "kangaroo"
	icon_state = "kangaroo"

/datum/sprite_accessory/mam_ears/jellyfish
	name = "Jellyfish"
	icon_state = "jellyfish"
	color_src = HAIR

/datum/sprite_accessory/mam_tails/kitsune
	name = "Kitsune"
	icon_state = "kitsune"
	extra = TRUE

/datum/sprite_accessory/mam_tails_animated/kitsune
	name = "Kitsune"
	icon_state = "kitsune"
	extra = TRUE

/datum/sprite_accessory/mam_ears/lab
	name = "Dog, Long"
	icon_state = "lab"

/datum/sprite_accessory/mam_tails/lab
	name = "Lab"
	icon_state = "lab"

/datum/sprite_accessory/mam_tails_animated/lab
	name = "Lab"
	icon_state = "lab"

/datum/sprite_accessory/mam_ears/murid
	name = "Murid"
	icon_state = "murid"

/datum/sprite_accessory/mam_tails/murid
	name = "Murid"
	icon_state = "murid"
	color_src = 0

/datum/sprite_accessory/mam_tails_animated/murid
	name = "Murid"
	icon_state = "murid"
	color_src = 0

/datum/sprite_accessory/mam_ears/neko
	name = "Neko"
	icon_state = "cat"
	hasinner = 1
	color_src = HAIR
	icon = 'modular_citadel/icons/mob/mutant_bodyparts.dmi'

/datum/sprite_accessory/mam_tails/neko
	name = "Neko"
	icon_state = "cat"
	color_src = HAIR
	icon = 'modular_citadel/icons/mob/mutant_bodyparts.dmi'

/datum/sprite_accessory/mam_tails_animated/neko
	name = "Neko"
	icon_state = "cat"
	color_src = HAIR
	icon = 'modular_citadel/icons/mob/mutant_bodyparts.dmi'

/datum/sprite_accessory/mam_ears/otie
	name = "Otusian"
	icon_state = "otie"
	hasinner= 1

/datum/sprite_accessory/mam_tails/otie
	name = "Otusian"
	icon_state = "otie"

/datum/sprite_accessory/mam_tails_animated/otie
	name = "Otusian"
	icon_state = "otie"

/datum/sprite_accessory/mam_tails/orca
	name = "Orca"
	icon_state = "orca"
	extra = TRUE

/datum/sprite_accessory/mam_tails_animated/orca
	name = "Orca"
	icon_state = "orca"
	extra = TRUE

/datum/sprite_accessory/mam_ears/pede
	name = "Scolipede"
	icon_state = "pede"
	icon = 'modular_citadel/icons/mob/mam_bodyparts.dmi'
	extra = TRUE
	color_src = MUTCOLORS2
	extra_color_src = MUTCOLORS3

/datum/sprite_accessory/mam_tails/pede
	name = "Scolipede"
	icon_state = "pede"
	icon = 'modular_citadel/icons/mob/mam_bodyparts.dmi'
	extra = TRUE
	extra2 = TRUE
	color_src = MUTCOLORS
	extra_color_src = MUTCOLORS2
	extra2_color_src = MUTCOLORS3

/datum/sprite_accessory/mam_tails_animated/pede
	name = "Scolipede"
	icon_state = "pede"
	icon = 'modular_citadel/icons/mob/mam_bodyparts.dmi'
	extra = TRUE
	extra2 = TRUE
	color_src = MUTCOLORS
	extra_color_src = MUTCOLORS2
	extra2_color_src = MUTCOLORS3

/datum/sprite_accessory/mam_ears/rabbit
    name = "Rabbit"
    icon_state = "rabbit"
    hasinner= 1

/datum/sprite_accessory/mam_tails/rabbit
	name = "Rabbit"
	icon_state = "rabbit"

/datum/sprite_accessory/mam_tails_animated/rabbit
	name = "Rabbit"
	icon_state = "rabbit"

/datum/sprite_accessory/mam_ears/sergal
	name = "Sergal"
	icon_state = "sergal"
	hasinner= 1

/datum/sprite_accessory/mam_tails/sergal
	name = "Sergal"
	icon_state = "sergal"

/datum/sprite_accessory/mam_tails_animated/sergal
	name = "Sergal"
	icon_state = "sergal"

/datum/sprite_accessory/mam_ears/skunk
	name = "skunk"
	icon_state = "skunk"

/datum/sprite_accessory/mam_tails/skunk
	name = "skunk"
	icon_state = "skunk"
	color_src = 0
	extra = TRUE

/datum/sprite_accessory/mam_tails_animated/skunk
	name = "skunk"
	icon_state = "skunk"
	color_src = 0
	extra = TRUE

/datum/sprite_accessory/mam_tails/shark
	name = "Shark"
	icon_state = "shark"
	color_src = MUTCOLORS

/datum/sprite_accessory/mam_tails_animated/shark
	name = "Shark"
	icon_state = "shark"
	color_src = MUTCOLORS

/datum/sprite_accessory/mam_tails/shepherd
	name = "Shepherd"
	icon_state = "shepherd"
	extra = TRUE
	extra2 = TRUE

/datum/sprite_accessory/mam_tails_animated/shepherd
	name = "Shepherd"
	icon_state = "shepherd"
	extra = TRUE
	extra2 = TRUE

/datum/sprite_accessory/mam_ears/squirrel
	name = "Squirrel"
	icon_state = "squirrel"
	hasinner= 1

/datum/sprite_accessory/mam_tails/squirrel
	name = "Squirrel"
	icon_state = "squirrel"

/datum/sprite_accessory/mam_tails_animated/squirrel
	name = "Squirrel"
	icon_state = "squirrel"

datum/sprite_accessory/mam_tails/tentacle
	name = "Tentacle"
	icon_state = "tentacle"

/datum/sprite_accessory/mam_tails_animated/tentacle
	name = "Tentacle"
	icon_state = "tentacle"

/datum/sprite_accessory/mam_ears/wolf
	name = "Wolf"
	icon_state = "wolf"
	hasinner = 1

/datum/sprite_accessory/mam_tails/wolf
	name = "Wolf"
	icon_state = "wolf"

/datum/sprite_accessory/mam_tails_animated/wolf
	name = "Wolf"
	icon_state = "wolf"

/******************************************
************ Body Markings ****************
*******************************************/

/datum/sprite_accessory/mam_body_markings
	extra = TRUE
	extra2 = TRUE
	icon = 'modular_citadel/icons/mob/mam_body_markings.dmi'

/datum/sprite_accessory/mam_body_markings/none
	name = "None"
	icon_state = "none"

/datum/sprite_accessory/mam_body_markings/ailurus
	name = "Red Panda"
	icon_state = "ailurus"
	gender_specific = 1

/datum/sprite_accessory/mam_body_markings/belly
	name = "Bee"
	icon_state = "bee"
	color_src = MUTCOLORS3
	gender_specific = 1

/datum/sprite_accessory/mam_body_markings/bee
	name = "Belly"
	icon_state = "belly"
	gender_specific = 1

/datum/sprite_accessory/mam_body_markings/corgi
	name = "Corgi"
	icon_state = "corgi"
	color_src = MUTCOLORS2
	extra_color_src = MUTCOLORS3
	gender_specific = 1

/datum/sprite_accessory/mam_body_markings/cow
	name = "Cow"
	icon_state = "cow"
	color_src = MUTCOLORS2
	extra_color_src = MUTCOLORS3
	gender_specific = 1

/datum/sprite_accessory/mam_body_markings/corvid
	name = "Crow"
	icon_state = "corvid"
	gender_specific = 1

/datum/sprite_accessory/mam_body_markings/deer
	name = "Deer"
	icon_state = "deer"
	color_src = MUTCOLORS2
	extra_color_src = MUTCOLORS3
	gender_specific = 1

/datum/sprite_accessory/mam_body_markings/eevee
	name = "Eevee"
	icon_state = "eevee"
	color_src = MUTCOLORS3

/datum/sprite_accessory/mam_body_markings/fennec
	name = "Fennec"
	icon_state = "Fennec"
	gender_specific = 1

/datum/sprite_accessory/mam_body_markings/fox
	name = "Fox"
	icon_state = "fox"
	gender_specific = 1

/datum/sprite_accessory/mam_body_markings/frog
	name = "Frog"
	icon_state = "frog"
	gender_specific = 1
	color_src = MUTCOLORS2

/datum/sprite_accessory/mam_body_markings/hawk
	name = "Hawk"
	icon_state = "hawk"
	gender_specific = 1

/datum/sprite_accessory/mam_body_markings/husky
	name = "Husky"
	icon_state = "husky"
	gender_specific = 1

/datum/sprite_accessory/mam_body_markings/moth
	name = "Moth"
	icon_state = "moth"
	color_src = MUTCOLORS2
	extra_color_src = MUTCOLORS3
	gender_specific = 1

/datum/sprite_accessory/mam_body_markings/otie
	name = "Otie"
	icon_state = "otie"
	gender_specific = 1

/datum/sprite_accessory/mam_body_markings/orca
	name = "Orca"
	icon_state = "orca"
	color_src = MUTCOLORS2
	gender_specific = 1

/datum/sprite_accessory/mam_body_markings/pede
	name = "Scolipede"
	icon_state = "pede"
	extra = TRUE
	extra_color_src = MUTCOLORS3
	color_src = MUTCOLORS2
	gender_specific = 1

/datum/sprite_accessory/mam_body_markings/shark
	name = "Shark"
	icon_state = "shark"
	color_src = MUTCOLORS2
	extra_color_src = MUTCOLORS3
	gender_specific = 1

/datum/sprite_accessory/mam_body_markings/shepherd
	name = "Shepherd"
	icon_state = "shepherd"
	gender_specific = 1

/datum/sprite_accessory/mam_body_markings/tiger
	name = "Tiger Stripes"
	color_src = MUTCOLORS3
	icon_state = "tiger"

/datum/sprite_accessory/mam_body_markings/turian
	name = "Turian"
	extra = TRUE
	color_src = MUTCOLORS
	extra_color_src = MUTCOLORS2
	icon_state = "turian"
	gender_specific = 1

/datum/sprite_accessory/mam_body_markings/wolf
	name = "Wolf"
	icon_state = "wolf"
	color_src = MUTCOLORS2
	gender_specific = 1

/datum/sprite_accessory/mam_body_markings/xeno
	name = "Xeno"
	icon_state = "xeno"
	color_src = MUTCOLORS2
	extra_color_src = MUTCOLORS3
	gender_specific = 1


/******************************************
************ Taur Bodies ******************
*******************************************/
/datum/sprite_accessory/taur
	icon = 'modular_citadel/icons/mob/mam_taur.dmi'
	extra_icon = 'modular_citadel/icons/mob/mam_taur.dmi'
	extra = TRUE
	extra2_icon = 'modular_citadel/icons/mob/mam_taur.dmi'
	extra2 = TRUE
	center = TRUE
	dimension_x = 64

/datum/sprite_accessory/taur/none
	name = "None"
	icon_state = "None"

/datum/sprite_accessory/taur/cow
	name = "Cow"
	icon_state = "cow"

/datum/sprite_accessory/taur/drake
	name = "Drake"
	icon_state = "drake"

/datum/sprite_accessory/taur/drider
	name = "Drider"
	icon_state = "drider"

/datum/sprite_accessory/taur/eevee
	name = "Eevee"
	icon_state = "eevee"

/datum/sprite_accessory/taur/fox
	name = "Fox"
	icon_state = "fox"

/datum/sprite_accessory/taur/husky
	name = "Husky"
	icon_state = "husky"

/datum/sprite_accessory/taur/horse
	name = "Horse"
	icon_state = "horse"

/datum/sprite_accessory/taur/lab
	name = "Lab"
	icon_state = "lab"

/datum/sprite_accessory/taur/naga
	name = "Naga"
	icon_state = "naga"

/datum/sprite_accessory/taur/tentacle
	name = "Tentacle"
	icon_state = "tentacle"

/datum/sprite_accessory/taur/otie
	name = "Otie"
	icon_state = "otie"

/datum/sprite_accessory/taur/pede
	name = "Scolipede"
	icon_state = "pede"
	extra = TRUE
	extra2 = TRUE
	color_src = MUTCOLORS
	extra_color_src = MUTCOLORS2
	extra2_color_src = MUTCOLORS3

/datum/sprite_accessory/taur/panther
	name = "Panther"
	icon_state = "panther"

/datum/sprite_accessory/taur/shepherd
	name = "Shepherd"
	icon_state = "shepherd"

/datum/sprite_accessory/taur/tajaran
	name = "Tajaran"
	icon_state = "tajaran"

/datum/sprite_accessory/taur/wolf
	name = "Wolf"
	icon_state = "wolf"

/******************************************
*************** Ayyliums ******************
*******************************************/

//Xeno Dorsal Tubes
/datum/sprite_accessory/xeno_dorsal
	icon = 'modular_citadel/icons/mob/xeno_parts_greyscale.dmi'

/datum/sprite_accessory/xeno_dorsal/standard
	name = "Standard"
	icon_state = "standard"

/datum/sprite_accessory/xeno_dorsal/royal
	name = "Royal"
	icon_state = "royal"

/datum/sprite_accessory/xeno_dorsal/down
	name = "Dorsal Down"
	icon_state = "down"

//Xeno Tail
/datum/sprite_accessory/xeno_tail
	icon = 'modular_citadel/icons/mob/xeno_parts_greyscale.dmi'

/datum/sprite_accessory/xeno_tail/none
	name = "None"

/datum/sprite_accessory/xeno_tail/standard
	name = "Xenomorph Tail"
	icon_state = "xeno"

//Xeno Caste Heads
/datum/sprite_accessory/xeno_head
	icon = 'modular_citadel/icons/mob/xeno_parts_greyscale.dmi'

/datum/sprite_accessory/xeno_head/standard
	name = "Standard"
	icon_state = "standard"

/datum/sprite_accessory/xeno_head/royal
	name = "royal"
	icon_state = "royal"

/datum/sprite_accessory/xeno_head/hollywood
	name = "hollywood"
	icon_state = "hollywood"

/datum/sprite_accessory/xeno_head/warrior
	name = "warrior"
	icon_state = "warrior"

// IPCs
/datum/sprite_accessory/screen
	icon = 'modular_citadel/icons/mob/ipc_screens.dmi'
	color_src = null

/datum/sprite_accessory/screen/blank
	name = "Blank"
	icon_state = "blank"

/datum/sprite_accessory/screen/pink
	name = "Pink"
	icon_state = "pink"

/datum/sprite_accessory/screen/green
	name = "Green"
	icon_state = "green"

/datum/sprite_accessory/screen/red
	name = "Red"
	icon_state = "red"

/datum/sprite_accessory/screen/blue
	name = "Blue"
	icon_state = "blue"

/datum/sprite_accessory/screen/yellow
	name = "Yellow"
	icon_state = "yellow"

/datum/sprite_accessory/screen/shower
	name = "Shower"
	icon_state = "shower"

/datum/sprite_accessory/screen/nature
	name = "Nature"
	icon_state = "nature"

/datum/sprite_accessory/screen/eight
	name = "Eight"
	icon_state = "eight"

/datum/sprite_accessory/screen/goggles
	name = "Goggles"
	icon_state = "goggles"

/datum/sprite_accessory/screen/heart
	name = "Heart"
	icon_state = "heart"

/datum/sprite_accessory/screen/monoeye
	name = "Mono eye"
	icon_state = "monoeye"

/datum/sprite_accessory/screen/breakout
	name = "Breakout"
	icon_state = "breakout"

/datum/sprite_accessory/screen/purple
	name = "Purple"
	icon_state = "purple"

/datum/sprite_accessory/screen/scroll
	name = "Scroll"
	icon_state = "scroll"

/datum/sprite_accessory/screen/console
	name = "Console"
	icon_state = "console"

/datum/sprite_accessory/screen/rgb
	name = "RGB"
	icon_state = "rgb"

/datum/sprite_accessory/screen/golglider
	name = "Gol Glider"
	icon_state = "golglider"

/datum/sprite_accessory/screen/rainbow
	name = "Rainbow"
	icon_state = "rainbow"

/datum/sprite_accessory/screen/sunburst
	name = "Sunburst"
	icon_state = "sunburst"

/datum/sprite_accessory/screen/static
	name = "Static"
	icon_state = "static"

//Oracle Station sprites

/datum/sprite_accessory/screen/bsod
	name = "BSOD"
	icon_state = "bsod"

/datum/sprite_accessory/screen/redtext
	name = "Red Text"
	icon_state = "retext"

/datum/sprite_accessory/screen/sinewave
	name = "Sine wave"
	icon_state = "sinewave"

/datum/sprite_accessory/screen/squarewave
	name = "Square wave"
	icon_state = "squarwave"

/datum/sprite_accessory/screen/ecgwave
	name = "ECG wave"
	icon_state = "ecgwave"

/datum/sprite_accessory/screen/eyes
	name = "Eyes"
	icon_state = "eyes"

/datum/sprite_accessory/screen/textdrop
	name = "Text drop"
	icon_state = "textdrop"

/datum/sprite_accessory/screen/stars
	name = "Stars"
	icon_state = "stars"

// IPC Antennas

/datum/sprite_accessory/antenna
	icon = 'modular_citadel/icons/mob/ipc_antennas.dmi'
	color_src = MUTCOLORS2

/datum/sprite_accessory/antenna/none
	name = "None"
	icon_state = "None"

/datum/sprite_accessory/antenna/antennae
	name = "Angled Antennae"
	icon_state = "antennae"

/datum/sprite_accessory/antenna/tvantennae
	name = "TV Antennae"
	icon_state = "tvantennae"

/datum/sprite_accessory/antenna/cyberhead
	name = "Cyberhead"
	icon_state = "cyberhead"

/datum/sprite_accessory/antenna/antlers
	name = "Antlers"
	icon_state = "antlers"

/datum/sprite_accessory/antenna/crowned
	name = "Crowned"
	icon_state = "crowned"

// *** Snooooow flaaaaake ***

/datum/sprite_accessory/mam_body_markings/guilmon
	name = "Guilmon"
	icon_state = "guilmon"
	gender_specific = 1

/datum/sprite_accessory/mam_tails/guilmon
	name = "Guilmon"
	icon_state = "guilmon"
	extra = TRUE

/datum/sprite_accessory/mam_tails_animated/guilmon
	name = "Guilmon"
	icon_state = "guilmon"
	extra = TRUE

/datum/sprite_accessory/mam_ears/guilmon
	name = "Guilmon"
	icon_state = "guilmon"

/datum/sprite_accessory/snout/guilmon
	name = "Guilmon"
	icon_state = "guilmon"

/datum/sprite_accessory/mam_tails/shark/datashark
	name = "DataShark"
	icon_state = "datashark"
	color_src = 0
	ckeys_allowed = list("rubyflamewing")

/datum/sprite_accessory/mam_tails_animated/shark/datashark
	name = "DataShark"
	icon_state = "datashark"
	color_src = 0

/datum/sprite_accessory/mam_body_markings/shark/datashark
	name = "DataShark"
	icon_state = "datashark"
	color_src = MUTCOLORS2
	ckeys_allowed = list("rubyflamewing")


//Sabresune
/datum/sprite_accessory/mam_ears/sabresune
	name = "sabresune"
	icon_state = "sabresune"
	hasinner = 1
	extra = TRUE
	extra_color_src = MUTCOLORS3
	ckeys_allowed = list("poojawa")

/datum/sprite_accessory/mam_tails/sabresune
	name = "sabresune"
	icon_state = "sabresune"
	extra = TRUE
	ckeys_allowed = list("poojawa")


/datum/sprite_accessory/mam_tails_animated/sabresune
	name = "sabresune"
	icon_state = "sabresune"
	extra = TRUE

/datum/sprite_accessory/mam_body_markings/sabresune
	name = "Sabresune"
	icon_state = "sabresune"
	color_src = MUTCOLORS2
	extra = FALSE
	extra2 = FALSE
	ckeys_allowed = list("poojawa")


//Lunasune
/datum/sprite_accessory/mam_ears/lunasune
	name = "lunasune"
	icon_state = "lunasune"
	hasinner = 1
	extra = TRUE
	extra_color_src = MUTCOLORS2
	ckeys_allowed = list("invader4352")

/datum/sprite_accessory/mam_tails/lunasune
	name = "lunasune"
	icon_state = "lunasune"
	extra = TRUE
	ckeys_allowed = list("invader4352")

/datum/sprite_accessory/mam_tails_animated/lunasune
	name = "lunasune"
	icon_state = "lunasune"
	extra = TRUE

/*************** VIRGO PORTED HAIRS ****************************/
#define VHAIR(_name, new_state) /datum/sprite_accessory/hair/##new_state/icon_state=#new_state;/datum/sprite_accessory/hair/##new_state/name = "Virgo - " + #_name
//VIRGO PORTED HAIRS
VHAIR(Short Hair Rosa, hair_rosa_s)
VHAIR(Short Hair 80s, hair_80s_s)
VHAIR(Long Bedhead, hair_long_bedhead_s)
VHAIR(Dave, hair_dave_s)
VHAIR(Country, hair_country_s)
VHAIR(Shy, hair_shy_s)
VHAIR(Unshaven Mohawk, hair_unshaven_mohawk_s)
VHAIR(Manbun, hair_manbun_s)
VHAIR(Longer Bedhead, hair_longer_bedhead_s)
VHAIR(Ponytail, hair_ponytail_s)
VHAIR(Ziegler, hair_ziegler_s)
VHAIR(Emo Fringe, hair_emofringe_s)
VHAIR(Very Short Over Eye Alt, hair_veryshortovereyealternate_s)
VHAIR(Shorthime, hair_shorthime_s)
VHAIR(High Tight, hair_hightight_s)
VHAIR(Thinning Front, hair_thinningfront_s)
VHAIR(Big Afro, hair_bigafro_s)
VHAIR(Afro, hair_afro_s)
VHAIR(High Braid, hair_hbraid_s)
VHAIR(Braid, hair_braid_s)
VHAIR(Sargeant, hair_sargeant_s)
VHAIR(Gelled, hair_gelled_s)
VHAIR(Kagami, hair_kagami_s)
VHAIR(ShortTail, hair_stail_s)
VHAIR(Gentle, hair_gentle_s)
VHAIR(Grande, hair_grande_s)
VHAIR(Bobcurl, hair_bobcurl_s)
VHAIR(Pompadeur, hair_pompadour_s)
VHAIR(Plait, hair_plait_s)
VHAIR(Long, hair_long_s)
VHAIR(Rattail, hair_rattail_s)
VHAIR(Tajspiky, hair_tajspiky_s)
VHAIR(Messy, hair_messy_s)
VHAIR(Bangs, hair_bangs_s)
VHAIR(TBraid, hair_tbraid_s)
VHAIR(Toriyama2, hair_toriyama2_s)
VHAIR(CIA, hair_cia_s)
VHAIR(Mulder, hair_mulder_s)
VHAIR(Scully, hair_scully_s)
VHAIR(Nitori, hair_nitori_s)
VHAIR(Joestar, hair_joestar_s)
VHAIR(Ponytail4, hair_ponytail4_s)
VHAIR(Ponytail5, hair_ponytail5_s)
VHAIR(Beehive2, hair_beehive2_s)
VHAIR(Short Braid, hair_shortbraid_s)
VHAIR(Reverse Mohawk, hair_reversemohawk_s)
VHAIR(SHort Bangs, hair_shortbangs_s)
VHAIR(Half Shaved, hair_halfshaved_s)
VHAIR(Longer Alt 2, hair_longeralt2_s)
VHAIR(Bun, hair_bun_s)
VHAIR(Curly, hair_curly_s)
VHAIR(Victory, hair_victory_s)
VHAIR(Ponytail6, hair_ponytail6_s)
VHAIR(Undercut3, hair_undercut3_s)
VHAIR(Bobcut Alt, hair_bobcultalt_s)
VHAIR(Fingerwave, hair_fingerwave_s)
VHAIR(Oxton, hair_oxton_s)
VHAIR(Poofy2, hair_poofy2_s)
VHAIR(Fringe Tail, hair_fringetail_s)
VHAIR(Bun3, hair_bun3_s)
VHAIR(Wisp, hair_wisp_s)
VHAIR(Undercut2, hair_undercut2_s)
VHAIR(TBob, hair_tbob_s)
VHAIR(Spiky Ponytail, hair_spikyponytail_s)
VHAIR(Rowbun, hair_rowbun_s)
VHAIR(Rowdualtail, hair_rowdualtail_s)
VHAIR(Rowbraid, hair_rowbraid_s)
VHAIR(Shaved Mohawk, hair_shavedmohawk_s)
VHAIR(Topknot, hair_topknot_s)
VHAIR(Ronin, hair_ronin_s)
VHAIR(Bowlcut2, hair_bowlcut2_s)
VHAIR(Thinning Rear, hair_thinningrear_s)
VHAIR(Thinning, hair_thinning_s)
VHAIR(Jade, hair_jade_s)
VHAIR(Bedhead, hair_bedhead_s)
VHAIR(Dreadlocks, hair_dreads_s)
VHAIR(Very Long, hair_vlong_s)
VHAIR(Jensen, hair_jensen_s)
VHAIR(Halfbang, hair_halfbang_s)
VHAIR(Kusangi, hair_kusangi_s)
VHAIR(Ponytail, hair_ponytail_s)
VHAIR(Ponytail3, hair_ponytail3_s)
VHAIR(Halfbang Alt, hair_halfbang_alt_s)
VHAIR(Bedhead V2, hair_bedheadv2_s)
VHAIR(Long Fringe, hair_longfringe_s)
VHAIR(Flair, hair_flair_s)
VHAIR(Bedhead V3, hair_bedheadv3_s)
VHAIR(Himecut, hair_himecut_s)
VHAIR(Curls, hair_curls_s)
VHAIR(Very Long Fringe, hair_vlongfringe_s)
VHAIR(Longest, hair_longest_s)
VHAIR(Father, hair_father_s)
VHAIR(Emo Long, hair_emolong_s)
VHAIR(Short Hair 3, hair_shorthair3_s)
VHAIR(Double Bun, hair_doublebun_s)
VHAIR(Sleeze, hair_sleeze_s)
VHAIR(Twintail, hair_twintail_s)
VHAIR(Emo 2, hair_emo2_s)
VHAIR(Low Fade, hair_lowfade_s)
VHAIR(Med Fade, hair_medfade_s)
VHAIR(High Fade, hair_highfade_s)
VHAIR(Bald Fade, hair_baldfade_s)
VHAIR(No Fade, hair_nofade_s)
VHAIR(Trim Flat, hair_trimflat_s)
VHAIR(Shaved, hair_shaved_s)
VHAIR(Trimmed, hair_trimmed_s)
VHAIR(Tight Bun, hair_tightbun_s)
VHAIR(Short Hair 4, hair_d_s)
VHAIR(Short Hair 5, hair_e_s)
VHAIR(Short Hair 6, hair_f_s)
VHAIR(Skinhead, hair_skinhead_s)
VHAIR(Afro2, hair_afro2_s)
VHAIR(Bobcut, hair_bobcut_s)
VHAIR(Emo, hair_emo_s)
VHAIR(Long Over Eye, hair_longovereye_s)
VHAIR(Feather, hair_feather_s)
VHAIR(Hitop, hair_hitop_s)
VHAIR(Short Over Eye, hair_shortoverye_s)
VHAIR(Straight, hair_straight_s)
VHAIR(Buzzcut, hair_buzzcut_s)
VHAIR(Combover, hair_combover_s)
VHAIR(Crewcut, hair_crewcut_s)
VHAIR(Devillock, hair_devilock_s)
VHAIR(Clean, hair_clean_s)
VHAIR(Shaggy, hair_shaggy_s)
VHAIR(Updo, hair_updo_s)
VHAIR(Mohawk, hair_mohawk_s)
VHAIR(Odango, hair_odango_s)
VHAIR(Ombre, hair_ombre_s)
VHAIR(Parted, hair_parted_s)
VHAIR(Quiff, hair_quiff_s)
VHAIR(Volaju, hair_volaju_s)
VHAIR(Bun2, hair_bun2_s)
VHAIR(Rows1, hair_rows1_s)
VHAIR(Rows2, hair_rows2_s)
VHAIR(Dandy Pompadour, hair_dandypompadour_s)
VHAIR(Poofy, hair_poofy_s)
VHAIR(Toriyama, hair_toriyama_s)
VHAIR(Drillruru, hair_drillruru_s)
VHAIR(Bowlcut, hair_bowlcut_s)
VHAIR(Coffee House, hair_coffeehouse_s)
VHAIR(Family Man, hair_thefamilyman_s)
VHAIR(Shaved Part, hair_shavedpart_s)
VHAIR(Modern, hair_modern_s)
VHAIR(One Shoulder, hair_oneshoulder_s)
VHAIR(Very Short Over Eye, hair_veryshortovereye_s)
VHAIR(Unkept, hair_unkept_s)
VHAIR(Wife, hair_wife_s)
VHAIR(Nia, hair_nia_s)
VHAIR(Undercut, hair_undercut_s)
VHAIR(Bobcut Alt, hair_bobcutalt_s)
VHAIR(Short Hair 4 alt, hair_shorthair4_s)
VHAIR(Tressshoulder, hair_tressshoulder_s)
 //END
#undef VHAIR

#define VFACE(_name, new_state) /datum/sprite_accessory/facial_hair/##new_state/icon_state=#new_state;;/datum/sprite_accessory/facial_hair/##new_state/name="Virgo" + #_name
VFACE(Watson, facial_watson_s)
VFACE(Chaplin, facial_chaplin_s)
VFACE(Fullbeard, facial_fullbeard_s)
VFACE(Vandyke, facial_vandyke_s)
VFACE(Elvis, facial_elvis_s)
VFACE(Abe, facial_abe_s)
VFACE(Chin, facial_chin_s)
VFACE(GT, facial_gt_s)
VFACE(Hip, facial_hip_s)
VFACE(Hogan, facial_hogan_s)
VFACE(Selleck, facial_selleck_s)
VFACE(Neckbeard, facial_neckbeard_s)
VFACE(Longbeard, facial_longbeard_s)
VFACE(Dwarf, facial_dwarf_s)
VFACE(Sideburn, facial_sideburn_s)
VFACE(Mutton, facial_mutton_s)
VFACE(Moustache, facial_moustache_s)
VFACE(Pencilstache, facial_pencilstache_s)
VFACE(Goatee, facial_goatee_s)
VFACE(Smallstache, facial_smallstache_s)
VFACE(Volaju, facial_volaju_s)
VFACE(3 O\'clock, facial_3oclock_s)
VFACE(5 O\'clock, facial_5oclock_s)
VFACE(7 O\'clock, facial_7oclock_s)
VFACE(5 O\'clock Moustache, facial_5oclockmoustache_s)
VFACE(7 O\'clock, facial_7oclockmoustache_s)
VFACE(Walrus, facial_walrus_s)
VFACE(Muttonmus, facial_muttonmus_s)
VFACE(Wise, facial_wise_s)
VFACE(Martial Artist, facial_martialartist_s)
VFACE(Dorsalfnil, facial_dorsalfnil_s)
VFACE(Hornadorns, facial_hornadorns_s)
VFACE(Spike, facial_spike_s)
VFACE(Chinhorns, facial_chinhorns_s)
VFACE(Cropped Fullbeard, facial_croppedfullbeard_s)
VFACE(Chinless Beard, facial_chinlessbeard_s)
VFACE(Moonshiner, facial_moonshiner_s)
VFACE(Tribearder, facial_tribearder_s)
#undef VFACE