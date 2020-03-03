// Credit for the sprites goes to CEV Eris. The sprites were taken from Hyper Station and modified to fit with armrests which were also added.

/obj/structure/chair/corp_sofa
	name = "sofa"
	desc = "Soft, cushy and cozy. These sofas reek of bland faceless corporatism, but they aren't old and ratty at least."
	icon_state = "corp_sofamiddle"
	icon = 'icons/obj/sofa.dmi'
	buildstackamount = 1
	var/mutable_appearance/armrest

/obj/structure/chair/corp_sofa/Initialize()
	armrest = mutable_appearance(icon, "[icon_state]_armrest", ABOVE_MOB_LAYER)
	return ..()

/obj/structure/chair/corp_sofa/post_buckle_mob(mob/living/M)
	. = ..()
	update_armrest()

/obj/structure/chair/corp_sofa/proc/update_armrest()
	if(has_buckled_mobs())
		add_overlay(armrest)
	else
		cut_overlay(armrest)

/obj/structure/chair/corp_sofa/post_unbuckle_mob()
	. = ..()
	update_armrest()

/obj/structure/chair/corp_sofa/left
	icon_state = "corp_sofaend_left"

/obj/structure/chair/corp_sofa/right
	icon_state = "corp_sofaend_right"

/obj/structure/chair/corp_sofa/corner
	icon_state = "corp_sofacorner"

/obj/structure/chair/corp_sofa/corner/handle_layer() //only the armrest/back of this chair should cover the mob.
	return
