/obj/item/reagent_containers/glass/bottle/vial
	name = "hypospray vial"
	desc = "This is a vial suitable for loading into mk II hyposprays."
	icon = 'modular_citadel/icons/obj/vial.dmi'
	icon_state = "hypovial"
	spillable = FALSE
	var/comes_with = list() //Easy way of doing this.
	volume = 10
	obj_flags = UNIQUE_RENAME
	unique_reskin = list("Hypospray vial" = "hypovial",
						"Red hypospray vial" = "hypovial-b",
						"Blue hypospray vial" = "hypovial-d",
						"Green hypospray vial" = "hypovial-a",
						"Orange hypospray vial" = "hypovial-k",
						"Purple hypospray vial" = "hypovial-p",
						"Black hypospray vial" = "hypovial-t"
						)

/obj/item/reagent_containers/glass/bottle/vial/Initialize()
	. = ..()
	if(!icon_state)
		icon_state = "hypovial"
	for(var/R in comes_with)
		reagents.add_reagent(R,comes_with[R])
	update_icon()


/obj/item/reagent_containers/glass/bottle/vial/on_reagent_change()
	update_icon()

/obj/item/reagent_containers/glass/bottle/vial/update_icon()
	cut_overlays()
	if(reagents.total_volume)
		var/mutable_appearance/filling = mutable_appearance('modular_citadel/icons/obj/vial.dmi', "hypovial10")

		var/percent = round((reagents.total_volume / volume) * 100)
		switch(percent)
			if(0 to 9)
				filling.icon_state = "hypovial10"
			if(10 to 29)
				filling.icon_state = "hypovial25"
			if(30 to 49)
				filling.icon_state = "hypovial50"
			if(50 to 85)
				filling.icon_state = "hypovial75"
			if(86 to INFINITY)
				filling.icon_state = "hypovial100"

		filling.color = mix_color_from_reagents(reagents.reagent_list)
		add_overlay(filling)

/obj/item/reagent_containers/glass/bottle/vial/small
	volume = 30

/obj/item/reagent_containers/glass/bottle/vial/large
	name = "large hypospray vial"
	desc = "This is a vial suitable for loading into the Chief Medical Officer's Hypospray mk II."
	icon_state = "hypoviallarge"
	volume = 60
	unique_reskin = list("Large hypospray vial" = "hypoviallarge",
						"Red hypospray vial" = "hypoviallarge-b",
						"Blue hypospray vial" = "hypoviallarge-d",
						"Green hypospray vial" = "hypoviallarge-a",
						"Orange hypospray vial" = "hypoviallarge-k",
						"Purple hypospray vial" = "hypoviallarge-p",
						"Black hypospray vial" = "hypoviallarge-t"
						)

/obj/item/reagent_containers/glass/bottle/vial/large/update_icon()
	cut_overlays()
	if(reagents.total_volume)
		var/mutable_appearance/filling = mutable_appearance('modular_citadel/icons/obj/vial.dmi', "hypoviallarge10")

		var/percent = round((reagents.total_volume / volume) * 100)
		switch(percent)
			if(0 to 9)
				filling.icon_state = "hypoviallarge10"
			if(10 to 29)
				filling.icon_state = "hypoviallarge25"
			if(30 to 49)
				filling.icon_state = "hypoviallarge50"
			if(50 to 85)
				filling.icon_state = "hypoviallarge75"
			if(86 to INFINITY)
				filling.icon_state = "hypoviallarge100"

		filling.color = mix_color_from_reagents(reagents.reagent_list)
		add_overlay(filling)


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

/obj/item/reagent_containers/glass/bottle/vial/small/preloaded/tricord
	name = "vial (tricordrazine)"
	icon_state = "hypovial"
	comes_with = list("tricordrazine" = 30)

/obj/item/reagent_containers/glass/bottle/vial/large/preloaded/CMO
	name = "large vial (CMO Special)"
	icon_state = "hypoviallarge-cmos"
	comes_with = list("epinephrine" = 15, "omnizine" = 15, "leporazine" = 15, "atropine" = 15)

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

/obj/item/reagent_containers/glass/bottle/vial/large/preloaded/combat
	name = "large combat injection vial"
	icon_state = "hypoviallarge-t"
	comes_with = list("epinephrine" = 15, "omnizine" = 15, "leporazine" = 15, "atropine" = 15)