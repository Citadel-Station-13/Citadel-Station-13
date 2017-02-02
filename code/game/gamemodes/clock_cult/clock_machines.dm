////////////////////////
// CLOCKWORK MACHINES //
////////////////////////
//not-actually-machines

/obj/structure/destructible/clockwork/powered
	var/obj/machinery/power/apc/target_apc
	var/active = FALSE
	var/needs_power = TRUE
	var/active_icon = null //icon_state while process() is being called
	var/inactive_icon = null //icon_state while process() isn't being called

/obj/structure/destructible/clockwork/powered/examine(mob/user)
	..()
	if(is_servant_of_ratvar(user) || isobserver(user))
		var/powered = total_accessable_power()
		user << "<span class='[powered ? "brass":"alloy"]'>It has access to <b>[powered == INFINITY ? "INFINITY":"[powered]"]W</b> of power.</span>"

/obj/structure/destructible/clockwork/powered/Destroy()
	SSfastprocess.processing -= src
	SSobj.processing -= src
	return ..()

/obj/structure/destructible/clockwork/powered/process()
	var/powered = total_accessable_power()
	return powered == PROCESS_KILL ? 25 : powered //make sure we don't accidentally return the arbitrary PROCESS_KILL define

/obj/structure/destructible/clockwork/powered/proc/toggle(fast_process, mob/living/user)
	if(user)
		if(!is_servant_of_ratvar(user))
			return 0
		user.visible_message("<span class='notice'>[user] [active ? "dis" : "en"]ables [src].</span>", "<span class='brass'>You [active ? "dis" : "en"]able [src].</span>")
	active = !active
	if(active)
		icon_state = active_icon
		if(fast_process)
			START_PROCESSING(SSfastprocess, src)
		else
			START_PROCESSING(SSobj, src)
	else
		icon_state = inactive_icon
		if(fast_process)
			STOP_PROCESSING(SSfastprocess, src)
		else
			STOP_PROCESSING(SSobj, src)


/obj/structure/destructible/clockwork/powered/proc/total_accessable_power() //how much power we have and can use
	if(!needs_power || ratvar_awakens)
		return INFINITY //oh yeah we've got power why'd you ask

	var/power = 0
	power += accessable_apc_power()
	power += accessable_sigil_power()
	return power

/obj/structure/destructible/clockwork/powered/proc/accessable_apc_power()
	var/power = 0
	var/area/A = get_area(src)
	var/area/targetAPCA
	for(var/obj/machinery/power/apc/APC in apcs_list)
		var/area/APCA = get_area(APC)
		if(APCA == A)
			target_apc = APC
	if(target_apc)
		targetAPCA = get_area(target_apc)
		if(targetAPCA != A)
			target_apc = null
		else if(target_apc.cell)
			var/apccharge = target_apc.cell.charge
			if(apccharge >= 50)
				power += apccharge
	return power

/obj/structure/destructible/clockwork/powered/proc/accessable_sigil_power()
	var/power = 0
	for(var/obj/effect/clockwork/sigil/transmission/T in range(1, src))
		power += T.power_charge
	return power


/obj/structure/destructible/clockwork/powered/proc/try_use_power(amount) //try to use an amount of power
	if(!needs_power || ratvar_awakens)
		return 1
	if(amount <= 0)
		return 0
	var/power = total_accessable_power()
	if(!power || power < amount)
		return 0
	return use_power(amount)

/obj/structure/destructible/clockwork/powered/proc/use_power(amount) //we've made sure we had power, so now we use it
	var/sigilpower = accessable_sigil_power()
	var/list/sigils_in_range = list()
	for(var/obj/effect/clockwork/sigil/transmission/T in range(1, src))
		sigils_in_range |= T
	while(sigilpower && amount >= 50)
		for(var/S in sigils_in_range)
			var/obj/effect/clockwork/sigil/transmission/T = S
			if(amount >= 50 && T.modify_charge(50))
				sigilpower -= 50
				amount -= 50
	var/apcpower = accessable_apc_power()
	while(apcpower >= 50 && amount >= 50)
		if(target_apc.cell.use(50))
			apcpower -= 50
			amount -= 50
			target_apc.update()
			target_apc.update_icon()
		else
			apcpower = 0
	if(amount)
		return 0
	else
		return 1

/obj/structure/destructible/clockwork/powered/proc/return_power(amount) //returns a given amount of power to all nearby sigils
	if(amount <= 0)
		return 0
	var/list/sigils_in_range = list()
	for(var/obj/effect/clockwork/sigil/transmission/T in range(1, src))
		sigils_in_range |= T
	if(!sigils_in_range.len)
		return 0
	while(amount >= 50)
		for(var/S in sigils_in_range)
			var/obj/effect/clockwork/sigil/transmission/T = S
			if(amount >= 50 && T.modify_charge(-50))
				amount -= 50
	return 1


/obj/structure/destructible/clockwork/powered/mending_motor //Mending motor: A prism that consumes replicant alloy to repair nearby mechanical servants at a quick rate.
	name = "mending motor"
	desc = "A dark onyx prism, held in midair by spiraling tendrils of stone."
	clockwork_desc = "A powerful prism that rapidly repairs nearby mechanical servants and clockwork structures."
	icon_state = "mending_motor_inactive"
	active_icon = "mending_motor"
	inactive_icon = "mending_motor_inactive"
	construction_value = 20
	max_health = 150
	health = 150
	break_message = "<span class='warning'>The prism collapses with a heavy thud!</span>"
	debris = list(/obj/item/clockwork/alloy_shards/small = 5, \
	/obj/item/clockwork/alloy_shards/medium = 1, \
	/obj/item/clockwork/alloy_shards/large = 1, \
	/obj/item/clockwork/component/vanguard_cogwheel = 1)
	var/stored_alloy = 0 //2500W = 1 alloy = 100 liquified alloy
	var/max_alloy = 25000
	var/mob_cost = 200
	var/structure_cost = 250
	var/cyborg_cost = 300

/obj/structure/destructible/clockwork/powered/mending_motor/prefilled
	stored_alloy = 2500 //starts with 1 replicant alloy/100 liquified alloy

/obj/structure/destructible/clockwork/powered/mending_motor/total_accessable_power()
	. = ..()
	if(. != INFINITY)
		. += accessable_alloy_power()

/obj/structure/destructible/clockwork/powered/mending_motor/proc/accessable_alloy_power()
	return stored_alloy

/obj/structure/destructible/clockwork/powered/mending_motor/use_power(amount)
	var/alloypower = accessable_alloy_power()
	while(alloypower >= 50 && amount >= 50)
		stored_alloy -= 50
		alloypower -= 50
		amount -= 50
	return ..()

/obj/structure/destructible/clockwork/powered/mending_motor/examine(mob/user)
	..()
	if(is_servant_of_ratvar(user) || isobserver(user))
		user << "<span class='alloy'>It contains <b>[stored_alloy*0.04]/[max_alloy*0.04]</b> units of liquified alloy, which is equivalent to <b>[stored_alloy]W/[max_alloy]W</b> of power.</span>"
		user << "<span class='inathneq_small'>It requires <b>[mob_cost]W</b> to heal clockwork mobs, <b>[structure_cost]W</b> for clockwork structures, and <b>[cyborg_cost]W</b> for cyborgs.</span>"

/obj/structure/destructible/clockwork/powered/mending_motor/process()
	if(..() < mob_cost)
		visible_message("<span class='warning'>[src] emits an airy chuckling sound and falls dark!</span>")
		toggle()
		return
	for(var/atom/movable/M in range(5, src))
		if(isclockmob(M) || istype(M, /mob/living/simple_animal/drone/cogscarab))
			var/mob/living/simple_animal/hostile/clockwork/W = M
			var/fatigued = FALSE
			if(istype(M, /mob/living/simple_animal/hostile/clockwork/marauder))
				var/mob/living/simple_animal/hostile/clockwork/marauder/E = M
				if(E.fatigue)
					fatigued = TRUE
			if((!fatigued && W.health == W.maxHealth) || W.stat)
				continue
			if(!try_use_power(mob_cost))
				break
			W.adjustHealth(-15)
		else if(istype(M, /obj/structure/destructible/clockwork))
			var/obj/structure/destructible/clockwork/C = M
			if(C.health == C.max_health)
				continue
			if(!try_use_power(structure_cost))
				break
			C.health = min(C.health + 15, C.max_health)
		else if(issilicon(M))
			var/mob/living/silicon/S = M
			if(S.health == S.maxHealth || S.stat == DEAD || !is_servant_of_ratvar(S))
				continue
			if(!try_use_power(cyborg_cost))
				break
			S.adjustBruteLoss(-15)
			S.adjustFireLoss(-15)
	return 1

/obj/structure/destructible/clockwork/powered/mending_motor/attack_hand(mob/living/user)
	if(user.canUseTopic(src, BE_CLOSE))
		if(total_accessable_power() < mob_cost)
			user << "<span class='warning'>[src] needs more power or replicant alloy to function!</span>"
			return 0
		toggle(0, user)

/obj/structure/destructible/clockwork/powered/mending_motor/attackby(obj/item/I, mob/user, params)
	if(istype(I, /obj/item/clockwork/component/replicant_alloy) && is_servant_of_ratvar(user))
		if(stored_alloy + 2500 > max_alloy)
			user << "<span class='warning'>[src] is too full to accept any more alloy!</span>"
			return 0
		clockwork_say(user, text2ratvar("Transmute into water."), TRUE)
		user.visible_message("<span class='notice'>[user] liquifies [I] and pours it onto [src].</span>", \
		"<span class='notice'>You liquify [src] and pour it onto [src], transferring the alloy into its reserves.</span>")
		stored_alloy = stored_alloy + 2500
		user.drop_item()
		qdel(I)
		return 1
	else
		return ..()



/obj/structure/destructible/clockwork/powered/mania_motor //Mania motor: A pair of antenna that, while active, cause braindamage and hallucinations in nearby human mobs.
	name = "mania motor"
	desc = "A pair of antenna with what appear to be sockets around the base. It reminds you of an antlion."
	clockwork_desc = "A transmitter that allows Sevtug to whisper into the minds of nearby non-servants, causing hallucinations and brain damage as long as it remains powered."
	icon_state = "mania_motor_inactive"
	active_icon = "mania_motor"
	inactive_icon = "mania_motor_inactive"
	construction_value = 20
	max_health = 80
	health = 80
	break_message = "<span class='warning'>The antenna break off, leaving a pile of shards!</span>"
	debris = list(/obj/item/clockwork/alloy_shards/large = 1, \
	/obj/item/clockwork/alloy_shards/small = 3, \
	/obj/item/clockwork/component/guvax_capacitor/antennae = 1)
	var/mania_cost = 150
	var/convert_attempt_cost = 150
	var/convert_cost = 300

	var/mania_messages = list("\"Go nuts.\"", "\"Take a crack at crazy.\"", "\"Make a bid for insanity.\"", "\"Get kooky.\"", "\"Move towards mania.\"", "\"Become bewildered.\"", "\"Wax wild.\"", \
	"\"Go round the bend.\"", "\"Land in lunacy.\"", "\"Try dementia.\"", "\"Strive to get a screw loose.\"")
	var/compel_messages = list("\"Come closer.\"", "\"Approach the transmitter.\"", "\"Touch the ante-nnae.\"", "\"I always have to deal with idiots. Move towards the mania motor.\"", \
	"\"Advance forward and place your head between the antennae - that's all it's good for.\"", "\"If you were smarter, you'd be over here already.\"", "\"Move FORWARD, you fool.\"")
	var/convert_messages = list("\"You won't do. Go to sleep while I tell these nitwits how to convert you.\"", "\"You are insufficient. I must instruct these idiots in the art of conversion.\"", \
	"\"Oh of course, someone we can't convert. These servants are fools.\"", "\"How hard is it to use a Sigil, anyway? All it takes is dragging someone onto it.\"", \
	"\"How do they fail to use a Sigil of Accession, anyway?\"", "\"Why is it that all servants are this inept?\"", "\"It's quite likely you'll be stuck here for a while.\"")
	var/close_messages = list("\"Well, you can't reach the motor from THERE, you moron.\"", "\"Interesting location. I'd prefer if you went somewhere you could ACTUALLY TOUCH THE ANTENNAE!\"", \
	"\"Amazing. You somehow managed to wedge yourself somewhere you can't actually reach the motor from.\"", "\"Such a show of idiocy is unparalleled. Perhaps I should put you on display?\"", \
	"\"Did you do this on purpose? I can't imagine you doing so accidentally. Oh, wait, I can.\"", "\"How is it that such smart creatures can still do something AS STUPID AS THIS!\"")


/obj/structure/destructible/clockwork/powered/mania_motor/examine(mob/user)
	..()
	if(is_servant_of_ratvar(user) || isobserver(user))
		user << "<span class='sevtug_small'>It requires <b>[mania_cost]W</b> to run, and <b>[convert_attempt_cost + convert_cost]W</b> to convert humans adjecent to it.</span>"

/obj/structure/destructible/clockwork/powered/mania_motor/process()
	var/turf/T = get_turf(src)
	if(!..())
		visible_message("<span class='warning'>[src] hums loudly, then the sockets at its base fall dark!</span>")
		playsound(T, 'sound/effects/screech.ogg', 40, 1)
		toggle(0)
		return
	if(try_use_power(mania_cost))
		var/hum = get_sfx('sound/effects/screech.ogg') //like playsound, same sound for everyone affected
		for(var/mob/living/carbon/human/H in view(1, src))
			if(H.Adjacent(src) && try_use_power(convert_attempt_cost))
				if(is_eligible_servant(H) && try_use_power(convert_cost))
					H << "<span class='sevtug'>\"[text2ratvar("You are mine and his, now.")]\"</span>"
					H.playsound_local(T, hum, 80, 1)
					add_servant_of_ratvar(H)
				else if(!H.stat)
					if(H.getBrainLoss() >= 100)
						H.Paralyse(5)
						H << "<span class='sevtug'>[text2ratvar(pick(convert_messages))]</span>"
					else
						H.adjustBrainLoss(100)
						H.visible_message("<span class='warning'>[H] reaches out and touches [src].</span>", "<span class='sevtug'>You touch [src] involuntarily.</span>")
			else
				visible_message("<span class='warning'>[src]'s antennae fizzle quietly.</span>")
				playsound(src, 'sound/effects/light_flicker.ogg', 50, 1)
		for(var/mob/living/carbon/human/H in range(10, src))
			if(!is_servant_of_ratvar(H) && !H.null_rod_check() && H.stat == CONSCIOUS)
				var/distance = get_dist(T, get_turf(H))
				var/falloff_distance = min((110) - distance * 10, 80)
				var/sound_distance = falloff_distance * 0.5
				var/targetbrainloss = H.getBrainLoss()
				var/targethallu = H.hallucination
				var/targetdruggy = H.druggy
				if(distance >= 4 && prob(falloff_distance))
					H << "<span class='sevtug_small'>[text2ratvar(pick(mania_messages))]</span>"
				H.playsound_local(T, hum, sound_distance, 1)
				switch(distance)
					if(2 to 3)
						if(prob(falloff_distance))
							if(prob(falloff_distance))
								H << "<span class='sevtug_small'>[text2ratvar(pick(mania_messages))]</span>"
							else
								H << "<span class='sevtug'>[text2ratvar(pick(compel_messages))]</span>"
						if(targetbrainloss <= 50)
							H.adjustBrainLoss(50 - targetbrainloss) //got too close had brain eaten
						if(targetdruggy <= 100)
							H.adjust_drugginess(8)
						if(targethallu <= 100)
							H.hallucination += 8
					if(4 to 5)
						if(targetbrainloss <= 50)
							H.adjustBrainLoss(1)
						if(targetdruggy <= 80)
							H.adjust_drugginess(6)
						if(targethallu <= 80)
							H.hallucination += 6
					if(6 to 7)
						if(targetbrainloss <= 30)
							H.adjustBrainLoss(1)
						if(prob(falloff_distance) && targetdruggy <= 60)
							H.adjust_drugginess(5)
						else if(targethallu <= 60)
							H.hallucination += 5
					if(8 to 9)
						if(H.getBrainLoss() <= 10)
							H.adjustBrainLoss(1)
						if(prob(falloff_distance) && targetdruggy <= 40)
							H.adjust_drugginess(3)
						else if(targethallu <= 40)
							H.hallucination += 3
					if(10 to INFINITY)
						if(prob(falloff_distance) && targetdruggy <= 20)
							H.adjust_drugginess(2)
						else if(targethallu <= 20)
							H.hallucination += 2
					else //if it's a distance of 1 and they can't see it/aren't adjacent or they're on top of it(how'd they get on top of it and still trigger this???)
						if(targetbrainloss <= 99)
							if(prob(falloff_distance))
								if(prob(falloff_distance))
									H << "<span class='sevtug'>[text2ratvar(pick(compel_messages))]</span>"
								else if(prob(falloff_distance))
									H << "<span class='sevtug'>[text2ratvar(pick(close_messages))]</span>"
								else
									H << "<span class='sevtug_small'>[text2ratvar(pick(mania_messages))]</span>"
							H.adjustBrainLoss(99 - targetbrainloss)
						if(targetdruggy <= 150)
							H.adjust_drugginess(15)
						if(targethallu <= 150)
							H.hallucination += 15

			if(is_servant_of_ratvar(H) && (H.getBrainLoss() || H.hallucination || H.druggy)) //not an else so that newly converted servants are healed of the damage it inflicts
				H.adjustBrainLoss(-H.getBrainLoss()) //heals servants of braindamage, hallucination, and druggy
				H.hallucination = 0
				H.adjust_drugginess(-H.druggy)
	else
		visible_message("<span class='warning'>[src] hums loudly, then the sockets at its base fall dark!</span>")
		playsound(src, 'sound/effects/screech.ogg', 40, 1)
		toggle(0)

/obj/structure/destructible/clockwork/powered/mania_motor/attack_hand(mob/living/user)
	if(user.canUseTopic(src, BE_CLOSE))
		if(!total_accessable_power() >= mania_cost)
			user << "<span class='warning'>[src] needs more power to function!</span>"
			return 0
		toggle(0, user)



/obj/structure/destructible/clockwork/powered/interdiction_lens //Interdiction lens: A powerful artifact that constantly disrupts electronics but, if it fails to find something to disrupt, turns off.
	name = "interdiction lens"
	desc = "An ominous, double-pronged brass totem. There's a strange gemstone clasped between the pincers."
	clockwork_desc = "A powerful totem that constantly disrupts nearby electronics and funnels power into nearby Sigils of Transmission."
	icon_state = "interdiction_lens"
	construction_value = 25
	active_icon = "interdiction_lens_active"
	inactive_icon = "interdiction_lens"
	break_message = "<span class='warning'>The lens flares a blinding violet before shattering!</span>"
	break_sound = 'sound/effects/Glassbr3.ogg'
	var/recharging = 0 //world.time when the lens was last used
	var/recharge_time = 1200 //if it drains no power and affects no objects, it turns off for two minutes
	var/disabled = FALSE //if it's actually usable
	var/interdiction_range = 14 //how large an area it drains and disables in
	var/disrupt_cost = 50 //how much power to use when disabling an object

/obj/structure/destructible/clockwork/powered/interdiction_lens/examine(mob/user)
	..()
	user << "<span class='[recharging > world.time ? "nezbere_small":"brass"]'>Its gemstone [recharging > world.time ? "has been breached by writhing tendrils of blackness that cover the totem" \
	: "vibrates in place and thrums with power"].</span>"
	if(is_servant_of_ratvar(user) || isobserver(user))
		user << "<span class='nezbere_small'>It requires <b>[disrupt_cost]W</b> of power for each nearby disruptable electronic.</span>"
		user << "<span class='nezbere_small'>If it fails to both drain any power and disrupt any electronics, it will disable itself for <b>[round(recharge_time/600, 1)]</b> minutes.</span>"

/obj/structure/destructible/clockwork/powered/interdiction_lens/toggle(fast_process, mob/living/user)
	..()
	if(active)
		SetLuminosity(4,2)
	else
		SetLuminosity(0)

/obj/structure/destructible/clockwork/powered/interdiction_lens/attack_hand(mob/living/user)
	if(user.canUseTopic(src, BE_CLOSE))
		if(disabled)
			user << "<span class='warning'>As you place your hand on the gemstone, cold tendrils of black matter crawl up your arm. You quickly pull back.</span>"
			return 0
		if(!total_accessable_power() >= disrupt_cost)
			user << "<span class='warning'>[src] needs more power to function!</span>"
			return 0
		toggle(0, user)

/obj/structure/destructible/clockwork/powered/interdiction_lens/process()
	if(recharging > world.time)
		return
	if(disabled)
		visible_message("<span class='warning'>The writhing tendrils return to the gemstone, which begins to glow with power!</span>")
		flick("interdiction_lens_recharged", src)
		disabled = FALSE
		toggle(0)
	else
		var/successfulprocess = FALSE
		var/power_drained = 0
		var/list/atoms_to_test = list()
		for(var/A in spiral_range_turfs(interdiction_range, src))
			var/turf/T = A
			for(var/M in T)
				atoms_to_test |= M

			CHECK_TICK

		for(var/M in atoms_to_test)
			if(istype(M, /obj/machinery/power/apc))
				var/obj/machinery/power/apc/A = M
				if(A.cell && A.cell.charge)
					successfulprocess = TRUE
					playsound(A, "sparks", 50, 1)
					flick("apc-spark", A)
					power_drained += min(A.cell.charge, 100)
					A.cell.charge = max(0, A.cell.charge - 100)
					if(!A.cell.charge && !A.shorted)
						A.shorted = 1
						A.visible_message("<span class='warning'>The [A.name]'s screen blurs with static.</span>")
					A.update()
					A.update_icon()
			else if(istype(M, /obj/machinery/power/smes))
				var/obj/machinery/power/smes/S = M
				if(S.charge)
					successfulprocess = TRUE
					power_drained += min(S.charge, 500)
					S.charge = max(0, S.charge - 50000) //SMES units contain too much power and could run an interdiction lens basically forever, or provide power forever
					if(!S.charge && !S.panel_open)
						S.panel_open = TRUE
						S.icon_state = "[initial(S.icon_state)]-o"
						var/datum/effect_system/spark_spread/spks = new(get_turf(S))
						spks.set_up(10, 0, get_turf(S))
						spks.start()
						S.visible_message("<span class='warning'>[S]'s panel flies open with a flurry of sparks.</span>")
					S.update_icon()
			else if(isrobot(M))
				var/mob/living/silicon/robot/R = M
				if(!is_servant_of_ratvar(R) && R.cell && R.cell.charge)
					successfulprocess = TRUE
					power_drained += min(R.cell.charge, 200)
					R.cell.charge = max(0, R.cell.charge - 200)
					R << "<span class='warning'>ERROR: Power loss detected!</span>"
					var/datum/effect_system/spark_spread/spks = new(get_turf(R))
					spks.set_up(3, 0, get_turf(R))
					spks.start()

			CHECK_TICK

		if(!return_power(power_drained) || power_drained < 50) //failed to return power drained or too little power to return
			successfulprocess = FALSE
		if(try_use_power(disrupt_cost) && total_accessable_power() >= disrupt_cost) //if we can disable at least one object
			playsound(src, 'sound/items/PSHOOM.ogg', 50, 1, interdiction_range-7, 1)
			for(var/M in atoms_to_test)
				if(istype(M, /obj/machinery/light)) //cosmetic light flickering
					var/obj/machinery/light/L = M
					if(L.on)
						playsound(L, 'sound/effects/light_flicker.ogg', 50, 1)
						L.flicker(3)
				else if(istype(M, /obj/machinery/camera))
					var/obj/machinery/camera/C = M
					if(C.isEmpProof() || !C.status)
						continue
					successfulprocess = TRUE
					if(C.emped)
						continue
					if(!try_use_power(disrupt_cost))
						break
					C.emp_act(1)
				else if(istype(M, /obj/item/device/radio))
					var/obj/item/device/radio/O = M
					successfulprocess = TRUE
					if(O.emped || !O.on)
						continue
					if(!try_use_power(disrupt_cost))
						break
					O.emp_act(1)
				else if(isliving(M) || istype(M, /obj/structure/closet) || istype(M, /obj/item/weapon/storage)) //other things may have radios in them but we don't care
					var/atom/movable/A = M
					for(var/obj/item/device/radio/O in A.GetAllContents())
						successfulprocess = TRUE
						if(O.emped || !O.on)
							continue
						if(!try_use_power(disrupt_cost))
							break
						O.emp_act(1)

				CHECK_TICK

		if(!successfulprocess)
			visible_message("<span class='warning'>The gemstone suddenly turns horribly dark, writhing tendrils covering it!</span>")
			recharging = world.time + recharge_time
			flick("interdiction_lens_discharged", src)
			icon_state = "interdiction_lens_inactive"
			SetLuminosity(2,1)
			disabled = TRUE



/obj/structure/destructible/clockwork/powered/clockwork_obelisk
	name = "clockwork obelisk"
	desc = "A large brass obelisk hanging in midair."
	clockwork_desc = "A powerful obelisk that can send a message to all servants or open a gateway to a target servant or clockwork obelisk."
	icon_state = "obelisk_inactive"
	active_icon = "obelisk"
	inactive_icon = "obelisk_inactive"
	construction_value = 20
	max_health = 200
	health = 200
	break_message = "<span class='warning'>The obelisk falls to the ground, undamaged!</span>"
	debris = list(/obj/item/clockwork/alloy_shards/small = 3, \
	/obj/item/clockwork/component/hierophant_ansible/obelisk = 1)
	var/hierophant_cost = 50 //how much it costs to broadcast with large text
	var/gateway_cost = 2000 //how much it costs to open a gateway
	var/gateway_active = FALSE

/obj/structure/destructible/clockwork/powered/clockwork_obelisk/New()
	..()
	toggle(1)

/obj/structure/destructible/clockwork/powered/clockwork_obelisk/examine(mob/user)
	..()
	if(is_servant_of_ratvar(user) || isobserver(user))
		user << "<span class='nzcrentr_small'>It requires <b>[hierophant_cost]W</b> to broadcast over the Hierophant Network, and <b>[gateway_cost]W</b> to open a Spatial Gateway.</span>"

/obj/structure/destructible/clockwork/powered/clockwork_obelisk/process()
	if(locate(/obj/effect/clockwork/spatial_gateway) in loc)
		icon_state = active_icon
		density = 0
		gateway_active = TRUE
	else
		icon_state = inactive_icon
		density = 1
		gateway_active = FALSE

/obj/structure/destructible/clockwork/powered/clockwork_obelisk/attack_hand(mob/living/user)
	if(!is_servant_of_ratvar(user) || !total_accessable_power() >= hierophant_cost)
		user << "<span class='warning'>You place your hand on the obelisk, but it doesn't react.</span>"
		return
	var/choice = alert(user,"You place your hand on the obelisk...",,"Hierophant Broadcast","Spatial Gateway","Cancel")
	switch(choice)
		if("Hierophant Broadcast")
			if(gateway_active)
				user << "<span class='warning'>The obelisk is sustaining a gateway and cannot broadcast!</span>"
				return
			var/input = stripped_input(usr, "Please choose a message to send over the Hierophant Network.", "Hierophant Broadcast", "")
			if(!input || !user.canUseTopic(src, BE_CLOSE))
				return
			if(gateway_active)
				user << "<span class='warning'>The obelisk is sustaining a gateway and cannot broadcast!</span>"
				return
			if(!try_use_power(hierophant_cost))
				user << "<span class='warning'>The obelisk lacks the power to broadcast!</span>"
				return
			clockwork_say(user, text2ratvar("Hierophant Broadcast, activate!"))
			titled_hierophant_message(user, input, "big_brass", "large_brass")
		if("Spatial Gateway")
			if(gateway_active)
				user << "<span class='warning'>The obelisk is already sustaining a gateway!</span>"
				return
			if(!try_use_power(gateway_cost))
				user << "<span class='warning'>The obelisk lacks the power to open a gateway!</span>"
				return
			if(procure_gateway(user, 100, 5, 1) && !gateway_active)
				clockwork_say(user, text2ratvar("Spatial Gateway, activate!"))
			else
				return_power(gateway_cost)
		if("Cancel")
			return
