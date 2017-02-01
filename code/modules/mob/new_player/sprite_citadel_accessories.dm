	/****************Body Markings**************/

/datum/sprite_accessory/body_markings/dtiger
	name = "Dark Tiger Body"
	icon_state = "dtiger"
	gender_specific = 1
	color_src = MUTCOLORS2
	species_allowed = list("lizard")

/datum/sprite_accessory/body_markings/ltiger
	name = "Light Tiger Body"
	icon_state = "ltiger"
	gender_specific = 1
	color_src = MUTCOLORS2
	species_allowed = list("lizard")

/datum/sprite_accessory/body_markings/lbelly
	name = "Light Belly"
	icon_state = "lbelly"
	gender_specific = 1
	color_src = MUTCOLORS2
	species_allowed = list("lizard")

/datum/sprite_accessory/body_markings/moth
	icon = 'icons/mob/exotic_bodyparts.dmi'
	name = "Moth"
	icon_state = "moth"
	gender_specific = 1
	color_src = MUTCOLORS2
	extra = 1
	extra_color_src = MUTCOLORS3
	species_allowed = list("moth")

/datum/sprite_accessory/body_markings/belly
	name = "Belly"
	icon_state = "belly"
	gender_specific = 1
	color_src = MUTCOLORS2
	icon = 'icons/mob/mam_bodyparts.dmi'

/datum/sprite_accessory/body_markings/bellyhandsfeet
	name = "Belly, Hands, & Feet"
	icon_state = "bellyhandsfeet"
	gender_specific = 1
	extra = 1
	extra_color_src = MUTCOLORS3
	icon = 'icons/mob/mam_bodyparts.dmi'

	/**************Snouts****************/

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

	/*********************************************
	 **************** Species ********************
	 *********************************************/
//Cat, Big
/datum/sprite_accessory/ears/catbig
	name = "Cat, Big"
	icon_state = "cat"
	hasinner = 1
	icon = 'icons/mob/mam_bodyparts.dmi'
	species_allowed = list("human","canine","felid")

/datum/sprite_accessory/tails/catbig
	name = "Cat, Big"
	icon_state = "catbig"
	icon = 'icons/mob/mam_bodyparts.dmi'
	species_allowed = list("human","canine","felid")

/datum/sprite_accessory/tails_animated/catbig
	name = "Cat, Big"
	icon_state = "catbig"
	icon = 'icons/mob/mam_bodyparts.dmi'
	species_allowed = list("human","canine","felid")

//Wolf
/datum/sprite_accessory/ears/wolf
	name = "Wolf"
	icon_state = "wolf"
	icon = 'icons/mob/mam_bodyparts.dmi'
	hasinner = 1
	species_allowed = list("human","canine","felid")

/datum/sprite_accessory/tails/wolf
	name = "Wolf"
	icon_state = "wolf"
	icon = 'icons/mob/mam_bodyparts.dmi'
	species_allowed = list("human","canine","felid")

/datum/sprite_accessory/tails_animated/wolf
	name = "Wolf"
	icon_state = "wolf"
	icon = 'icons/mob/mam_bodyparts.dmi'
	species_allowed = list("human","canine","felid")

//Fox
/datum/sprite_accessory/ears/fox
	name = "Fox"
	icon_state = "fox"
	icon = 'icons/mob/mam_bodyparts.dmi'
	hasinner = 0
	species_allowed = list("human","canine","felid")

/datum/sprite_accessory/tails/fox
	name = "Fox"
	icon_state = "fox"
	icon = 'icons/mob/mam_bodyparts.dmi'
	extra = 1
	extra_color_src = MUTCOLORS2
	species_allowed = list("human","canine","felid")

/datum/sprite_accessory/tails_animated/fox
	name = "Fox"
	icon_state = "fox"
	icon = 'icons/mob/mam_bodyparts.dmi'
	extra = 1
	extra_color_src = MUTCOLORS2
	species_allowed = list("human","canine","felid")

//Fennec
/datum/sprite_accessory/ears/fennec
	name = "Fennec"
	icon_state = "fennec"
	icon = 'icons/mob/mam_bodyparts.dmi'
	hasinner = 1
	species_allowed = list("human","canine","felid")

/datum/sprite_accessory/tails/fennec
	name = "Fennec"
	icon_state = "fennec"
	icon = 'icons/mob/mam_bodyparts.dmi'
	species_allowed = list("human","canine","felid")

/datum/sprite_accessory/tails_animated/fennec
	name = "Fennec"
	icon_state = "fennec"
	icon = 'icons/mob/mam_bodyparts.dmi'
	species_allowed = list("human","canine","felid")

//Lab
/datum/sprite_accessory/ears/lab
	name = "Dog, Long"
	icon_state = "lab"
	icon = 'icons/mob/mam_bodyparts.dmi'
	species_allowed = list("human","canine","felid")

/datum/sprite_accessory/tails/lab
	name = "Lab"
	icon_state = "lab"
	icon = 'icons/mob/mam_bodyparts.dmi'
	species_allowed = list("human","canine","felid")

/datum/sprite_accessory/tails_animated/lab
	name = "Lab"
	icon_state = "lab"
	icon = 'icons/mob/mam_bodyparts.dmi'
	species_allowed = list("human","canine","felid")

//Husky
/datum/sprite_accessory/ears/husky
	name = "Husky"
	icon_state = "wolf"
	hasinner = 1
	icon = 'icons/mob/mam_bodyparts.dmi'
	extra = 1
	species_allowed = list("human","canine","felid")

/datum/sprite_accessory/tails/husky
	name = "Husky"
	icon_state = "husky"
	extra = 1
	icon = 'icons/mob/mam_bodyparts.dmi'
	species_allowed = list("human","canine","felid")

/datum/sprite_accessory/tails_animated/husky
	name = "Husky"
	icon_state = "husky"
	extra = 1
	icon = 'icons/mob/mam_bodyparts.dmi'
	species_allowed = list("human","canine","felid")

//Murid
/datum/sprite_accessory/ears/murid
	name = "Murid"
	icon_state = "murid"
	icon = 'icons/mob/mam_bodyparts.dmi'
	species_allowed = list("human","canine","felid")

/datum/sprite_accessory/tails/murid
	name = "Murid"
	icon_state = "murid"
	color_src = 0
	icon = 'icons/mob/mam_bodyparts.dmi'
	species_allowed = list("human","canine","felid")

/datum/sprite_accessory/tails_animated/murid
	name = "Murid"
	icon_state = "murid"
	color_src = 0
	icon = 'icons/mob/mam_bodyparts.dmi'
	species_allowed = list("human","canine","felid")

//Shark
/datum/sprite_accessory/tails/shark
	name = "Shark"
	icon_state = "shark"
	color_src = 0
	icon = 'icons/mob/mam_bodyparts.dmi'
	species_allowed = list("human","canine","felid", "aquatic", "lizard")


//Squirrel
/datum/sprite_accessory/ears/squirrel
	name = "Squirrel"
	icon_state = "squirrel"
	hasinner= 1
	icon = 'icons/mob/mam_bodyparts.dmi'
	species_allowed = list("human","canine","felid")

/datum/sprite_accessory/tails/squirrel
	name = "Squirrel"
	icon_state = "squirrel"
	icon = 'icons/mob/mam_bodyparts.dmi'
	species_allowed = list("human","canine","felid")

/datum/sprite_accessory/tails_animated/squirrel
	name = "Squirrel"
	icon_state = "squirrel"
	icon = 'icons/mob/mam_bodyparts.dmi'
	species_allowed = list("human","canine","felid")


/*******************Xenos*********************/
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


/**************** Whitelist/donator *****************/
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