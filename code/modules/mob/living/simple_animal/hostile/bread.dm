//funny reference to the video 'Expiration Date'

/mob/living/simple_animal/hostile/bread
	name = "tumor bread"
	desc = "I have done nothing but teleport bread for three days."
	icon_state = "tumorbread"
	health = 1
	maxHealth = 1
	turns_per_move = 5  //this isn't player speed =|
	speed = 2  //this is player speed
	melee_damage_lower = 1
	melee_damage_upper = 2
	obj_damage = 0
	loot = list(/obj/item/reagent_containers/food/snacks/store/bread/tumor_bread)
	atmos_requirements = list("min_oxy" = 0, "max_oxy" = 0, "min_tox" = 0, "max_tox" = 0, "min_co2" = 0, "max_co2" = 0, "min_n2" = 0, "max_n2" = 0)
	minbodytemp = 270
	maxbodytemp = INFINITY
	pass_flags = PASSTABLE | PASSGRILLE | PASSMOB
	mob_size = MOB_SIZE_TINY
	response_help_continuous  = "pokes"
	response_help_simple = "poke"
	response_disarm_continuous = "shoos"
	response_disarm_simple = "shoo"
	response_harm_continuous = "punches"
	response_harm_simple = "punch"
	speak_emote = list("growls")
	mouse_opacity = 2
	density = TRUE
	verb_say = "growls"
	verb_ask = "growls inquisitively"
	verb_exclaim = "growls loudly"
	verb_yell = "growls loudly"
	del_on_death = TRUE

/mob/living/simple_animal/bread/hostile/Initialize()
	. = ..()
	var/area/A = get_area(src)
	if(A)
		notify_ghosts("A tumor bread has been created in \the [A.name].", source = src, action=NOTIFY_ATTACK, flashwindow = FALSE, ignore_dnr_observers = TRUE)
	AddElement(/datum/element/ventcrawling, given_tier = VENTCRAWLER_ALWAYS)

/mob/living/simple_animal/hostile/bread/attack_ghost(mob/user)
	if(key)			//please stop using src. without a good reason.
		return
	if(CONFIG_GET(flag/use_age_restriction_for_jobs))
		if(!isnum(user.client.player_age))
			return
	if(isobserver(user))
		var/mob/dead/observer/O = user
		if(!O.can_reenter_round())
			return
	if(!SSticker.mode)
		to_chat(user, "Can't become a tumor bread before the game has started.")
		return
	var/be_bread = alert("Become a tumor bread? (Warning, You can no longer be cloned!)",,"Yes","No")
	if(be_bread == "No" || QDELETED(src) || !isobserver(user))
		return
	if(key)
		to_chat(user, "<span class='notice'>Someone else already took this tumor bread.</span>")
		return
	sentience_act()
	user.transfer_ckey(src, FALSE)
	density = TRUE

/mob/living/simple_animal/hostile/bread/ex_act()
	return

/mob/living/simple_animal/hostile/bread/start_pulling()
	return FALSE
