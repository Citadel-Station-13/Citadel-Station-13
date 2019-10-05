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
	visible_message("<b>[src]</b> cackles, <span class='spooky'>\"You'll nae get rid a me that easily!\"</span>")
	playsound(loc, 'sound/spookoween/ahaha.ogg', 100, 1)
	var/mob/living/jacq/Jacq = new src.type(loc)
	Jacq.tricked = tricked
	Jacq.progression = progression
	Jacq.poof()
	..()

/mob/living/jacq/death() //What is alive may never die
	visible_message("<b>[src]</b> cackles, <span class='spooky'>\"You'll nae get rid a me that easily!\"</span>")
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
			visible_message("<b>[src] smiles ominously at [L],</b> <span class='spooky'>\"Well hal� there [gender]! Ah�m Jacqueline, tae great Pumpqueen, right in tae flesh fer ye.\"</span>")
			sleep(20)
			visible_message("<span class='spooky'><b>[src] smiles ominously at [L],</b> \"Well hal� there [gender]! Ah�m Jacqueline, tae great Pumpqueen, right in tae flesh fer ye.\"</span>")

	var/choices = list("Trick", "Treat")
	var/choice = input(usr, "Trick or Treat?", "Trick or Treat?") in choices
	switch(choice)
		if("Trick")
			return
		if("Treat")
			return

/*
visible_message("<span class='spooky'><b>[src] smiles ominously at [L],</b> ”Well halò there [gender]! Ah’m Jacqueline, tae great Pumpqueen, right in tae flesh fer ye.”</span>")
says, ”Ah’m sure yae well stunned, but ah’ve got nae taem fer that. Ah’m after yer candies. If yae get mae enoof o the wee buggers, I’ll give you a treat, or if yae feeling bold, Ah ken trick ye instaed.” giving [L] a wide grin.

Why do you want the candies?
”Have you tried them? They’re full of all sorts of reagents. I’m after them so I can magic them up and hopefully find some rare stuff for me brews. Honestly it’s a lot cheaper magicking up tatt for you lot than sending a familiar off to pick them up for me. Most of my familiars are funny fellows and constantly go off on adventures when given simple objectives like; Go grab me a tea cake or watch over me cauldron. I mean, you might run into Bernkastel my cat. She’s supposed to be tending my cauldron, but I’ve no idea where she’s got to.
What is that on your head?
Points at the pumpkin atop her head, ”This thing? This isn’t any ordinary pumpkin! My mother grew this monster over a year of love, dedication and hard work. Honestly it felt like she loved this thing more than she any of her kids, which I know isn’t true and it’s not like she was heartless or anything but.. well, we had a falling out when I got back home with all me stuff in tow. And all she had done is sent me owl after owl over the last year about this bloody pumpkin and I had enough. So I took it, and put it on my head. You know, as you do. I am the great Pumpqueen after all, I deserve this.
Isn’t it a bit far to get candy?
looks to the side sheepishly, ”Aye, well, tae be honest, Ah’m here tae see me sis, but dunnae let her knew that. She’s an alchemist too like, but she dunnae use a caldron like mae, she buggered off like to her posh ivory tower tae learn bloody chemistry instead!” [src] scowls, “She’s tae black sheep o’ the family too, so we dunnae see eye to eye sometimes on alchemy. Ah mean, she puts <i> moles </i> in her brews! Ye dunnae put moles in yer brews! Yae threw your brews at tae wee bastards an blew em up!” [src] sighs ”But she’s a heart o gold so.. Ah wanted tae see her an check up oon her, make sure she’s okay.”
Are you a witch?
grumbles </b>”If you must know, I got kicked out of the witch academy for being too much of a “loose cannon”. A bloody loose cannon? Nae they were just pissed off I had the brass to proclaim myself as the Pumpqueen…. And also maybe the time I went and blew up one of the towers by trying to make a huge batch of astrogen might’ve had something to do with it. I mean it would’ve worked fine if the cauldrons weren’t so shite and were actually upgraded by the faculty. So technically no, I’m not a witch.”
So you got ex-spell-ed?
Gives you a blank look at the pun, before continuing ”Not quite, I know I can get back into the academy, it’s only an explosion, they happen all the time, but, to be fair it’s my fault that things came to their explosive climax. You don’t know what it’s like when you’re after a witch doctorate, everyone else is doing well, everyone’s making new spells and the like, and I’m just good at making explosions really, or fireworks. So, I did something I knew was dangerous, because I had to do something to stand out, but I know this life isn’t for me, I don’t want to be locked up in dusty towers, grinding reagent after reagent together, trying to find new reactions, some of the wizards in there haven’t left for years. I want to live, I want to fly around on a broom, turn people into cats for a day and disappear cackling! That’s what got me into witchcraft!” she throws her arms up in the arm, spinning the pumpkin upon her head slightly. She carefully spins it back to face you, giving out a soft sigh, ”I know my mother’s obsession with this dumb thing on my head is just her trying to fill the void of me and my sis moving out, and it really shouldn’t be on my head. And I know that I’m really here to get help from my sis… She’s the sensible one, and she gives good hugs.”
Thanks [L], I guess I didn’t realise I needed someone to talk to but, I’m glad you spent all your candies talking to me.” she gives a grin underneath the pumpkin upon her head, ”Though I’m still keeping the candies!”
Will you go on a date with me?
”…You want to ask me out on a date? Me? After all that nonsense I just said? It seems a waste of a candy honestly.”
[src] looks to the side.
”Look, I like ye but, I don’t think I can right now. If you can’t tell, the stations covered in volatile candies, I’ve a few other laddies and lassies running after me treats, and to top it all off, I’ve the gods breathing down me neck, watching every treat I make for the lot of yous.” she sighs, ”But that’s not a no, right? That’s.. just a not right now.”
[src] takes off the pumpkin on her head, a rich blush on her cheeks. She leans over planting a kiss upon your forehead quickly before popping the pumpkin back on her head.

” There, that aught to be worth a candy.”

Ondeath:
visible_message("<span class='spooky'><b>[src] cackles,</b> "You'll nae get rid a me that easily!"</span>")
(the last message is if I can't get a ghost/a person in it)
*/

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

/obj/item/reagent_containers/food/snacks/special_candy/Initialize()
	reagents.add_reagent(get_random_reagent_id(), 5)
	..()
