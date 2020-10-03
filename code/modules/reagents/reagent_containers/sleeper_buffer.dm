//Created if a sleeper is deconstructed, to contain the reagents within it.
/obj/item/reagent_containers/sleeper_buffer
	name = "Sleeper buffer container"
	desc = "A closed container for insertion in the Medical Sleepers."
	icon_state = "sleeper_buffer"
	volume = 500
	reagent_flags = NO_REACT
	spillable = TRUE
	resistance_flags = ACID_PROOF
	amount_per_transfer_from_this = 0
	possible_transfer_amounts = list()
