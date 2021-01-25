/obj/item/reagent_containers/pill
	name = "pill"
	desc = "A tablet or capsule."
	icon = 'icons/obj/chemical.dmi'
	icon_state = "pill"
	item_state = "pill"
	lefthand_file = 'icons/mob/inhands/equipment/medical_lefthand.dmi'
	righthand_file = 'icons/mob/inhands/equipment/medical_righthand.dmi'
	possible_transfer_amounts = list()
	volume = 50
	grind_results = list()
	var/apply_type = INGEST
	var/apply_method = "swallow"
	var/roundstart = FALSE
	var/self_delay = FALSE //pills are instant, this is because patches inheret their aplication from pills
	var/dissolvable = TRUE

/obj/item/reagent_containers/pill/Initialize()
	. = ..()
	if(!icon_state)
		icon_state = "pill[rand(1,20)]"
	if(reagents.total_volume && roundstart)
		name += " ([reagents.total_volume]u)"

/obj/item/reagent_containers/pill/attack_self(mob/user)
	return

/obj/item/reagent_containers/pill/get_w_volume() // DEFAULT_VOLUME_TINY at 25u, DEFAULT_VOLUME_SMALL at 50u
	return DEFAULT_VOLUME_TINY/2 + reagents.total_volume / reagents.maximum_volume * DEFAULT_VOLUME_TINY

/obj/item/reagent_containers/pill/attack(mob/living/M, mob/living/user, attackchain_flags = NONE, damage_multiplier = 1)
	INVOKE_ASYNC(src, .proc/attempt_feed, M, user)

/obj/item/reagent_containers/pill/proc/attempt_feed(mob/living/M, mob/living/user)
	if(!canconsume(M, user))
		return FALSE

	if(M == user)
		M.visible_message("<span class='notice'>[user] attempts to [apply_method] [src].</span>")
		if(self_delay)
			if(!do_mob(user, M, self_delay))
				return FALSE
		to_chat(M, "<span class='notice'>You [apply_method] [src].</span>")
	else
		M.visible_message("<span class='danger'>[user] attempts to force [M] to [apply_method] [src].</span>", \
							"<span class='userdanger'>[user] attempts to force [M] to [apply_method] [src].</span>")
		if(!do_mob(user, M))
			return FALSE
		M.visible_message("<span class='danger'>[user] forces [M] to [apply_method] [src].</span>", \
							"<span class='userdanger'>[user] forces [M] to [apply_method] [src].</span>")

	var/makes_me_think = pick(strings("redpill.json", "redpill_questions"))
	if(icon_state == "pill4" && prob(5)) //you take the red pill - you stay in Wonderland, and I show you how deep the rabbit hole goes
		addtimer(CALLBACK(GLOBAL_PROC, /proc/to_chat, M, "<span class='notice'>[makes_me_think]</span>"), 50)

	log_combat(user, M, "fed", reagents.log_list())
	if(reagents.total_volume)
		reagents.reaction(M, apply_type)
		reagents.trans_to(M, reagents.total_volume, log = TRUE)
	qdel(src)
	return TRUE

/obj/item/reagent_containers/pill/afterattack(obj/target, mob/user , proximity)
	. = ..()
	if(!proximity)
		return
	if(!dissolvable || !target.is_refillable())
		return
	if(target.is_drainable() && !target.reagents.total_volume)
		to_chat(user, "<span class='warning'>[target] is empty! There's nothing to dissolve [src] in.</span>")
		return

	if(target.reagents.holder_full())
		to_chat(user, "<span class='warning'>[target] is full.</span>")
		return

	user.visible_message("<span class='warning'>[user] slips something into [target]!</span>",
						"<span class='notice'>You dissolve [src] in [target].</span>", vision_distance = 2)
	log_combat(user, target, "spiked", src, reagents.log_list())
	reagents.trans_to(target, reagents.total_volume, log = TRUE)
	qdel(src)
	return STOP_ATTACK_PROC_CHAIN

/obj/item/reagent_containers/pill/tox
	name = "toxins pill"
	desc = "Highly toxic."
	icon_state = "pill5"
	list_reagents = list(/datum/reagent/toxin = 50)
	roundstart = TRUE

/obj/item/reagent_containers/pill/cyanide
	name = "cyanide pill"
	desc = "Don't swallow this."
	icon_state = "pill5"
	list_reagents = list(/datum/reagent/toxin/cyanide = 50)
	roundstart = TRUE

/obj/item/reagent_containers/pill/adminordrazine
	name = "adminordrazine pill"
	desc = "It's magic. We don't have to explain it."
	icon_state = "pill16"
	list_reagents = list(/datum/reagent/medicine/adminordrazine = 50)
	roundstart = TRUE

/obj/item/reagent_containers/pill/morphine
	name = "morphine pill"
	desc = "Commonly used to treat insomnia."
	icon_state = "pill8"
	list_reagents = list(/datum/reagent/medicine/morphine = 30)
	roundstart = TRUE

/obj/item/reagent_containers/pill/stimulant
	name = "stimulant pill"
	desc = "Often taken by overworked employees, athletes, and the inebriated. You'll snap to attention immediately!"
	icon_state = "pill19"
	list_reagents = list(/datum/reagent/medicine/ephedrine = 10, /datum/reagent/medicine/antihol = 10, /datum/reagent/consumable/coffee = 30)
	roundstart = TRUE

/obj/item/reagent_containers/pill/salbutamol
	name = "salbutamol pill"
	desc = "Used to treat oxygen deprivation."
	icon_state = "pill16"
	list_reagents = list(/datum/reagent/medicine/salbutamol = 30)
	roundstart = TRUE

/obj/item/reagent_containers/pill/charcoal
	name = "charcoal pill"
	desc = "Neutralizes many common toxins."
	icon_state = "pill17"
	list_reagents = list(/datum/reagent/medicine/charcoal = 10)
	roundstart = TRUE

/obj/item/reagent_containers/pill/epinephrine
	name = "epinephrine pill"
	desc = "Used to stabilize patients."
	icon_state = "pill5"
	list_reagents = list(/datum/reagent/medicine/epinephrine = 15)
	roundstart = TRUE

/obj/item/reagent_containers/pill/mannitol
	name = "mannitol pill"
	desc = "Used to treat brain damage."
	icon_state = "pill17"
	list_reagents = list(/datum/reagent/medicine/mannitol = 25)
	roundstart = TRUE

/obj/item/reagent_containers/pill/mutadone
	name = "mutadone pill"
	desc = "Used to treat genetic damage."
	icon_state = "pill20"
	list_reagents = list(/datum/reagent/medicine/mutadone = 25)
	roundstart = TRUE

/obj/item/reagent_containers/pill/salicyclic
	name = "salicylic acid pill"
	desc = "Used to dull pain."
	icon_state = "pill9"
	list_reagents = list(/datum/reagent/medicine/sal_acid = 24)
	roundstart = TRUE

/obj/item/reagent_containers/pill/oxandrolone
	name = "oxandrolone pill"
	desc = "Used to stimulate burn healing."
	icon_state = "pill11"
	list_reagents = list(/datum/reagent/medicine/oxandrolone = 24)
	roundstart = TRUE

/obj/item/reagent_containers/pill/insulin
	name = "insulin pill"
	desc = "Handles hyperglycaemic coma."
	icon_state = "pill18"
	list_reagents = list(/datum/reagent/medicine/insulin = 50)
	roundstart = TRUE

/obj/item/reagent_containers/pill/psicodine
	name = "psicodine pill"
	desc = "Used to treat mental instability and phobias."
	list_reagents = list(/datum/reagent/medicine/psicodine = 10)
	icon_state = "pill22"
	roundstart = TRUE

/obj/item/reagent_containers/pill/antirad
	name = "potassium iodide pill"
	desc = "Used to treat radition used to counter radiation poisoning."
	icon_state = "pill18"
	list_reagents = list(/datum/reagent/medicine/potass_iodide = 50)
	roundstart = TRUE

/obj/item/reagent_containers/pill/antirad_plus
	name = "prussian blue pill"
	desc = "Used to treat heavy radition poisoning."
	icon_state = "prussian_blue"
	list_reagents = list(/datum/reagent/medicine/prussian_blue = 25)
	roundstart = TRUE

/obj/item/reagent_containers/pill/mutarad
	name = "radiation treatment deluxe pill"
	desc = "Used to treat heavy radition poisoning and genetic defects."
	icon_state = "anit_rad_fixgene"
	list_reagents = list(/datum/reagent/medicine/prussian_blue = 10, /datum/reagent/medicine/potass_iodide = 10, /datum/reagent/medicine/mutadone = 5)
	roundstart = TRUE

/obj/item/reagent_containers/pill/neurine
	name = "neurine pill"
	desc = "Used to treat non-severe mental traumas."
	list_reagents = list("neurine" = 10)
	icon_state = "pill22"
	roundstart = TRUE

///////////////////////////////////////// this pill is used only in a legion mob drop
/obj/item/reagent_containers/pill/shadowtoxin
	name = "black pill"
	desc = "I wouldn't eat this if I were you."
	icon_state = "pill9"
	color = "#454545"
	list_reagents = list(/datum/reagent/mutationtoxin/shadow = 1)
//////////////////////////////////////// drugs
/obj/item/reagent_containers/pill/zoom
	name = "zoom pill"
	list_reagents = list(/datum/reagent/medicine/synaptizine = 10, /datum/reagent/drug/nicotine = 10, /datum/reagent/drug/methamphetamine = 1)


/obj/item/reagent_containers/pill/happy
	name = "happy pill"
	list_reagents = list(/datum/reagent/consumable/sugar = 10, /datum/reagent/drug/space_drugs = 10)


/obj/item/reagent_containers/pill/lsd
	name = "hallucinogen pill"
	list_reagents = list(/datum/reagent/drug/mushroomhallucinogen = 12.5, /datum/reagent/toxin/mindbreaker = 12.5)


/obj/item/reagent_containers/pill/aranesp
	name = "speedy pill"
	list_reagents = list(/datum/reagent/drug/aranesp = 10)

/obj/item/reagent_containers/pill/happiness
	name = "happiness pill"
	desc = "It has a creepy smiling face on it."
	icon_state = "pill_happy"
	list_reagents = list(/datum/reagent/drug/happiness = 10)

/obj/item/reagent_containers/pill/floorpill
	name = "floorpill"
	desc = "A strange pill found in the depths of maintenance"
	icon_state = "pill21"
	var/static/list/names = list("maintenance pill","floorpill","mystery pill","suspicious pill","strange pill")
	var/static/list/descs = list("Your feeling is telling you no, but...","Drugs are expensive, you can't afford not to eat any pills that you find."\
	, "Surely, there's no way this could go bad.")

/obj/item/reagent_containers/pill/floorpill/Initialize()
	list_reagents = list(get_random_reagent_id() = rand(10,50))
	. = ..()
	name = pick(names)
	if(prob(20))
		desc = pick(descs)

/obj/item/reagent_containers/pill/get_belt_overlay()
	return mutable_appearance('icons/obj/clothing/belt_overlays.dmi', "pouch")

/obj/item/reagent_containers/pill/penis_enlargement
	name = "penis enlargement pill"
	list_reagents = list(/datum/reagent/fermi/penis_enlarger = 10)

/obj/item/reagent_containers/pill/breast_enlargement
	name = "breast enlargement pill"
	list_reagents = list(/datum/reagent/fermi/breast_enlarger = 10)
