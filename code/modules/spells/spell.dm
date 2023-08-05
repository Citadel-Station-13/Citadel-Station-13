#define TARGET_CLOSEST 1
#define TARGET_RANDOM 2


/obj/effect/proc_holder
	var/panel = "Debug"//What panel the proc holder needs to go on.
	var/active = FALSE //Used by toggle based abilities.
	var/ranged_mousepointer
	var/mob/living/ranged_ability_user
	var/ranged_clickcd_override = -1
	var/has_action = TRUE
	var/datum/action/spell_action/action = null
	var/action_icon = 'icons/mob/actions/actions_spells.dmi'
	var/action_icon_state = "spell_default"
	var/action_background_icon_state = "bg_spell"
	var/base_action = /datum/action/spell_action

/obj/effect/proc_holder/Initialize(mapload)
	. = ..()
	if(has_action)
		action = new base_action(src)

/obj/effect/proc_holder/Destroy()
	QDEL_NULL(action)
	if(ranged_ability_user)
		remove_ranged_ability()
	return ..()

/obj/effect/proc_holder/proc/on_gain(mob/living/user)
	return

/obj/effect/proc_holder/proc/on_lose(mob/living/user)
	return

/obj/effect/proc_holder/proc/fire(mob/living/user)
	return TRUE

/obj/effect/proc_holder/proc/get_panel_text()
	return ""

GLOBAL_LIST_INIT(spells, typesof(/obj/effect/proc_holder/spell)) //needed for the badmin verb for now

/obj/effect/proc_holder/singularity_act()
	return

/obj/effect/proc_holder/singularity_pull()
	return

/obj/effect/proc_holder/Click()
	return Trigger(usr, FALSE)

/obj/effect/proc_holder/proc/Trigger(mob/user)
	return TRUE

/obj/effect/proc_holder/proc/InterceptClickOn(mob/living/caller, params, atom/A)
	if(caller.ranged_ability != src || ranged_ability_user != caller) //I'm not actually sure how these would trigger, but, uh, safety, I guess?
		to_chat(caller, "<span class='warning'><b>[caller.ranged_ability.name]</b> has been disabled.</span>")
		caller.ranged_ability.remove_ranged_ability()
		return TRUE //TRUE for failed, FALSE for passed.
	return FALSE

/obj/effect/proc_holder/proc/add_ranged_ability(mob/living/user, msg, forced)
	if(!user || !user.client)
		return
	if(user.ranged_ability && user.ranged_ability != src)
		if(forced)
			to_chat(user, "<span class='warning'><b>[user.ranged_ability.name]</b> has been replaced by <b>[name]</b>.</span>")
			user.ranged_ability.remove_ranged_ability()
		else
			return
	user.ranged_ability = src
	user.click_intercept = src
	user.update_mouse_pointer()
	ranged_ability_user = user
	if(msg)
		to_chat(ranged_ability_user, msg)
	active = TRUE
	update_icon()

/obj/effect/proc_holder/proc/remove_ranged_ability(msg)
	if(!ranged_ability_user || !ranged_ability_user.client || (ranged_ability_user.ranged_ability && ranged_ability_user.ranged_ability != src)) //To avoid removing the wrong ability
		return
	ranged_ability_user.ranged_ability = null
	ranged_ability_user.click_intercept = null
	ranged_ability_user.update_mouse_pointer()
	if(msg)
		to_chat(ranged_ability_user, msg)
	ranged_ability_user = null
	active = FALSE
	update_icon()

/obj/effect/proc_holder/spell
	name = "Spell"
	desc = "A wizard spell."
	panel = "Spells"
	var/sound = null //The sound the spell makes when it is cast
	anchored = TRUE // Crap like fireball projectiles are proc_holders, this is needed so fireballs don't get blown back into your face via atmos etc.
	pass_flags = PASSTABLE
	density = FALSE
	opacity = 0

	var/school = "evocation" //not relevant at now, but may be important later if there are changes to how spells work. the ones I used for now will probably be changed... maybe spell presets? lacking flexibility but with some other benefit?

	var/charge_type = "recharge" //can be recharge or charges, see charge_max and charge_counter descriptions; can also be based on the holder's vars now, use "holder_var" for that

	var/charge_max = 100 //recharge time in deciseconds if charge_type = "recharge" or starting charges if charge_type = "charges"
	var/charge_counter = 0 //can only cast spells if it equals recharge, ++ each decisecond if charge_type = "recharge" or -- each cast if charge_type = "charges"
	var/still_recharging_msg = "<span class='notice'>The spell is still recharging.</span>"
	var/recharging = TRUE

	var/holder_var_type = "bruteloss" //only used if charge_type equals to "holder_var"
	var/holder_var_amount = 20 //same. The amount adjusted with the mob's var when the spell is used

	var/clothes_req = SPELL_WIZARD_GARB //see if it requires clothes
	var/list/mobs_whitelist //spell can only be casted by mobs in this typecache.
	var/list/mobs_blacklist //The opposite of the above.
	var/stat_allowed = 0 //see if it requires being conscious/alive, need to set to 1 for ghostpells
	var/phase_allowed = 0 // If true, the spell can be cast while phased, eg. blood crawling, ethereal jaunting
	var/antimagic_allowed = FALSE // If false, the spell cannot be cast while under the effect of antimagic
	var/invocation = "HURP DURP" //what is uttered when the wizard casts the spell
	var/invocation_emote_self = null
	var/invocation_type = "none" //can be none, whisper, emote and shout
	var/range = 7 //the range of the spell; outer radius for aoe spells
	var/message = "" //whatever it says to the guy affected by it
	var/selection_type = "view" //can be "range" or "view"
	var/spell_level = 0 //if a spell can be taken multiple times, this raises
	var/level_max = 4 //The max possible level_max is 4
	var/cooldown_min = 0 //This defines what spell quickened four times has as a cooldown. Make sure to set this for every spell
	var/player_lock = 1 //If it can be used by simple mobs

	var/overlay = 0
	var/overlay_icon = 'icons/obj/wizard.dmi'
	var/overlay_icon_state = "spell"
	var/overlay_lifespan = 0

	var/sparks_spread = 0
	var/sparks_amt = 0 //cropped at 10
	var/smoke_spread = 0 //1 - harmless, 2 - harmful
	var/smoke_amt = 0 //cropped at 10

	var/centcom_cancast = 1 //Whether or not the spell should be allowed on z2

	action_icon = 'icons/mob/actions/actions_spells.dmi'
	action_icon_state = "spell_default"
	action_background_icon_state = "bg_spell"
	base_action = /datum/action/spell_action/spell

/obj/effect/proc_holder/spell/Initialize(mapload)
	. = ..()
	if(mobs_whitelist)
		mobs_whitelist = typecacheof(mobs_whitelist)
	if(mobs_blacklist)
		mobs_blacklist = typecacheof(mobs_blacklist)

/obj/effect/proc_holder/spell/proc/cast_check(skipcharge = FALSE, mob/user = usr, skip_can_cast = FALSE) //checks if the spell can be cast based on its settings; skipcharge is used when an additional cast_check is called inside the spell
	if(!skip_can_cast && !can_cast(user, skipcharge))
		return FALSE

	if(!skipcharge)
		switch(charge_type)
			if("recharge")
				charge_counter = 0 //doesn't start recharging until the targets selecting ends
			if("charges")
				charge_counter-- //returns the charge if the targets selecting fails
			if("holdervar")
				adjust_var(user, holder_var_type, holder_var_amount)
	if(action)
		action.UpdateButtonIcon()
	return TRUE

/obj/effect/proc_holder/spell/proc/charge_check(mob/user, silent = FALSE)
	switch(charge_type)
		if("recharge")
			if(charge_counter < charge_max)
				if(!silent)
					to_chat(user, still_recharging_msg)
				return FALSE
		if("charges")
			if(!charge_counter)
				if(!silent)
					to_chat(user, "<span class='notice'>[name] has no charges left.</span>")
				return FALSE
	return TRUE

/obj/effect/proc_holder/spell/proc/invocation(mob/user = usr) //spelling the spell out and setting it on recharge/reducing charges amount
	var/mob/living/L
	if(isliving(user))
		L = user
	switch(invocation_type)
		if("shout")
			if(!L || L.can_speak_vocal(invocation))
				if(prob(50))//Auto-mute? Fuck that noise
					user.say(invocation, forced = "spell")
				else
					user.say(replacetext(invocation," ","`"), forced = "spell")
		if("whisper")
			if(!L || L.can_speak_vocal(invocation))
				if(prob(50))
					user.whisper(invocation)
				else
					user.whisper(replacetext(invocation," ","`"))
		if("emote")
			user.visible_message(invocation, invocation_emote_self) //same style as in mob/living/emote.dm

/obj/effect/proc_holder/spell/proc/playMagSound()
	playsound(get_turf(usr), sound,50,1)

/obj/effect/proc_holder/spell/Initialize(mapload)
	. = ..()
	START_PROCESSING(SSfastprocess, src)

	still_recharging_msg = "<span class='notice'>[name] is still recharging.</span>"
	charge_counter = charge_max

/obj/effect/proc_holder/spell/Destroy()
	STOP_PROCESSING(SSfastprocess, src)
	qdel(action)
	return ..()

/obj/effect/proc_holder/spell/Trigger(mob/user, skip_can_cast = TRUE)
	if(cast_check(FALSE, user, skip_can_cast))
		choose_targets()
	return 1

/obj/effect/proc_holder/spell/proc/choose_targets(mob/user = usr) //depends on subtype - /targeted or /aoe_turf
	return

/**
  * can_target: Checks if we are allowed to cast the spell on a target.
  *
  * Arguments:
  * * target The atom that is being targeted by the spell.
  * * user The mob using the spell.
  * * silent If the checks should not give any feedback messages.
  */
/obj/effect/proc_holder/spell/proc/can_target(atom/target, mob/user, silent = FALSE)
	return TRUE

/obj/effect/proc_holder/spell/proc/start_recharge()
	recharging = TRUE

/obj/effect/proc_holder/spell/process()
	if(recharging && charge_type == "recharge" && (charge_counter < charge_max))
		charge_counter += 2	//processes 5 times per second instead of 10.
		if(charge_counter >= charge_max)
			action.UpdateButtonIcon()
			charge_counter = charge_max
			recharging = FALSE

/obj/effect/proc_holder/spell/proc/perform(list/targets, recharge = TRUE, mob/user = usr) //if recharge is started is important for the trigger spells
	before_cast(targets)
	invocation(user)
	if(user && user.ckey)
		user.log_message("<span class='danger'>cast the spell [name].</span>", LOG_ATTACK)
	if(recharge)
		recharging = TRUE
	if(sound)
		playMagSound()
	cast(targets,user=user)
	after_cast(targets)
	if(action)
		action.UpdateButtonIcon()

/obj/effect/proc_holder/spell/proc/before_cast(list/targets)
	if(overlay)
		for(var/atom/target in targets)
			var/location
			if(isliving(target))
				location = target.loc
			else if(isturf(target))
				location = target
			var/obj/effect/overlay/spell = new /obj/effect/overlay(location)
			spell.icon = overlay_icon
			spell.icon_state = overlay_icon_state
			spell.anchored = TRUE
			spell.density = FALSE
			QDEL_IN(spell, overlay_lifespan)

/obj/effect/proc_holder/spell/proc/after_cast(list/targets)
	for(var/atom/target in targets)
		var/location
		if(isliving(target))
			location = target.loc
		else if(isturf(target))
			location = target
		if(isliving(target) && message)
			to_chat(target, text("[message]"))
		if(sparks_spread)
			do_sparks(sparks_amt, FALSE, location)
		if(smoke_spread)
			if(smoke_spread == 1)
				var/datum/effect_system/smoke_spread/smoke = new
				smoke.set_up(smoke_amt, location)
				smoke.start()
			else if(smoke_spread == 2)
				var/datum/effect_system/smoke_spread/bad/smoke = new
				smoke.set_up(smoke_amt, location)
				smoke.start()
			else if(smoke_spread == 3)
				var/datum/effect_system/smoke_spread/sleeping/smoke = new
				smoke.set_up(smoke_amt, location)
				smoke.start()


/obj/effect/proc_holder/spell/proc/cast(list/targets,mob/user = usr)
	return

/obj/effect/proc_holder/spell/proc/view_or_range(distance = world.view, center=usr, type="view")
	switch(type)
		if("view")
			. = view(distance,center)
		if("range")
			. = range(distance,center)

/obj/effect/proc_holder/spell/proc/revert_cast(mob/user = usr) //resets recharge or readds a charge
	switch(charge_type)
		if("recharge")
			charge_counter = charge_max
		if("charges")
			charge_counter++
		if("holdervar")
			adjust_var(user, holder_var_type, -holder_var_amount)
	if(action)
		action.UpdateButtonIcon()

/obj/effect/proc_holder/spell/proc/adjust_var(mob/living/target = usr, type, amount) //handles the adjustment of the var when the spell is used. has some hardcoded types
	if (!istype(target))
		return
	switch(type)
		if("bruteloss")
			target.adjustBruteLoss(amount)
		if("fireloss")
			target.adjustFireLoss(amount)
		if("toxloss")
			target.adjustToxLoss(amount)
		if("oxyloss")
			target.adjustOxyLoss(amount)
		if("stun")
			target.AdjustStun(amount)
		if("knockdown")
			target.AdjustKnockdown(amount)
		if("unconscious")
			target.AdjustUnconscious(amount)
		else
			target.vars[type] += amount //I bear no responsibility for the runtimes that'll happen if you try to adjust non-numeric or even non-existent vars

/obj/effect/proc_holder/spell/targeted //can mean aoe for mobs (limited/unlimited number) or one target mob
	var/max_targets = 1 //leave 0 for unlimited targets in range, 1 for one selectable target in range, more for limited number of casts (can all target one guy, depends on target_ignore_prev) in range
	var/target_ignore_prev = 1 //only important if max_targets > 1, affects if the spell can be cast multiple times at one person from one cast
	var/include_user = 0 //if it includes usr in the target list
	var/random_target = 0 // chooses random viable target instead of asking the caster
	var/random_target_priority = TARGET_CLOSEST // if random_target is enabled how it will pick the target


/obj/effect/proc_holder/spell/aoe_turf //affects all turfs in view or range (depends)
	var/inner_radius = -1 //for all your ring spell needs

/obj/effect/proc_holder/spell/targeted/choose_targets(mob/user = usr)
	var/list/targets = list()

	switch(max_targets)
		if(0) //unlimited
			for(var/mob/living/target in view_or_range(range, user, selection_type))
				if(!can_target(target, user, TRUE))
					continue
				targets += target
		if(1) //single target can be picked
			if(range < 0)
				targets += user
			else
				var/possible_targets = list()

				for(var/mob/living/M in view_or_range(range, user, selection_type))
					if(!include_user && user == M)
						continue
					if(!can_target(M, user, TRUE))
						continue
					possible_targets += M

				//targets += input("Choose the target for the spell.", "Targeting") as mob in possible_targets
				//Adds a safety check post-input to make sure those targets are actually in range.
				var/mob/M
				if(!random_target)
					M = input("Choose the target for the spell.", "Targeting") as null|mob in sortNames(possible_targets)
				else
					switch(random_target_priority)
						if(TARGET_RANDOM)
							M = pick(possible_targets)
						if(TARGET_CLOSEST)
							for(var/mob/living/L in possible_targets)
								if(M)
									if(get_dist(user,L) < get_dist(user,M))
										if(los_check(user,L))
											M = L
								else
									if(los_check(user,L))
										M = L
				if(M in view_or_range(range, user, selection_type))
					targets += M

		else
			var/list/possible_targets = list()
			for(var/mob/living/target in view_or_range(range, user, selection_type))
				if(!can_target(target, user, TRUE))
					continue
				possible_targets += target
			for(var/i=1,i<=max_targets,i++)
				if(!possible_targets.len)
					break
				if(target_ignore_prev)
					var/target = pick(possible_targets)
					possible_targets -= target
					targets += target
				else
					targets += pick(possible_targets)

	if(!include_user && (user in targets))
		targets -= user

	if(!targets.len) //doesn't waste the spell
		revert_cast(user)
		return

	perform(targets,user=user)

/obj/effect/proc_holder/spell/aoe_turf/choose_targets(mob/user = usr)
	var/list/targets = list()

	for(var/turf/target in view_or_range(range,user,selection_type))
		if(!can_target(target, user, TRUE))
			continue
		if(!(target in view_or_range(inner_radius,user,selection_type)))
			targets += target

	if(!targets.len) //doesn't waste the spell
		revert_cast()
		return

	perform(targets,user=user)

/obj/effect/proc_holder/spell/proc/updateButtonIcon(status_only, force)
	action.UpdateButtonIcon(status_only, force)

/obj/effect/proc_holder/spell/targeted/proc/los_check(mob/A,mob/B)
	//Checks for obstacles from A to B
	var/obj/dummy = new(A.loc)
	dummy.pass_flags |= PASSTABLE
	for(var/turf/turf in getline(A,B))
		for(var/atom/movable/AM in turf)
			if(!AM.CanPass(dummy,turf,1))
				qdel(dummy)
				return 0
	qdel(dummy)
	return 1

/obj/effect/proc_holder/spell/proc/can_cast(mob/user = usr, skipcharge = FALSE, silent = FALSE)
	var/magic_flags = SEND_SIGNAL(user, COMSIG_MOB_SPELL_CAN_CAST, src)
	if(magic_flags & SPELL_SKIP_ALL_REQS)
		return TRUE

	if(player_lock ? (!user.mind || !(src in user.mind.spell_list) && !(src in user.mob_spell_list)) : !(src in user.mob_spell_list))
		if(!silent)
			to_chat(user, "<span class='warning'>You shouldn't have this spell! Something's wrong.</span>")
		return FALSE

	if(!centcom_cancast && !(magic_flags & SPELL_SKIP_CENTCOM)) //Certain spells are not allowed on the centcom zlevel
		var/turf/T = get_turf(user)
		if(is_centcom_level(T.z))
			if(!silent)
				to_chat(user, "<span class='notice'>You can't cast this spell here.</span>")
			return FALSE

	if(!skipcharge && !charge_check(user, silent))
		return FALSE

	if(user.stat && !stat_allowed && !(magic_flags & SPELL_SKIP_STAT))
		if(!silent)
			to_chat(user, "<span class='notice'>Not when you're incapacitated.</span>")
		return FALSE

	if(!phase_allowed && istype(user.loc, /obj/effect/dummy))
		if(!silent)
			to_chat(user, "<span class='notice'>[name] cannot be cast unless you are completely manifested in the material plane.</span>")
		return FALSE

	if(clothes_req && !(magic_flags & SPELL_SKIP_CLOTHES))
		var/met_requirements = magic_flags & (clothes_req)
		if(met_requirements != clothes_req)
			if(!silent)
				var/the_many_hats = met_requirements & (clothes_req & (SPELL_WIZARD_HAT|SPELL_CULT_HELMET))
				var/the_many_suits = met_requirements & (clothes_req & (SPELL_WIZARD_ROBE|SPELL_CULT_ARMOR))
				var/without_hat_robe = the_many_suits ? "a proper headwear" : the_many_hats ? "a proper suit" : "proper garments"
				to_chat(user, "<span class='notice'>I don't feel strong enough to cast this spell without [without_hat_robe].</span>")
			return FALSE

	if(!antimagic_allowed && !(magic_flags & SPELL_SKIP_ANTIMAGIC) && user.anti_magic_check(TRUE, FALSE, chargecost = 0, self = TRUE))
		return FALSE


	if(!(magic_flags & SPELL_SKIP_VOCAL) && (invocation_type in list("whisper", "shout")) && isliving(user))
		var/mob/living/L = user
		if(!L.can_speak_vocal())
			if(!silent)
				to_chat(L, "<span class='notice'>You can't get the words out!</span>")
			return FALSE

	if(!(magic_flags & SPELL_SKIP_MOBTYPE) && ((mobs_whitelist && !mobs_whitelist[user.type]) || (mobs_blacklist && mobs_blacklist[user.type])))
		if(!silent)
			to_chat(user, "<span class='notice'>This spell can't be casted in this current form!</span>")
		return FALSE
	return TRUE

/obj/effect/proc_holder/spell/self //Targets only the caster. Good for buffs and heals, but probably not wise for fireballs (although they usually fireball themselves anyway, honke)
	range = -1 //Duh

/obj/effect/proc_holder/spell/self/choose_targets(mob/user = usr)
	if(!user)
		revert_cast()
		return
	perform(null,user=user)

/obj/effect/proc_holder/spell/self/basic_heal //This spell exists mainly for debugging purposes, and also to show how casting works
	name = "Lesser Heal"
	desc = "Heals a small amount of brute and burn damage."
	mobs_whitelist = list(/mob/living/carbon/human)
	clothes_req = NONE
	charge_max = 100
	cooldown_min = 50
	invocation = "Victus sano!"
	invocation_type = "whisper"
	school = "restoration"
	sound = 'sound/magic/staff_healing.ogg'

/obj/effect/proc_holder/spell/self/basic_heal/cast(mob/living/carbon/human/user) //Note the lack of "list/targets" here. Instead, use a "user" var depending on mob requirements.
	//Also, notice the lack of a "for()" statement that looks through the targets. This is, again, because the spell can only have a single target.
	user.visible_message("<span class='warning'>A wreath of gentle light passes over [user]!</span>", "<span class='notice'>You wreath yourself in healing light!</span>")
	user.adjustBruteLoss(-10)
	user.adjustFireLoss(-10)
