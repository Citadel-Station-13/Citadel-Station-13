/datum/reagent/consumable/ethanol/stabsinthe
	name = "Stabsinthe"
	id = "stabsinthe"
	description = "A blend of absinthe brewed with nettles. Inspires violence"
	color = "#006400" //rgb 0, 100, 0. html "darkgreen"
	boozepwr = 100
	taste_description = "acid and needles"
	glass_name = "glass of stabsinthe"
	glass_desc = "A waxy, thirst-quenching drink refined from ground Nettle needles. Inspires violence in whoever drinks it"

/datum/reagent/consumable/ethanol/stabsinthe/on_mob_life(mob/living/M) //TODO: Make this force the user into harm intent, and automatically attack people who attack them
	if(prob(2.5)) //I don't know how likely this is to occur over periods of time because I don't know how quickly on_mob_life is called, so these values can be adjusted
		to_chat(M, "<span class='danger'>You feel a stabbing pain in your throat</span>") //Spacemen ain't from Caelondia, they don't know to spit up the needles
		M.adjustBruteLoss(5)

	if(M.a_intent != INTENT_HARM)
		to_chat(M, "<span class='danger'>You feel violent!</span>")
		M.a_intent_change(INTENT_HARM)