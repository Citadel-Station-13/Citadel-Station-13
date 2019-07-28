/*/////////////////////////////////////////////////////////////////////////////////
///////																		///////
///////								Star Trek Stuffs						///////
///////																		///////
*//////////////////////////////////////////////////////////////////////////////////
//  <3 Nienhaus && Joan.
// I made the Voy and DS9 stuff tho. - Poojy

/obj/item/clothing/suit/trek
	allowed = list(
		/obj/item/flashlight, /obj/item/analyzer,
		/obj/item/radio, /obj/item/tank/internals/emergency_oxygen,
		/obj/item/reagent_containers/hypospray, /obj/item/healthanalyzer,/obj/item/reagent_containers/syringe,
		/obj/item/reagent_containers/glass/bottle/vial,/obj/item/reagent_containers/glass/beaker,
		/obj/item/reagent_containers/pill,/obj/item/storage/pill_bottle, /obj/item/restraints/handcuffs,/obj/item/hypospray
		)
	body_parts_covered = CHEST|GROIN|ARMS
	mutantrace_variation = NO_MUTANTRACE_VARIATION

/obj/item/clothing/suit/trek/ds9
	name = "Padded Overcoat"
	desc = "The overcoat worn by all officers of the 2380s."
	icon_state = "trek_ds9_coat"
	item_state = "trek_ds9_coat"
	permeability_coefficient = 0.50

/obj/item/clothing/suit/trek/ds9/admiral // Only for adminuz
	name = "Admiral Overcoat"
	desc = "Admirality specialty coat to keep flag officers fashionable and protected."
	icon_state = "trek_ds9_coat_adm"
	item_state = "trek_ds9_coat_adm"
	permeability_coefficient = 0.01
	armor = list("melee" = 50, "bullet" = 50, "laser" = 50,"energy" = 50, "bomb" = 50, "bio" = 50, "rad" = 50, "fire" = 50, "acid" = 50)

//MODERN ish Joan sqrl sprites. I think

//For general use
/obj/item/clothing/suit/trek/fedcoat
	name = "Federation Uniform Jacket"
	desc = "A uniform jacket from the United Federation. Set phasers to awesome."
	icon_state = "fedcoat"
	item_state = "fedcoat"

	blood_overlay_type = "coat"
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
	var/unbuttoned = 0

/obj/item/clothing/suit/trek/fedcoat/verb/toggle()
	set name = "Toggle coat buttons"
	set category = "Object"
	set src in usr

	if(!usr.incapacitated())
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
/obj/item/clothing/suit/trek/fedcoat/medsci
	icon_state = "fedblue"
	item_state = "fedblue"

/obj/item/clothing/suit/trek/fedcoat/eng
	icon_state = "fedeng"
	item_state = "fedeng"

/obj/item/clothing/suit/trek/fedcoat/capt
	icon_state = "fedcapt"
	item_state = "fedcapt"
	armor = list("melee" = 10, "bullet" = 5, "laser" = 5,"energy" = 5, "bomb" = 5, "bio" = 5, "rad" = 10, "fire" = 10, "acid" = 0)


//"modern" ones for fancy

/obj/item/clothing/suit/trek/modernfedcoat
	name = "Modern Federation Uniform Jacket"
	desc = "A modern uniform jacket from the United Federation."
	icon_state = "fedmodern"
	item_state = "fedmodern"

	//Variants
/obj/item/clothing/suit/trek/modernfedcoat/medsci
	icon_state = "fedmodernblue"
	item_state = "fedmodernblue"

/obj/item/clothing/suit/trek/modernfedcoat/eng
	icon_state = "fedmoderneng"
	item_state = "fedmoderneng"

/obj/item/clothing/suit/trek/modernfedcoat/sec
	icon_state = "fedmodernsec"
	item_state = "fedmodernsec"
	armor = list("melee" = 10, "bullet" = 5, "laser" = 5,"energy" = 5, "bomb" = 5, "bio" = 5, "rad" = 10, "fire" = 10, "acid" = 0)

