/datum/martial_art/mime
	name = "Krav Mine-ga"
	var/datum/action/neck_chop/neckchop = new/datum/action/neck_chop_mime()
	var/datum/action/leg_sweep/legsweep = new/datum/action/leg_sweep_mime()
	var/datum/action/lung_punch/lungpunch = new/datum/action/lung_punch_mime()

/datum/action/neck_chop_mime
	name = "Neck Chop - Injures the neck, stopping the victim from speaking for a while."
	icon_icon = 'icons/mob/actions/actions_items.dmi'
	button_icon_state = "neckchop"

/datum/action/neck_chop_mime/Trigger()
	if(owner.incapacitated())
		to_chat(owner, "<span class='warning'>You can't use [name] while you're incapacitated.</span>")
		return
	var/mob/living/carbon/human/H = owner
	if (H.mind.martial_art.streak == "neck_chop")
		owner.visible_message("<span class='danger'>[owner] assumes a neutral stance.</span>", "<b><i>Your next attack is cleared.</i></b>")
		H.mind.martial_art.streak = ""
	else
		owner.visible_message("<span class='danger'>[owner] assumes the Neck Chop stance!</span>", "<b><i>Your next attack will be a Neck Chop.</i></b>")
		H.mind.martial_art.streak = "neck_chop"

/datum/action/leg_sweep_mime
	name = "Leg Sweep - Trips the victim, knocking them down for a brief moment."
	icon_icon = 'icons/mob/actions/actions_items.dmi'
	button_icon_state = "legsweep"

/datum/action/leg_sweep_mime/Trigger()
	if(owner.incapacitated())
		to_chat(owner, "<span class='warning'>You can't use [name] while you're incapacitated.</span>")
		return
	var/mob/living/carbon/human/H = owner
	if (H.mind.martial_art.streak == "leg_sweep")
		owner.visible_message("<span class='danger'>[owner] assumes a neutral stance.</span>", "<b><i>Your next attack is cleared.</i></b>")
		H.mind.martial_art.streak = ""
	else
		owner.visible_message("<span class='danger'>[owner] assumes the Leg Sweep stance!</span>", "<b><i>Your next attack will be a Leg Sweep.</i></b>")
		H.mind.martial_art.streak = "leg_sweep"

/datum/action/lung_punch_mime //referred to internally as 'quick choke'
	name = "Lung Punch - Delivers a strong punch just above the victim's abdomen, constraining the lungs. The victim will be unable to breathe and speak for a short time."
	icon_icon = 'icons/mob/actions/actions_items.dmi'
	button_icon_state = "lungpunch"

/datum/action/lung_punch_mime/Trigger()
	if(owner.incapacitated())
		to_chat(owner, "<span class='warning'>You can't use [name] while you're incapacitated.</span>")
		return
	var/mob/living/carbon/human/H = owner
	if (H.mind.martial_art.streak == "quick_choke")
		owner.visible_message("<span class='danger'>[owner] assumes a neutral stance.</span>", "<b><i>Your next attack is cleared.</i></b>")
		H.mind.martial_art.streak = ""
	else
		owner.visible_message("<span class='danger'>[owner] assumes the Lung Punch stance!</span>", "<b><i>Your next attack will be a Lung Punch.</i></b>")
		H.mind.martial_art.streak = "quick_choke"//internal name for lung punch

/datum/martial_art/mime/teach(mob/living/carbon/human/H,make_temporary=0)
	if(..())
		to_chat(H, "<span class = 'userdanger'>You know the arts of [name]!</span>")
		to_chat(H, "<span class = 'danger'>Place your cursor over a move at the top of the screen to see what it does.</span>")
		neckchop.Grant(H)
		legsweep.Grant(H)
		lungpunch.Grant(H)

/datum/martial_art/mime/on_remove(mob/living/carbon/human/H)
	to_chat(H, "<span class = 'userdanger'>You suddenly forget the arts of [name]...</span>")
	neckchop.Remove(H)
	legsweep.Remove(H)
	lungpunch.Remove(H)

/datum/martial_art/mime/proc/check_streak(var/mob/living/carbon/human/A, var/mob/living/carbon/human/D)
	switch(streak)
		if("neck_chop")
			streak = ""
			neck_chop(A,D)
			return 1
		if("leg_sweep")
			streak = ""
			leg_sweep(A,D)
			return 1
		if("quick_choke")//is actually lung punch
			streak = ""
			quick_choke(A,D)
			return 1
	return 0

/datum/martial_art/mime/proc/leg_sweep(var/mob/living/carbon/human/A, var/mob/living/carbon/human/D)
	if(D.stat || D.IsKnockdown())
		return 0
	D.visible_message("<span class='warning'>[A] silently leg sweeps [D]!</span>", \
					  	"<span class='userdanger'>[A] silently leg sweeps you!</span>")
	D.apply_damage(5, BRUTE)
	D.Knockdown(40)
	log_combat(A, D, "leg sweeped")
	return 1

/datum/martial_art/mime/proc/quick_choke(var/mob/living/carbon/human/A, var/mob/living/carbon/human/D)//is actually lung punch
	D.visible_message("<span class='warning'>[A] silently pounds [D] on the chest!</span>", \
				  	"<span class='userdanger'>[A] silently slams your chest! You can't breathe or speak!</span>")
	if(D.losebreath <= 15)
		D.losebreath = CLAMP(D.losebreath + 5, 0, 15)
	D.adjustOxyLoss(10)
	log_combat(A, D, "quickchoked")
	return 1

/datum/martial_art/mime/proc/neck_chop(var/mob/living/carbon/human/A, var/mob/living/carbon/human/D)
	D.visible_message("<span class='warning'>[A] silently karate chops [D]'s neck!</span>", \
				  	"<span class='userdanger'>[A] silently karate chops your neck, rendering you unable to speak!</span>")
	D.apply_damage(5, BRUTE)
	if(D.silent <= 30)
		D.silent = CLAMP(D.silent + 30, 0, 30)
	log_combat(A, D, "neck chopped")
	return 1

/datum/martial_art/mime/grab_act(var/mob/living/carbon/human/A, var/mob/living/carbon/human/D)
	if(check_streak(A,D))
		return 1
	log_combat(A, D, "grabbed (Krav Mine-ga)")
	..()

/datum/martial_art/mime/harm_act(var/mob/living/carbon/human/A, var/mob/living/carbon/human/D)
	if(check_streak(A,D))
		return 1
	log_combat(A, D, "punched")
	var/picked_hit_type = pick("punches", "kicks")
	var/bonus_damage = 10
	if(D.IsKnockdown() || D.resting || D.lying)
		bonus_damage += 5
		picked_hit_type = "stomps on"
	D.apply_damage(bonus_damage, BRUTE)
	if(picked_hit_type == "kicks" || picked_hit_type == "stomps on")
		A.do_attack_animation(D, ATTACK_EFFECT_KICK)
	else
		A.do_attack_animation(D, ATTACK_EFFECT_PUNCH)
	D.visible_message("<span class='danger'>[A] silently [picked_hit_type] [D]!</span>", \
					  "<span class='userdanger'>[A] silently [picked_hit_type] you!</span>")
	log_combat(A, D, "[picked_hit_type] with [name]")
	return 1

/datum/martial_art/mime/disarm_act(var/mob/living/carbon/human/A, var/mob/living/carbon/human/D)
	if(check_streak(A,D))
		return 1
	var/obj/item/I = null
	I = D.get_active_held_item()
	if(I)
		if(D.temporarilyRemoveItemFromInventory(I))
			A.put_in_hands(I)
	D.visible_message("<span class='danger'>[A] has silently disarmed [D]!</span>", \
						"<span class='userdanger'>[A] has silently disarmed [D]!</span>")
	log_combat(A, D, "disarmed (Krav Mine-ga)", "[I ? " removing \the [I]" : ""]")
	return 1