//Whacha doing in here like? Yae wan tae ruin ta magicks?
/mob/living/jacq
	name = "Jacqueline"
	real_name = "Jacqueline"
	icon = 'icons/obj/halloween_items.dmi'
	icon_state = "jacqueline"
	maxHealth = INFINITY
	health = 20
	speak_emote = list("croons")
	emote_hear = list("spooks","giggles")
	density = FALSE
    var/destinations = list("Bar", "Brig", "Bridge", "Chapel", "Chemistry", "Cyrogenics", "Engineering", "Xenobiology")
    var/tricked = list() //Those who have been tricked
	var/progression = list() //Keep track of where people are in the story.


/mob/living/jacq/proc/Destroy() //I.e invincible
	visible_message("<span class='spooky'><b>[src] cackles,</b> \"You'll nae get rid a me that easily!\"</span>")
	playsound(loc, 'sound/spookoween/ahaha.ogg', 100, 1)
	var/mob/living/Jacq = new src(loc)
	Jacq.tricked = tricked
	Jacq.progression = progression
	Jacq.poof()
	..()

/mob/living/jacq/death() //What is alive may never die
	visible_message("<span class='spooky'><b>[src] cackles,</b> \"You'll nae get rid a me that easily!\"</span>")
	playsound(loc, 'sound/spookoween/ahaha.ogg', 100, 1)
	health = 20
	poof()


/mob/living/jacq/proc/poof()
    var/area/A = GLOB.sortedAreas["[pick(destinations)]"]
    if(A && istype(A))
        if(M.forceMove(safepick(get_area_turfs(A))))

//Ye wee bugger, gerrout of it. Ye've nae tae enjoy reading the code fer mae secrets like.
/mob/living/jacq/proc/chit_chat(var/mob/living/L)
	if(istype(L, mob/living/carbon))
		var/mob/living/carbon/C = L

	//Very important
	var/gender = "lamb"
	if(C)
		if(C.gender == MALE)
			gender = "laddie"
		if(C.gender == FEMALE)
			gender = "lassie"

		if(!progression[C])
			visible_message("<span class='spooky'><b>[src] smiles ominously at [L],</b> \”Well halò there [gender]! Ah’m Jacqueline, tae great Pumpqueen, right in tae flesh fer ye.”</span>")
			sleep(20)
			visible_message("<span class='spooky'><b>[src] smiles ominously at [L],</b> \”Well halò there [gender]! Ah’m Jacqueline, tae great Pumpqueen, right in tae flesh fer ye.”</span>")

	var/choices = list("Trick", "Treat")
    var/choice = input(usr, "Trick or Treat?", "Trick or Treat?") in choices
	switch(choice)
		if("Trick")
			L.
		if("Treat")

/mob/living/jacq/proc/check_candies(var/mob/living/carbon/C)
	var/inv = C.get_contents()
	var/candy_count = 0
	for(var/item in inv)
		if(istype(item, /obj/item/reagent_containers/food/snacks/special_candy))
			candy_count++
	return candy_count

/mob/living/jacq/proc/take_candies(var/mob/living/carbon/C, amount)
	var/inv = C.get_contents()
	var/candies = list()
	for(var/item in inv)
		if(istype(item, /obj/item/reagent_containers/food/snacks/special_candy))
			candies += item
		if(LAZYLEN(candy_count) == amount)
			for(var/candy in candies)
				qdel(candy)
			return TRUE
	return FALSE

/mob/living/jacq/proc/trick()
    var/
//var/area/A = input(usr, "Pick an area.", "Pick an area") in GLOB.sortedAreas|null
