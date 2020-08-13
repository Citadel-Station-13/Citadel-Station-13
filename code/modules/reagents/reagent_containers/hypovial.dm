//hypovials used with the MkII hypospray. See hypospray.dm.

/obj/item/reagent_containers/glass/bottle/vial // these have literally no fucking right to just be better beakers that you can shit out of a chemmaster
	name = "broken hypovial"
	desc = "A hypovial compatible with most hyposprays."
	icon_state = "hypovial"
	spillable = FALSE
	volume = 10
	possible_transfer_amounts = list(1,2,5,10)
	container_flags = APTFT_VERB
	obj_flags = UNIQUE_RENAME
	unique_reskin = list("hypovial" = "hypovial",
						"red hypovial" = "hypovial-b",
						"blue hypovial" = "hypovial-d",
						"green hypovial" = "hypovial-a",
						"orange hypovial" = "hypovial-k",
						"purple hypovial" = "hypovial-p",
						"black hypovial" = "hypovial-t",
						"pink hypovial" = "hypovial-pink"
						)
	always_reskinnable = TRUE
	cached_icon = "hypovial"

/obj/item/reagent_containers/glass/bottle/vial/Initialize()
	. = ..()
	update_icon()

/obj/item/reagent_containers/glass/bottle/vial/on_reagent_change()
	update_icon()

/obj/item/reagent_containers/glass/bottle/vial/tiny
	name = "small hypovial"
	//Shouldn't be possible to get this without adminbuse

/obj/item/reagent_containers/glass/bottle/vial/small
	name = "hypovial"
	volume = 60
	possible_transfer_amounts = list(1,2,5,10,20)

/obj/item/reagent_containers/glass/bottle/vial/small/bluespace
	volume = 120
	possible_transfer_amounts = list(1,2,5,10,20)
	name = "bluespace hypovial"
	icon_state = "hypovialbs"
	unique_reskin = null

/obj/item/reagent_containers/glass/bottle/vial/large
	name = "large hypovial"
	desc = "A large hypovial, for deluxe hypospray models."
	icon_state = "hypoviallarge"
	volume = 120
	possible_transfer_amounts = list(1,2,5,10,20)
	unique_reskin = list("large hypovial" = "hypoviallarge",
						"large red hypovial" = "hypoviallarge-b",
						"large blue hypovial" = "hypoviallarge-d",
						"large green hypovial" = "hypoviallarge-a",
						"large orange hypovial" = "hypoviallarge-k",
						"large purple hypovial" = "hypoviallarge-p",
						"large black hypovial" = "hypoviallarge-t"
						)
	cached_icon = "hypoviallarge"

/obj/item/reagent_containers/glass/bottle/vial/large/bluespace
	possible_transfer_amounts = list(1,2,5,10,20)
	name = "bluespace large hypovial"
	volume = 240
	icon_state = "hypoviallargebs"
	unique_reskin = null


/obj/item/reagent_containers/glass/bottle/vial/small/bicaridine
	name = "red hypovial (bicaridine)"
	icon_state = "hypovial-b"
	list_reagents = list(/datum/reagent/medicine/bicaridine = 30)

/obj/item/reagent_containers/glass/bottle/vial/small/antitoxin
	name = "green hypovial (Anti-Tox)"
	icon_state = "hypovial-a"
	list_reagents = list(/datum/reagent/medicine/antitoxin = 30)

/obj/item/reagent_containers/glass/bottle/vial/small/kelotane
	name = "orange hypovial (kelotane)"
	icon_state = "hypovial-k"
	list_reagents = list(/datum/reagent/medicine/kelotane = 30)

/obj/item/reagent_containers/glass/bottle/vial/small/dexalin
	name = "blue hypovial (dexalin)"
	icon_state = "hypovial-d"
	list_reagents = list(/datum/reagent/medicine/dexalin = 30)

/obj/item/reagent_containers/glass/bottle/vial/small/tricord
	name = "hypovial (tricordrazine)"
	icon_state = "hypovial"
	list_reagents = list(/datum/reagent/medicine/tricordrazine = 30)

/obj/item/reagent_containers/glass/bottle/vial/large/CMO
	name = "deluxe hypovial"
	icon_state = "hypoviallarge-cmos"
	list_reagents = list(/datum/reagent/medicine/omnizine = 20, /datum/reagent/medicine/leporazine = 20, /datum/reagent/medicine/atropine = 20)

/obj/item/reagent_containers/glass/bottle/vial/large/bicaridine
	name = "large red hypovial (bicaridine)"
	icon_state = "hypoviallarge-b"
	list_reagents = list(/datum/reagent/medicine/bicaridine = 60)

/obj/item/reagent_containers/glass/bottle/vial/large/antitoxin
	name = "large green hypovial (anti-tox)"
	icon_state = "hypoviallarge-a"
	list_reagents = list(/datum/reagent/medicine/antitoxin = 60)

/obj/item/reagent_containers/glass/bottle/vial/large/kelotane
	name = "large orange hypovial (kelotane)"
	icon_state = "hypoviallarge-k"
	list_reagents = list(/datum/reagent/medicine/kelotane = 60)

/obj/item/reagent_containers/glass/bottle/vial/large/dexalin
	name = "large blue hypovial (dexalin)"
	icon_state = "hypoviallarge-d"
	list_reagents = list(/datum/reagent/medicine/dexalin = 60)

/obj/item/reagent_containers/glass/bottle/vial/large/charcoal
	name = "large black hypovial (charcoal)"
	icon_state = "hypoviallarge-t"
	list_reagents = list(/datum/reagent/medicine/charcoal = 60)

/obj/item/reagent_containers/glass/bottle/vial/large/tricord
	name = "large hypovial (tricord)"
	icon_state = "hypoviallarge"
	list_reagents = list(/datum/reagent/medicine/tricordrazine = 60)

/obj/item/reagent_containers/glass/bottle/vial/large/salglu
	name = "large green hypovial (salglu)"
	icon_state = "hypoviallarge-a"
	list_reagents = list(/datum/reagent/medicine/salglu_solution = 60)

/obj/item/reagent_containers/glass/bottle/vial/large/synthflesh
	name = "large orange hypovial (synthflesh)"
	icon_state = "hypoviallarge-k"
	list_reagents = list(/datum/reagent/medicine/synthflesh = 60)

/obj/item/reagent_containers/glass/bottle/vial/large/combat
	name = "combat hypovial"
	icon_state = "hypoviallarge-t"
	list_reagents = list(/datum/reagent/medicine/epinephrine = 3, /datum/reagent/medicine/omnizine = 19, /datum/reagent/medicine/leporazine = 19, /datum/reagent/medicine/atropine = 19) //Epinephrine's main effect here is to kill suff damage, so we don't need much given atropine
