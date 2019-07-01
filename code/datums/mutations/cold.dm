//Cold Resistance gives your entire body an orange halo, and makes you immune to the effects of vacuum and cold.
/datum/mutation/human/cold_resistance
	name = "Cold Resistance"
	desc = "A strange mutation that renders the host immune to extremely cold degrees. Won't protect the user from heat or the vacuum of space."
	quality = POSITIVE
	difficulty = 12
	text_gain_indication = "<span class='notice'>Your body feels warm!</span>"
	time_coeff = 5
	instability = 15

/datum/mutation/human/cold_resistance/New(class_ = MUT_OTHER, timer, datum/mutation/human/copymut)
	..()
	if(!(type in visual_indicators))
		visual_indicators[type] = list(mutable_appearance('icons/effects/genetics.dmi', "fire", -MUTATIONS_LAYER))

/datum/mutation/human/cold_resistance/get_visual_indicator()
	return visual_indicators[type][1]

/datum/mutation/human/cold_resistance/on_acquiring(mob/living/carbon/human/owner)
	. = ..()
	if(.)
		return
	ADD_TRAIT(owner, TRAIT_RESISTCOLD, GENETIC_MUTATION)

/datum/mutation/human/cold_resistance/on_losing(mob/living/carbon/human/owner)
	. = ..()
	if(.)
		return
	REMOVE_TRAIT(owner, TRAIT_RESISTCOLD, GENETIC_MUTATION)

/datum/mutation/human/geladikinesis
	name = "Geladikinesis"
	desc = "Allows the user to concentrate moisture and sub-zero forces into snow."
	quality = POSITIVE
	text_gain_indication = "<span class='notice'>Your hand feels cold.</span>"
	instability = 10
	difficulty = 10
	synchronizer_coeff = 1
	power = /obj/effect/proc_holder/spell/targeted/conjure_item/snow

/obj/effect/proc_holder/spell/targeted/conjure_item/snow
	name = "Create Snow"
	desc = "Concentrates cryokinetic forces to create snow, useful for snow-like construction."
	item_type = /obj/item/stack/sheet/mineral/snow
	charge_max = 50
	delete_old = FALSE
	action_icon = 'icons/mob/actions/actions_genetic.dmi'
	action_icon_state = "snow"

/datum/mutation/human/cryokinesis
	name = "Cryokinesis"
	desc = "Draws negative energy from the sub-zero void to freeze surrounding temperatures at subject's will."
	quality = POSITIVE //upsides and downsides
	text_gain_indication = "<span class='notice'>Your hand feels cold.</span>"
	instability = 20
	difficulty = 12
	synchronizer_coeff = 1
	power = /obj/effect/proc_holder/spell/aimed/cryo

/obj/effect/proc_holder/spell/aimed/cryo
	name = "Cryobeam"
	desc = "This power fires a frozen bolt at a target."
	charge_max = 150
	cooldown_min = 150
	clothes_req = FALSE
	range = 3
	action_icon = 'icons/mob/actions/actions_genetic.dmi'
	projectile_type = /obj/item/projectile/temp/cryo
	base_icon_state = "icebeam"
	action_icon_state = "icebeam"
	active_msg = "You focus your cryokinesis!"
	deactive_msg = "You relax."
	active = FALSE
