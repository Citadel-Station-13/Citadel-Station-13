/datum/reagent/consumable/ethanol/stabsinthe
	name = "Stabsinthe"
	id = "stabsinthe"
	description = "A blend of absinthe brewed with nettles. Inspires violence"
	color = "#006400" //rgb 0, 100, 0. html "darkgreen"
	boozepwr = 100
	taste_description = "acid and needles"
	glass_name = "glass of stabsinthe"
	glass_desc = "Stabsinthe's like drinkin' a cool breeze. Just don't go spittin' needles everywhere"
	var/retaliated = FALSE //I don't know where else to put this. Limits retaliation to once per mob_life cycle

/datum/reagent/consumable/ethanol/stabsinthe/on_mob_life(mob/living/M)
	retaliated = FALSE

	if(prob(2.5)) //I don't know how likely this is to occur over periods of time because I don't know how quickly on_mob_life is called, so these values can be adjusted
		to_chat(M, "<span class='danger'>You feel a stabbing pain in your throat</span>") //Spacemen ain't from Caelondia, they don't know to spit up the needles
		M.adjustBruteLoss(5)

	if(M.a_intent != INTENT_HARM) //Sets the user's intent to harm. Since it only happens once per mob_life cycle, it does give a window to do quick actions on other intents
		to_chat(M, "<span class='danger'>You feel violent!</span>")
		M.a_intent_change(INTENT_HARM)

/datum/reagent/consumable/ethanol/stabsinthe/on_mob_attacked(mob/living/M)
	if(!retaliated)
		M.click_random_mob() //Doesn't neccesirily mean attacking, but we (hopefully) are on harm intent, so it will at least be a little violent.
		M.visible_message("<span class='warning'>[M] furiously retaliates!","<span class='warning'>You furiously retaliate!")
		retaliated = TRUE