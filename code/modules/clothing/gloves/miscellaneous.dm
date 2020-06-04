
/obj/item/clothing/gloves/fingerless
	name = "fingerless gloves"
	desc = "Plain black gloves without fingertips for the hard working."
	icon_state = "fingerless"
	item_state = "fingerless"
	transfer_prints = TRUE
	strip_delay = 40
	equip_delay_other = 20
	cold_protection = HANDS
	min_cold_protection_temperature = GLOVES_MIN_TEMP_PROTECT
	strip_mod = 0.9
	custom_price = 75

/obj/item/clothing/gloves/fingerless/pugilist
	name = "armwraps"
	desc = "A series of armwraps. Makes you pretty keen to start punching people."
	icon_state = "armwraps"
	item_state = "armwraps"
	body_parts_covered = ARMS
	cold_protection = ARMS
	strip_delay = 300 //you can't just yank them off
	///Extra damage through the punch.
	var/enhancement = 0 //it's a +0 to your punches because it isn't magical
	///Main trait added by the gloves to the user on wear.
	var/inherited_trait = TRAIT_NOGUNS //what are you, dishonoroable?
	///Secondary trait added by the gloves to the user on wear.
	var/secondary_trait = TRAIT_FEARLESS //what are you, a coward?

/obj/item/clothing/gloves/fingerless/pugilist/equipped(mob/user, slot)
	. = ..()
	if(slot == SLOT_GLOVES)
		if(ishuman(user))
			var/mob/living/carbon/human/H = user
			ADD_TRAIT(H, TRAIT_PUGILIST, GLOVE_TRAIT)
			ADD_TRAIT(H, inherited_trait, GLOVE_TRAIT)
			ADD_TRAIT(H, secondary_trait, GLOVE_TRAIT)
			H.dna.species.punchdamagehigh += enhancement
			H.dna.species.punchdamagelow += enhancement

/obj/item/clothing/gloves/fingerless/pugilist/dropped(mob/user)

	REMOVE_TRAIT(user, TRAIT_PUGILIST, GLOVE_TRAIT)
	REMOVE_TRAIT(user, inherited_trait, GLOVE_TRAIT)
	REMOVE_TRAIT(user, secondary_trait, GLOVE_TRAIT)
	if(ishuman(user))
		var/mob/living/carbon/human/H = user
		H.dna.species.punchdamagehigh = initial(H.dna.species.punchdamagehigh)
		H.dna.species.punchdamagelow = initial(H.dna.species.punchdamagelow)
	return ..()

/obj/item/clothing/gloves/fingerless/pugilist/chaplain
	name = "armwraps of unyielding resolve"
	desc = "A series of armwraps, soaked in holy water. Makes you pretty keen to smite evil magic users."
	resistance_flags = FIRE_PROOF | ACID_PROOF
	enhancement = 2 //It is not magic that makes you punch harder, but force of will. Trust me.
	secondary_trait = TRAIT_ANTIMAGIC
	var/chaplain_spawnable = TRUE

/obj/item/clothing/gloves/fingerless/pugilist/chaplain/Initialize()
	. = ..()
	AddComponent(/datum/component/anti_magic, TRUE, TRUE, FALSE, null, null, FALSE)

/obj/item/clothing/gloves/fingerless/pugilist/magic
	name = "armwraps of mighty fists"
	desc = "A series of armwraps. Makes you pretty keen to go adventuring and punch dragons."
	resistance_flags = FIRE_PROOF | ACID_PROOF //magic items are harder to damage with energy this is a dnd joke okay?
	enhancement = 1 //They're +1!

/obj/item/clothing/gloves/fingerless/pugilist/hungryghost
	name = "armwraps of the hungry ghost"
	desc = "A series of blackened, bloodstained armwraps stitched with strange geometric symbols. Makes you pretty keen to commit horrible acts against the living through bloody carnage."
	icon_state = "narsiearmwraps"
	item_state = "narsiearmwraps"
	resistance_flags = FIRE_PROOF | ACID_PROOF
	armor = list("melee" = 10, "bullet" = 0, "laser" = 0, "energy" = 0, "bomb" = 0, "bio" = 35, "rad" = 0, "fire" = 50, "acid" = 50)
	enhancement = 3
	secondary_trait = TRAIT_KI_VAMPIRE

/obj/item/clothing/gloves/fingerless/pugilist/brassmountain
	name = "armbands of the brass mountain"
	desc = "A series of scolding hot brass armbands. Makes you pretty keen to bring the light to the unenlightened through unmitigated violence."
	icon_state = "ratvararmwraps"
	item_state = "ratvararmwraps"
	resistance_flags = FIRE_PROOF | ACID_PROOF
	armor = list("melee" = 10, "bullet" = 0, "laser" = -10, "energy" = 0, "bomb" = 0, "bio" = 35, "rad" = 0, "fire" = 50, "acid" = 50)
	enhancement = 4 //The artifice of Ratvar is unmatched except when it is.
	secondary_trait = TRAIT_STRONG_GRABBER

/obj/item/clothing/gloves/fingerless/pugilist/rapid
	name = "Bands of the North Star"
	desc = "The armbands of a deadly martial artist. Makes you pretty keen to put an end to evil in an extremely violent manner."
	icon_state = "rapid"
	item_state = "rapid"
	enhancement = 10 //omae wa mou shindeiru
	var/warcry = "AT"
	secondary_trait = TRAIT_NOSOFTCRIT //basically extra health

/obj/item/clothing/gloves/fingerless/pugilist/rapid/Initialize()
	. = ..()
	ADD_TRAIT(src, TRAIT_NODROP, GLOVE_TRAIT)

/obj/item/clothing/gloves/fingerless/pugilist/rapid/Touch(atom/target, proximity = TRUE)
	if(!isliving(target))
		return

	var/mob/living/M = loc
	M.changeNext_move(CLICK_CD_RAPID)
	if(warcry)
		M.say("[warcry]", ignore_spam = TRUE, forced = TRUE)

	return FALSE

/obj/item/clothing/gloves/fingerless/pugilist/rapid/AltClick(mob/user)
	var/input = stripped_input(user,"What do you want your battlecry to be? Max length of 6 characters.", ,"", 7)
	if(input)
		warcry = input

/obj/item/clothing/gloves/fingerless/pugilist/hug
	name = "Hugs of the North Star"
	desc = "The armbands of a humble friend. Makes you pretty keen to go let everyone know how much you appreciate them!"
	icon_state = "rapid"
	item_state = "rapid"
	enhancement = 0
	secondary_trait = TRAIT_PACIFISM //You are only here to hug and be friends!

/obj/item/clothing/gloves/fingerless/pugilist/hug/Touch(mob/target, proximity = TRUE)
	if(!isliving(target))
		return

	var/mob/living/M = loc

	if(M.a_intent != INTENT_HELP)
		return FALSE
	if(target.stat != CONSCIOUS) //Can't hug people who are dying/dead
		return FALSE
	else
		M.changeNext_move(CLICK_CD_RAPID)

	return FALSE

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
	resistance_flags = NONE
	armor = list("melee" = 0, "bullet" = 0, "laser" = 0, "energy" = 0, "bomb" = 0, "bio" = 0, "rad" = 0, "fire" = 70, "acid" = 30)
	strip_mod = 0.9

/obj/item/clothing/gloves/combat
	name = "combat gloves"
	desc = "These tactical gloves are fireproof and shock resistant."
	icon_state = "combat"
	item_state = "blackgloves"
	siemens_coefficient = 0
	permeability_coefficient = 0.05
	strip_delay = 80
	cold_protection = HANDS
	min_cold_protection_temperature = GLOVES_MIN_TEMP_PROTECT
	heat_protection = HANDS
	max_heat_protection_temperature = GLOVES_MAX_TEMP_PROTECT
	resistance_flags = NONE
	armor = list("melee" = 0, "bullet" = 0, "laser" = 0, "energy" = 0, "bomb" = 0, "bio" = 0, "rad" = 0, "fire" = 80, "acid" = 50)
	strip_mod = 1.5


/obj/item/clothing/gloves/bracer
	name = "bone bracers"
	desc = "For when you're expecting to get slapped on the wrist. Offers modest protection to your arms."
	icon_state = "bracers"
	item_state = "bracers"
	transfer_prints = TRUE
	strip_delay = 40
	equip_delay_other = 20
	body_parts_covered = ARMS
	cold_protection = ARMS
	min_cold_protection_temperature = GLOVES_MIN_TEMP_PROTECT
	max_heat_protection_temperature = GLOVES_MAX_TEMP_PROTECT
	resistance_flags = NONE
	armor = list("melee" = 15, "bullet" = 35, "laser" = 35, "energy" = 20, "bomb" = 35, "bio" = 35, "rad" = 35, "fire" = 0, "acid" = 0)

/obj/item/clothing/gloves/thief
	name = "black gloves"
	desc = "Gloves made with completely frictionless, insulated cloth, easier to steal from people with."
	icon_state = "thief"
	item_state = "blackgloves"
	siemens_coefficient = 0
	permeability_coefficient = 0.05
	strip_delay = 80
	transfer_prints = FALSE
	strip_mod = 5
	strip_silence = TRUE
