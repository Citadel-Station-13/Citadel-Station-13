/mob/living/carbon/alien/humanoid/hunter
	name = "alien hunter"
	caste = "h"
	maxHealth = 170
	health = 170
	icon_state = "alienh"
	meleeKnockdownPower = 75
	meleeSlashHumanPower = 20
	meleeSlashSAPower = 45
	var/obj/screen/leap_icon = null

/mob/living/carbon/alien/humanoid/hunter/create_internal_organs()
	internal_organs += new /obj/item/organ/alien/plasmavessel/small
	..()

//Hunter verbs

/mob/living/carbon/alien/humanoid/hunter/proc/toggle_leap(message = 1)
	leap_on_click = !leap_on_click
	leap_icon.icon_state = "leap_[leap_on_click ? "on":"off"]"
	update_icons()
	if(message)
		to_chat(src, "<span class='noticealien'>You will now [leap_on_click ? "leap at":"slash at"] enemies!</span>")
	else
		return

/mob/living/carbon/alien/humanoid/hunter/ClickOn(atom/A, params)
	face_atom(A)
	if(leap_on_click)
		leap_at(A)
	else
		..()

#define MAX_ALIEN_LEAP_DIST 7

/mob/living/carbon/alien/humanoid/hunter/proc/leap_at(atom/A)
	if(!CHECK_MULTIPLE_BITFIELDS(mobility_flags, MOBILITY_STAND | MOBILITY_MOVE) || leaping)
		return

	if(pounce_cooldown > world.time)
		to_chat(src, "<span class='alertalien'>You are too fatigued to pounce right now!</span>")
		return

	if(!has_gravity() || !A.has_gravity())
		to_chat(src, "<span class='alertalien'>It is unsafe to leap without gravity!</span>")
		//It's also extremely buggy visually, so it's balance+bugfix
		return

	else //Maybe uses plasma in the future, although that wouldn't make any sense...
		leaping = 1
		weather_immunities += "lava"
		update_icons()
		throw_at(A, MAX_ALIEN_LEAP_DIST, 1, src, FALSE, TRUE, callback = CALLBACK(src, .proc/leap_end))

/mob/living/carbon/alien/humanoid/hunter/proc/leap_end()
	leaping = 0
	weather_immunities -= "lava"
	update_icons()

/mob/living/carbon/alien/humanoid/hunter/throw_impact(atom/hit_atom, datum/thrownthing/throwingdatum)

	if(!leaping)
		return ..()

	pounce_cooldown = world.time + pounce_cooldown_time
	if(hit_atom)
		if(isliving(hit_atom))
			var/mob/living/L = hit_atom
			if(L.run_block(src, 0, "the [name]", ATTACK_TYPE_TACKLE, 0, src) & BLOCK_SUCCESS)
				DefaultCombatKnockdown(40, 1, 1)
			else
				L.visible_message("<span class ='danger'>[src] pounces on [L]!</span>", "<span class ='userdanger'>[src] pounces on you!</span>")
				L.DefaultCombatKnockdown(100)
				L.Stagger(4 SECONDS)
				sleep(2)//Runtime prevention (infinite bump() calls on hulks)
				step_towards(src,L)

			toggle_leap(0)
		else if(hit_atom.density && !hit_atom.CanPass(src))
			visible_message("<span class ='danger'>[src] smashes into [hit_atom]!</span>", "<span class ='alertalien'>[src] smashes into [hit_atom]!</span>")
			Paralyze(40, TRUE, TRUE)

		if(leaping)
			leaping = 0
			update_icons()
			update_mobility()


/mob/living/carbon/alien/humanoid/float(on)
	if(leaping)
		return
	..()


