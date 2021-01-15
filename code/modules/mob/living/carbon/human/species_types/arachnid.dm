/datum/species/arachnid
	name = "Arachnid"
	id = SPECIES_ARACHNID
	override_bp_icon = 'icons/mob/arachnid_parts.dmi'
	say_mod = "chitters"
	default_color = "00FF00"
	species_traits = list(LIPS, NOEYES, NO_UNDERWEAR, HAS_FLESH, HAS_BONE)
	inherent_biotypes = MOB_ORGANIC|MOB_HUMANOID|MOB_BUG
	mutant_bodyparts = list("arachnid_legs" = "Plain", "arachnid_spinneret" = "Plain", "arachnid_mandibles" = "Plain")
	attack_verb = "slash"
	attack_sound = 'sound/weapons/slash.ogg'
	miss_sound = 'sound/weapons/slashmiss.ogg'
	meat = /obj/item/reagent_containers/food/snacks/meat/slab/spider
	liked_food = MEAT | RAW
	disliked_food = FRUIT | GROSS
	toxic_food = VEGETABLES | DAIRY
	mutanteyes = /obj/item/organ/eyes/night_vision/arachnid
	mutanttongue = /obj/item/organ/tongue/arachnid
	species_language_holder = /datum/language_holder/arachnid
	brutemod = 1.1
	var/web_cooldown = 200
	var/web_ready = TRUE
	var/spinner_rate = 25

/datum/species/arachnid/random_name(gender,unique,lastname)
	if(unique)
		return random_unique_arachnid_name()

	var/randname = arachnid_name()

	if(lastname)
		randname += " [lastname]"

	return randname

/datum/species/arachnid/handle_chemicals(datum/reagent/chem, mob/living/carbon/human/H)
	. = ..()
	if(chem.type == /datum/reagent/toxin/pestkiller)
		H.adjustToxLoss(3)
		H.reagents.remove_reagent(chem.type, REAGENTS_METABOLISM)

/datum/species/arachnid/check_weakness(obj/item/weapon, mob/living/attacker)
	if(istype(weapon, /obj/item/melee/flyswatter))
		return 9 //flyswatters deal 10x damage to arachnids
	return 0

/datum/species/arachnid/on_species_gain(mob/living/carbon/human/H, datum/species/old_species)
	. = ..()
	var/datum/action/innate/spin_web/SW = new
	var/datum/action/innate/spin_cocoon/SC = new
	SC.Grant(H)
	SW.Grant(H)

/datum/species/arachnid/on_species_loss(mob/living/carbon/human/H)
	. = ..()
	var/datum/action/innate/spin_web/SW = locate(/datum/action/innate/spin_web) in H.actions
	var/datum/action/innate/spin_cocoon/SC = locate(/datum/action/innate/spin_cocoon) in H.actions
	SC?.Remove(H)
	SW?.Remove(H)

/datum/action/innate/spin_web
	name = "Spin Web"
	check_flags = AB_CHECK_RESTRAINED|AB_CHECK_STUN|AB_CHECK_CONSCIOUS
	icon_icon = 'icons/mob/actions/actions_animal.dmi'
	button_icon_state = "lay_web"

/datum/action/innate/spin_cocoon
	name = "Spin Cocoon"
	check_flags = AB_CHECK_RESTRAINED|AB_CHECK_STUN|AB_CHECK_CONSCIOUS
	icon_icon = 'icons/mob/actions/actions_animal.dmi'
	button_icon_state = "wrap_0"

/datum/action/innate/spin_web/Activate()
	var/mob/living/carbon/human/species/arachnid/H = owner
	var/datum/species/arachnid/E = H.dna.species
	if(H.stat == "DEAD")
		return
	if(E.web_ready == FALSE)
		to_chat(H, "<span class='warning'>You need to wait a while to regenerate web fluid.</span>")
		return
	var/turf/T = get_turf(H)
	if(!T)
		to_chat(H, "<span class='warning'>There's no room to spin your web here!</span>")
		return
	var/obj/structure/spider/stickyweb/W = locate() in T
	var/obj/structure/arachnid/W2 = locate() in T
	if(W || W2)
		to_chat(H, "<span class='warning'>There's already a web here!</span>")
		return
	 // Should have some minimum amount of food before trying to activate
	var/nutrition_threshold = NUTRITION_LEVEL_FED
	if (H.nutrition >= nutrition_threshold)
		to_chat(H, "<i>You begin spinning some web...</i>")
		if(!do_after(H, 10 SECONDS, 1, T))
			to_chat(H, "<span class='warning'>Your web spinning was interrupted!</span>")
			return
		H.adjust_nutrition(-E.spinner_rate)
		addtimer(VARSET_CALLBACK(E, web_ready, TRUE), E.web_cooldown)
		to_chat(H, "<i>You use up a fair amount of energy weaving a web on the ground with your spinneret!</i>")
		new /obj/structure/arachnid(T, owner)

	else
		to_chat(H, "<span class='warning'>You're too hungry to spin web right now, eat something first!</span>")
		return
/*
	This took me far too long to figure out so I'm gonna document it here.
	1) Create an innate action for the species
	2) Have that action trigger a RegisterSignal for mob clicking
	3) Trigger the cocoonAtom proc on that signal
	4) Validate the target then start spinning
	5) if you're not interrupted, force move the target to the cocoon created at their location.
*/
/datum/action/innate/spin_cocoon/Activate()
	var/mob/living/carbon/human/species/arachnid/H = owner
	var/datum/species/arachnid/E = H.dna.species
	if(H.stat == "DEAD")
		return
	if(E.web_ready == FALSE)
		to_chat(H, "<span class='warning'>You need to wait awhile to regenerate web fluid.</span>")
		return
	var/nutrition_threshold = NUTRITION_LEVEL_FED
	if (H.nutrition >= nutrition_threshold)
		to_chat(H, "<span class='warning'>You pull out a strand from your spinneret, ready to wrap a target. <BR>\
		 (Press ALT+CLICK on the target to start wrapping.)</span>")
		H.adjust_nutrition(E.spinner_rate * -0.5)
		addtimer(VARSET_CALLBACK(E, web_ready, TRUE), E.web_cooldown)
		RegisterSignal(H, list(COMSIG_MOB_ALTCLICKON), .proc/cocoonAtom)
		return
	else
		to_chat(H, "<span class='warning'>You're too hungry to spin web right now, eat something first!</span>")
		return

/datum/action/innate/spin_cocoon/proc/cocoonAtom(mob/living/carbon/human/species/arachnid/H, atom/movable/A)
	UnregisterSignal(H, list(COMSIG_MOB_ALTCLICKON))
	var/datum/species/arachnid/E = H.dna.species
	if (!H || !isarachnid(H))
		return COMSIG_MOB_CANCEL_CLICKON
	else
		if(E.web_ready == FALSE)
			to_chat(H, "<span class='warning'>You need to wait awhile to regenerate web fluid.</span>")
			return
		if(!H.Adjacent(A))	//No.
			return
		if(!isliving(A) && A.anchored)
			to_chat(H, "<span class='warning'>[A] is bolted to the floor!</span>")
			return
		if(istype(A, /obj/structure/arachnid))
			to_chat(H, "<span class='warning'>No double wrapping.</span>")
			return
		if(istype(A, /obj/effect))
			to_chat(H, "<span class='warning'>You cannot wrap this.</span>")
			return
		H.visible_message("<span class='danger'>[H] starts to wrap [A] into a cocoon!</span>","<span class='warning'>You start to wrap [A] into a cocoon.</span>")
		if(!do_after(H, 10 SECONDS, 1, A))
			to_chat(H, "<span class='warning'>Your web spinning was interrupted!</span>")
			return
		H.adjust_nutrition(E.spinner_rate * -3)
		var/obj/structure/arachnid/cocoon/C = new(A.loc)
		if(isliving(A))
			C.icon_state = pick("cocoon_large1","cocoon_large2","cocoon_large3")
			A.forceMove(C)
			H.visible_message("<span class='danger'>[H] wraps [A] into a large cocoon!</span>")
			return
		else
			A.forceMove(C)
			H.visible_message("<span class='danger'>[H] wraps [A] into a cocoon!</span>")
			return
