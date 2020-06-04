/obj/item/clothing/under/misc/pj/red
	name = "red pj's"
	desc = "Sleepwear."
	icon_state = "red_pyjamas"
	item_state = "w_suit"
	can_adjust = FALSE

/obj/item/clothing/under/misc/pj/blue
	name = "blue pj's"
	desc = "Sleepwear."
	icon_state = "blue_pyjamas"
	item_state = "w_suit"
	can_adjust = FALSE

/obj/item/clothing/under/misc/patriotsuit
	name = "Patriotic Suit"
	desc = "Motorcycle not included."
	icon_state = "ek"
	item_state = "ek"
	can_adjust = FALSE

/obj/item/clothing/under/rank/prisoner
	name = "prison jumpsuit"
	desc = "It's standardised Nanotrasen prisoner-wear. Its suit sensors are stuck in the \"Fully On\" position."
	icon_state = "prisoner"
	item_state = "o_suit"
	has_sensor = LOCKED_SENSORS
	sensor_mode = SENSOR_COORDS
	random_sensor = FALSE

/obj/item/clothing/under/rank/prisoner/skirt
	name = "prison jumpskirt"
	desc = "It's standardised Nanotrasen prisoner-wear. Its suit sensors are stuck in the \"Fully On\" position."
	icon_state = "prisoner_skirt"
	item_state = "o_suit"
	body_parts_covered = CHEST|GROIN|ARMS
	can_adjust = FALSE
	fitted = FEMALE_UNIFORM_TOP
	mutantrace_variation = STYLE_DIGITIGRADE|STYLE_NO_ANTHRO_ICON

/obj/item/clothing/under/misc/mailman
	name = "mailman's jumpsuit"
	desc = "<i>'Special delivery!'</i>"
	icon_state = "mailman"
	item_state = "b_suit"

/obj/item/clothing/under/misc/psyche
	name = "psychedelic jumpsuit"
	desc = "Groovy!"
	icon_state = "psyche"
	item_state = "p_suit"

/obj/item/clothing/under/misc/vice_officer
	name = "vice officer's jumpsuit"
	desc = "It's the standard issue pretty-boy outfit, as seen on Holo-Vision."
	icon_state = "vice"
	item_state = "gy_suit"
	can_adjust = FALSE


/obj/item/clothing/under/misc/adminsuit
	name = "administrative cybernetic jumpsuit"
	icon_state = "syndicate"
	item_state = "bl_suit"
	desc = "A cybernetically enhanced jumpsuit used for administrative duties."
	gas_transfer_coefficient = 0.01
	permeability_coefficient = 0.01
	body_parts_covered = CHEST|GROIN|LEGS|FEET|ARMS|HANDS
	armor = list("melee" = 100, "bullet" = 100, "laser" = 100,"energy" = 100, "bomb" = 100, "bio" = 100, "rad" = 100, "fire" = 100, "acid" = 100)
	cold_protection = CHEST | GROIN | LEGS | FEET | ARMS | HANDS
	min_cold_protection_temperature = SPACE_SUIT_MIN_TEMP_PROTECT
	heat_protection = CHEST|GROIN|LEGS|FEET|ARMS|HANDS
	max_heat_protection_temperature = SPACE_SUIT_MAX_TEMP_PROTECT
	can_adjust = FALSE
	resistance_flags = FIRE_PROOF | ACID_PROOF

/obj/item/clothing/under/misc/burial
	name = "burial garments"
	desc = "Traditional burial garments from the early 22nd century."
	icon_state = "burial"
	item_state = "burial"
	has_sensor = NO_SENSORS

/obj/item/clothing/under/misc/overalls
	name = "laborer's overalls"
	desc = "A set of durable overalls for getting the job done."
	icon_state = "overalls"
	item_state = "lb_suit"
	can_adjust = FALSE
	custom_price = 60

/obj/item/clothing/under/misc/assistantformal
	name = "assistant's formal uniform"
	desc = "An assistant's formal-wear. Why an assistant needs formal-wear is still unknown."
	icon_state = "assistant_formal"
	item_state = "gy_suit"
	can_adjust = FALSE

/obj/item/clothing/under/misc/staffassistant
	name = "staff assistant's jumpsuit"
	desc = "It's a generic grey jumpsuit. That's about what assistants are worth, anyway."
	icon = 'goon/icons/obj/item_js_rank.dmi'
	mob_overlay_icon = 'goon/icons/mob/worn_js_rank.dmi'
	icon_state = "assistant"
	item_state = "gy_suit"
	mutantrace_variation = USE_TAUR_CLIP_MASK

/obj/item/clothing/under/croptop
	name = "crop top"
	desc = "We've saved money by giving you half a shirt!"
	icon_state = "croptop"
	body_parts_covered = CHEST|GROIN|ARMS
	fitted = FEMALE_UNIFORM_TOP
	can_adjust = FALSE

/obj/item/clothing/under/plasmaman
	name = "plasma envirosuit"
	desc = "A special containment suit that allows plasma-based lifeforms to exist safely in an oxygenated environment, and automatically extinguishes them in a crisis. Despite being airtight, it's not spaceworthy."
	icon_state = "plasmaman"
	item_state = "plasmaman"
	armor = list("melee" = 0, "bullet" = 0, "laser" = 0, "energy" = 0, "bomb" = 0, "bio" = 100, "rad" = 0, "fire" = 95, "acid" = 95)
	slowdown = 1
	body_parts_covered = CHEST|GROIN|LEGS|FEET|ARMS|HANDS
	mutantrace_variation = USE_TAUR_CLIP_MASK
	can_adjust = FALSE
	strip_delay = 80
	var/next_extinguish = 0
	var/extinguish_cooldown = 100
	var/extinguishes_left = 5

/obj/item/clothing/under/plasmaman/examine(mob/user)
	. = ..()
	. += "<span class='notice'>There are [extinguishes_left] extinguisher charges left in this suit.</span>"

/obj/item/clothing/under/plasmaman/proc/Extinguish(mob/living/carbon/human/H)
	if(!istype(H))
		return
	if(H.on_fire)
		if(extinguishes_left)
			if(next_extinguish > world.time)
				return
			next_extinguish = world.time + extinguish_cooldown
			extinguishes_left--
			H.visible_message("<span class='warning'>[H]'s suit automatically extinguishes [H.p_them()]!</span>","<span class='warning'>Your suit automatically extinguishes you.</span>")
			H.ExtinguishMob()
			new /obj/effect/particle_effect/water(get_turf(H))
	return 0

/obj/item/clothing/under/plasmaman/attackby(obj/item/E, mob/user, params)
	..()
	if (istype(E, /obj/item/extinguisher_refill))
		if (extinguishes_left == 5)
			to_chat(user, "<span class='notice'>The inbuilt extinguisher is full.</span>")
			return
		else
			extinguishes_left = 5
			to_chat(user, "<span class='notice'>You refill the suit's built-in extinguisher, using up the cartridge.</span>")
			qdel(E)
			return
	return

/obj/item/extinguisher_refill
	name = "envirosuit extinguisher cartridge"
	desc = "A cartridge loaded with a compressed extinguisher mix, used to refill the automatic extinguisher on plasma envirosuits."
	icon_state = "plasmarefill"
	icon = 'icons/obj/device.dmi'

/obj/item/clothing/under/misc/gear_harness
	name = "gear harness"
	desc = "A simple, inconspicuous harness replacement for a jumpsuit."
	icon_state = "gear_harness"
	item_state = "gear_harness"
	body_parts_covered = CHEST|GROIN
	can_adjust = FALSE

/obj/item/clothing/under/misc/durathread
	name = "durathread jumpsuit"
	desc = "A jumpsuit made from durathread, its resilient fibres provide some protection to the wearer."
	icon_state = "durathread"
	item_state = "durathread"
	can_adjust = TRUE
	armor = list("melee" = 10, "laser" = 10, "fire" = 40, "acid" = 10, "bomb" = 5)

/obj/item/clothing/under/misc/durathread/skirt
	name = "durathread jumpskirt"
	desc = "A jumpsuit made from durathread, its resilient fibres provide some protection to the wearer. Being a short skirt, it naturally doesn't protect the legs."
	icon_state = "duraskirt"
	item_state = "duraskirt"
	can_adjust = FALSE
	body_parts_covered = CHEST|GROIN|ARMS
	mutantrace_variation = STYLE_DIGITIGRADE|STYLE_NO_ANTHRO_ICON

/obj/item/clothing/under/misc/squatter
	name = "slav squatter tracksuit"
	desc = "Cyka blyat."
	icon_state = "squatteroutfit"
	item_state = "squatteroutfit"
	can_adjust = FALSE
	mutantrace_variation = USE_TAUR_CLIP_MASK

/obj/item/clothing/under/misc/blue_camo
	name = "russian blue camo"
	desc = "Drop and give me dvadtsat!"
	icon_state = "russobluecamo"
	item_state = "russobluecamo"
	can_adjust = FALSE
	mutantrace_variation = USE_TAUR_CLIP_MASK

/obj/item/clothing/under/misc/keyholesweater
	name = "keyhole sweater"
	desc = "What is the point of this, anyway?"
	icon_state = "keyholesweater"
	item_state = "keyholesweater"
	can_adjust = FALSE
	mutantrace_variation = STYLE_DIGITIGRADE|STYLE_NO_ANTHRO_ICON

/obj/item/clothing/under/misc/stripper
	name = "pink stripper outfit"
	icon_state = "stripper_p"
	item_state = "stripper_p"
	body_parts_covered = CHEST|GROIN
	can_adjust = FALSE
	mutantrace_variation = STYLE_DIGITIGRADE|STYLE_NO_ANTHRO_ICON

/obj/item/clothing/under/misc/stripper/green
	name = "green stripper outfit"
	icon_state = "stripper_g"
	item_state = "stripper_g"

/obj/item/clothing/under/misc/stripper/mankini
	name = "pink mankini"
	icon_state = "mankini"
	item_state = "mankini"

/obj/item/clothing/under/misc/corporateuniform
	name = "corporate uniform"
	desc = "A comfortable, tight fitting jumpsuit made of premium materials. Not space-proof."
	icon_state = "tssuit"
	item_state = "r_suit"
	can_adjust = FALSE
	mutantrace_variation = USE_TAUR_CLIP_MASK

/obj/item/clothing/under/misc/poly_shirt
	name = "polychromic button-up shirt"
	desc = "A fancy button-up shirt made with polychromic threads."
	icon_state = "polysuit"
	item_state = "sl_suit"
	mutantrace_variation = NONE

/obj/item/clothing/under/misc/poly_shirt/ComponentInitialize()
	. = ..()
	AddElement(/datum/element/polychromic, list("#FFFFFF", "#353535", "#353535"), 3)

/obj/item/clothing/under/misc/polyshorts
	name = "polychromic shorts"
	desc = "For ease of movement and style."
	icon_state = "polyshorts"
	item_state = "rainbow"
	can_adjust = FALSE
	body_parts_covered = CHEST|GROIN|ARMS

/obj/item/clothing/under/misc/polyshorts/ComponentInitialize()
	. = ..()
	AddElement(/datum/element/polychromic, list("#353535", "#808080", "#808080"), 3)

/obj/item/clothing/under/misc/polyjumpsuit
	name = "polychromic tri-tone jumpsuit"
	desc = "A fancy jumpsuit made with polychromic threads."
	icon_state = "polyjump"
	item_state = "rainbow"
	can_adjust = FALSE
	mutantrace_variation = NONE

/obj/item/clothing/under/misc/polyjumpsuit/ComponentInitialize()
	. = ..()
	AddElement(/datum/element/polychromic, list("#FFFFFF", "#808080", "#353535"), 3)

/obj/item/clothing/under/misc/poly_bottomless
	name = "polychromic bottomless shirt"
	desc = "Great for showing off your underwear in dubious style."
	icon_state = "polybottomless"
	item_state = "rainbow"
	body_parts_covered = CHEST|ARMS	//Because there's no bottom included
	can_adjust = FALSE
	mutantrace_variation = STYLE_DIGITIGRADE|STYLE_NO_ANTHRO_ICON

/obj/item/clothing/under/misc/poly_bottomless/ComponentInitialize()
	. = ..()
	AddElement(/datum/element/polychromic, list("#808080", "#FF3535"), 2)

/obj/item/clothing/under/misc/poly_tanktop
	name = "polychromic tank top"
	desc = "For those lazy summer days."
	icon_state = "polyshimatank"
	item_state = "rainbow"
	body_parts_covered = CHEST|GROIN
	can_adjust = FALSE
	mutantrace_variation = STYLE_DIGITIGRADE|STYLE_NO_ANTHRO_ICON
	var/list/poly_states = 3
	var/list/poly_colors = list("#808080", "#FFFFFF", "#8CC6FF")

/obj/item/clothing/under/misc/poly_tanktop/ComponentInitialize()
	. = ..()
	AddElement(/datum/element/polychromic, poly_colors, poly_states)

/obj/item/clothing/under/misc/poly_tanktop/female
	name = "polychromic feminine tank top"
	desc = "Great for showing off your chest in style. Not recommended for males."
	icon_state = "polyfemtankpantsu"
	poly_states = 2
	poly_colors = list("#808080", "#FF3535")
