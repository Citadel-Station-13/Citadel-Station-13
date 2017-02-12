
/obj/item/clothing/gloves/fingerless
	name = "fingerless gloves"
	desc = "Plain black gloves without fingertips for the hard working."
	icon_state = "fingerless"
	item_state = "fingerless"
	item_color = null	//So they don't wash.
	transfer_prints = TRUE
	strip_delay = 40
	put_on_delay = 20
	cold_protection = HANDS
	min_cold_protection_temperature = GLOVES_MIN_TEMP_PROTECT

/obj/item/clothing/gloves/botanic_leather
	name = "botanist's leather gloves"
	desc = "These leather gloves protect against thorns, barbs, prickles, spikes and other harmful objects of floral origin.  They're also quite warm."
	icon_state = "leather"
	item_state = "ggloves"
	permeability_coefficient = 0.9
	cold_protection = HANDS
	min_cold_protection_temperature = GLOVES_MIN_TEMP_PROTECT
	heat_protection = HANDS
	max_heat_protection_temperature = GLOVES_MAX_TEMP_PROTECT
	resistance_flags = 0
	armor = list(melee = 0, bullet = 0, laser = 0, energy = 0, bomb = 0, bio = 0, rad = 0, fire = 70, acid = 30)

/obj/item/clothing/gloves/combat
	name = "combat gloves"
	desc = "These tactical gloves are fireproof and shock resistant."
	icon_state = "black"
	item_state = "blackgloves"
	siemens_coefficient = 0
	permeability_coefficient = 0.05
	strip_delay = 80
	cold_protection = HANDS
	min_cold_protection_temperature = GLOVES_MIN_TEMP_PROTECT
	heat_protection = HANDS
	max_heat_protection_temperature = GLOVES_MAX_TEMP_PROTECT
	resistance_flags = 0
	armor = list(melee = 0, bullet = 0, laser = 0, energy = 0, bomb = 0, bio = 0, rad = 0, fire = 80, acid = 50)


/obj/item/clothing/gloves/bracer
	name = "bone bracers"
	desc = "For when you're expecting to get slapped on the wrist. Offers modest protection to your arms."
	icon_state = "bracers"
	item_state = "bracers"
	item_color = null	//So they don't wash.
	transfer_prints = TRUE
	strip_delay = 40
	put_on_delay = 20
	body_parts_covered = ARMS
	cold_protection = ARMS
	min_cold_protection_temperature = GLOVES_MIN_TEMP_PROTECT
	max_heat_protection_temperature = GLOVES_MAX_TEMP_PROTECT
	resistance_flags = 0
	armor = list(melee = 15, bullet = 35, laser = 35, energy = 20, bomb = 35, bio = 35, rad = 35, fire = 0, acid = 0)

/obj/item/clothing/gloves/batmangloves
	desc = "Used for handling all things bat related."
	name = "batgloves"
	icon_state = "bmgloves"
	item_state = "bmgloves"
	item_color = "bmgloves"


obj/item/clothing/gloves/bikergloves
	name = "Biker's Gloves"
	icon_state = "biker-gloves"
	item_state = "biker-gloves"
	item_color = "bikergloves"

/obj/item/clothing/gloves/megagloves
	desc = "Uncomfortably bulky armored gloves."
	name = "DRN-001 Gloves"
	icon_state = "megagloves"
	item_state = "megagloves"


/obj/item/clothing/gloves/protogloves
	desc = "Funcionally identical to the DRN-001 model's, but in red!"
	name = "Prototype Gloves"
	icon_state = "protogloves"
	item_state = "protogloves"


/obj/item/clothing/gloves/megaxgloves
	desc = "An upgrade to the DRN-001's gauntlets, retains the uncomfortable armor, but comes with white gloves!"
	name = "Maverick Hunter gloves"
	icon_state = "megaxgloves"
	item_state = "megaxgloves"


/obj/item/clothing/gloves/joegloves
	desc = "Large grey gloves, very similar to the Prototype's."
	name = "Sniper Gloves"
	icon_state = "joegloves"
	item_state = "joegloves"


/obj/item/clothing/gloves/doomguy
	desc = ""
	name = "Doomguy's gloves"
	icon_state = "doom"
	item_state = "doom"


/obj/item/clothing/gloves/anchor_arms
	name = "Anchor Arms"
	desc = "When you're a jerk, everybody loves you."
	icon_state = "anchorarms"
	item_state = "anchorarms"

/obj/item/clothing/gloves/neorussian
	name = "neo-Russian gloves"
	desc = "Utilizes a non-slip technology that allows you to never drop your precious bottles of vodka."
	icon_state = "nr_gloves"
	item_state = "nr_gloves"


/obj/item/clothing/gloves/neorussian/fingerless
	name = "neo-Russian fingerless gloves"
	desc = "For these tense combat situations when you just have to pick your nose."
	icon_state = "nr_fgloves"
	item_state = "nr_fgloves"
