/mob/living/carbon/alien/larva/BiologicalLife(delta_time, times_fired)
	if(!(. = ..()))
		return
	// GROW!
	if(amount_grown < max_grown)
		amount_grown++
		update_icons()


/mob/living/carbon/alien/larva/update_stat()
	if(status_flags & GODMODE)
		return
	if(stat != DEAD)
		if(health<= -maxHealth || !getorgan(/obj/item/organ/brain))
			death()
			return
		if(IsUnconscious() || IsSleeping() || getOxyLoss() > 50 || (HAS_TRAIT(src, TRAIT_DEATHCOMA)) || health <= crit_threshold)
			if(stat == CONSCIOUS)
				set_stat(UNCONSCIOUS)
				if(!eye_blind)
					blind_eyes(1)
				update_mobility()
		else if(stat == UNCONSCIOUS)
			set_stat(CONSCIOUS)
			if(!(combat_flags & COMBAT_FLAG_HARD_STAMCRIT))
				set_resting(FALSE, TRUE)
			if(eye_blind <= 1)
				adjust_blindness(-1)
			update_mobility()
	update_damage_hud()
	update_health_hud()
