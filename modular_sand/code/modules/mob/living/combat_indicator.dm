var/static/mutable_appearance/combat_indicator

/mob/living/proc/set_combat_indicator(var/state)
	if(!combat_indicator)
		combat_indicator = mutable_appearance('modular_sand/icons/mob/combat_indicator.dmi', "combat", FLY_LAYER)
		combat_indicator.appearance_flags = APPEARANCE_UI_IGNORE_ALPHA | KEEP_APART

	if(state && stat != DEAD)
		add_overlay(combat_indicator)
	else
		cut_overlay(combat_indicator)
