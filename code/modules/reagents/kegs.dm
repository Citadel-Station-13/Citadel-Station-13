/obj/structure/reagent_dispensers/keg
	name = "keg"
	desc = "A keg."
	icon_state = "keg"
	var/reagent_type = "water"

/obj/structure/reagent_dispensers/keg/New()
	..()
	reagents.add_reagent(reagent_type,1000)

/obj/structure/reagent_dispensers/keg/blob_act()
	qdel(src)

/obj/structure/reagent_dispensers/keg/mead
	name = "keg of mead"
	desc = "A keg of mead."
	icon_state = "orangekeg"
	reagent_type = "mead"

/obj/structure/reagent_dispensers/keg/aphro
	name = "keg of aphrodisiac"
	desc = "A keg of aphrodisiac."
	icon_state = "pinkkeg"
	reagent_type = "hornychem"

/obj/structure/reagent_dispensers/keg/milk
	name = "keg of milk"
	desc = "It's not quite what you were hoping for."
	icon_state = "whitekeg"
	reagent_type = "milk"

/obj/structure/reagent_dispensers/keg/semen
	name = "keg of semen"
	desc = "Dear lord, where did this even come from?"
	icon_state = "whitekeg"
	reagent_type = "semen"

/obj/structure/reagent_dispensers/keg/gargle
	name = "keg of pan galactic gargleblaster"
	desc = "A keg of... wow that's a long name."
	icon_state = "bluekeg"
	reagent_type = "gargleblaster"