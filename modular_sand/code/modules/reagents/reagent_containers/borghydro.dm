/*
Borg Shaker
*/
/obj/item/reagent_containers/borghypo/borgshaker/beershaker
	name = "cyborg shaker"
	desc = "An advanced drink synthesizer and mixer."
	icon = 'modular_sand/icons/obj/drinks.dmi'
	icon_state = "beershaker"
	possible_transfer_amounts = list(5,10,20)
	charge_cost = 20 //Lots of reagents all regenerating at once, so the charge cost is lower. They also regenerate faster.
	recharge_time = 1
	accepts_reagent_upgrades = FALSE
	reagent_ids = list(	/datum/reagent/consumable/ethanol/beer,
						/datum/reagent/consumable/ethanol/whiskey,
						/datum/reagent/consumable/ethanol/vodka,
						/datum/reagent/consumable/ethanol/rum,
						/datum/reagent/consumable/ethanol/gin,
						/datum/reagent/consumable/ethanol/tequila,
						/datum/reagent/consumable/ethanol/vermouth,
						/datum/reagent/consumable/ethanol/wine,
						/datum/reagent/consumable/ethanol/kahlua,
						/datum/reagent/consumable/ethanol/cognac,
						/datum/reagent/consumable/ethanol/ale,
						/datum/reagent/consumable/ethanol/fernet,
						/datum/reagent/consumable/ethanol/triple_sec,
						/datum/reagent/consumable/nothing,
						/datum/reagent/consumable/laughter,
						/datum/reagent/consumable/ethanol/creme_de_menthe,
						/datum/reagent/consumable/ethanol/creme_de_cacao,
						/datum/reagent/consumable/ethanol/creme_de_coconut,
						/datum/reagent/consumable/ethanol/champagne,
						/datum/reagent/consumable/ethanol/thirteenloko,
						/datum/reagent/consumable/ethanol/absinthe,
						/datum/reagent/consumable/ethanol/hooch,
						/datum/reagent/consumable/ethanol/moonshine)


/obj/item/reagent_containers/borghypo/borgshaker/juiceshaker
	name = "cyborg shaker"
	desc = "An advanced drink synthesizer and mixer."
	icon = 'modular_sand/icons/obj/drinks.dmi'
	icon_state = "juiceshaker"
	possible_transfer_amounts = list(5,10,20)
	charge_cost = 20 //Lots of reagents all regenerating at once, so the charge cost is lower. They also regenerate faster.
	recharge_time = 1
	accepts_reagent_upgrades = FALSE
	reagent_ids = list(	/datum/reagent/consumable/orangejuice,
						/datum/reagent/consumable/limejuice,
						/datum/reagent/consumable/tomatojuice,
						/datum/reagent/consumable/carrotjuice,
						/datum/reagent/consumable/berryjuice,
						/datum/reagent/consumable/applejuice,
						/datum/reagent/consumable/peachjuice,
						/datum/reagent/consumable/strawberryjuice,
						/datum/reagent/consumable/pineapplejuice,
						/datum/reagent/consumable/watermelonjuice,
						/datum/reagent/consumable/parsnipjuice,
						/datum/reagent/consumable/grapejuice,
						/datum/reagent/consumable/potato_juice,
						/datum/reagent/consumable/pumpkinjuice,
						/datum/reagent/consumable/lemonjuice)

/obj/item/reagent_containers/borghypo/borgshaker/sodashaker
	name = "cyborg shaker"
	desc = "An advanced drink synthesizer and mixer."
	icon = 'modular_sand/icons/obj/drinks.dmi'
	icon_state = "sodashaker"
	possible_transfer_amounts = list(5,10,20)
	charge_cost = 20 //Lots of reagents all regenerating at once, so the charge cost is lower. They also regenerate faster.
	recharge_time = 1
	accepts_reagent_upgrades = FALSE
	reagent_ids = list(	/datum/reagent/consumable/space_cola,
						/datum/reagent/consumable/nuka_cola,
						/datum/reagent/consumable/spacemountainwind,
						/datum/reagent/consumable/dr_gibb,
						/datum/reagent/consumable/space_up,
						/datum/reagent/consumable/lemon_lime,
						/datum/reagent/consumable/pwr_game,
						/datum/reagent/consumable/shamblers,
						/datum/reagent/consumable/buzz_fuzz,
						/datum/reagent/consumable/grey_bull,
						/datum/reagent/consumable/cream_soda,
						/datum/reagent/consumable/sol_dry,
						/datum/reagent/consumable/tonic,
						/datum/reagent/consumable/sodawater)

/obj/item/reagent_containers/borghypo/borgshaker/miscshaker
	name = "cyborg shaker"
	desc = "An advanced drink synthesizer and mixer."
	icon = 'modular_sand/icons/obj/drinks.dmi'
	icon_state = "miscshaker"
	possible_transfer_amounts = list(5,10,20)
	charge_cost = 20 //Lots of reagents all regenerating at once, so the charge cost is lower. They also regenerate faster.
	recharge_time = 1
	accepts_reagent_upgrades = FALSE
	reagent_ids = list(	/datum/reagent/consumable/grenadine,
						/datum/reagent/consumable/banana,
						/datum/reagent/consumable/honey,
						/datum/reagent/consumable/sugar,
						/datum/reagent/consumable/vanilla,
						/datum/reagent/blood/synthetics,
						/datum/reagent/consumable/capsaicin,
						/datum/reagent/consumable/coco,
						/datum/reagent/consumable/menthol,
						/datum/reagent/consumable/ice,
						/datum/reagent/consumable/cream,
						/datum/reagent/consumable/milk,
						/datum/reagent/consumable/soymilk,
						/datum/reagent/consumable/coconutmilk,
						/datum/reagent/consumable/coffee,
						/datum/reagent/consumable/tea,
						/datum/reagent/consumable/lemonade,
						/datum/reagent/water)

/obj/item/reagent_containers/borghypo/borgshaker/hacked
	name = "cyborg shaker"
	desc = "Will mix drinks that knock them dead."
	icon = 'icons/obj/drinks.dmi'
	icon_state = "threemileislandglass"
	possible_transfer_amounts = list(5,10,20)
	charge_cost = 20 //Lots of reagents all regenerating at once, so the charge cost is lower. They also regenerate faster.
	recharge_time = 1
	accepts_reagent_upgrades = FALSE
	reagent_ids = list(	/datum/reagent/toxin/fakebeer,
						/datum/reagent/consumable/poisonberryjuice,
						/datum/reagent/toxin/itching_powder,
						/datum/reagent/toxin/bungotoxin,
						/datum/reagent/consumable/superlaughter)
