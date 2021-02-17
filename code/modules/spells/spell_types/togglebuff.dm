/obj/effect/proc_holder/spell/self/mantra
	name = "Inner Mantra"
	desc = "Control your Inner Mantra, gaining strength and durability for a cost."
	clothes_req = NONE
	mobs_whitelist = list(/mob/living/carbon/human)
	charge_max = 100
	antimagic_allowed = TRUE
	invocation = "SU'UP'AH S'EI YEN"
	invocation_type = "shout"
	level_max = 0
	cooldown_min = 100
	action_icon = 'icons/obj/magic.dmi'
	action_icon_state = "iconmantra"

/obj/effect/proc_holder/spell/self/mantra/cast(mob/living/carbon/human/user)
	if(user.has_status_effect(STATUS_EFFECT_MANTRA))
		user.remove_status_effect(STATUS_EFFECT_MANTRA)
	else
		user.apply_status_effect(STATUS_EFFECT_MANTRA)

/obj/effect/proc_holder/spell/self/asura
	name = "Asura's Wrath"
	desc = "Unleash your rage as corrosive power fills your muscles."
	clothes_req = NONE
	mobs_whitelist = list(/mob/living/carbon/human)
	charge_max = 100
	antimagic_allowed = TRUE
	invocation = "KYE Y'O'KEN"
	invocation_type = "shout"
	level_max = 0
	cooldown_min = 100
	action_icon = 'icons/obj/magic.dmi'
	action_icon_state = "iconasura"

/obj/effect/proc_holder/spell/self/asura/cast(mob/living/carbon/human/user)
	if(user.has_status_effect(STATUS_EFFECT_ASURA))
		user.remove_status_effect(STATUS_EFFECT_ASURA)
	else
		user.apply_status_effect(STATUS_EFFECT_ASURA)
