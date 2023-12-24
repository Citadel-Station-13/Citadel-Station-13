/mob/living/silicon/ai/attacked_by(obj/item/I, mob/living/user, def_zone, attackchain_flags = NONE, damage_multiplier = 1)
	. = ..()
	if(!.)
		return FALSE
	if(I.force && I.damtype != STAMINA && stat != DEAD && !QDELETED(src)) //only sparks if real damage is dealt.
		spark_system.start()

/mob/living/silicon/ai/attack_slime(mob/living/simple_animal/slime/user)
	return //immune to slimes

/mob/living/silicon/ai/blob_act(obj/structure/blob/B)
	if (stat != DEAD)
		adjustBruteLoss(60)
		updatehealth()
		return 1
	return 0

/mob/living/silicon/ai/emp_act(severity)
	. = ..()
	if(. & EMP_PROTECT_SELF)
		return
	if(severity >= 60)
		disconnect_shell()
		if(prob(30))
			switch(pick(1,2))
				if(1)
					view_core()
				if(2)
					SSshuttle.requestEvac(src,"ALERT: Energy surge detected in AI core! Station integrity may be compromised! Initiati--%m091#ar-BZZT")

/mob/living/silicon/ai/ex_act(severity, target, origin)
	switch(severity)
		if(1)
			gib()
		if(2)
			if (stat != DEAD)
				adjustBruteLoss(60)
				adjustFireLoss(60)
		if(3)
			if (stat != DEAD)
				adjustBruteLoss(30)



/mob/living/silicon/ai/bullet_act(obj/item/projectile/Proj)
	. = ..()
	updatehealth()

/mob/living/silicon/ai/flash_act(intensity = 1, override_blindness_check = 0, affect_silicon = 0)
	return // no eyes, no flashing

/mob/living/silicon/ai/emag_act(mob/user, obj/item/card/emag/emag_card) ///emags access panel lock, so you can crowbar it without robotics access or consent
	. = ..()
	if(emagged)
		balloon_alert(user, "access panel lock already shorted!")
		return
	balloon_alert(user, "access panel lock shorted")
	var/message = (user ? "[user] shorts out your access panel lock!" : "Your access panel lock was short circuited!")
	to_chat(src, span_warning(message))
	do_sparks(3, FALSE, src) // just a bit of extra "oh shit" to the ai - might grab its attention
	emagged = TRUE
	return TRUE

/mob/living/silicon/ai/wrench_act(mob/living/user, obj/item/tool)
	. = ..()
	if(user.a_intent == INTENT_HARM)
		return
	balloon_alert(user, "[!is_anchored ? "tightening" : "loosening"] bolts...")
	balloon_alert(src, "bolts being [!is_anchored ? "tightened" : "loosened"]...")
	if(!tool.use_tool(src, user, 4 SECONDS))
		return TRUE
	flip_anchored()
	balloon_alert(user, "bolts [is_anchored ? "tightened" : "loosened"]")
	balloon_alert(src, "bolts [is_anchored ? "tightened" : "loosened"]")
	return TRUE

/mob/living/silicon/ai/crowbar_act(mob/living/user, obj/item/tool)
	. = ..()
	if(user.a_intent == INTENT_HARM)
		return
	if(!is_anchored)
		balloon_alert(user, "bolt it down first!")
		return TRUE
	if(opened)
		if(emagged)
			balloon_alert(user, "access panel lock damaged!")
			return TRUE
		balloon_alert(user, "closing access panel...")
		balloon_alert(src, "access panel being closed...")
		if(!tool.use_tool(src, user, 5 SECONDS))
			return TRUE
		balloon_alert(src, "access panel closed")
		balloon_alert(user, "access panel closed")
		opened = FALSE
		return TRUE
	if(stat == DEAD)
		to_chat(user, span_warning("The access panel looks damaged, you try dislodging the cover."))
	else
		var/consent
		var/consent_override = FALSE
		if(ishuman(user))
			var/mob/living/carbon/human/human_user = user
			if(human_user.wear_id)
				var/list/access = human_user.wear_id.GetAccess()
				if(ACCESS_ROBOTICS in access)
					consent_override = TRUE
		if(mind)
			consent = tgui_alert(src, "[user] is attempting to open your access panel, unlock the cover?", "AI Access Panel", list("Yes", "No"))
			if(consent == "No" && !consent_override && !emagged)
				to_chat(user, span_notice("[src] refuses to unlock its access panel."))
				return TRUE
			if(consent != "Yes" && (consent_override || emagged))
				to_chat(user, span_warning("[src] refuses to unlock its access panel...so you[!emagged ? " swipe your ID and " : " "]open it anyway!"))
		else
			if(!consent_override && !emagged)
				to_chat(user, span_notice("[src] did not respond to your request to unlock its access panel cover lock."))
				return TRUE
			else
				to_chat(user, span_notice("[src] did not respond to your request to unlock its access panel cover lock. You[!emagged ? " swipe your ID and " : " "]open it anyway."))

	balloon_alert(user, "prying open access panel...")
	balloon_alert(src, "access panel being pried open...")
	if(!tool.use_tool(src, user, (stat == DEAD ? 40 SECONDS : 5 SECONDS)))
		return TRUE
	balloon_alert(src, "access panel opened")
	balloon_alert(user, "access panel opened")
	opened = TRUE
	return TRUE

/mob/living/silicon/ai/wirecutter_act(mob/living/user, obj/item/tool)
	. = ..()
	if(user.a_intent == INTENT_HARM)
		return
	if(!is_anchored)
		balloon_alert(user, "bolt it down first!")
		return TRUE
	if(!opened)
		balloon_alert(user, "open the access panel first!")
		return TRUE
	balloon_alert(src, "neural network being disconnected...")
	balloon_alert(user, "disconnecting neural network...")
	if(!tool.use_tool(src, user, (stat == DEAD ? 40 SECONDS : 5 SECONDS)))
		return TRUE
	if(IS_MALF_AI(src))
		to_chat(user, span_userdanger("The voltage inside the wires rises dramatically!"))
		user.electrocute_act(120, src)
		opened = FALSE
		return TRUE
	to_chat(src, span_danger("You feel incredibly confused and disorientated."))
	var/atom/ai_structure = ai_mob_to_structure()
	ai_structure.balloon_alert(user, "disconnected neural network")
	return TRUE
