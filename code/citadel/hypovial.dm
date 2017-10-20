/obj/item/reagent_containers/glass/bottle/vial
	possible_transfer_amounts = list(5,10)
	icon = 'icons/obj/citadel/vial.dmi'
	icon_state = hyposprayvial
	w_class = ITEMSIZE_SMALL //Why would it be the same size as a beaker?
	var/comes_with = list() //Easy way of doing this.
	volume = 20

/obj/item/reagent_containers/glass/bottle/vial/Initialize()
	. = ..()
	if(!icon_state)
		icon_state = "bottle"
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
	possible_transfer_amounts = list(5,10,15,30,120) //cmo hypo should be able to dump lots into it
	volume = 120

/obj/item/reagent_containers/glass/bottle/vial/New()
	..()
	for(var/R in comes_with)
		reagents.add_reagent(R,comes_with[R])

/obj/item/reagent_containers/glass/bottle/vial/small/preloaded/bicaridine
	name = "vial (bicaridine)"
	comes_with = list("bicaridine" = 30)

/obj/item/reagent_containers/glass/bottle/vial/small/preloaded/antitoxin
	name = "vial (Anti-Tox)"
	comes_with = list("antitoxin" = 30)

/obj/item/reagent_containers/glass/bottle/vial/small/preloaded/dermaline
	name = "vial (dermaline)"
	comes_with = list("dermaline" = 30)

/obj/item/reagent_containers/glass/bottle/vial/small/preloaded/kelotane
	name = "vial (kelotane)"
	comes_with = list("kelotane" = 30)

/obj/item/reagent_containers/glass/bottle/vial/small/preloaded/dexalin
	name = "vial (dexalin)"
	comes_with = list("dexalin" = 30)

/obj/item/reagent_containers/glass/bottle/vial/small/preloaded/dexalinplus
	name = "vial (dexalinp)"
	comes_with = list("dexalinp" = 30)

/obj/item/reagent_containers/glass/bottle/vial/small/preloaded/tricordrazine
	name = "vial (tricordrazine)"
	comes_with = list("tricordrazine" = 30)

/obj/item/reagen_containers/glass/bottle/vial/large/preloaded/CMO
	name = "vial (CMO Special)"
	comes_with = list("epinephrine" = 30, "kelotane" = 30, "antitoxin" = 30, "bicaridine" = 30)
