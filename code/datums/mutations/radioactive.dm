/datum/mutation/human/radioactive
	name = "Radioactivity"
	desc = "A volatile mutation that causes the host to sent out deadly beta radiation. This affects both the hosts and their surroundings."
	quality = NEGATIVE
	text_gain_indication = "<span class='warning'>You can feel it in your bones!</span>"
	tick_life = TRUE
	time_coeff = 5
	instability = 5
	difficulty = 8
	power_coeff = 1
	synchronizer_coeff = 1

/datum/mutation/human/radioactive/on_life()
	radiation_pulse(owner, 20 * GET_MUTATION_SYNCHRONIZER(src))

/datum/mutation/human/radioactive/New(class_ = MUT_OTHER, timer, datum/mutation/human/copymut)
	..()
	if(!(type in visual_indicators))
		visual_indicators[type] = list(mutable_appearance('icons/effects/genetics.dmi', "radiation", -MUTATIONS_LAYER))

/datum/mutation/human/radioactive/get_visual_indicator()
	return visual_indicators[type][1]

/datum/mutation/human/radioactive/modify()
	. = ..()
	if(IS_MUT_EMPOWERED(src) && !power)
		power = /obj/effect/proc_holder/spell/targeted/radioactive_pulse
		grant_spell()
		power.charge_max = initial(power.charge_max) * GET_MUTATION_ENERGY(src)
		power.charge_counter = initial(power.charge_counter) * GET_MUTATION_ENERGY(src)
	else if(power)
		owner.RemoveSpell(power)

/obj/effect/proc_holder/spell/targeted/radioactive_pulse
	name = "Radioactivity Pulse"
	desc = "Release a burst of radioactivity on your location, irradiating and possibly damaing yourself as drawback."
	charge_max = 1500
	clothes_req = FALSE
	range = -1
	include_user = TRUE
	action_icon = 'icons/obj/decals.dmi'
	action_icon_state = "radiation"
	sound = 'sound/items/geiger/med1.ogg'

/obj/effect/proc_holder/spell/targeted/radioactive_pulse/cast(list/targets, mob/user = usr)
	radiation_pulse(user, 50 * GET_MUTATION_POWER(associated_mutation), 3)
	if(iscarbon(user))
		var/mob/living/carbon/C = user
		C.radiation += rand(20, 50) * GET_MUTATION_SYNCHRONIZER(associated_mutation)
		if(IS_GENETIC_MUTATION(associated_mutation) && prob(GET_DNA_INSTABILITY(C.dna)) * 2)
			C.adjustBrainLoss(rand(10, 20))