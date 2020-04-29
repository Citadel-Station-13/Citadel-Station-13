/obj/item/organ/cyberimp/chest
	name = "cybernetic torso implant"
	desc = "Implants for the organs in your torso."
	icon_state = "chest_implant"
	implant_overlay = "chest_implant_overlay"
	zone = BODY_ZONE_CHEST

/obj/item/organ/cyberimp/chest/nutriment
	name = "Nutriment pump implant"
	desc = "This implant will synthesize and pump into your bloodstream a small amount of nutriment when you are starving."
	icon_state = "chest_implant"
	implant_color = "#00AA00"
	var/hunger_threshold = NUTRITION_LEVEL_STARVING
	var/synthesizing = 0
	var/poison_amount = 5
	slot = ORGAN_SLOT_STOMACH_AID

/obj/item/organ/cyberimp/chest/nutriment/on_life()
	. = ..()
	if(!. || synthesizing)
		return

	if(owner.nutrition <= hunger_threshold)
		synthesizing = TRUE
		to_chat(owner, "<span class='notice'>You feel less hungry...</span>")
		owner.nutrition += 50
		addtimer(CALLBACK(src, .proc/synth_cool), 50)

/obj/item/organ/cyberimp/chest/nutriment/proc/synth_cool()
	synthesizing = FALSE

/obj/item/organ/cyberimp/chest/nutriment/emp_act(severity)
	. = ..()
	if(!owner || . & EMP_PROTECT_SELF)
		return
	owner.reagents.add_reagent(/datum/reagent/toxin/bad_food, poison_amount / severity)
	to_chat(owner, "<span class='warning'>You feel like your insides are burning.</span>")


/obj/item/organ/cyberimp/chest/nutriment/plus
	name = "Nutriment pump implant PLUS"
	desc = "This implant will synthesize and pump into your bloodstream a small amount of nutriment when you are hungry."
	icon_state = "chest_implant"
	implant_color = "#006607"
	hunger_threshold = NUTRITION_LEVEL_HUNGRY
	poison_amount = 10

#define MAX_HEAL_COOLDOWN 15 MINUTES
#define DEF_CONVALESCENCE_TIME 15 SECONDS

/obj/item/organ/cyberimp/chest/reviver
	name = "Reviver implant"
	desc = "This implant will attempt to revive and heal you if you lose consciousness. For the faint of heart!"
	icon_state = "chest_implant"
	implant_color = "#AD0000"
	slot = ORGAN_SLOT_HEART_AID
	var/revive_cost = 0
	var/reviving = FALSE
	var/cooldown = 0
	var/convalescence_time = 0

/obj/item/organ/cyberimp/chest/reviver/on_life()
	. = ..()
	if(reviving)
		var/do_heal = . && world.time < convalescence_time
		if(revive_cost >= MAX_HEAL_COOLDOWN)
			do_heal = FALSE
		else if(owner?.stat && owner.stat != DEAD)
			do_heal = TRUE
		else if(!do_heal)
			convalescence_time = world.time + DEF_CONVALESCENCE_TIME
		if(. && (do_heal || world.time < convalescence_time))
			addtimer(CALLBACK(src, .proc/heal), 3 SECONDS)
		else
			cooldown = revive_cost + world.time
			reviving = FALSE
			if(owner)
				to_chat(owner, "<span class='notice'>Your reviver implant shuts down and starts recharging. It will be ready again in [DisplayTimeText(revive_cost)].</span>")
		return

	if(!. || cooldown > world.time || owner.stat == CONSCIOUS || owner.stat == DEAD || owner.suiciding)
		return

	revive_cost = 0
	convalescence_time = 0
	reviving = TRUE
	to_chat(owner, "<span class='notice'>You feel a faint buzzing as your reviver implant starts patching your wounds...</span>")

/obj/item/organ/cyberimp/chest/reviver/proc/heal()
	if(!owner)
		return
	if(owner.getOxyLoss())
		owner.adjustOxyLoss(-5)
		revive_cost += 0.5 SECONDS
	if(owner.getBruteLoss())
		owner.adjustBruteLoss(-2)
		revive_cost += 4 SECONDS
	if(owner.getFireLoss())
		owner.adjustFireLoss(-2)
		revive_cost += 4 SECONDS
	if(owner.getToxLoss())
		owner.adjustToxLoss(-1)
		revive_cost += 4 SECONDS


/obj/item/organ/cyberimp/chest/reviver/emp_act(severity)
	. = ..()
	if(!owner || . & EMP_PROTECT_SELF)
		return

	if(reviving)
		revive_cost += 20 SECONDS
	else
		cooldown += 20 SECONDS

	if(ishuman(owner))
		var/mob/living/carbon/human/H = owner
		if(H.stat != DEAD && prob(50 / severity) && H.can_heartattack())
			H.set_heartattack(TRUE)
			to_chat(H, "<span class='userdanger'>You feel a horrible agony in your chest!</span>")
			addtimer(CALLBACK(src, .proc/undo_heart_attack), 60 SECONDS / severity)

/obj/item/organ/cyberimp/chest/reviver/proc/undo_heart_attack()
	var/mob/living/carbon/human/H = owner
	if(!H || !istype(H))
		return
	H.set_heartattack(FALSE)
	if(H.stat == CONSCIOUS || H.stat == SOFT_CRIT)
		to_chat(H, "<span class='notice'>You feel your heart beating again!</span>")

#undef MAX_HEAL_COOLDOWN
#undef DEF_CONVALESCENCE_TIME

/obj/item/organ/cyberimp/chest/thrusters
	name = "implantable thrusters set"
	desc = "An implantable set of thruster ports. They use the gas from environment or subject's internals for propulsion in zero-gravity areas. \
	Unlike regular jetpacks, this device has no stabilization system."
	slot = ORGAN_SLOT_THRUSTERS
	icon_state = "imp_jetpack"
	implant_overlay = null
	implant_color = null
	actions_types = list(/datum/action/item_action/organ_action/toggle)
	w_class = WEIGHT_CLASS_NORMAL
	var/on = FALSE
	var/datum/effect_system/trail_follow/ion/ion_trail

/obj/item/organ/cyberimp/chest/thrusters/Insert(mob/living/carbon/M, special = 0, drop_if_replaced = TRUE)
	. = ..()
	if(!ion_trail)
		ion_trail = new
	ion_trail.set_up(M)

/obj/item/organ/cyberimp/chest/thrusters/Remove(special = FALSE)
	if(on)
		toggle(TRUE)
	return ..()

/obj/item/organ/cyberimp/chest/thrusters/ui_action_click()
	toggle()

/obj/item/organ/cyberimp/chest/thrusters/proc/toggle(silent = FALSE)
	if(!on)
		if(crit_fail || (organ_flags & ORGAN_FAILING))
			if(!silent)
				to_chat(owner, "<span class='warning'>Your thrusters set seems to be broken!</span>")
			return 0
		on = TRUE
		if(allow_thrust(0.01))
			ion_trail.start()
			RegisterSignal(owner, COMSIG_MOVABLE_MOVED, .proc/move_react)
			owner.add_movespeed_modifier(/datum/movespeed_modifier/jetpack/cybernetic)
			if(!silent)
				to_chat(owner, "<span class='notice'>You turn your thrusters set on.</span>")
	else
		ion_trail.stop()
		if(!QDELETED(owner))
			UnregisterSignal(owner, COMSIG_MOVABLE_MOVED)
			owner.remove_movespeed_modifier(/datum/movespeed_modifier/jetpack/cybernetic)
			if(!silent)
				to_chat(owner, "<span class='notice'>You turn your thrusters set off.</span>")
		on = FALSE
	update_icon()

/obj/item/organ/cyberimp/chest/thrusters/update_icon_state()
	if(on)
		icon_state = "imp_jetpack-on"
	else
		icon_state = "imp_jetpack"

/obj/item/organ/cyberimp/chest/thrusters/proc/move_react()
	allow_thrust(0.01)

/obj/item/organ/cyberimp/chest/thrusters/proc/allow_thrust(num)
	if(!on || !owner)
		return 0

	var/turf/T = get_turf(owner)
	if(!T) // No more runtimes from being stuck in nullspace.
		return 0

	// Priority 1: use air from environment.
	var/datum/gas_mixture/environment = T.return_air()
	if(environment && environment.return_pressure() > 30)
		return 1

	// Priority 2: use plasma from internal plasma storage.
	// (just in case someone would ever use this implant system to make cyber-alien ops with jetpacks and taser arms)
	if(owner.getPlasma() >= num*100)
		owner.adjustPlasma(-num*100)
		return 1

	// Priority 3: use internals tank.
	var/obj/item/tank/I = owner.internal
	if(I && I.air_contents && I.air_contents.total_moles() > num)
		var/datum/gas_mixture/removed = I.air_contents.remove(num)
		if(removed.total_moles() > 0.005)
			T.assume_air(removed)
			return 1
		else
			T.assume_air(removed)

	toggle(silent = TRUE)
	return 0
