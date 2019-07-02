/datum/mutation/human/shock
	name = "Shock Touch"
	desc = "The affected can channel excess electricity through their hands without shocking themselves, allowing them to shock others."
	quality = POSITIVE
	locked = TRUE
	difficulty = 16
	text_gain_indication = "<span class='notice'>You feel power flow through your hands.</span>"
	text_lose_indication = "<span class='notice'>The energy in your hands subsides.</span>"
	power = /obj/effect/proc_holder/spell/targeted/touch/shock
	instability = 30
	synchronizer_coeff = 1

/obj/effect/proc_holder/spell/targeted/touch/shock
	name = "Shock Touch"
	desc = "Channel electricity to your hand to shock people with."
	drawmessage = "You channel electricity into your hand."
	dropmessage = "You let the electricity from your hand dissipate."
	hand_path = /obj/item/melee/touch_attack/shock
	charge_max = 100
	clothes_req = FALSE
	action_icon = 'icons/mob/actions/actions_genetic.dmi'
	action_icon_state = "zap"

/obj/item/melee/touch_attack/shock
	name = "\improper shock touch"
	desc = "This is kind of like when you rub your feet on a shag rug so you can zap your friends, only a lot less safe."
	catchphrase = null
	on_use_sound = 'sound/weapons/zapbang.ogg'
	icon_state = "zapper"
	item_state = "zapper"

/obj/item/melee/touch_attack/shock/afterattack(atom/target, mob/living/carbon/user, proximity)
	var/success = FALSE
	var/rigged = FALSE
	var/datum/mutation/human/S = attached_spell?.associated_mutation
	if(IS_GENETIC_MUTATION(S) && prob(GET_DNA_INSTABILITY(user.dna) * GET_MUTATION_SYNCHRONIZER(S) * 0.3))
		target = user
		rigged = TRUE //Insulation won't help
	if(iscarbon(target))
		var/mob/living/carbon/C = target
		if(C.electrocute_act(15, src, 1, FALSE, rigged, FALSE, FALSE, FALSE, rigged))//doesnt stun. never let this stun
			C.dropItemToGround(C.get_active_held_item())
			C.dropItemToGround(C.get_inactive_held_item())
			C.confused += 15
			success = TRUE
		else
			user.visible_message("<span class='warning'>[target == user ? "[user] fails to clumsily electrocute [user.p_them()]self" : "[user] fails to electrocute [target]"]!</span>")
			return ..()
	else if(isliving(target))
		var/mob/living/L = target
		if(L.electrocute_act(15, src, 1, FALSE, FALSE, FALSE, FALSE))
			success = TRUE
		else
			to_chat(user,"<span class='warning'>[target == user ? "You fail to clumsily shock yourself, what a luck!" : "The electricity doesn't seem to affect [target]..."]</span>")
			return ..()
	if(success)
		target.visible_message("<span class='danger'>[user] electrocutes [target == user ? "[user.p_them()]self, somehow" : target]!</span>","<span class='userdanger'>[user == target ? "Your zapper backfires and you electrocute yourself" : "[user] electrocutes you"]!</span>")
		return ..()