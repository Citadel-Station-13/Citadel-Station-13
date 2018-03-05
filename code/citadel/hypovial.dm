/obj/item/reagent_containers/glass/bottle/vial
	name = "hypospray vial"
	desc = "This is a vial suitable for loading into mk II hyposprays."
	icon = 'icons/obj/citadel/vial.dmi'
	icon_state = "hypovial"
	w_class = WEIGHT_CLASS_SMALL //Why would it be the same size as a beaker?
	container_type = OPENCONTAINER
	spillable = FALSE
	resistance_flags = ACID_PROOF
	var/comes_with = list() //Easy way of doing this.
	volume = 10

/obj/item/reagent_containers/glass/bottle/vial/Initialize()
	. = ..()
	if(!icon_state)
		icon_state = "hypovial"
	update_icon()

/obj/item/reagent_containers/glass/bottle/vial/on_reagent_change()
	update_icon()

/obj/item/reagent_containers/glass/bottle/vial/update_icon()
	cut_overlays()
	if(reagents.total_volume)
		var/mutable_appearance/filling = mutable_appearance('icons/obj/citadel/vial.dmi', "[icon_state]10")

		var/percent = round((reagents.total_volume / volume) * 100)
		switch(percent)
			if(0 to 9)
				filling.icon_state = "[icon_state]10"
			if(10 to 29)
				filling.icon_state = "[icon_state]25"
			if(30 to 49)
				filling.icon_state = "[icon_state]50"
			if(50 to 69)
				filling.icon_state = "[icon_state]75"
			if(70 to INFINITY)
				filling.icon_state = "[icon_state]100"

		filling.color = mix_color_from_reagents(reagents.reagent_list)
		add_overlay(filling)

/obj/item/reagent_containers/glass/bottle/vial/small
	volume = 30

/obj/item/reagent_containers/glass/bottle/vial/large
	name = "large hypospray vial"
	desc = "This is a vial suitable for loading into the Chief Medical Officer's Hypospray mk II."
	icon_state = "hypoviallarge"
	volume = 60

/obj/item/reagent_containers/glass/bottle/vial/New()
	..()
	for(var/R in comes_with)
		reagents.add_reagent(R,comes_with[R])

/obj/item/reagent_containers/glass/bottle/vial/small/preloaded/bicaridine
	name = "vial (bicaridine)"
	icon_state = "hypovial-b"
	comes_with = list("bicaridine" = 30)

/obj/item/reagent_containers/glass/bottle/vial/small/preloaded/antitoxin
	name = "vial (Anti-Tox)"
	icon_state = "hypovial-a"
	comes_with = list("antitoxin" = 30)

/obj/item/reagent_containers/glass/bottle/vial/small/preloaded/kelotane
	name = "vial (kelotane)"
	icon_state = "hypovial-k"
	comes_with = list("kelotane" = 30)

/obj/item/reagent_containers/glass/bottle/vial/small/preloaded/dexalin
	name = "vial (dexalin)"
	icon_state = "hypovial-d"
	comes_with = list("dexalin" = 30)

/obj/item/reagent_containers/glass/bottle/vial/small/preloaded/tricordrazine
	name = "vial (tricordrazine)"
	icon_state = "hypovial"
	comes_with = list("tricordrazine" = 30)

/obj/item/reagent_containers/glass/bottle/vial/large/preloaded/CMO
	name = "large vial (CMO Special)"
	icon_state = "hypoviallarge-cmos"
	comes_with = list("epinephrine" = 15, "kelotane" = 15, "charcoal" = 15, "bicaridine" = 15)

/obj/item/reagent_containers/glass/bottle/vial/large/preloaded/bicaridine
	name = "large vial (bicaridine)"
	icon_state = "hypoviallarge-b"
	comes_with = list("bicaridine" = 60)

/obj/item/reagent_containers/glass/bottle/vial/large/preloaded/antitoxin
	name = "large vial (Anti-Tox)"
	icon_state = "hypoviallarge-a"
	comes_with = list("antitoxin" = 60)

/obj/item/reagent_containers/glass/bottle/vial/large/preloaded/kelotane
	name = "large vial (kelotane)"
	icon_state = "hypoviallarge-k"
	comes_with = list("kelotane" = 60)

/obj/item/reagent_containers/glass/bottle/vial/large/preloaded/dexalin
	name = "large vial (dexalin)"
	icon_state = "hypoviallarge-d"
	comes_with = list("dexalin" = 60)
