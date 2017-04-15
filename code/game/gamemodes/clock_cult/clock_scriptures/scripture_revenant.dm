//////////////
// REVENANT //
//////////////

//Invoke Inath-neq, the Resonant Cogwheel: Grants invulnerability and stun immunity to everyone nearby for 15 seconds.
/datum/clockwork_scripture/invoke_inathneq
	descname = "Area Invulnerability"
	name = "Invoke Inath-neq, the Resonant Cogwheel"
	desc = "Taps the limitless power of Inath-neq, one of Ratvar's four generals. The benevolence of Inath-Neq will grant complete invulnerability to all Servants in range for fifteen seconds."
	invocations = list("I call upon you, Vanguard!!", "Let the Resonant Cogs turn once more!!", "Grant me and my allies the strength to vanquish our foes!!")
	channel_time = 100
	consumed_components = list(VANGUARD_COGWHEEL = 4, GEIS_CAPACITOR = 2, REPLICANT_ALLOY = 2, HIEROPHANT_ANSIBLE = 2)
	usage_tip = "Servants affected by this scripture are only weak to things that outright destroy bodies, such as bombs or the singularity."
	tier = SCRIPTURE_REVENANT
	primary_component = VANGUARD_COGWHEEL
	sort_priority = 2

/datum/clockwork_scripture/invoke_inathneq/check_special_requirements()
	if(!slab.no_cost && GLOB.clockwork_generals_invoked["inath-neq"] > world.time)
		to_chat(invoker, "<span class='inathneq'>\"[text2ratvar("I cannot lend you my aid yet, champion. Please be careful.")]\"</span>\n\
		<span class='warning'>Inath-neq has already been invoked recently! You must wait several minutes before calling upon the Resonant Cogwheel.</span>")
		return FALSE
	return TRUE

/datum/clockwork_scripture/invoke_inathneq/scripture_effects()
	new/obj/effect/clockwork/general_marker/inathneq(get_turf(invoker))
	hierophant_message("<span class='inathneq_large'>[text2ratvar("Vanguard: \"I lend you my aid, champions! Let glory guide your blows!")]\"</span>", FALSE, invoker)
	GLOB.clockwork_generals_invoked["inath-neq"] = world.time + CLOCKWORK_GENERAL_COOLDOWN
	playsound(invoker, 'sound/magic/clockwork/invoke_general.ogg', 50, 0)
	if(invoker.real_name == "Lucio")
		clockwork_say(invoker, text2ratvar("Aww, let's break it DOWN!!"))
	for(var/mob/living/L in range(7, invoker))
		if(!is_servant_of_ratvar(L) || L.stat == DEAD)
			continue
		L.apply_status_effect(STATUS_EFFECT_INATHNEQS_ENDOWMENT)
	return TRUE


//Invoke Sevtug, the Formless Pariah: Causes massive global hallucinations, braindamage, confusion, and dizziness to all humans on the same zlevel.
/datum/clockwork_scripture/invoke_sevtug
	descname = "Global Hallucination"
	name = "Invoke Sevtug, the Formless Pariah"
	desc = "Taps the limitless power of Sevtug, one of Ratvar's four generals. The mental manipulation ability of the Pariah allows its wielder to cause mass hallucinations and confusion \
	for all non-servant humans on the same z-level as them. The power of this scripture falls off somewhat with distance, and certain things may reduce its effects."
	invocations = list("I call upon you, Fright!!", "Let your power shatter the sanity of the weak-minded!!", "Let your tendrils hold sway over all!!")
	channel_time = 150
	consumed_components = list(BELLIGERENT_EYE = 3, VANGUARD_COGWHEEL = 3, GEIS_CAPACITOR = 6, HIEROPHANT_ANSIBLE = 3)
	usage_tip = "Causes brain damage, hallucinations, confusion, and dizziness in massive amounts."
	tier = SCRIPTURE_REVENANT
	sort_priority = 3
	primary_component = GEIS_CAPACITOR
	invokers_required = 3
	multiple_invokers_used = TRUE
	var/static/list/mindbreaksayings = list("\"Oh, great. I get to shatter some minds.\"", "\"More minds to crush.\"", \
	"\"Really, this is almost boring.\"", "\"None of these minds have anything interesting in them.\"", "\"Maybe I can instill a little bit of terror in this one.\"", \
	"\"What a waste of my power.\"", "\"I'm sure I could just control these minds instead, but they never ask.\"")

/datum/clockwork_scripture/invoke_sevtug/check_special_requirements()
	if(!slab.no_cost && GLOB.clockwork_generals_invoked["sevtug"] > world.time)
		to_chat(invoker, "<span class='sevtug'>\"[text2ratvar("Is it really so hard - even for a simpleton like you - to grasp the concept of waiting?")]\"</span>\n\
		<span class='warning'>Sevtug has already been invoked recently! You must wait several minutes before calling upon the Formless Pariah.</span>")
		return FALSE
	if(!slab.no_cost && GLOB.ratvar_awakens)
		to_chat(invoker, "<span class='sevtug'>\"[text2ratvar("Do you really think anything I can do right now will compare to Engine's power?")]\"</span>\n\
		<span class='warning'>Sevtug will not grant his power while Ratvar's dwarfs his own!</span>")
		return FALSE
	return TRUE

/datum/clockwork_scripture/invoke_sevtug/scripture_effects()
	new/obj/effect/clockwork/general_marker/sevtug(get_turf(invoker))
	hierophant_message("<span class='sevtug_large'>[text2ratvar("Fright: \"I heed your call, idiots. Get going and use this chance while it lasts!")]\"</span>", FALSE, invoker)
	GLOB.clockwork_generals_invoked["sevtug"] = world.time + GLOBAL_CLOCKWORK_GENERAL_COOLDOWN
	playsound(invoker, 'sound/magic/clockwork/invoke_general.ogg', 50, 0)
	var/hum = get_sfx('sound/effects/screech.ogg') //like playsound, same sound for everyone affected
	var/turf/T = get_turf(invoker)
	for(var/mob/living/carbon/human/H in GLOB.living_mob_list)
		if(H.z == invoker.z && !is_servant_of_ratvar(H))
			var/distance = 0
			distance += get_dist(T, get_turf(H))
			var/visualsdistance = max(150 - distance, 5)
			var/minordistance = max(200 - distance*2, 5)
			var/majordistance = max(150 - distance*3, 5)
			if(H.null_rod_check())
				to_chat(H, "<span class='sevtug'>[text2ratvar("Oh, a void weapon. How annoying, I may as well not bother.")]</span>\n\
				<span class='warning'>Your holy weapon glows a faint orange, defending your mind!</span>")
				continue
			else if(H.isloyal())
				visualsdistance = round(visualsdistance * 0.5) //half effect for shielded targets
				minordistance = round(minordistance * 0.5)
				majordistance = round(majordistance * 0.5)
				to_chat(H, "<span class='sevtug'>[text2ratvar("Oh, look, a mindshield. Cute, I suppose I'll humor it.")]</span>")
			else if(prob(visualsdistance))
				to_chat(H, "<span class='sevtug'>[text2ratvar(pick(mindbreaksayings))]</span>")
			H.playsound_local(T, hum, visualsdistance, 1)
			flash_color(H, flash_color="#AF0AAF", flash_time=visualsdistance*10)
			H.dizziness = minordistance + H.dizziness
			H.hallucination = minordistance + H.hallucination
			H.confused = majordistance + H.confused
			H.setBrainLoss(majordistance + H.getBrainLoss())
	return TRUE


//Invoke Nezbere, the Brass Eidolon: Invokes Nezbere, bolstering the strength of many clockwork items for one minute.
/datum/clockwork_scripture/invoke_nezbere
	descname = "Global Structure Buff"
	name = "Invoke Nezbere, the Brass Eidolon"
	desc = "Taps the limitless power of Nezbere, one of Ratvar's four generals. The restless toil of the Eidolon will empower a wide variety of clockwork apparatus for a full minute - notably, \
	clockwork proselytizers will charge very rapidly."
	invocations = list("I call upon you, Armorer!!", "Let your machinations reign on this miserable station!!", "Let your power flow through the tools of your master!!")
	channel_time = 150
	consumed_components = list(BELLIGERENT_EYE = 3, VANGUARD_COGWHEEL = 3, GEIS_CAPACITOR = 3, REPLICANT_ALLOY = 6)
	usage_tip = "Ocular wardens will become empowered, clockwork proselytizers will require no alloy, tinkerer's daemons will produce twice as quickly, \
	and interdiction lenses, mending motors, mania motors, tinkerer's daemons, and clockwork obelisks will all require no power."
	tier = SCRIPTURE_REVENANT
	primary_component = REPLICANT_ALLOY
	sort_priority = 4
	invokers_required = 3
	multiple_invokers_used = TRUE

/datum/clockwork_scripture/invoke_nezbere/check_special_requirements()
	if(!slab.no_cost && GLOB.clockwork_generals_invoked["nezbere"] > world.time)
		to_chat(invoker, "<span class='nezbere'>\"[text2ratvar("Not just yet, friend. Patience is a virtue.")]\"</span>\n\
		<span class='warning'>Nezbere has already been invoked recently! You must wait several minutes before calling upon the Brass Eidolon.</span>")
		return FALSE
	if(!slab.no_cost && GLOB.ratvar_awakens)
		to_chat(invoker, "<span class='nezbere'>\"[text2ratvar("Our master is here already. You do not require my help, friend.")]\"</span>\n\
		<span class='warning'>There is no need for Nezbere's assistance while Ratvar is risen!</span>")
		return FALSE
	return TRUE

/datum/clockwork_scripture/invoke_nezbere/scripture_effects()
	new/obj/effect/clockwork/general_marker/nezbere(get_turf(invoker))
	hierophant_message("<span class='nezbere_large'>[text2ratvar("Armorer: \"I heed your call, champions. May your artifacts bring ruin upon the heathens that oppose our master!")]\"</span>", FALSE, invoker)
	GLOB.clockwork_generals_invoked["nezbere"] = world.time + GLOBAL_CLOCKWORK_GENERAL_COOLDOWN
	playsound(invoker, 'sound/magic/clockwork/invoke_general.ogg', 50, 0)
	GLOB.nezbere_invoked++
	for(var/obj/O in GLOB.all_clockwork_objects)
		O.ratvar_act()
	addtimer(CALLBACK(GLOBAL_PROC, /proc/reset_nezbere_invocation), 600)
	return TRUE

/proc/reset_nezbere_invocation()
	GLOB.nezbere_invoked--
	for(var/obj/O in GLOB.all_clockwork_objects)
		O.ratvar_act()


//Invoke Nzcrentr, the Eternal Thunderbolt: Imbues an immense amount of energy into the invoker. After several seconds, everyone near the invoker will be hit with a devastating lightning blast.
/datum/clockwork_scripture/invoke_nzcrentr
	descname = "Area Lightning Blast"
	name = "Invoke Nzcrentr, the Eternal Thunderbolt"
	desc = "Taps the limitless power of Nzcrentr, one of Ratvar's four generals. Nzcrentr will grant you a tiny fraction of its boundless power. After several seconds, all non-Servants near you \
	will be struck by devastating lightning bolts."
	invocations = list("I call upon you, Amperage!!", "Let your energy flow through me!!", "Let your boundless power shatter stars!!")
	channel_time = 100
	consumed_components = list(BELLIGERENT_EYE = 2, GEIS_CAPACITOR = 2, REPLICANT_ALLOY = 2, HIEROPHANT_ANSIBLE = 4)
	usage_tip = "Struck targets will also be knocked down for about sixteen seconds."
	tier = SCRIPTURE_REVENANT
	primary_component = HIEROPHANT_ANSIBLE
	sort_priority = 5

/datum/clockwork_scripture/invoke_nzcrentr/check_special_requirements()
	if(!slab.no_cost && GLOB.clockwork_generals_invoked["nzcrentr"] > world.time)
		to_chat(invoker, "<span class='nzcrentr'>\"[text2ratvar("The boss says you have to wait. Hey, do you think he would mind if I killed you? ...He would? Ok.")]\"</span>\n\
		<span class='warning'>Nzcrentr has already been invoked recently! You must wait several minutes before calling upon the Eternal Thunderbolt.</span>")
		return FALSE
	return TRUE

/datum/clockwork_scripture/invoke_nzcrentr/scripture_effects()
	new/obj/effect/clockwork/general_marker/nzcrentr(get_turf(invoker))
	GLOB.clockwork_generals_invoked["nzcrentr"] = world.time + CLOCKWORK_GENERAL_COOLDOWN
	hierophant_message("<span class='nzcrentr_large'>[text2ratvar("Amperage: \"[invoker.real_name] has called forth my power. Hope [invoker.p_they()] [invoker.p_do()] not shatter under it!")]\"</span>", FALSE, invoker)
	invoker.visible_message("<span class='warning'>[invoker] begins to radiate a blinding light!</span>", \
	"<span class='nzcrentr'>\"[text2ratvar("The boss says it's okay to do this. Don't blame me if you die from it.")]\"</span>\n\
	<span class='userdanger'>You feel limitless power surging through you!</span>")
	playsound(invoker, 'sound/magic/clockwork/invoke_general.ogg', 50, 0)
	sleep(2)
	playsound(invoker, 'sound/magic/lightning_chargeup.ogg', 100, 0)
	var/oldcolor = invoker.color
	animate(invoker, color = list(rgb(255, 255, 255), rgb(255, 255, 255), rgb(255, 255, 255), rgb(0,0,0)), time = 88) //Gradual advancement to extreme brightness
	sleep(88)
	if(invoker)
		invoker.visible_message("<span class='warning'>Massive bolts of energy emerge from across [invoker]'s body!</span>", \
		"<span class='nzcrentr'>\"[text2ratvar("I told you you wouldn't be able to handle it.")]\"</span>\n\
		<span class='userdanger'>TOO... MUCH! CAN'T... TAKE IT!</span>")
		playsound(invoker, 'sound/magic/lightningbolt.ogg', 100, 0)
		if(invoker.stat == CONSCIOUS)
			animate(invoker, color = oldcolor, time = 10)
			addtimer(CALLBACK(invoker, /atom/proc/update_atom_colour), 10)
			for(var/mob/living/L in view(7, invoker))
				if(is_servant_of_ratvar(L) || L.null_rod_check())
					continue
				invoker.Beam(L, icon_state = "nzcrentrs_power", time = 10)
				var/randdamage = rand(40, 60)
				if(iscarbon(L))
					L.electrocute_act(randdamage, "Nzcrentr's power", 1, randdamage)
				else
					L.adjustFireLoss(randdamage)
					L.visible_message(
					"<span class='danger'>[L] was shocked by Nzcrentr's power!</span>", \
					"<span class='userdanger'>You feel a powerful shock coursing through your body!</span>", \
					"<span class='italics'>You hear a heavy electrical crack.</span>" \
					)
				L.Weaken(8)
				playsound(L, 'sound/magic/LightningShock.ogg', 50, 1)
		else
			playsound(invoker, 'sound/magic/Disintegrate.ogg', 50, 1)
			invoker.gib()
		return TRUE
	else
		return FALSE
