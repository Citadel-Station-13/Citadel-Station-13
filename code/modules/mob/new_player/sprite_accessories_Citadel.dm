/datum/sprite_accessories
	var/extra = 0
	var/extra_icon = 'icons/mob/mam_bodyparts.dmi'
	var/extra_color_src = MUTCOLORS2 						//The color source for the extra overlay.

/* tbi eventually idk
/datum/sprite_accessory/legs/digitigrade_mam
	name = "Anthro Digitigrade Legs"
	icon = 'icons/mob/mam_bodyparts.dmi'
*/

/******************************************
************ Human Ears/Tails *************
*******************************************/

/datum/sprite_accessory/ears/fox
	name = "Fox"
	icon_state = "fox"
	hasinner = 0
	icon = 'icons/mob/mam_bodyparts.dmi'

/datum/sprite_accessory/ears/wolf
	name = "Wolf"
	icon_state = "wolf"
	hasinner = 1
	icon = 'icons/mob/mam_bodyparts.dmi'

/datum/sprite_accessory/tails/human/fox
	name = "Fox"
	icon_state = "fox"
	icon = 'icons/mob/mam_bodyparts.dmi'
	extra = 1

/datum/sprite_accessory/tails_animated/human/fox
	name = "Fox"
	icon_state = "fox"
	icon = 'icons/mob/mam_bodyparts.dmi'
	extra = 1

/datum/sprite_accessory/tails/human/wolf
	name = "Wolf"
	icon_state = "wolf"
	icon = 'icons/mob/mam_bodyparts.dmi'

/datum/sprite_accessory/tails_animated/human/wolf
	name = "Wolf"
	icon_state = "wolf"
	icon = 'icons/mob/mam_bodyparts.dmi'

/datum/sprite_accessory/tails/human/catbig
	name = "Cat, Big"
	icon_state = "catbig"
	icon = 'icons/mob/mam_bodyparts.dmi'

/datum/sprite_accessory/tails_animated/human/catbig
	name = "Cat, Big"
	icon_state = "catbig"
	icon = 'icons/mob/mam_bodyparts.dmi'

/datum/sprite_accessory/ears/fennec
	name = "Fennec"
	icon_state = "fennec"
	icon = 'icons/mob/mam_bodyparts.dmi'

/datum/sprite_accessory/tails/human/fennec
	name = "Fennec"
	icon_state = "fennec"
	icon = 'icons/mob/mam_bodyparts.dmi'

/datum/sprite_accessory/tails_animated/human/fennec
	name = "Fennec"
	icon_state = "fennec"
	icon = 'icons/mob/mam_bodyparts.dmi'

/datum/sprite_accessory/ears/lab
	name = "Dog, Floppy"
	icon_state = "lab"
	hasinner = 0
	icon = 'icons/mob/mam_bodyparts.dmi'

/datum/sprite_accessory/tails/human/husky
	name = "Husky"
	icon_state = "husky"
	icon = 'icons/mob/mam_bodyparts.dmi'
	extra = 1

/datum/sprite_accessory/tails_animated/human/husky
	name = "Husky"
	icon_state = "husky"
	icon = 'icons/mob/mam_bodyparts.dmi'
	extra = 1

/datum/sprite_accessory/ears/murid
	name = "Murid"
	icon_state = "murid"
	icon = 'icons/mob/mam_bodyparts.dmi'

/datum/sprite_accessory/tails/human/murid
	name = "Murid"
	icon_state = "murid"
	color_src = 0
	icon = 'icons/mob/mam_bodyparts.dmi'


/datum/sprite_accessory/tails_animated/human/murid
	name = "Murid"
	icon_state = "murid"
	color_src = 0
	icon = 'icons/mob/mam_bodyparts.dmi'

/datum/sprite_accessory/tails/human/shark
	name = "Shark"
	icon_state = "shark"
	color_src = 0
	icon = 'icons/mob/mam_bodyparts.dmi'

/datum/sprite_accessory/tails/human/shark/datashark
	name = "datashark"
	icon_state = "datashark"
	color_src = 0
	icon = 'icons/mob/mam_bodyparts.dmi'

/datum/sprite_accessory/tails/human/ailurus
	name = "ailurus"
	icon_state = "ailurus"
	color_src = 0
	icon = 'icons/mob/mam_bodyparts.dmi'

/datum/sprite_accessory/ears/squirrel
	name = "Squirrel"
	icon_state = "squirrel"
	hasinner= 1
	icon = 'icons/mob/mam_bodyparts.dmi'

/datum/sprite_accessory/tails/human/squirrel
	name = "Squirrel"
	icon_state = "squirrel"
	icon = 'icons/mob/mam_bodyparts.dmi'

/datum/sprite_accessory/tails_animated/human/squirrel
	name = "Squirrel"
	icon_state = "squirrel"
	icon = 'icons/mob/mam_bodyparts.dmi'


/******************************************
*************** Body Parts ****************
*******************************************/

/datum/sprite_accessory/mam_ears
	icon = 'icons/mob/mam_bodyparts.dmi'
/datum/sprite_accessory/mam_ears/none
	name = "None"

/datum/sprite_accessory/mam_tails
	icon = 'icons/mob/mam_bodyparts.dmi'
/datum/sprite_accessory/mam_tails/none
	name = "None"

/datum/sprite_accessory/mam_tails_animated
	icon = 'icons/mob/mam_bodyparts.dmi'
/datum/sprite_accessory/mam_tails_animated/none
	name = "None"

/******************************************
**************** Snouts *******************
*******************************************/

/datum/sprite_accessory/snouts/lcanid
	name = "Fox, Long"
	icon_state = "lcanid"
	icon = 'icons/mob/mam_bodyparts.dmi'
	extra = 1

/datum/sprite_accessory/snouts/scanid
	name = "Fox, Short"
	icon_state = "scanid"
	icon = 'icons/mob/mam_bodyparts.dmi'
	extra = 1

/datum/sprite_accessory/snouts/wolf
	name = "Wolf"
	icon_state = "wolf"
	icon = 'icons/mob/mam_bodyparts.dmi'
	extra = 1

/datum/sprite_accessory/snouts/husky
	name = "Husky"
	icon_state = "husky"
	icon = 'icons/mob/mam_bodyparts.dmi'
	extra = 1

/******************************************
************ Actual Species ***************
*******************************************/
//Cat, Big
/datum/sprite_accessory/mam_ears/catbig
	name = "Cat, Big"
	icon_state = "cat"
	hasinner = 1
	icon = 'icons/mob/mutant_bodyparts.dmi'

/datum/sprite_accessory/mam_tails/catbig
	name = "Cat, Big"
	icon_state = "catbig"

/datum/sprite_accessory/mam_tails_animated/catbig
	name = "Cat, Big"
	icon_state = "catbig"

//Wolf
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

//Fox
/datum/sprite_accessory/mam_ears/fox
	name = "Fox"
	icon_state = "fox"
	hasinner = 0

/datum/sprite_accessory/mam_tails/fox
	name = "Fox"
	icon_state = "fox"
	extra = 1
	extra_color_src = MUTCOLORS2

/datum/sprite_accessory/mam_tails_animated/fox
	name = "Fox"
	icon_state = "fox"
	extra = 1
	extra_color_src = MUTCOLORS2

//Fennec
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

//Lab
/datum/sprite_accessory/mam_ears/lab
	name = "Dog, Long"
	icon_state = "lab"

/datum/sprite_accessory/mam_tails/lab
	name = "Lab"
	icon_state = "lab"

/datum/sprite_accessory/mam_tails_animated/lab
	name = "Lab"
	icon_state = "lab"

//Husky
/datum/sprite_accessory/mam_ears/husky
	name = "Husky"
	icon_state = "wolf"
	hasinner = 1
	icon = 'icons/mob/mam_bodyparts.dmi'
	extra = 1

/datum/sprite_accessory/mam_tails/husky
	name = "Husky"
	icon_state = "husky"
	extra = 1

/datum/sprite_accessory/mam_tails_animated/husky
	name = "Husky"
	icon_state = "husky"
	extra = 1

//Murid
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

//Shark
/datum/sprite_accessory/mam_tails/shark
	name = "Shark"
	icon_state = "shark"
	color_src = 0
	icon = 'icons/mob/mam_bodyparts.dmi'


/datum/sprite_accessory/mam_tails/shark/datashark
	name = "DataShark"
	icon_state = "datashark"
	color_src = 0
	icon = 'icons/mob/mam_bodyparts.dmi'


//Squirrel
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

/datum/sprite_accessory/mam_tails/ailurus
	name = "Ailurus"
	icon_state = "ailurus"

/******************************************
************ Body Markings ****************
*******************************************/

/datum/sprite_accessory/mam_body_markings
	color_src = MUTCOLORS2
	icon = 'icons/mob/mam_bodyparts.dmi'

/datum/sprite_accessory/mam_body_markings/none
	name = "None"
	icon_state = "none"

/datum/sprite_accessory/mam_body_markings/belly
	name = "Belly"
	icon_state = "belly"
	gender_specific = 1
/*
/datum/sprite_accessory/mam_body_markings/bellyhandsfeet
	name = "Belly, Hands, & Feet"
	icon_state = "bellyhandsfeet"
	gender_specific = 1
	extra = 1
	extra_color_src = MUTCOLORS3
*/

/******************************************
************ Taur Bodies ******************
*******************************************/

//Xeno Dorsal Tubes
/datum/sprite_accessory/xeno_dorsal
	icon = 'icons/mob/exotic_bodyparts.dmi'
	color_src = 0

/datum/sprite_accessory/xeno_dorsal/none
	name = "None"

/datum/sprite_accessory/xeno_dorsal/normal
	name = "Dorsal Tubes"
	icon_state = "dortubes"

//Xeno Tail
/datum/sprite_accessory/xeno_tail
	icon = 'icons/mob/exotic_bodyparts.dmi'
	color_src = 0

/datum/sprite_accessory/xeno_tail/none
	name = "None"

/datum/sprite_accessory/xeno_tail/normal
	name = "Xenomorph Tail"
	icon_state = "xeno"

//Xeno Caste Heads
//unused as of October 3, 2016
/datum/sprite_accessory/xeno_head
	icon = 'icons/mob/exotic_bodyparts.dmi'
	color_src = 0

/datum/sprite_accessory/xeno_head/none
	name = "None"


/datum/sprite_accessory/xeno_head/hunter
	name = "Hunter"
	icon_state = "hunter"

/datum/sprite_accessory/xeno_head/drone
	name = "Drone"
	icon_state = "drone"

/datum/sprite_accessory/xeno_head/sentinel
	name = "Sentinel"
	icon_state = "sentinel"
/*
//Slimecoon Parts
/datum/sprite_accessory/slimecoon_ears
	icon = 'icons/mob/exotic_bodyparts.dmi'
	name = "Slimecoon Ears"
	icon_state = "slimecoon"
/datum/sprite_accessory/slimecoon_tail
	icon = 'icons/mob/exotic_bodyparts.dmi'
	name = "Slimecoon Tail"
	icon_state = "slimecoon"
/datum/sprite_accessory/slimecoon_snout
	icon = 'icons/mob/exotic_bodyparts.dmi'
	name = "Hunter"
	icon_state = "slimecoon" */