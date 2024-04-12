/mob/living/simple_animal/banana_spider
	name = "banana spider"
	desc = "What the fuck is this abomination?"
	icon_state = "bananaspider"
	icon_dead = "bananaspider_peel"
	health = 1
	maxHealth = 1
	turns_per_move = 5			//this isn't player speed =|
	speed = 2				//this is player speed
	loot = list(/obj/item/reagent_containers/food/snacks/deadbanana_spider)
	atmos_requirements = list("min_oxy" = 0, "max_oxy" = 0, "min_tox" = 0, "max_tox" = 0, "min_co2" = 0, "max_co2" = 0, "min_n2" = 0, "max_n2" = 0)
	minbodytemp = 270
	maxbodytemp = INFINITY
	pass_flags = PASSTABLE | PASSGRILLE | PASSMOB
	mob_size = MOB_SIZE_TINY
	response_help_continuous  = "pokes"
	response_help_simple = "poke"
	response_disarm_continuous = "shoos"
	response_disarm_simple = "shoo"
	response_harm_continuous = "splats"
	response_harm_simple = "plat"
	speak_emote = list("chitters")
	mouse_opacity = 2
	density = TRUE
	verb_say = "chitters"
	verb_ask = "chitters inquisitively"
	verb_exclaim = "chitters loudly"
	verb_yell = "chitters loudly"
	var/squish_chance = 50
	var/projectile_density = TRUE		//griffons get shot
	del_on_death = TRUE

/mob/living/simple_animal/banana_spider/Initialize(mapload)
	. = ..()
	var/area/A = get_area(src)
	if(A)
		notify_ghosts("A banana spider has been created in \the [A.name].", source = src, action=NOTIFY_ATTACK, flashwindow = FALSE, ignore_dnr_observers = TRUE)

	AddElement(/datum/element/ventcrawling, given_tier = VENTCRAWLER_ALWAYS)

/mob/living/simple_animal/banana_spider/attack_ghost(mob/user)
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
		to_chat(user, "Can't become a banana spider before the game has started.")
		return
	var/be_spider = alert("Become a banana spider? (Warning, You can no longer be cloned!)",,"Yes","No")
	if(be_spider == "No" || QDELETED(src) || !isobserver(user))
		return
	if(key)
		to_chat(user, "<span class='notice'>Someone else already took this banana spider.</span>")
		return
	sentience_act()
	user.transfer_ckey(src, FALSE)
	density = TRUE

/mob/living/simple_animal/banana_spider/ComponentInitialize()
	. = ..()
	AddComponent(/datum/component/slippery, 40)

/mob/living/simple_animal/banana_spider/Crossed(atom/movable/AM)		//no /var in proc headers
	. = ..()
	if(istype(AM, /obj/item/projectile) && projectile_density)		//forced projectile density
		var/obj/item/projectile/P = AM
		P.Bump(src)
	if(ismob(AM))
		if(isliving(AM))
			var/mob/living/A = AM
			if(A.mob_size > MOB_SIZE_SMALL && !(A.movement_type & FLYING))
				if(prob(squish_chance))
					A.visible_message("<span class='notice'>[A] squashed [src].</span>", "<span class='notice'>You squashed [src] under your weight as you fell.</span>")
					adjustBruteLoss(1)
				else
					visible_message("<span class='notice'>[src] avoids getting crushed.</span>")
	else
		if(isstructure(AM))
			if(prob(squish_chance))
				AM.visible_message("<span class='notice'>[src] was crushed under [AM]'s weight as they fell.</span>")
				adjustBruteLoss(1)
			else
				visible_message("<span class='notice'>[src] avoids getting crushed.</span>")

/mob/living/simple_animal/banana_spider/ex_act(severity, target, origin)
	return

/mob/living/simple_animal/banana_spider/start_pulling()
	return FALSE			//No.

/obj/item/reagent_containers/food/snacks/deadbanana_spider
	name = "dead banana spider"
	desc = "Thank god it's gone...but it does look slippery."
	icon_state = "bananaspider"
	bitesize = 3
	eatverb = "devours"
	list_reagents = list(/datum/reagent/consumable/nutriment = 3, /datum/reagent/consumable/nutriment/vitamin = 2)
	foodtype = GROSS | MEAT | RAW
	grind_results = list(/datum/reagent/blood = 20, /datum/reagent/liquidgibs = 5)
	juice_results = list(/datum/reagent/consumable/banana = 0)


/obj/item/reagent_containers/food/snacks/deadbanana_spider/Initialize(mapload)
	. = ..()
	AddComponent(/datum/component/slippery, 20)
