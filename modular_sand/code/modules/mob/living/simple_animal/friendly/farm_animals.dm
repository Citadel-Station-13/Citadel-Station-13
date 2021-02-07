/mob/living/simple_animal/hostile/retaliate/goat/Retaliate()
	..()
	playsound(src, 'sound/machines/chime.ogg', 10)
	flick_emote_popup_on_mob(src, "combat", 10)
	set_combat_indicator(TRUE)

/mob/living/simple_animal/hostile/retaliate/goat/death()
	. = ..()
	set_combat_indicator(FALSE) //please don't keep it while dead

/mob/living/simple_animal/hostile/retaliate/goat/revive(admin_revive, full_heal)
	. = ..()
	if(enemies.len)
		playsound(src, 'sound/machines/chime.ogg', 10)
		flick_emote_popup_on_mob(src, "combat", 10)
		set_combat_indicator(TRUE)
