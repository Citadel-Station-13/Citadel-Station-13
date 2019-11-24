#define DEFAULT_TASTE_SENSITIVITY 15

/mob/living
	var/last_taste_time
	var/last_taste_text

/mob/living/proc/get_taste_sensitivity()
	return DEFAULT_TASTE_SENSITIVITY

/mob/living/carbon/get_taste_sensitivity()
	var/obj/item/organ/tongue/tongue = getorganslot(ORGAN_SLOT_TONGUE)
	if(istype(tongue) && !HAS_TRAIT(src, TRAIT_AGEUSIA))
		. = tongue.taste_sensitivity
	else
		. = 101 // can't taste anything without a tongue

// non destructively tastes a reagent container

//FermiChem - How to check pH of a beaker without a meter/pH paper.
//Basically checks the pH of the holder and burns your poor tongue if it's too acidic!
//TRAIT_AGEUSIA players can't taste, unless it's burning them.
//taking sips of a strongly acidic/alkaline substance will burn your tongue.
/mob/living/proc/taste(datum/reagents/from)
	var/obj/item/organ/tongue/T = getorganslot("tongue")
	var/taste_sensitivity = get_taste_sensitivity()
	var/text_output = from.generate_taste_message(taste_sensitivity)
	if(T)
		if(istype(T, /obj/item/organ/tongue/cybernetic))
			to_chat(src, "<span class='notice'>Your tongue moves on it's own in response to the substance in your mouth.</span>")
			say("The pH is appropriately [round(from.pH, 1)].")
		else if ((from.pH > 12.5) || (from.pH < 1.5))
			text_output += "<span class='warning'> and it burns!!</span>"
			T.applyOrganDamage(5)
		else if (!HAS_TRAIT(src, TRAIT_AGEUSIA)) //I'll let you get away with not having 1 damage.
			switch(from.pH)
				if(11.5 to INFINITY)
					text_output += "<span class='warning'> and a strong alkaline note to it</span>"
				if(8.5 to 11.5)
					text_output += "<span class='notice'> and a soapy tone to it</span>"
				if(2.5 to 5.5)
					text_output += "<span class='notice'> and an acid tone to it</span>"
				if(-INFINITY to 2.5)
					text_output += "<span class='warning'> and has a strong acidic note to it</span>"

	if(last_taste_time + 50 < world.time)
		// We dont want to spam the same message over and over again at the
		// person. Give it a bit of a buffer.
		if(hallucination > 50 && prob(25))
			text_output = pick("spiders","dreams","nightmares","the future","the past","victory",\
			"defeat","pain","bliss","revenge","poison","time","space","death","life","truth","lies","justice","memory",\
			"regrets","your soul","suffering","music","noise","blood","hunger","the american way")
		if(text_output != last_taste_text || last_taste_time + 100 < world.time)
			to_chat(src, "<span class='notice'>You can taste [text_output].</span>")
			// "something indescribable" -> too many tastes, not enough flavor.

			last_taste_time = world.time
			last_taste_text = text_output

#undef DEFAULT_TASTE_SENSITIVITY
