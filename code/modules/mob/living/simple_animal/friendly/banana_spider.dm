/mob/living/simple_animal/banana_spider
	icon = 'icons/mob/BananaSpider20.dmi'
	name = "banana spider"
	desc = "What the fuck is this?"
	icon_state = "banana"
	icon_dead = "banana_peel"
	health = 1
	maxHealth = 1
	turns_per_move = 5
	loot = list(/obj/item/reagent_containers/food/snacks/deadbanana_spider)
	atmos_requirements = list("min_oxy" = 0, "max_oxy" = 0, "min_tox" = 0, "max_tox" = 0, "min_co2" = 0, "max_co2" = 0, "min_n2" = 0, "max_n2" = 0)
	minbodytemp = 270
	maxbodytemp = INFINITY
	pass_flags = PASSTABLE | PASSGRILLE | PASSMOB
	mob_size = MOB_SIZE_TINY
	response_help  = "pokes"
	response_disarm = "shoos"
	response_harm   = "splats"
	speak_emote = list("chitters")
	density = FALSE
	ventcrawler = VENTCRAWLER_ALWAYS
	gold_core_spawnable = FRIENDLY_SPAWN
	verb_say = "chitters"
	verb_ask = "chitters inquisitively"
	verb_exclaim = "chitters loudly"
	verb_yell = "chitters loudly"
	var/squish_chance = 50
	del_on_death = 1

/mob/living/simple_animal/banana_spider/death(gibbed)
	if(SSticker.mode && SSticker.mode.station_was_nuked) //If the nuke is going off, then cockroaches are invincible. Keeps the nuke from killing them, cause cockroaches are immune to nukes.
		return
	..()

/mob/living/simple_animal/banana_spider/Crossed(var/atom/movable/AM)
	if(ismob(AM))
		if(isliving(AM))
			var/mob/living/A = AM
			if(A.mob_size > MOB_SIZE_SMALL && !(A.movement_type & FLYING))
				if(prob(squish_chance))
					A.visible_message("<span class='notice'>[A] squashed [src].</span>", "<span class='notice'>You squashed [src].</span>")
					adjustBruteLoss(1) //kills a normal cockroach
				else
					visible_message("<span class='notice'>[src] avoids getting crushed.</span>")
	else
		if(isstructure(AM))
			if(prob(squish_chance))
				AM.visible_message("<span class='notice'>[src] was crushed under [AM].</span>")
				adjustBruteLoss(1)
			else
				visible_message("<span class='notice'>[src] avoids getting crushed.</span>")

/mob/living/simple_animal/banana_spider/ex_act() //Explosions are a terrible way to handle a cockroach.
	return

/obj/effect/decal/cleanable/deadbanana_spiderT
	name = "dead banana spider guts"
	desc = "One bug squashed. Four more will rise in its place."
	icon = 'icons/effects/blood.dmi'
	icon_state = "xfloor1"
	random_icon_states = list("xfloor1", "xfloor2", "xfloor3", "xfloor4", "xfloor5", "xfloor6", "xfloor7")

/obj/item/reagent_containers/food/snacks/deadbanana_spider
	name = "dead banana spider"
	desc = "Thank god it's gone...but it does look slippery."
	icon = 'icons/mob/BananaSpider20.dmi'
	icon_state = "banana_peel"
	bitesize = 3
	eatverb = "devours"
	list_reagents = list("nutriment" = 3, "vitamin" = 2)
	foodtype = GROSS | MEAT | RAW
	grind_results = list("blood" = 20, "liquidgibs" = 5)