/datum/mood_event/high
	mood_change = 6
	description = "<span class='nicegreen'>Woooow duudeeeeee...I'm tripping baaalls...</span>\n"

/datum/mood_event/smoked
	description = "<span class='nicegreen'>I have had a smoke recently.</span>\n"
	mood_change = 2
	timeout = 3600

/datum/mood_event/overdose
	mood_change = -8
	timeout = 3000

/datum/mood_event/overdose/add_effects(drug_name)
	description = "<span class='warning'>I think I took a bit too much of that [drug_name]</span>\n"

/datum/mood_event/withdrawal_light
	mood_change = -2

/datum/mood_event/withdrawal_light/add_effects(drug_name)
	description = "<span class='warning'>I could use some [drug_name]</span>\n"

/datum/mood_event/withdrawal_medium
	mood_change = -5

/datum/mood_event/withdrawal_medium/add_effects(drug_name)
	description = "<span class='warning'>I really need [drug_name]</span>\n"

/datum/mood_event/withdrawal_severe
	mood_change = -8

/datum/mood_event/withdrawal_severe/add_effects(drug_name)
	description = "<span class='boldwarning'>Oh god I need some [drug_name]</span>\n"

/datum/mood_event/withdrawal_critical
	mood_change = -10

/datum/mood_event/withdrawal_critical/add_effects(drug_name)
	description = "<span class='boldwarning'>[drug_name]! [drug_name]! [drug_name]!</span>\n"

/datum/mood_event/happiness_drug
	description = "<span class='nicegreen'>I can't feel anything and I never want this to end.</span>\n"
	mood_change = 10

/datum/mood_event/happiness_drug_good_od
	description = "<span class='nicegreen'>YES! YES!! YES!!!</span>\n"
	mood_change = 20
	timeout = 300
	//special_screen_obj = "mood_happiness_good" Originally in tg, but I personally think they look dumb

/datum/mood_event/happiness_drug_bad_od
	description = "<span class='boldwarning'>NO! NO!! NO!!!</span>\n"
	mood_change = -20
	timeout = 300
	//special_screen_obj = "mood_happiness_bad" Originally in tg

/datum/mood_event/eigenstate
	mood_change = -3
	description = "<span class='warning'>Where the hell am I? Is this an alternative dimension ?</span>\n"

/datum/mood_event/enthrall
	mood_change = 5

/datum/mood_event/enthrall/add_effects(message)
	description = "<span class='nicegreen'>[message]</span>\n"

/datum/mood_event/enthrallpraise
	mood_change = 10
	timeout = 1 MINUTES

/datum/mood_event/enthrallpraise/add_effects(message)
	description = "<span class='nicegreen'>[message]</span>\n"

/datum/mood_event/enthrallscold
	mood_change = -10
	timeout = 1 MINUTES

/datum/mood_event/enthrallscold/add_effects(message)
	description = "<span class='warning'>[message]</span>\n"//aaa I'm not kinky enough for this

/datum/mood_event/enthrallmissing1
	mood_change = -5

/datum/mood_event/enthrallmissing1/add_effects(message)
	description = "<span class='warning'>[message]</span>\n"

/datum/mood_event/enthrallmissing2
	mood_change = -10

/datum/mood_event/enthrallmissing2/add_effects(message)
	description = "<span class='warning'>[message]</span>\n"

/datum/mood_event/enthrallmissing3
	mood_change = -15

/datum/mood_event/enthrallmissing3/add_effects(message)
	description = "<span class='warning'>[message]</span>\n"

/datum/mood_event/enthrallmissing4
	mood_change = -25

/datum/mood_event/enthrallmissing4/add_effects(message)
	description = "<span class='warning'>[message]</span>\n"

/datum/mood_event/InLove
	mood_change = 10

/datum/mood_event/InLove/add_effects(message)
	description = "<span class='nicegreen'>[message]</span>\n"

/datum/mood_event/MissingLove
	mood_change = -10

/datum/mood_event/MissingLove/add_effects(message)
	description = "<span class='warning'>[message]</span>\n"
