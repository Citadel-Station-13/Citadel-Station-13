/*/////////////////////////////////////////////////////////////////////////////////
///////																		///////
///////								Star Trek Stuffs						///////
///////																		///////
*//////////////////////////////////////////////////////////////////////////////////
//  <3 Nienhaus && Joan.
// I made the Voy and DS9 stuff tho. - Poojy
// Armor lists for even Heads of Staff is Nulled out do round start armor as well most armor going onto the suit itself rather then a armor slot - Trilby
///////////////////////////////////////////////////////////////////////////////////

//DS9

/obj/item/clothing/suit/trek/ds9
	name = "Padded Overcoat"
	desc = "The overcoat worn by all officers of the 2380s."
	icon_state = "trek_ds9_coat"
	item_state = "trek_ds9_coat"
	body_parts_covered = CHEST|GROIN|ARMS
	mutantrace_variation = NONE
	permeability_coefficient = 0.50
	allowed = list(
		/obj/item/flashlight, /obj/item/analyzer,
		/obj/item/radio, /obj/item/tank/internals/emergency_oxygen,
		/obj/item/reagent_containers/hypospray, /obj/item/healthanalyzer,/obj/item/reagent_containers/syringe,
		/obj/item/reagent_containers/glass/bottle/vial,/obj/item/reagent_containers/glass/beaker,
		/obj/item/reagent_containers/pill,/obj/item/storage/pill_bottle, /obj/item/restraints/handcuffs,/obj/item/hypospray
		)
	armor = list("melee" = 0, "bullet" = 0, "laser" = 0,"energy" = 0, "bomb" = 0, "bio" = 0, "rad" = 0, "fire" = 0, "acid" = 0)

/obj/item/clothing/suit/trek/ds9/admiral // Only for adminuz
	name = "Admiral Overcoat"
	desc = "Admirality specialty coat to keep flag officers fashionable and protected."
	icon_state = "trek_ds9_coat_adm"
	item_state = "trek_ds9_coat_adm"
	permeability_coefficient = 0.01
	armor = list("melee" = 50, "bullet" = 50, "laser" = 50,"energy" = 50, "bomb" = 50, "bio" = 50, "rad" = 50, "fire" = 50, "acid" = 50)

//MODERN ish Joan sqrl sprites. I think

//For general use
/obj/item/clothing/suit/fluff/fedcoat
	name = "Federation Uniform Jacket"
	desc = "A uniform jacket from the United Federation. Set phasers to awesome."
	icon_state = "fedcoat"
	item_state = "fedcoat"
	mutantrace_variation = NONE
	blood_overlay_type = "coat"
	body_parts_covered = CHEST|GROIN|ARMS
	allowed = list(
				/obj/item/tank/internals/emergency_oxygen,
				/obj/item/flashlight,
				/obj/item/analyzer,
				/obj/item/radio,
				/obj/item/gun,
				/obj/item/melee/baton,
				/obj/item/restraints/handcuffs,
				/obj/item/reagent_containers/hypospray,
				/obj/item/hypospray,
				/obj/item/healthanalyzer,
				/obj/item/reagent_containers/syringe,
				/obj/item/reagent_containers/glass/bottle/vial,
				/obj/item/reagent_containers/glass/beaker,
				/obj/item/storage/pill_bottle,
				/obj/item/taperecorder)
	armor = list("melee" = 0, "bullet" = 0, "laser" = 0,"energy" = 0, "bomb" = 0, "bio" = 0, "rad" = 0, "fire" = 0, "acid" = 0)
	var/unbuttoned = 0

	verb/toggle()
		set name = "Toggle coat buttons"
		set category = "Object"
		set src in usr

		var/mob/living/L = usr
		if(!istype(L) || !CHECK_MOBILITY(L, MOBILITY_USE))
			return FALSE

		switch(unbuttoned)
			if(0)
				icon_state = "[initial(icon_state)]_open"
				item_state = "[initial(item_state)]_open"
				unbuttoned = 1
				to_chat(usr,"You unbutton the coat.")
			if(1)
				icon_state = "[initial(icon_state)]"
				item_state = "[initial(item_state)]"
				unbuttoned = 0
				to_chat(usr,"You button up the coat.")
		usr.update_inv_wear_suit()

	//Variants
/obj/item/clothing/suit/fluff/fedcoat/medsci
		icon_state = "fedblue"
		item_state = "fedblue"

/obj/item/clothing/suit/fluff/fedcoat/eng
		icon_state = "fedeng"
		item_state = "fedeng"

/obj/item/clothing/suit/fluff/fedcoat/capt
		icon_state = "fedcapt"
		item_state = "fedcapt"

//"modern" ones for fancy

/obj/item/clothing/suit/fluff/modernfedcoat
	name = "Modern Federation Uniform Jacket"
	desc = "A modern uniform jacket from the United Federation."
	icon_state = "fedmodern"
	item_state = "fedmodern"
	body_parts_covered = CHEST|GROIN|ARMS
	allowed = list(
		/obj/item/flashlight, /obj/item/analyzer,
		/obj/item/radio, /obj/item/tank/internals/emergency_oxygen,
		/obj/item/reagent_containers/hypospray, /obj/item/healthanalyzer,/obj/item/reagent_containers/syringe,
		/obj/item/reagent_containers/glass/bottle/vial,/obj/item/reagent_containers/glass/beaker,
		/obj/item/reagent_containers/pill,/obj/item/storage/pill_bottle, /obj/item/restraints/handcuffs,/obj/item/hypospray
		)
	armor = list("melee" = 0, "bullet" = 0, "laser" = 0,"energy" = 0, "bomb" = 0, "bio" = 0, "rad" = 0, "fire" = 0, "acid" = 0)

	//Variants
/obj/item/clothing/suit/fluff/modernfedcoat/medsci
		icon_state = "fedmodernblue"
		item_state = "fedmodernblue"

/obj/item/clothing/suit/fluff/modernfedcoat/eng
		icon_state = "fedmoderneng"
		item_state = "fedmoderneng"

/obj/item/clothing/suit/fluff/modernfedcoat/sec
		icon_state = "fedmodernsec"
		item_state = "fedmodernsec"

//Not star trek stuff from here on

/obj/item/clothing/suit/armor/hos/trenchcoat/cloak
	name = "armored trenchcloak"
	desc = "A trenchcoat enchanced with a special lightweight kevlar. This one appears to be designed to be draped over one's shoulders rather than worn normally.."
	icon_state = "hostrench"
	item_state = "hostrench"
	mutantrace_variation = NONE
	body_parts_covered = CHEST|ARMS|LEGS

/obj/item/clothing/suit/hooded/cloak/david
	name = "red cloak"
	icon_state = "goliath_cloak"
	desc = "Ever wanted to look like a badass without ANY effort? Try this nanotrasen brand red cloak, perfect for kids"
	hoodtype = /obj/item/clothing/head/hooded/cloakhood/david
	body_parts_covered = CHEST|GROIN|ARMS
	mutantrace_variation = NONE

/obj/item/clothing/head/hooded/cloakhood/david
	name = "red cloak hood"
	icon_state = "golhood"
	desc = "conceal your face in shame with this nanotrasen brand hood"
	flags_inv = HIDEEARS|HIDEEYES|HIDEHAIR|HIDEFACIALHAIR
	mutantrace_variation = NONE
