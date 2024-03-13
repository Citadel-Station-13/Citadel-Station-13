//miscellaneous spacesuits
/*
Contains:
 - Captain's spacesuit
 - Death squad's hardsuit
 - SWAT suit
 - Officer's beret/spacesuit
 - NASA Voidsuit
 - Father Christmas' magical clothes
 - Pirate's spacesuit
 - ERT hardsuit: Command, Sec, Engi, Med
 - ERT High Alarm - Command, Sec, Engi, Med
 - EVA spacesuit
 - Radiation Spacesuit
 - Freedom's spacesuit (freedom from vacuum's oppression)
 - Carp hardsuit
*/

	//Death squad armored space suits, not hardsuits!
/obj/item/clothing/head/helmet/space/hardsuit/deathsquad
	name = "MK.III SWAT Helmet"
	desc = "An advanced tactical space helmet."
	icon_state = "deathsquad"
	item_state = "deathsquad"
	armor = list(MELEE = 80, BULLET = 80, LASER = 50, ENERGY = 50, BOMB = 100, BIO = 100, RAD = 100, FIRE = 100, ACID = 100, WOUND = 30)
	strip_delay = 130
	max_heat_protection_temperature = FIRE_IMMUNITY_MAX_TEMP_PROTECT
	resistance_flags = FIRE_PROOF | ACID_PROOF
	actions_types = list()

/obj/item/clothing/head/helmet/space/hardsuit/deathsquad/attack_self(mob/user)
	return

/obj/item/clothing/suit/space/hardsuit/deathsquad
	name = "MK.III SWAT Suit"
	desc = "A prototype designed to replace the ageing MK.II SWAT suit. Based on the streamlined MK.II model, the traditional ceramic and graphene plate construction was replaced with plasteel, allowing superior armor against most threats. There's room for some kind of energy projection device on the back."
	icon_state = "deathsquad"
	item_state = "swat_suit"
	allowed = list(/obj/item/gun, /obj/item/ammo_box, /obj/item/ammo_casing, /obj/item/melee/baton, /obj/item/restraints/handcuffs, /obj/item/tank/internals, /obj/item/kitchen/knife/combat)
	armor = list(MELEE = 80, BULLET = 80, LASER = 50, ENERGY = 50, BOMB = 100, BIO = 100, RAD = 100, FIRE = 100, ACID = 100, WOUND = 30)
	strip_delay = 130
	max_heat_protection_temperature = FIRE_IMMUNITY_MAX_TEMP_PROTECT
	resistance_flags = FIRE_PROOF | ACID_PROOF
	helmettype = /obj/item/clothing/head/helmet/space/hardsuit/deathsquad
	dog_fashion = /datum/dog_fashion/back/deathsquad

	//NEW SWAT suit
/obj/item/clothing/suit/space/swat
	name = "MK.I SWAT Suit"
	desc = "A tactical space suit first developed in a joint effort by the defunct IS-ERI and Nanotrasen in 20XX for military space operations. A tried and true workhorse, it is very difficult to move in but offers robust protection against all threats!"
	icon_state = "heavy"
	item_state = "swat_suit"
	allowed = list(/obj/item/gun, /obj/item/ammo_box, /obj/item/ammo_casing, /obj/item/melee/baton, /obj/item/restraints/handcuffs, /obj/item/tank/internals, /obj/item/kitchen/knife/combat)
	armor = list(MELEE = 40, BULLET = 30, LASER = 30,ENERGY = 30, BOMB = 50, BIO = 90, RAD = 20, FIRE = 100, ACID = 100, WOUND = 25)
	strip_delay = 120
	resistance_flags = FIRE_PROOF | ACID_PROOF
	mutantrace_variation = STYLE_DIGITIGRADE

/obj/item/clothing/head/helmet/space/beret
	name = "officer's beret"
	desc = "An armored beret commonly used by special operations officers. Uses advanced force field technology to protect the head from space."
	icon_state = "beret_badge"
	dynamic_hair_suffix = "+generic"
	dynamic_fhair_suffix = "+generic"
	flags_inv = 0
	armor = list(MELEE = 80, BULLET = 80, LASER = 50, ENERGY = 50, BOMB = 100, BIO = 100, RAD = 100, FIRE = 100, ACID = 100, WOUND = 30)
	strip_delay = 130
	max_heat_protection_temperature = FIRE_IMMUNITY_MAX_TEMP_PROTECT
	resistance_flags = FIRE_PROOF | ACID_PROOF
	mutantrace_variation = NONE

/obj/item/clothing/suit/space/officer
	name = "officer's jacket"
	desc = "An armored, space-proof jacket used in special operations."
	icon_state = "detective"
	item_state = "det_suit"
	blood_overlay_type = "coat"
	slowdown = 0
	flags_inv = 0
	w_class = WEIGHT_CLASS_NORMAL
	allowed = list(/obj/item/gun, /obj/item/ammo_box, /obj/item/ammo_casing, /obj/item/melee/baton, /obj/item/restraints/handcuffs, /obj/item/tank/internals)
	armor = list(MELEE = 80, BULLET = 80, LASER = 50, ENERGY = 50, BOMB = 100, BIO = 100, RAD = 100, FIRE = 100, ACID = 100, WOUND = 30)
	strip_delay = 130
	max_heat_protection_temperature = FIRE_IMMUNITY_MAX_TEMP_PROTECT
	resistance_flags = FIRE_PROOF | ACID_PROOF
	mutantrace_variation = STYLE_DIGITIGRADE

	//NASA Voidsuit
/obj/item/clothing/head/helmet/space/nasavoid
	name = "NASA Void Helmet"
	desc = "An old, NASA CentCom branch designed, dark red space suit helmet."
	icon_state = "void"
	item_state = "void"

/obj/item/clothing/suit/space/nasavoid
	name = "NASA Voidsuit"
	icon_state = "void"
	item_state = "void"
	desc = "An old, NASA CentCom branch designed, dark red space suit."
	allowed = list(/obj/item/flashlight, /obj/item/tank/internals, /obj/item/multitool)
	mutantrace_variation = STYLE_DIGITIGRADE

/obj/item/clothing/head/helmet/space/nasavoid/old
	name = "Engineering Void Helmet"
	desc = "A CentCom engineering dark red space suit helmet. While old and dusty, it still gets the job done."
	icon_state = "void"
	item_state = "void"

/obj/item/clothing/suit/space/nasavoid/old
	name = "Engineering Voidsuit"
	icon_state = "void"
	item_state = "void"
	desc = "A CentCom engineering dark red space suit. Age has degraded the suit making is difficult to move around in."
	slowdown = 4
	allowed = list(/obj/item/flashlight, /obj/item/tank/internals, /obj/item/multitool)

	//Space santa outfit suit
/obj/item/clothing/head/helmet/space/santahat
	name = "Santa's hat"
	desc = "Ho ho ho. Merrry X-mas!"
	icon_state = "santahat"
	flags_cover = HEADCOVERSEYES
	mutantrace_variation = NONE

	dog_fashion = /datum/dog_fashion/head/santa

/obj/item/clothing/suit/space/santa
	name = "Santa's suit"
	desc = "Festive!"
	icon_state = "santa"
	item_state = "santa"
	slowdown = 0
	allowed = list(/obj/item) //for stuffing exta special presents
	mutantrace_variation = STYLE_DIGITIGRADE


	//Space pirate outfit
/obj/item/clothing/head/helmet/space/pirate
	name = "royal tricorne"
	desc = "A thick, space-proof tricorne from the royal Space Queen. It's lined with a layer of reflective kevlar."
	icon_state = "pirate"
	item_state = "pirate"
	armor = list(MELEE = 30, BULLET = 50, LASER = 30,ENERGY = 15, BOMB = 30, BIO = 30, RAD = 30, FIRE = 60, ACID = 75, WOUND = 30)
	flags_inv = HIDEHAIR
	strip_delay = 40
	equip_delay_other = 20
	flags_cover = HEADCOVERSEYES
	mutantrace_variation = NONE

/obj/item/clothing/head/helmet/space/pirate/bandana
	name = "royal bandana"
	desc = "A space-proof bandanna crafted with reflective kevlar."
	icon_state = "bandana"
	item_state = "bandana"
	mutantrace_variation = NONE

/obj/item/clothing/suit/space/pirate
	name = "royal waistcoat "
	desc = "A royal, space-proof waistcoat. The inside of it is lined with reflective kevlar."
	icon_state = "pirate"
	item_state = "pirate"
	w_class = WEIGHT_CLASS_NORMAL
	flags_inv = 0
	allowed = list(/obj/item/gun, /obj/item/ammo_box, /obj/item/ammo_casing, /obj/item/melee/baton, /obj/item/restraints/handcuffs, /obj/item/tank/internals, /obj/item/melee/transforming/energy/sword/pirate, /obj/item/clothing/glasses/eyepatch, /obj/item/reagent_containers/food/drinks/bottle/rum)
	slowdown = 0
	armor = list(MELEE = 30, BULLET = 50, LASER = 30,ENERGY = 15, BOMB = 30, BIO = 30, RAD = 30, FIRE = 60, ACID = 75, WOUND = 30)
	strip_delay = 40
	equip_delay_other = 20
	mutantrace_variation = STYLE_DIGITIGRADE

	//Emergency Response Team suits
/obj/item/clothing/head/helmet/space/hardsuit/ert
	name = "emergency response unit helmet"
	desc = "Standard issue command helmet for the ERT."
	icon_state = "hardsuit0-ert_commander"
	item_state = "hardsuit0-ert_commander"
	hardsuit_type = "ert_commander"
	armor = list(MELEE = 65, BULLET = 50, LASER = 50, ENERGY = 50, BOMB = 50, BIO = 100, RAD = 100, FIRE = 80, ACID = 80, WOUND = 30)
	strip_delay = 130
	brightness_on = 7
	resistance_flags = ACID_PROOF

/obj/item/clothing/head/helmet/space/hardsuit/ert/Initialize(mapload)
	. = ..()
	ADD_TRAIT(src, TRAIT_NODROP, LOCKED_HELMET_TRAIT)

/obj/item/clothing/suit/space/hardsuit/ert
	name = "emergency response team suit"
	desc = "Standard issue command suit for the ERT."
	icon_state = "ert_command"
	item_state = "ert_command"
	helmettype = /obj/item/clothing/head/helmet/space/hardsuit/ert
	allowed = list(/obj/item/gun, /obj/item/ammo_box, /obj/item/ammo_casing, /obj/item/melee/baton, /obj/item/restraints/handcuffs, /obj/item/tank/internals)
	armor = list(MELEE = 65, BULLET = 50, LASER = 50, ENERGY = 50, BOMB = 50, BIO = 100, RAD = 100, FIRE = 80, ACID = 80, WOUND = 30)
	slowdown = 0
	strip_delay = 130
	resistance_flags = ACID_PROOF

	//ERT Security
/obj/item/clothing/head/helmet/space/hardsuit/ert/sec
	desc = "Standard issue security helmet for the ERT."
	icon_state = "hardsuit0-ert_security"
	item_state = "hardsuit0-ert_security"
	hardsuit_type = "ert_security"

/obj/item/clothing/suit/space/hardsuit/ert/sec
	desc = "Standard issue security suit for the ERT."
	icon_state = "ert_security"
	item_state = "ert_security"
	helmettype = /obj/item/clothing/head/helmet/space/hardsuit/ert/sec

	//ERT Engineering
/obj/item/clothing/head/helmet/space/hardsuit/ert/engi
	desc = "Standard issue engineer helmet for the ERT."
	icon_state = "hardsuit0-ert_engineer"
	item_state = "hardsuit0-ert_engineer"
	hardsuit_type = "ert_engineer"

/obj/item/clothing/suit/space/hardsuit/ert/engi
	desc = "Standard issue engineer suit for the ERT."
	icon_state = "ert_engineer"
	item_state = "ert_engineer"
	helmettype = /obj/item/clothing/head/helmet/space/hardsuit/ert/engi

	//ERT Medical
/obj/item/clothing/head/helmet/space/hardsuit/ert/med
	desc = "Standard issue medical helmet for the ERT."
	icon_state = "hardsuit0-ert_medical"
	item_state = "hardsuit0-ert_medical"
	hardsuit_type = "ert_medical"

/obj/item/clothing/suit/space/hardsuit/ert/med
	desc = "Standard issue medical suit for the ERT."
	icon_state = "ert_medical"
	item_state = "ert_medical"
	helmettype = /obj/item/clothing/head/helmet/space/hardsuit/ert/med

	//Red alert ERT

/obj/item/clothing/head/helmet/space/hardsuit/ert/alert
	name = "emergency response unit helmet"
	desc = "Red alert command helmet for the ERT. This one is more armored than its standard version."
	icon_state = "hardsuit0-ert_commander-alert"
	item_state = "hardsuit0-ert_commander-alert"
	hardsuit_type = "ert_commander-alert"
	armor = list(MELEE = 70, BULLET = 55, LASER = 50, ENERGY = 50, BOMB = 65, BIO = 100, RAD = 100, FIRE = 100, ACID = 100, WOUND = 50)
	brightness_on = 8
	resistance_flags = FIRE_PROOF | ACID_PROOF

/obj/item/clothing/suit/space/hardsuit/ert/alert
	name = "emergency response team suit"
	desc = "Red alert command suit for the ERT. This one is more armored than its standard version."
	icon_state = "ert_command-alert"
	item_state = "ert_command-alert"
	helmettype = /obj/item/clothing/head/helmet/space/hardsuit/ert/alert
	armor = list(MELEE = 70, BULLET = 55, LASER = 50, ENERGY = 50, BOMB = 65, BIO = 100, RAD = 100, FIRE = 100, ACID = 100, WOUND = 50)
	resistance_flags = FIRE_PROOF | ACID_PROOF
	mutantrace_variation = STYLE_DIGITIGRADE|STYLE_SNEK_TAURIC|STYLE_PAW_TAURIC

	//ERT Security
/obj/item/clothing/head/helmet/space/hardsuit/ert/alert/sec
	desc = "Red alert security helmet for the ERT. This one is more armored than its standard version."
	icon_state = "hardsuit0-ert_security-alert"
	item_state = "hardsuit0-ert_security-alert"
	hardsuit_type = "ert_security-alert"

/obj/item/clothing/suit/space/hardsuit/ert/alert/sec
	desc = "Red alert security suit for the ERT. This one is more armored than its standard version."
	icon_state = "ert_security-alert"
	item_state = "ert_security-alert"
	helmettype = /obj/item/clothing/head/helmet/space/hardsuit/ert/alert/sec

	//ERT Engineering
/obj/item/clothing/head/helmet/space/hardsuit/ert/alert/engi
	desc = "Red alert engineer helmet for the ERT. This one is more armored than its standard version."
	icon_state = "hardsuit0-ert_engineer-alert"
	item_state = "hardsuit0-ert_engineer-alert"
	hardsuit_type = "ert_engineer-alert"

/obj/item/clothing/suit/space/hardsuit/ert/alert/engi
	desc = "Red alert engineer suit for the ERT. This one is more armored than its standard version."
	icon_state = "ert_engineer-alert"
	item_state = "ert_engineer-alert"
	helmettype = /obj/item/clothing/head/helmet/space/hardsuit/ert/alert/engi

	//ERT Medical
/obj/item/clothing/head/helmet/space/hardsuit/ert/alert/med
	desc = "Red alert medical helmet for the ERT. This one is more armored than its standard version."
	icon_state = "hardsuit0-ert_medical-alert"
	item_state = "hardsuit0-ert_medical-alert"
	hardsuit_type = "ert_medical-alert"

/obj/item/clothing/suit/space/hardsuit/ert/alert/med
	desc = "Red alert medical suit for the ERT. This one is more armored than its standard version."
	icon_state = "ert_medical-alert"
	item_state = "ert_medical-alert"
	helmettype = /obj/item/clothing/head/helmet/space/hardsuit/ert/alert/med

/obj/item/clothing/suit/space/eva
	name = "EVA suit"
	icon_state = "space"
	item_state = "s_suit"
	desc = "A lightweight space suit with the basic ability to protect the wearer from the vacuum of space during emergencies."
	armor = list(MELEE = 0, BULLET = 0, LASER = 0,ENERGY = 0, BOMB = 0, BIO = 100, RAD = 20, FIRE = 50, ACID = 65, WOUND = 10)

/obj/item/clothing/head/helmet/space/eva
	name = "EVA helmet"
	icon_state = "space"
	item_state = "space"
	desc = "A lightweight space helmet with the basic ability to protect the wearer from the vacuum of space during emergencies."
	flash_protect = 0
	armor = list(MELEE = 0, BULLET = 0, LASER = 0,ENERGY = 0, BOMB = 0, BIO = 100, RAD = 20, FIRE = 50, ACID = 65, WOUND = 10)

//Radiation
/obj/item/clothing/head/helmet/space/rad
	name = "radiation voidsuit helmet"
	desc = "A special helmet that protects against radiation and space. Not much else unfortunately."
	icon_state = "cespace_helmet"
	item_state = "nothing"
	armor = list(MELEE = 0, BULLET = 0, LASER = 0, ENERGY = 0, BOMB = 0, BIO = 100, RAD = 100, FIRE = 0, ACID = 0, WOUND = 5)
	resistance_flags = FIRE_PROOF
	rad_flags = RAD_PROTECT_CONTENTS | RAD_NO_CONTAMINATE
	actions_types = list()

/obj/item/clothing/suit/space/rad
	name = "radiation voidsuit"
	desc = "A special suit that protects against radiation and space. Not much else unfortunately."
	icon_state = "hardsuit-rad"
	item_state = "nothing"
	armor = list(MELEE = 0, BULLET = 0, LASER = 0, ENERGY = 0, BOMB = 0, BIO = 100, RAD = 100, FIRE = 0, ACID = 0, WOUND = 5)
	resistance_flags = FIRE_PROOF
	rad_flags = RAD_PROTECT_CONTENTS | RAD_NO_CONTAMINATE
	mutantrace_variation = NONE

/obj/item/clothing/head/helmet/space/freedom
	name = "eagle helmet"
	desc = "An advanced, space-proof helmet. It appears to be modeled after an old-world eagle."
	icon_state = "griffinhat"
	item_state = "griffinhat"
	armor = list(MELEE = 20, BULLET = 40, LASER = 30, ENERGY = 25, BOMB = 100, BIO = 100, RAD = 100, FIRE = 80, ACID = 80, WOUND = 20)
	strip_delay = 130
	max_heat_protection_temperature = FIRE_IMMUNITY_MAX_TEMP_PROTECT
	resistance_flags = ACID_PROOF | FIRE_PROOF
	mutantrace_variation = NONE

/obj/item/clothing/suit/space/freedom
	name = "eagle suit"
	desc = "An advanced, light suit, fabricated from a mixture of synthetic feathers and space-resistant material. A gun holster appears to be integrated into the suit and the wings appear to be stuck in 'freedom' mode."
	icon_state = "freedom"
	item_state = "freedom"
	allowed = list(/obj/item/gun, /obj/item/ammo_box, /obj/item/ammo_casing, /obj/item/melee/baton, /obj/item/restraints/handcuffs, /obj/item/tank/internals)
	armor = list(MELEE = 20, BULLET = 40, LASER = 30,ENERGY = 25, BOMB = 100, BIO = 100, RAD = 100, FIRE = 80, ACID = 80, WOUND = 20)
	strip_delay = 130
	max_heat_protection_temperature = FIRE_IMMUNITY_MAX_TEMP_PROTECT
	resistance_flags = ACID_PROOF | FIRE_PROOF
	slowdown = 0
	mutantrace_variation = STYLE_DIGITIGRADE

//Carpsuit, bestsuit, lovesuit
/obj/item/clothing/head/helmet/space/hardsuit/carp
	name = "carp helmet"
	desc = "Spaceworthy and it looks like a space carp's head, smells like one too."
	icon_state = "carp_helm"
	item_state = "syndicate"
	armor = list(MELEE = -20, BULLET = 0, LASER = 0, ENERGY = 0, BOMB = 0, BIO = 100, RAD = 75, FIRE = 60, ACID = 75, WOUND = 5)	//As whimpy as a space carp
	brightness_on = 0 //luminosity when on
	actions_types = list()
	mutantrace_variation = NONE

/obj/item/clothing/head/helmet/space/hardsuit/carp/Initialize(mapload)
	. = ..()
	ADD_TRAIT(src, TRAIT_NODROP, LOCKED_HELMET_TRAIT)


/obj/item/clothing/suit/space/hardsuit/carp
	name = "carp space suit"
	desc = "A slimming piece of dubious space carp technology, you suspect it won't stand up to hand-to-hand blows."
	icon_state = "carp_suit"
	item_state = "space_suit_syndicate"
	slowdown = 0	//Space carp magic, never stop believing
	armor = list(MELEE = -20, BULLET = 0, LASER = 0, ENERGY = 0, BOMB = 0, BIO = 100, RAD = 75, FIRE = 60, ACID = 75, WOUND = 5) //As whimpy whimpy whoo
	allowed = list(/obj/item/tank/internals, /obj/item/gun/ballistic/automatic/speargun)	//I'm giving you a hint here
	helmettype = /obj/item/clothing/head/helmet/space/hardsuit/carp
	mutantrace_variation = STYLE_DIGITIGRADE

/obj/item/clothing/head/helmet/space/hardsuit/ert/paranormal
	name = "paranormal response unit helmet"
	desc = "A helmet worn by those who deal with paranormal threats for a living."
	icon_state = "hardsuit0-prt"
	item_state = "hardsuit0-prt"
	hardsuit_type = "knight_grey"
	max_heat_protection_temperature = FIRE_IMMUNITY_MAX_TEMP_PROTECT
	actions_types = list()
	resistance_flags = FIRE_PROOF
	mutantrace_variation = NONE
	var/charges = INFINITY

/obj/item/clothing/head/helmet/space/hardsuit/ert/paranormal/Initialize(mapload)
	. = ..()
	AddComponent(/datum/component/anti_magic, FALSE, FALSE, TRUE, ITEM_SLOT_HEAD, charges, TRUE, null, CALLBACK(src, PROC_REF(anti_magic_gone)))

/obj/item/clothing/head/helmet/space/hardsuit/ert/paranormal/proc/anti_magic_gone()
	var/mob/M = loc
	if(!istype(M))
		return
	do_sparks(2, TRUE, M)
	M.show_message("<span class='warning'>\The [src] sparks and fizzles as its psychic wards wane away at last...</span>", MSG_VISUAL)

/obj/item/clothing/suit/space/hardsuit/ert/paranormal
	name = "paranormal response team suit"
	desc = "Powerful wards are built into this hardsuit, protecting the user from all manner of paranormal threats."
	icon_state = "knight_grey"
	item_state = "knight_grey"
	helmettype = /obj/item/clothing/head/helmet/space/hardsuit/ert/paranormal
	max_heat_protection_temperature = FIRE_IMMUNITY_MAX_TEMP_PROTECT
	resistance_flags = FIRE_PROOF
	var/charges = INFINITY

/obj/item/clothing/suit/space/hardsuit/ert/paranormal/Initialize(mapload)
	. = ..()
	AddComponent(/datum/component/anti_magic, TRUE, TRUE, FALSE, ITEM_SLOT_OCLOTHING, charges, TRUE, null, CALLBACK(src, PROC_REF(anti_magic_gone)))

/obj/item/clothing/suit/space/hardsuit/ert/paranormal/proc/anti_magic_gone()
	var/mob/M = loc
	if(!istype(M))
		return
	do_sparks(2, TRUE, M)
	M.show_message("<span class='warning'>\The [src] sparks and fizzles as its anti magic wards wane away at last...</span>", MSG_VISUAL)

/obj/item/clothing/suit/space/hardsuit/ert/paranormal/inquisitor
	name = "inquisitor's hardsuit"
	icon_state = "hardsuit-inq"
	item_state = "hardsuit-inq"
	helmettype = /obj/item/clothing/head/helmet/space/hardsuit/ert/paranormal/inquisitor

/obj/item/clothing/head/helmet/space/hardsuit/ert/paranormal/inquisitor
	name = "inquisitor's helmet"
	icon_state = "hardsuit0-inq"
	item_state = "hardsuit0-inq"

/obj/item/clothing/suit/space/hardsuit/ert/paranormal/inquisitor/old
	desc = "Powerful wards are built into this hardsuit, protecting the user from all manner of paranormal threats. Alas, this one looks pretty worn out and rusted."
	armor = list(MELEE = 55, BULLET = 40, LASER = 40, ENERGY = 40, BOMB = 40, BIO = 80, RAD = 80, FIRE = 60, ACID = 60, WOUND = 20)
	slowdown = 0.8
	helmettype = /obj/item/clothing/head/helmet/space/hardsuit/ert/paranormal/inquisitor/old
	charges = 12

/obj/item/clothing/head/helmet/space/hardsuit/ert/paranormal/inquisitor/old
	desc = "A helmet worn by those who deal with paranormal threats for a living. Alas, this one looks pretty worn out and rusted."
	armor = list(MELEE = 55, BULLET = 40, LASER = 40, ENERGY = 40, BOMB = 40, BIO = 80, RAD = 80, FIRE = 60, ACID = 60, WOUND = 20)
	charges = 12

/obj/item/clothing/suit/space/hardsuit/ert/paranormal/beserker
	name = "champion's hardsuit"
	desc = "Voices echo from the hardsuit, driving the user insane."
	icon_state = "hardsuit-beserker"
	item_state = "hardsuit-beserker"
	helmettype = /obj/item/clothing/head/helmet/space/hardsuit/ert/paranormal/beserker

/obj/item/clothing/head/helmet/space/hardsuit/ert/paranormal/beserker
	name = "champion's helmet"
	desc = "Peering into the eyes of the helmet is enough to seal damnation."
	icon_state = "hardsuit0-beserker"
	item_state = "hardsuit0-beserker"

/obj/item/clothing/suit/space/hardsuit/ert/paranormal/beserker/old
	desc = "Voices echo from the hardsuit, driving the user insane. This one is pretty battle-worn, but still fearsome."
	armor = list(MELEE = 55, BULLET = 40, LASER = 40, ENERGY = 40, BOMB = 40, BIO = 80, RAD = 80, FIRE = 60, ACID = 60, WOUND = 20)
	slowdown = 0.8
	helmettype = /obj/item/clothing/head/helmet/space/hardsuit/ert/paranormal/beserker/old
	charges = 6

/obj/item/clothing/head/helmet/space/hardsuit/ert/paranormal/beserker/old
	desc = "Peering into the eyes of the helmet is enough to seal damnation. This one is pretty battle-worn, but still fearsome."
	armor = list(MELEE = 55, BULLET = 40, LASER = 40, ENERGY = 40, BOMB = 40, BIO = 80, RAD = 80, FIRE = 60, ACID = 60, WOUND = 20)
	charges = 6

/obj/item/clothing/head/helmet/space/fragile
	name = "emergency space helmet"
	desc = "A bulky, air-tight helmet meant to protect the user during emergency situations. It doesn't look very durable."
	icon_state = "syndicate-helm-orange"
	item_state = "syndicate-helm-orange"
	armor = list(MELEE = 5, BULLET = 0, LASER = 0, ENERGY = 0, BOMB = 0, BIO = 0, RAD = 10, FIRE = 0, ACID = 0, WOUND = 5)
	strip_delay = 65

/obj/item/clothing/suit/space/fragile
	name = "emergency space suit"
	desc = "A bulky, air-tight suit meant to protect the user during emergency situations. It doesn't look very durable."
	var/torn = FALSE
	icon_state = "syndicate-orange"
	item_state = "syndicate-orange"
	slowdown = 2
	armor = list(MELEE = 5, BULLET = 0, LASER = 0, ENERGY = 0, BOMB = 0, BIO = 0, RAD = 10, FIRE = 0, ACID = 0, WOUND = 5)
	strip_delay = 65

/obj/item/clothing/suit/space/fragile/run_block(mob/living/owner, atom/object, damage, attack_text, attack_type, armour_penetration, mob/attacker, def_zone, final_block_chance, list/block_return)
	. = ..()
	if(!torn && prob(50) && damage >= 5)
		to_chat(owner, "<span class='warning'>[src] tears from the damage, breaking the air-tight seal!</span>")
		clothing_flags &= ~STOPSPRESSUREDAMAGE
		name = "torn [src]."
		desc = "A bulky suit meant to protect the user during emergency situations, at least until someone tore a hole in the suit."
		torn = TRUE
		playsound(loc, 'sound/weapons/slashmiss.ogg', 50, 1)
		playsound(loc, 'sound/effects/refill.ogg', 50, 1)

/obj/item/clothing/suit/space/eva/paramedic
	name = "paramedic EVA suit"
	icon_state = "paramedic-eva"
	item_state = "paramedic-eva"
	desc = "A deep blue space suit decorated with medical insignia to indicate that the wearer is trained emergency medical personnel."
	allowed = list(/obj/item/flashlight, /obj/item/tank/internals, /obj/item/roller)

/obj/item/clothing/head/helmet/space/eva/paramedic
	name = "paramedic EVA helmet"
	desc = "A deep blue space helmet decorated with medical insignia to designate the wearer as trained emergency medical personnel."
	icon_state = "paramedic-eva-helmet"
	item_state = "paramedic-eva-helmet"

/obj/item/clothing/suit/space/hunter
	name = "bounty hunting suit"
	desc = "A custom version of the MK.II SWAT suit, modified to look rugged and tough. Works as a space suit, if you can find a helmet."
	icon_state = "hunter"
	item_state = "swat_suit"
	allowed = list(/obj/item/gun, /obj/item/ammo_box, /obj/item/ammo_casing, /obj/item/melee/baton, /obj/item/restraints/handcuffs, /obj/item/tank/internals, /obj/item/kitchen/knife/combat)
	armor = list(MELEE = 60, BULLET = 40, LASER = 40, ENERGY = 50, BOMB = 100, BIO = 100, RAD = 100, FIRE = 100, ACID = 100, WOUND = 25)
	strip_delay = 130
	resistance_flags = FIRE_PROOF | ACID_PROOF

