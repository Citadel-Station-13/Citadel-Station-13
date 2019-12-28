/datum/mutation/human/telepathy
	name = "Telepathy"
	desc = "A rare mutation that allows the user to telepathically communicate to others."
	quality = POSITIVE
	text_gain_indication = "<span class='notice'>You can hear your own voice echoing in your mind!</span>"
	text_lose_indication = "<span class='notice'>You don't hear your mind echo anymore.</span>"
	difficulty = 12
	power = /obj/effect/proc_holder/spell/targeted/telepathy/genetic
	instability = 10
	energy_coeff = 1

/datum/mutation/human/telepathy/on_acquiring(mob/living/carbon/human/owner)
	. = ..()

/datum/mutation/human/telepathy/on_losing(mob/living/carbon/human/owner)
	. = ..()

/obj/effect/proc_holder/spell/targeted/telepathy/genetic
	magic_check = FALSE

/datum/mutation/human/firebreath
	name = "Fire Breath"
	desc = "An ancient mutation that gives lizards breath of fire."
	quality = POSITIVE
	difficulty = 12
	locked = TRUE
	text_gain_indication = "<span class='notice'>Your throat is burning!</span>"
	text_lose_indication = "<span class='notice'>Your throat is cooling down.</span>"
	power = /obj/effect/proc_holder/spell/aimed/firebreath
	instability = 30
	energy_coeff = 1
	power_coeff = 1

/datum/mutation/human/firebreath/modify()
	if(power)
		var/obj/effect/proc_holder/spell/aimed/firebreath/S = power
		S.strength = GET_MUTATION_POWER(src)

/obj/effect/proc_holder/spell/aimed/firebreath
	name = "Fire Breath"
	desc = "You can breathe fire at a target."
	school = "evocation"
	charge_max = 1200
	clothes_req = FALSE
	range = 20
	projectile_type = /obj/item/projectile/magic/aoe/fireball/firebreath
	base_icon_state = "fireball"
	action_icon_state = "fireball0"
	sound = 'sound/magic/demon_dies.ogg' //horrifying lizard noises
	active_msg = "You built up heat in your mouth."
	deactive_msg = "You swallow the flame."
	var/strength = 1

/obj/effect/proc_holder/spell/aimed/firebreath/before_cast(list/targets)
	. = ..()
	if(iscarbon(usr))
		var/mob/living/carbon/C = usr
		if(C.is_mouth_covered())
			C.adjust_fire_stacks(2)
			C.IgniteMob()
			to_chat(C,"<span class='warning'>Something in front of your mouth caught fire!</span>")
			return FALSE

/obj/effect/proc_holder/spell/aimed/firebreath/ready_projectile(obj/item/projectile/P, atom/target, mob/user, iteration)
	if(!istype(P, /obj/item/projectile/magic/aoe/fireball))
		return
	var/obj/item/projectile/magic/aoe/fireball/F = P
	switch(strength)
		if(1 to 3)
			F.exp_light = strength-1
		if(4 to INFINITY)
			F.exp_heavy = strength-3
	F.exp_fire += strength


/obj/item/projectile/magic/aoe/fireball/firebreath
	name = "fire breath"
	exp_heavy = 0
	exp_light = 0
	exp_flash = 0
	exp_fire= 4

/datum/mutation/human/void
	name = "Void Magnet"
	desc = "A rare genome that attracts odd forces not usually observed."
	quality = MINOR_NEGATIVE //upsides and downsides
	text_gain_indication = "<span class='notice'>You feel a heavy, dull force just beyond the walls watching you.</span>"
	instability = 30
	power = /obj/effect/proc_holder/spell/self/void
	energy_coeff = 1
	synchronizer_coeff = 1

/datum/mutation/human/void/on_life(mob/living/carbon/human/owner)
	if(!isturf(owner.loc))
		return
	if(prob((0.5+((100-dna.stability)/20))) * GET_MUTATION_SYNCHRONIZER(src)) //very rare, but enough to annoy you hopefully. +0.5 probability for every 10 points lost in stability
		new /obj/effect/immortality_talisman/void(get_turf(owner), owner)

/obj/effect/proc_holder/spell/self/void
	name = "Convoke Void" //magic the gathering joke here
	desc = "A rare genome that attracts odd forces not usually observed. May sometimes pull you in randomly."
	school = "evocation"
	clothes_req = FALSE
	charge_max = 600
	invocation = "DOOOOOOOOOOOOOOOOOOOOM!!!"
	invocation_type = "shout"
	action_icon_state = "void_magnet"
	var/in_use = FALSE //so it doesnt cast while you are already deep innit

/obj/effect/proc_holder/spell/self/void/can_cast(mob/user = usr)
	. = ..()
	if(!isturf(user.loc))
		return FALSE

/obj/effect/proc_holder/spell/self/void/cast(mob/user = usr)
	. = ..()
	new /obj/effect/immortality_talisman/void(get_turf(user), user)

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

/obj/effect/proc_holder/spell/targeted/touch/shock
	name = "Shock Touch"
	desc = "Channel electricity to your hand to shock people with."
	drawmessage = "You channel electricity into your hand."
	dropmessage = "You let the electricity from your hand dissipate."
	hand_path = /obj/item/melee/touch_attack/shock
	charge_max = 400
	clothes_req = FALSE
	action_icon_state = "zap"

/obj/item/melee/touch_attack/shock
	name = "\improper shock touch"
	desc = "This is kind of like when you rub your feet on a shag rug so you can zap your friends, only a lot less safe."
	catchphrase = null
	on_use_sound = 'sound/weapons/zapbang.ogg'
	icon_state = "zapper"
	item_state = "zapper"

/obj/item/melee/touch_attack/shock/afterattack(atom/target, mob/living/carbon/user, proximity)
	if(!proximity || !isliving(target))
		return
	if(iscarbon(target))
		var/mob/living/carbon/C = target
		if(C.electrocute_act(15, user, 1, stun = 0))//doesnt stun. never let this stun
			C.dropItemToGround(C.get_active_held_item())
			C.dropItemToGround(C.get_inactive_held_item())
			C.confused += 10
			C.visible_message("<span class='danger'>[user] electrocutes [target]!</span>","<span class='userdanger'>[user] electrocutes you!</span>")
			return ..()
		else
			user.visible_message("<span class='warning'>[user] fails to electrocute [target]!</span>")
			return ..()
	else if(isliving(target))
		var/mob/living/L = target
		L.electrocute_act(15, user, 1, stun = 0)
		L.visible_message("<span class='danger'>[user] electrocutes [target]!</span>","<span class='userdanger'>[user] electrocutes you!</span>")
		return ..()
	else
		to_chat(user,"<span class='warning'>The electricity doesn't seem to affect [target]...</span>")
		return ..()