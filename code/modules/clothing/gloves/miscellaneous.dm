
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
	custom_price = PRICE_ALMOST_CHEAP

/obj/item/clothing/gloves/fingerless/pugilist
	name = "armwraps"
	desc = "A series of armwraps. Makes you pretty keen to start punching people."
	icon_state = "armwraps"
	item_state = "armwraps"
	body_parts_covered = ARMS
	cold_protection = ARMS
	strip_delay = 300 //you can't just yank them off
	obj_flags = UNIQUE_RENAME
	/// did you ever get around to wearing these or no
	var/wornonce = FALSE
	///Extra damage through the punch.
	var/enhancement = 0 //it's a +0 to your punches because it isn't magical
	///extra wound bonus through the punch (MAYBE DON'T BE GENEROUS WITH THIS)
	var/wound_enhancement = 0
	/// do we give the flavortext for wearing them
	var/silent = FALSE
	///Main trait added by the gloves to the user on wear.
	var/inherited_trait = TRAIT_NOGUNS //what are you, dishonoroable?
	///Secondary trait added by the gloves to the user on wear.
	var/secondary_trait = TRAIT_FEARLESS //what are you, a coward?

/obj/item/clothing/gloves/fingerless/pugilist/equipped(mob/user, slot)
	. = ..()
	if(slot == SLOT_GLOVES)
		wornonce = TRUE
		if((HAS_TRAIT(user, TRAIT_NOPUGILIST)))
			to_chat(user, "<span class='danger'>What purpose is there to don the weapons of pugilism if you're already well-practiced in martial arts? Mixing arts is blasphemous!</span>")
			return
		use_buffs(user, TRUE)

/obj/item/clothing/gloves/fingerless/pugilist/dropped(mob/user)
	. = ..()
	if(wornonce)
		wornonce = FALSE
		if((HAS_TRAIT(user, TRAIT_NOPUGILIST)))
			return
		use_buffs(user, FALSE)

/obj/item/clothing/gloves/fingerless/pugilist/proc/use_buffs(mob/user, buff)
	if(buff) // tarukaja
		if(ishuman(user))
			var/mob/living/carbon/human/H = user
			ADD_TRAIT(H, TRAIT_PUGILIST, GLOVE_TRAIT)
			ADD_TRAIT(H, inherited_trait, GLOVE_TRAIT)
			ADD_TRAIT(H, secondary_trait, GLOVE_TRAIT)
			H.dna.species.punchdamagehigh += enhancement
			H.dna.species.punchdamagelow += enhancement
			H.dna.species.punchwoundbonus += wound_enhancement
			if(!silent)
				to_chat(H, "<span class='notice'>With [src] on your arms, you feel ready to punch things.</span>")
	else // dekaja
		REMOVE_TRAIT(user, TRAIT_PUGILIST, GLOVE_TRAIT)
		REMOVE_TRAIT(user, inherited_trait, GLOVE_TRAIT)
		REMOVE_TRAIT(user, secondary_trait, GLOVE_TRAIT)
		if(ishuman(user))
			var/mob/living/carbon/human/H = user
			H.dna.species.punchdamagehigh -= enhancement
			H.dna.species.punchdamagelow -= enhancement
			H.dna.species.punchwoundbonus -= wound_enhancement
			H.dna?.species?.attack_sound_override = null
		if(!silent)
			to_chat(user, "<span class='warning'>With [src] off of your arms, you feel less ready to punch things.</span>")

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
	wound_enhancement = 10
	var/warcry = "AT"
	secondary_trait = TRAIT_NOSOFTCRIT //basically extra health

/obj/item/clothing/gloves/fingerless/pugilist/rapid/Initialize()
	. = ..()
	ADD_TRAIT(src, TRAIT_NODROP, GLOVE_TRAIT)

/obj/item/clothing/gloves/fingerless/pugilist/rapid/Touch(atom/target, proximity = TRUE)
	if(!isliving(target))
		return

	var/mob/living/M = loc
	M.SetNextAction(CLICK_CD_RAPID)
	if(warcry)
		M.say("[warcry]", ignore_spam = TRUE, forced = TRUE)

	return NO_AUTO_CLICKDELAY_HANDLING | ATTACK_IGNORE_ACTION

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
		M.SetNextAction(CLICK_CD_RAPID)

	return NO_AUTO_CLICKDELAY_HANDLING | ATTACK_IGNORE_ACTION

/obj/item/clothing/gloves/fingerless/ablative
	name = "ablative armwraps"
	desc = "Armwraps made out of a highly durable, reflective metal. Has the side effect of absorbing shocks."
	siemens_coefficient = 0
	icon_state = "ablative_armwraps"
	item_state = "ablative_armwraps"
	block_parry_data = /datum/block_parry_data/ablative_armwraps
	var/wornonce = FALSE

/obj/item/clothing/gloves/fingerless/ablative/proc/get_component_parry_data(datum/source, parrying_method, datum/parrying_item_mob_or_art, list/backup_items, list/override)
	if(parrying_method && !(parrying_method == UNARMED_PARRY))
		return
	override[src] = ITEM_PARRY

/obj/item/clothing/gloves/fingerless/ablative/equipped(mob/user, slot)
	. = ..()
	if(current_equipped_slot == SLOT_GLOVES)
		RegisterSignal(user, COMSIG_LIVING_ACTIVE_PARRY_START, .proc/get_component_parry_data)
		wornonce = TRUE

/obj/item/clothing/gloves/fingerless/ablative/dropped(mob/user)
	. = ..()
	if(wornonce)
		UnregisterSignal(user, COMSIG_LIVING_ACTIVE_PARRY_START)
		wornonce = FALSE

/obj/item/clothing/gloves/fingerless/ablative/can_active_parry(mob/user)
	var/mob/living/carbon/human/H = user
	if(!istype(H))
		return FALSE
	return src == H.gloves

/obj/item/clothing/gloves/fingerless/ablative/on_active_parry(mob/living/owner, atom/object, damage, attack_text, attack_type, armour_penetration, mob/attacker, def_zone, list/block_return, parry_efficiency, parry_time)
	. = ..()
	if(parry_efficiency > 0)
		owner.visible_message("<span class='warning'>[owner] deflects \the [object] with their armwraps!</span>")

/datum/block_parry_data/ablative_armwraps
	parry_stamina_cost = 4
	parry_attack_types = ATTACK_TYPE_UNARMED | ATTACK_TYPE_PROJECTILE | ATTACK_TYPE_TACKLE | ATTACK_TYPE_THROWN | ATTACK_TYPE_MELEE
	parry_flags = NONE

	parry_time_windup = 0
	parry_time_spindown = 0
	parry_time_active = 7.5

	parry_time_perfect = 1
	parry_time_perfect_leeway = 7.5
	parry_imperfect_falloff_percent = 20
	parry_efficiency_perfect = 100
	parry_time_perfect_leeway_override = list(
		TEXT_ATTACK_TYPE_MELEE = 1
	)

	parry_efficiency_considered_successful = 0.01
	parry_efficiency_to_counterattack = INFINITY	// no auto counter
	parry_max_attacks = INFINITY
	parry_failed_cooldown_duration = 2.25 SECONDS
	parry_failed_stagger_duration = 2.25 SECONDS
	parry_cooldown = 0
	parry_failed_clickcd_duration = 0

/obj/item/clothing/gloves/fingerless/pugilist/mauler
	name = "mauler gauntlets"
	desc = "Plastitanium gauntlets coated in a thick nano-weave carbon material and implanted with nanite injectors that boost the wielder's strength six-fold."
	icon_state = "mauler_gauntlets"
	item_state = "mauler_gauntlets"
	transfer_prints = FALSE
	body_parts_covered = ARMS|HANDS
	cold_protection = ARMS|HANDS
	min_cold_protection_temperature = GLOVES_MIN_TEMP_PROTECT
	max_heat_protection_temperature = GLOVES_MAX_TEMP_PROTECT
	armor = list("melee" = 30, "bullet" = 30, "laser" = 10, "energy" = 10, "bomb" = 55, "bio" = 15, "rad" = 15, "fire" = 80, "acid" = 50)
	siemens_coefficient = 0
	permeability_coefficient = 0.05
	strip_delay = 80
	enhancement = 12 // same as the changeling gauntlets but without changeling utility
	wound_enhancement = 12
	silent = TRUE
	inherited_trait = TRAIT_CHUNKYFINGERS // your fingers are fat because the gloves are
	secondary_trait = TRAIT_MAULER // commit table slam

/obj/item/clothing/gloves/fingerless/pugilist/mauler/equipped(mob/user, slot)
	. = ..()
	if(slot == SLOT_GLOVES)
		wornonce = TRUE
		if((HAS_TRAIT(user, TRAIT_NOPUGILIST)))
			return
		use_mauls(user, TRUE)

/obj/item/clothing/gloves/fingerless/pugilist/mauler/dropped(mob/user)
	. = ..()
	if(wornonce)
		wornonce = FALSE
		if((HAS_TRAIT(user, TRAIT_NOPUGILIST)))
			return
		use_mauls(user, FALSE)

/obj/item/clothing/gloves/fingerless/pugilist/mauler/proc/use_mauls(mob/user, maul)
	if(maul)
		if(ishuman(user))
			var/mob/living/carbon/human/H = user
			H.dna?.species?.attack_sound_override = 'sound/weapons/mauler_punch.ogg'
			if(silent)
				to_chat(H, "<span class='danger'>You feel prickles around your wrists as [src] cling to them - strength courses through your veins!</span>")

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

/obj/item/clothing/gloves/evening
	name = "evening gloves"
	desc = "Thin, pretty gloves intended for use in regal feminine attire. A tag on the hem claims they were 'maid' in Space China, these were probably intended for use in some maid fetish."
	icon_state = "evening"
	item_state = "evening"
	transfer_prints = TRUE
	cold_protection = HANDS
	min_cold_protection_temperature = GLOVES_MIN_TEMP_PROTECT
	strip_mod = 0.9

/obj/item/clothing/gloves/evening/black
	name = "midnight gloves"
	desc = "Thin, pretty gloves intended for use in sexy feminine attire. A tag on the hem claims they pair great with black stockings."
	icon_state = "eveningblack"
	item_state = "eveningblack"
