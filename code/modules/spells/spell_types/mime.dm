/obj/effect/proc_holder/spell/aoe_turf/conjure/mime_wall
	name = "Invisible Wall"
	desc = "The mime's performance transmutates into physical reality."
	school = "mime"
	panel = "Mime"
	summon_type = list(/obj/effect/forcefield/mime)
	invocation_type = "emote"
	invocation_emote_self = "<span class='notice'>You form a wall in front of yourself.</span>"
	summon_lifespan = 300
	charge_max = 300
	clothes_req = NONE
	range = 0
	cast_sound = null
	mobs_whitelist = list(/mob/living/carbon/human)

	action_icon_state = "mime"
	action_background_icon_state = "bg_mime"

/obj/effect/proc_holder/spell/aoe_turf/conjure/mime_wall/Click()
	if(usr && usr.mind)
		if(!usr.mind.miming)
			to_chat(usr, "<span class='notice'>You must dedicate yourself to silence first.</span>")
			return
		invocation = "<B>[usr.real_name]</B> looks as if a wall is in front of [usr.p_them()]."
	else
		invocation_type ="none"
	..()


/obj/effect/proc_holder/spell/targeted/mime/speak
	name = "Speech"
	desc = "Make or break a vow of silence."
	school = "mime"
	panel = "Mime"
	clothes_req = NONE
	mobs_whitelist = list(/mob/living/carbon/human)
	charge_max = 3000
	range = -1
	include_user = 1

	action_icon_state = "mime"
	action_background_icon_state = "bg_mime"

/obj/effect/proc_holder/spell/targeted/mime/speak/Click()
	if(!usr)
		return
	if(!ishuman(usr))
		return
	var/mob/living/carbon/human/H = usr
	if(H.mind.miming)
		still_recharging_msg = "<span class='warning'>You can't break your vow of silence that fast!</span>"
	else
		still_recharging_msg = "<span class='warning'>You'll have to wait before you can give your vow of silence again!</span>"
	..()

/obj/effect/proc_holder/spell/targeted/mime/speak/cast(list/targets,mob/user = usr)
	for(var/mob/living/carbon/human/H in targets)
		H.mind.miming=!H.mind.miming
		if(H.mind.miming)
			to_chat(H, "<span class='notice'>You make a vow of silence.</span>")
			SEND_SIGNAL(H, COMSIG_CLEAR_MOOD_EVENT, "vow")
		else
			SEND_SIGNAL(H, COMSIG_ADD_MOOD_EVENT, "vow", /datum/mood_event/broken_vow)
			to_chat(H, "<span class='notice'>You break your vow of silence.</span>")

// These spells can only be gotten from the "Guide for Advanced Mimery series" for Mime Traitors.

/obj/effect/proc_holder/spell/targeted/forcewall/mime
	name = "Invisible Blockade"
	desc = "Form an invisible three tile wide blockade."
	school = "mime"
	panel = "Mime"
	wall_type = /obj/effect/forcefield/mime/advanced
	invocation_type = "emote"
	invocation_emote_self = "<span class='notice'>You form a blockade in front of yourself.</span>"
	charge_max = 600
	sound =  null
	clothes_req = NONE
	range = -1
	include_user = 1

	action_icon_state = "mime"
	action_background_icon_state = "bg_mime"

/obj/effect/proc_holder/spell/targeted/forcewall/mime/Click()
	if(usr && usr.mind)
		if(!usr.mind.miming)
			to_chat(usr, "<span class='notice'>You must dedicate yourself to silence first.</span>")
			return
		invocation = "<B>[usr.real_name]</B> looks as if a blockade is in front of [usr.p_them()]."
	else
		invocation_type ="none"
	..()

/obj/effect/proc_holder/spell/aimed/finger_guns
	name = "Finger Guns"
	desc = "Shoot a mimed bullet from your fingers that stuns and does some damage."
	school = "mime"
	panel = "Mime"
	charge_max = 300
	clothes_req = NONE
	invocation_type = "emote"
	invocation_emote_self = "<span class='dangers'>You fire your finger gun!</span>"
	range = 20
	projectile_type = /obj/item/projectile/bullet/mime
	projectile_amount = 3
	sound = null
	active_msg = "You draw your fingers!"
	deactive_msg = "You put your fingers at ease. Another time."
	active = FALSE

	action_icon_state = "mime"
	action_background_icon_state = "bg_mime"
	base_icon_state = "mime"


/obj/effect/proc_holder/spell/aimed/finger_guns/Click()
	var/mob/living/carbon/human/owner = usr
	if(owner.incapacitated())
		to_chat(owner, "<span class='warning'>You can't properly point your fingers while incapacitated.</span>")
		return
	if(usr && usr.mind)
		if(!usr.mind.miming)
			to_chat(usr, "<span class='notice'>You must dedicate yourself to silence first.</span>")
			return
		invocation = "<B>[usr.real_name]</B> fires [usr.p_their()] finger gun!"
	else
		invocation_type ="none"
	..()

/obj/effect/proc_holder/spell/targeted/touch/mimerope
	name = "Invisible Rope"
	desc = "Form an invisible rope to tie people or trip people with."
	school = "mime"
	panel = "Mime"
	invocation_type = "emote"
	invocation_emote_self = "<span class='notice'>You start fabricate an invisible rope.</span>"
	charge_max = 700
	sound =  null
	clothes_req = 0
	range = -1
	include_user = 1
	action_icon_state = "mime"
	action_background_icon_state = "bg_mime"
	hand_path = /obj/item/melee/touch_attack/mimerope

/obj/effect/proc_holder/spell/targeted/touch/mimerope/Click()
	if(usr && usr.mind)
		if(!usr.mind.miming)
			to_chat(usr, "<span class='notice'>You must dedicate yourself to silence first.</span>")
			return
		if (usr.get_active_held_item())
			to_chat(usr, "<span class='notice'>Your hands must be free to create the invisible rope.</span>")
			return
		invocation = "<B>[usr.real_name]</B> is twirling an invisible rope in [usr.p_their()] hands."
	else
		invocation_type ="none"

/obj/effect/proc_holder/spell/targeted/touch/mimerope/cast(list/targets,mob/user = usr)

	usr.put_in_hands()

/obj/item/melee/touch_attack/mimerope
	item_state = ""
	icon_state = ""
	name = "mime rope"
	desc = "An invisible rope."

/obj/item/restraints/handcuffs/cable/mime
	name = "mime restraints"
	desc = "An invisible rope."
	item_state = ""
	icon_state = ""

/obj/item/book/granter/spell/mimery_blockade
	spell = /obj/effect/proc_holder/spell/targeted/forcewall/mime
	spellname = "Invisible Blockade"
	name = "Guide to Advanced Mimery Vol 1"
	desc = "The pages don't make any sound when turned."
	icon_state ="bookmime"
	remarks = list("...")

/obj/item/book/granter/spell/mimery_blockade/attack_self(mob/user)
	..()
	if(!locate(/obj/effect/proc_holder/spell/targeted/mime/speak) in user.mind.spell_list)
		user.mind.AddSpell(new /obj/effect/proc_holder/spell/targeted/mime/speak)

/obj/item/book/granter/spell/mimery_guns
	spell = /obj/effect/proc_holder/spell/aimed/finger_guns
	spellname = "Finger Guns"
	name = "Guide to Advanced Mimery Vol 2"
	desc = "There aren't any words written..."
	icon_state ="bookmime"
	remarks = list("...")

/obj/item/book/granter/spell/mimery_guns/attack_self(mob/user)
	..()
	if(!locate(/obj/effect/proc_holder/spell/targeted/mime/speak) in user.mind.spell_list)
		user.mind.AddSpell(new /obj/effect/proc_holder/spell/targeted/mime/speak)