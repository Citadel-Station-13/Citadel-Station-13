//Whacha doing in here like? Yae wan tae ruin ta magicks?
/mob/living/jacq
	name = "Jacqueline the Pumpqueen"
	real_name = "Jacqueline"
	icon = 'icons/obj/halloween_items.dmi'
	icon_state = "jacqueline"
	maxHealth = INFINITY
	health = 20
	density = FALSE
	var/destinations = list("Bar", "Brig", "Bridge", "Chapel", "Chemistry", "Cyrogenics", "Engineering", "Xenobiology")
	var/tricked = list() //Those who have been tricked
	var/progression = list() //Keep track of where people are in the story.


/mob/living/jacq/Destroy() //I.e invincible
	visible_message("<span class='spooky'><b>[src]</b> cackles, \"You'll nae get rid a me that easily!\"</span>")
	playsound(loc, 'sound/spookoween/ahaha.ogg', 100, 1)
	var/mob/living/jacq/Jacq = new src.type(loc)
	Jacq.tricked = tricked
	Jacq.progression = progression
	Jacq.poof()
	..()

/mob/living/jacq/death() //What is alive may never die
	visible_message("<span class='spooky'><b>[src]</b> cackles, \"You'll nae get rid a me that easily!\"</span>")
	playsound(loc, 'sound/spookoween/ahaha.ogg', 100, 1)
	health = 20
	poof()


/mob/living/jacq/proc/poof()
	var/datum/reagents/R = new/datum/reagents(100)//Hey, just in case.
	var/datum/effect_system/smoke_spread/chem/s = new()
	R.add_reagent("secretcatchem", (10))
	s.set_up(R, 2, loc)
	s.start()

	for(var/i = 1, i <= 5, i+=1)//try 5 times to teleport
		var/area/A = GLOB.sortedAreas["[pick(destinations)]"]
		if(A && istype(A))
			if(forceMove(safepick(get_area_turfs(A))))
				return TRUE
	return FALSE


//Ye wee bugger, gerrout of it. Ye've nae tae enjoy reading the code fer mae secrets like.
/mob/living/jacq/proc/chit_chat(mob/living/L)
	var/mob/living/carbon/C = L

	//Very important
	var/gender = "lamb"
	if(C)
		if(C.gender == MALE)
			gender = "laddie"
		if(C.gender == FEMALE)
			gender = "lassie"

		if(!progression[C])
			visible_message("<span class='spooky'><b>[src] smiles ominously at [L],</b> \"Well hal� there [gender]! Ah�m Jacqueline, tae great Pumpqueen, right in tae flesh fer ye.\"</span>")
			sleep(20)
			visible_message("<span class='spooky'><b>[src] smiles ominously at [L],</b> \"Well hal� there [gender]! Ah�m Jacqueline, tae great Pumpqueen, right in tae flesh fer ye.\"</span>")

	var/choices = list("Trick", "Treat")
	var/choice = input(usr, "Trick or Treat?", "Trick or Treat?") in choices
	switch(choice)
		if("Trick")
			return
		if("Treat")
			return

/mob/living/jacq/proc/check_candies(mob/living/carbon/C)
	var/invs = C.get_contents()
	var/candy_count = 0
	for(var/item in invs)
		if(istype(item, /obj/item/reagent_containers/food/snacks/special_candy))
			candy_count++
	return candy_count

/mob/living/jacq/proc/take_candies(mob/living/carbon/C, candy_amount = 1)
	var/inv = C.get_contents()
	var/candies = list()
	for(var/item in inv)
		if(istype(item, /obj/item/reagent_containers/food/snacks/special_candy))
			candies += item
		if(LAZYLEN(candies) == candy_amount)
			for(var/candy in candies)
				qdel(candy)
			return TRUE
	return FALSE

/mob/living/jacq/proc/trick()
//var/area/A = input(usr, "Pick an area.", "Pick an area") in GLOB.sortedAreas|null


//Candies
/obj/item/reagent_containers/food/snacks/special_candy
	name = "Magic candy"
